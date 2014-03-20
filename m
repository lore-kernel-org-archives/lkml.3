Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758436AbaCTNU2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 09:20:28 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:33685 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353AbaCTNU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 09:20:26 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg KH <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Rob Herring <robh+dt@kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>, devicetree@vger.kernel.org
Subject: Re: [RFC PATCH 1/3] of: Parse OF graph into graph structure
Date: Thu, 20 Mar 2014 14:22:13 +0100
Message-ID: <2669834.F10GLns7F9@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1395241924-9675-2-git-send-email-p.zabel@pengutronix.de>
References: <1395241924-9675-1-git-send-email-p.zabel@pengutronix.de> <1395241924-9675-2-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp,

Thank you for the patch.

On Wednesday 19 March 2014 16:12:02 Philipp Zabel wrote:
> This patch adds a function of_graph_populate() that parses the complete
> device tree for port and endpoint nodes and stores them in a graph
> structure. The internal graph structure is not exported, the API still uses
> struct device_node pointers as handles.
> At the same time, of_graph_get_next_endpoint is changed to drop the
> reference count of its prev parameter, so it can be used in a
> for_each_endpoint_of_node macro, which is added to conveniently iterate
> over all endpoints of a node.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/of/base.c        | 403 +++++++++++++++++++++++++++++++++++---------
>  include/linux/of_graph.h |  12 ++
>  2 files changed, 337 insertions(+), 78 deletions(-)
> 
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index fd4b9c2..abfc462 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -28,7 +28,70 @@
> 
>  #include "of_private.h"
> 
> +/**
> + * struct of_graph_entity - In-kernel representation of a node with ports
> + *
> + * @of_node: The corresponding device node in the device tree.
> + * @list: List head in the global graph entity list.
> + * @ports: List of ports contained in this entity.
> + *
> + * This is a shortcut directly containing a list of pe-parsed ports,
> whether
> + * they are contained in a 'ports' subnode, or whether they are direct
> children
> + * of the device node. While the of_graph_entity usually will correspond to
> a
> + * struct device with the same of_node, this is not always the case.
> + */
> +struct of_graph_entity {
> +	struct device_node *of_node;
> +	struct list_head list;
> +	struct list_head ports;
> +};
> +
> +/**
> + * struct of_graph_port - In-kernel representation of a port node
> + *
> + * @of_node: The corresponding port node in the device tree.
> + * @parent: The in-kernel representation of the parent device_node.
> + *	This is either a direct parent of the of_node, or its grandparent,
> + *	if the parent is a 'ports' node.
> + * @list: List head in the parent entity 'ports' list.
> + * @endpoints: List of endpoints contained in this port.
> + * @id: Index of the port in the device_node, set by the 'reg' property.
> + */
> +struct of_graph_port {
> +	struct device_node *of_node;
> +	struct of_graph_entity *parent;
> +	struct list_head list;
> +	struct list_head endpoints;
> +	int id;

Can the ID be negative ?

> +};
> +
> +/**
> + * struct of_graph_endpoint - In-kernel representation of an endpoint node
> + *
> + * @of_node: The corresponding endpoint node in the device tree.
> + * @parent: The in-kernel port representation of the parent port node.
> + * @list: List head in the parent port 'endpoints' list.
> + * @global_list: List head in the global endpoint list.
> + * @remote_node: Remote endpoint node, which either is pointed to by the
> local
> + *	'remote-endpoint' phandle property, or which points to the
> + *	local endpoint node this way.
> + * @remote_endpoint: Pointer to remote in-kernel endpoint representation
> after
> + *	linking of endpoint nodes.
> + * @id: Index of the endpoint in the port, set by the 'reg' property.
> + */
> +struct of_graph_endpoint {
> +	struct device_node *of_node;
> +	struct of_graph_port *parent;
> +	struct list_head list;
> +	struct list_head global_list;
> +	struct device_node *remote_node;
> +	struct of_graph_endpoint *remote_endpoint;
> +	int id;

Same question here ?

> +};
> +
>  LIST_HEAD(aliases_lookup);
> +LIST_HEAD(entity_list);

I would have called this of_graph_entity_list or of_graph_entities, but I'll 
leave it up to you.

> +LIST_HEAD(endpoint_list);

Same here.

>  struct device_node *of_allnodes;
>  EXPORT_SYMBOL(of_allnodes);
> @@ -1984,6 +2047,32 @@ struct device_node *of_find_next_cache_node(const
> struct device_node *np) return NULL;
>  }
> 
> +static struct of_graph_entity *__of_graph_lookup_entity(
> +					const struct device_node *node)
> +{
> +	struct of_graph_entity *entity;
> +
> +	list_for_each_entry(entity, &entity_list, list) {
> +		if (entity->of_node == node)
> +			return entity;
> +	}
> +
> +	return NULL;
> +}
> +
> +static struct of_graph_endpoint *__of_graph_lookup_endpoint(
> +					const struct device_node *node)
> +{
> +	struct of_graph_endpoint *endpoint;
> +
> +	list_for_each_entry(endpoint, &endpoint_list, global_list) {
> +		if (endpoint->of_node == node)
> +			return endpoint;
> +	}
> +
> +	return NULL;
> +}
> +
>  /**
>   * of_graph_parse_endpoint() - parse common endpoint node properties
>   * @node: pointer to endpoint device_node
> @@ -1994,22 +2083,17 @@ struct device_node *of_find_next_cache_node(const
> struct device_node *np) int of_graph_parse_endpoint(const struct
> device_node *node,
>  			    struct of_endpoint *endpoint)
>  {
> -	struct device_node *port_node = of_get_parent(node);
> -
> -	WARN_ONCE(!port_node, "%s(): endpoint %s has no parent node\n",
> -		  __func__, node->full_name);
> +	struct of_graph_endpoint *ep;
> 
>  	memset(endpoint, 0, sizeof(*endpoint));
> 
> -	endpoint->local_node = node;
> -	/*
> -	 * It doesn't matter whether the two calls below succeed.
> -	 * If they don't then the default value 0 is used.
> -	 */
> -	of_property_read_u32(port_node, "reg", &endpoint->port);
> -	of_property_read_u32(node, "reg", &endpoint->id);
> +	ep = __of_graph_lookup_endpoint(node);
> +	if (!ep || !ep->parent)
> +		return -EINVAL;
> 
> -	of_node_put(port_node);
> +	endpoint->local_node = ep->of_node;
> +	endpoint->port = ep->parent->id;
> +	endpoint->id = ep->id;
> 
>  	return 0;
>  }
> @@ -2017,75 +2101,63 @@ EXPORT_SYMBOL(of_graph_parse_endpoint);
> 
>  /**
>   * of_graph_get_next_endpoint() - get next endpoint node
> + *
>   * @parent: pointer to the parent device node
>   * @prev: previous endpoint node, or NULL to get first
>   *
> - * Return: An 'endpoint' node pointer with refcount incremented. Refcount
> - * of the passed @prev node is not decremented, the caller have to use
> - * of_node_put() on it when done.
> + * Return: An 'endpoint' node pointer with refcount incremented. The caller
> + * has to use of_node_put() on it when done.
>   */
>  struct device_node *of_graph_get_next_endpoint(const struct device_node
> *parent, -					struct device_node *prev)
> +					       struct device_node *prev)
>  {
> -	struct device_node *endpoint;
> -	struct device_node *port = NULL;
> +	struct of_graph_entity *entity;
> +	struct of_graph_port *port;
> +	struct of_graph_endpoint *endpoint = NULL;
> 
>  	if (!parent)
>  		return NULL;
> 
>  	if (!prev) {
> -		struct device_node *node;
> -		/*
> -		 * It's the first call, we have to find a port subnode
> -		 * within this node or within an optional 'ports' node.
> -		 */
> -		node = of_get_child_by_name(parent, "ports");
> -		if (node)
> -			parent = node;
> +		/* It's the first call, we have to find the first port. */
> +		entity = __of_graph_lookup_entity(parent);
> +		if (WARN_ONCE(!entity || list_empty(&entity->ports),
> +				"%s(): no ports specified for %s\n",
> +				__func__, parent->full_name))

Can this ever happen ? An entity without any port can't end up in the entities 
list, can it ?

> +			return NULL;
> 
> -		port = of_get_child_by_name(parent, "port");
> +		port = list_first_entry(&entity->ports,
> +					struct of_graph_port, list);
> +	} else {
> +		endpoint = __of_graph_lookup_endpoint(prev);
> +		of_node_put(prev);
> +		if (WARN_ONCE(!endpoint, "%s(): endpoint %s not in global list\n",
> +			      __func__, prev->full_name))
> +			return NULL;
> +		port = endpoint->parent;
> +	}
> 
> -		if (port) {
> -			/* Found a port, get an endpoint. */
> -			endpoint = of_get_next_child(port, NULL);
> -			of_node_put(port);
> +	entity = port->parent;
> +	list_for_each_entry_from(port, &entity->ports, list) {
> +		if (!endpoint) {
> +			endpoint = list_first_entry(&port->endpoints,
> +					struct of_graph_endpoint, list);
> +		} else if (endpoint != list_last_entry(&port->endpoints,
> +					struct of_graph_endpoint, list)) {
> +			endpoint = list_next_entry(endpoint, list);
>  		} else {
> +			/*
> +			 * The previous endpoint is the port's last one,
> +			 * continue with the next port.
> +			 */
>  			endpoint = NULL;
> +			continue;
>  		}
> 
> -		if (!endpoint)
> -			pr_err("%s(): no endpoint nodes specified for %s\n",
> -			       __func__, parent->full_name);
> -		of_node_put(node);
> -
> -		return endpoint;
> +		return of_node_get(endpoint->of_node);
>  	}
> 
> -	port = of_get_parent(prev);
> -	if (WARN_ONCE(!port, "%s(): endpoint %s has no parent node\n",
> -		      __func__, prev->full_name))
> -		return NULL;
> -
> -	/* Avoid dropping prev node refcount to 0. */
> -	of_node_get(prev);
> -	endpoint = of_get_next_child(port, prev);
> -	if (endpoint) {
> -		of_node_put(port);
> -		return endpoint;
> -	}
> -
> -	/* No more endpoints under this port, try the next one. */
> -	do {
> -		port = of_get_next_child(parent, port);
> -		if (!port)
> -			return NULL;
> -	} while (of_node_cmp(port->name, "port"));
> -
> -	/* Pick up the first endpoint in this port. */
> -	endpoint = of_get_next_child(port, NULL);
> -	of_node_put(port);
> -
> -	return endpoint;
> +	return NULL;
>  }
>  EXPORT_SYMBOL(of_graph_get_next_endpoint);
> 
> @@ -2099,19 +2171,16 @@ EXPORT_SYMBOL(of_graph_get_next_endpoint);
>  struct device_node *of_graph_get_remote_port_parent(
>  			       const struct device_node *node)
>  {
> -	struct device_node *np;
> -	unsigned int depth;
> +	struct of_graph_port *port;
> +	struct of_graph_endpoint *ep  = __of_graph_lookup_endpoint(node);
> +	if (!ep || !ep->remote_endpoint)
> +		return NULL;
> 
> -	/* Get remote endpoint node. */
> -	np = of_parse_phandle(node, "remote-endpoint", 0);
> +	port = ep->remote_endpoint->parent;
> +	if (!port || !port->parent)
> +		return NULL;
> 
> -	/* Walk 3 levels up only if there is 'ports' node. */
> -	for (depth = 3; depth && np; depth--) {
> -		np = of_get_next_parent(np);
> -		if (depth == 2 && of_node_cmp(np->name, "ports"))
> -			break;
> -	}
> -	return np;
> +	return port->parent->of_node;

According to the function documentation I think 
of_graph_get_remote_port_parent() should return a new reference to the OF 
node.

>  }
>  EXPORT_SYMBOL(of_graph_get_remote_port_parent);
> 
> @@ -2124,12 +2193,190 @@ EXPORT_SYMBOL(of_graph_get_remote_port_parent);
>   */
>  struct device_node *of_graph_get_remote_port(const struct device_node
> *node) {
> -	struct device_node *np;
> +	struct of_graph_endpoint *ep;
> 
> -	/* Get remote endpoint node. */
> -	np = of_parse_phandle(node, "remote-endpoint", 0);
> -	if (!np)
> +	ep = __of_graph_lookup_endpoint(node);
> +	if (!ep || !ep->remote_endpoint || !ep->remote_endpoint->parent)
>  		return NULL;
> -	return of_get_next_parent(np);
> +
> +	return ep->remote_endpoint->parent->of_node;

Same comment here, I think of_graph_get_remote_port() should return a new 
reference to the OF node.

>  }
>  EXPORT_SYMBOL(of_graph_get_remote_port);
> +
> +static int of_graph_add_endpoint(struct of_graph_port *port,
> +				struct device_node *node)
> +{
> +	struct of_graph_endpoint *ep = kzalloc(sizeof(*ep), GFP_KERNEL);
> +	if (!ep)
> +		return -ENOMEM;
> +
> +	ep->of_node = node;
> +	ep->parent = port;
> +	of_property_read_u32(node, "reg", &ep->id);
> +	ep->remote_node = of_parse_phandle(node, "remote-endpoint", 0);
> +
> +	list_add_tail(&ep->global_list, &endpoint_list);
> +	list_add_tail(&ep->list, &port->endpoints);
> +	return 0;
> +}
> +
> +static int of_graph_add_port(struct of_graph_entity *entity,
> +				struct device_node *node)
> +{
> +	struct device_node *child;
> +	struct of_graph_port *port = kzalloc(sizeof(*port), GFP_KERNEL);
> +	if (!port)
> +		return -ENOMEM;
> +
> +	port->of_node = node;
> +	port->parent = entity;
> +	of_property_read_u32(node, "reg", &port->id);
> +	INIT_LIST_HEAD(&port->endpoints);
> +
> +	for_each_child_of_node(node, child) {
> +		int rc;
> +		if (of_node_cmp(child->name, "endpoint") != 0) {
> +			pr_warn("%s(): non-endpoint node inside port %s\n",
> +				__func__, node->full_name);

I don't think this deserves a warning, as device-specific subnodes could 
probably exist in port nodes. The OF graph DT bindings don't specify any such 
subnode, but don't prevent device DT bindings from creating them.

> +			continue;
> +		}
> +
> +		rc = of_graph_add_endpoint(port, child);
> +		if (rc)

You're leaking port here. You can either free it (as well as all the 
associated endpoints already parsed) or move the list_add_tail before the 
loop.

> +			return rc;
> +	}
> +
> +	list_add_tail(&port->list, &entity->ports);
> +	return 0;
> +}
> +
> +/**
> + * of_graph_entity() - parse all ports contained in a node

Typo, this should be of_graph_add_entity()

> + *
> + * @node: The parent node containing the ports.
> + * @child: Either the 'ports' node or the first 'port' node contained in
> node.
> + * @ports_node: If true, child is a 'ports' node, otherwise it is the first
> + *	'port'.
> + *
> + * This function is given either the 'ports' node or the first 'port' as
> + * second parameter so the parsing that was already done in
> of_graph_recurse
> + * does not have to be repeated. It parses all ports and collects them in
> an
> + * of_graph_entity structure that is added to the global entity_list.
> + *
> + * Returns zero on success, an error value otherwise.
> + */
> +static int of_graph_add_entity(struct device_node *node,
> +				struct device_node *child, bool ports_node)
> +{
> +	struct device_node *parent = node;
> +	struct of_graph_entity *entity;
> +	int rc = 0;

No need to initialize rc to 0.

> +
> +	entity = kzalloc(sizeof(*entity), GFP_KERNEL);
> +	if (!entity)
> +		return -ENOMEM;
> +
> +	entity->of_node = node;
> +	INIT_LIST_HEAD(&entity->ports);
> +
> +	if (ports_node) {
> +		parent = child;
> +		child = of_get_next_child(parent, NULL);
> +	}
> +	while (child) {
> +		rc = of_graph_add_port(entity, child);
> +		if (rc)

You're leaking entity here. You can either free it (as well as all the 
associated ports and endpoints already parsed) or move the list_add_tail 
before the loop.

> +			return rc;
> +
> +		do {
> +			child = of_get_next_child(parent, child);
> +			if (!child)
> +				break;
> +		} while (of_node_cmp(child->name, "port"));
> +	}
> +
> +	list_add_tail(&entity->list, &entity_list);
> +	return 0;
> +}
> +
> +static int of_graph_recurse(struct device_node *node)
> +{
> +	struct device_node *child;
> +	int rc = 0;
> +
> +	for_each_child_of_node(node, child) {
> +		/*
> +		 * Find the first 'ports' or 'port' subnode. If one is found,
> +		 * parse all ports contained in the node
> +		 */
> +		if ((of_node_cmp(child->name, "ports") == 0) &&
> +		    (!of_find_property(child, "compatible", NULL))) {
> +			rc = of_graph_add_entity(node, child, true);
> +			break;
> +		} else if ((of_node_cmp(child->name, "port") == 0) &&
> +			   (!of_find_property(child, "compatible", NULL))) {
> +			rc = of_graph_add_entity(node, child, false);
> +			break;
> +		} else {
> +			rc = of_graph_recurse(child);

I'm a bit cautious about using the kernel stack for unbounded recursion. 
Wouldn't it make sense to at least limit the maximum recursion level, and 
possibly use a kmalloc-allocated stack ?

Shouldn't you also break when rc < 0 ? I would return of_graph_add_entity() 
directly above, add a if (rc < 0) return rc; here and return 0 below. You 
could then remove the initialization of rc at declaration time.

> +		}
> +	}
> +
> +	return rc;
> +}
> +
> +/**
> + * of_graph_populate() - populates the of graph from the device tree
> + *
> + * @root: Root node of the device tree.
> + *
> + * This function scans the device tree for port and endpoint nodes and
> + * generates the of graph from that, linking together endpoints that point
> + * at each other.
> + *
> + * Returns zero on success, an error value otherwise.
> + */
> +int of_graph_populate(struct device_node *root)
> +{
> +	struct of_graph_endpoint *ep1, *ep2;
> +	int rc = 0;

There's no need to initialize rc to 0.

> +
> +	/* Skip if the graph is already populated */
> +	if (!list_empty(&endpoint_list))
> +		return 0;

This will need to be changed to support DT fragments, but we can do that 
later. However, that change will also require adding locking, which we should 
already be careful about now to make sure that APIs that will require taking a 
mutex are not called in atomic context by drivers. Would it make sense to 
already protect the endpoint_list with a mutex ?

> +	root = root ? of_node_get(root) : of_find_node_by_path("/");
> +
> +	/* Parse device tree */
> +	rc = of_graph_recurse(root);
> +	if (rc)

Aren't you missing an of_node_put() (or a "goto out;") here ?

> +		return rc;
> +
> +	/* Connect endpoints */
> +	list_for_each_entry(ep1, &endpoint_list, global_list) {
> +		ep2 = ep1;
> +		list_for_each_entry_continue(ep2, &endpoint_list, global_list) {
> +			struct of_graph_endpoint *from, *to;
> +
> +			if (ep1->remote_node) {
> +				from = ep1;
> +				to = ep2;
> +			} else {
> +				from = ep2;
> +				to = ep1;
> +			}
> +			if (from->remote_node &&
> +			    from->remote_node == to->of_node) {

As to->of_node can't be NULL I think you can remove the from->remote_node NULL 
check.

> +				WARN_ON(to->remote_node &&
> +					to->remote_node != from->of_node);

A WARN_ON is OK for now, but we might want to handle this more gracefully in 
the future.

> +				to->remote_node = from->of_node;
> +				to->remote_endpoint = from;
> +				from->remote_endpoint = to;
> +			}
> +		}
> +	}
> +
> +	of_node_put(root);
> +	return rc;
> +}
> +EXPORT_SYMBOL(of_graph_populate);
> diff --git a/include/linux/of_graph.h b/include/linux/of_graph.h
> index befef42..b6dd55b 100644
> --- a/include/linux/of_graph.h
> +++ b/include/linux/of_graph.h
> @@ -26,6 +26,10 @@ struct of_endpoint {
>  	const struct device_node *local_node;
>  };
> 
> +#define for_each_endpoint_of_node(dn, ep) \
> +	for (ep = of_graph_get_next_endpoint(dn, NULL); ep != NULL; \
> +	     ep = of_graph_get_next_endpoint(dn, ep))
> +
>  #ifdef CONFIG_OF
>  int of_graph_parse_endpoint(const struct device_node *node,
>  				struct of_endpoint *endpoint);

-- 
Regards,

Laurent Pinchart

