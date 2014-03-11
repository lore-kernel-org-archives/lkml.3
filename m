Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135AbaCKSxJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 14:53:09 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40069 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbaCKSxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 14:53:06 -0400
Message-ID: <1394563959.3772.55.camel@paszta.hi.pengutronix.de>
Subject: Re: [RFC PATCH] [media]: of: move graph helpers from
 drivers/media/v4l2-core to drivers/of
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Philipp Zabel <philipp.zabel@gmail.com>
Date: Tue, 11 Mar 2014 19:52:39 +0100
In-Reply-To: <2089551.u6VYBAmlhv@avalon>
References: <1392119105-25298-1-git-send-email-p.zabel@pengutronix.de>
	 <20140310145815.17595C405FA@trevor.secretlab.ca>
	 <1394550420.3772.29.camel@paszta.hi.pengutronix.de>
	 <2089551.u6VYBAmlhv@avalon>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

Am Dienstag, den 11.03.2014, 16:21 +0100 schrieb Laurent Pinchart:
> Hi Philipp,
> 
> On Tuesday 11 March 2014 16:07:00 Philipp Zabel wrote:
> > Am Montag, den 10.03.2014, 14:58 +0000 schrieb Grant Likely:
> > > On Mon, 10 Mar 2014 14:52:53 +0100, Laurent Pinchart wrote:
> 
> [snip]
> 
> > > > In theory unidirectional links in DT are indeed enough. However, let's
> > > > not forget the following.
> > > > 
> > > > - There's no such thing as single start points for graphs. Sure, in some
> > > > simple cases the graph will have a single start point, but that's not a
> > > > generic rule. For instance the camera graphs
> > > > http://ideasonboard.org/media/omap3isp.ps and
> > > > http://ideasonboard.org/media/eyecam.ps have two camera sensors, and
> > > > thus two starting points from a data flow point of view. And if you
> > > > want a better understanding of how complex media graphs can become,
> > > > have a look at http://ideasonboard.org/media/vsp1.0.pdf (that's a real
> > > > world example, albeit all connections are internal to the SoC in that
> > > > particular case, and don't need to be described in DT).
> > > > 
> > > > - There's also no such thing as a master device that can just point to
> > > > slave devices. Once again simple cases exist where that model could
> > > > work, but real world examples exist of complex pipelines with dozens of
> > > > elements all implemented by a separate IP core and handled by separate
> > > > drivers, forming a graph with long chains and branches. We thus need
> > > > real graph bindings.
> > > > 
> > > > - Finally, having no backlinks in DT would make the software
> > > > implementation very complex. We need to be able to walk the graph in a
> > > > generic way without having any of the IP core drivers loaded, and
> > > > without any specific starting point. We would thus need to parse the
> > > > complete DT tree, looking at all nodes and trying to find out whether
> > > > they're part of the graph we're trying to walk. The complexity of the
> > > > operation would be at best quadratic to the number of nodes in the whole
> > > > DT and to the number of nodes in the graph.
> > > 
> > > Not really. To being with, you cannot determine any meaning of a node
> > > across the tree (aside from it being an endpoint) without also
> > > understanding the binding that the node is a part of. That means you
> > > need to have something matching against the compatible string on both
> > > ends of the linkage. For instance:
> > > 
> > > panel {
> > > 	compatible = "acme,lvds-panel";
> > > 	lvds-port: port {
> > > 	};
> > > };
> > > 
> > > display-controller {
> > > 	compatible = "encom,video";
> > > 	port {
> > > 		remote-endpoint = <&lvds-port>;
> > > 	};
> > > };
> > > 
> > > In the above example, the encom,video driver has absolutely zero
> > > information about what the acme,lvds-panel binding actually implements.
> > > There needs to be both a driver for the "acme,lvds-panel" binding and
> > > one for the "encom,video" binding (even if the acme,lvds-panel binding
> > > is very thin and defers the functionality to the video controller).
> > > 
> > > What you want here is the drivers to register each side of the
> > > connection. That could be modeled with something like the following
> > > (pseudocode):
> > > 
> > > struct of_endpoint {
> > > 
> > > 	struct list_head list;
> > > 	struct device_node *ep_node;
> > > 	void *context;
> > > 	void (*cb)(struct of_endpoint *ep, void *data);
> > > 
> > > }
> > > 
> > > int of_register_port(struct device *node, void (*cb)(struct of_endpoint
> > > *ep, void *data), void *data) {
> > > 
> > > 	struct of_endpoint *ep = kzalloc(sizeof(*ep), GFP_KERNEL);
> > > 	
> > > 	ep->ep_node = node;
> > > 	ep->data = data;
> > > 	ep->callback = cb;
> > > 	
> > > 	/* store the endpoint to a list */
> > > 	/* check if the endpoint has a remote-endpoint link */
> > > 		/* If so, then link the two together and call the
> > > 		 * callbacks */
> > > }
> > > 
> > > That's neither expensive or complicated.
> > > 
> > > Originally I suggested walking the whole tree multiple times, but as
> > > mentioned that doesn't scale, and as I thought about the above it isn't
> > > even a valid thing to do. Everything has to be driven by drivers, so
> > > even if the backlinks are there, nothing can be done with the link until
> > > the other side goes through enumeration independently.
> > 
> > I have implemented your suggestion as follows. Basically, this allows
> > either endpoint to contain the remote-endpoint link, as long as all
> > drivers register their endpoints in the probe function and return
> > -EPROBE_DEFER from their component framework bind callback until all
> > their endpoints are connected.
> 
> Beside bringing the whole graph down when a single component can't be probed 
> (either because the corresponding hardware devices is missing, broken, or the 
> driver isn't loaded), that's adding even one more level of complexity with an 
> additional callback.

That callback could be completely optional. But you are right that with
this model, each device in the graph can't look beyond the directly
connected devices (easily). On the other hand, I'm not quite sure how
useful this really is given that you can't know how a device's ports
relate to each other internally, until the driver is probed.

>  I'm afraid I can't accept it as-is, the result is just 
> too complex for device drivers and not flexible enough.

With the right wrapper, most subdevices probably could just call
	of_graph_register_all_endpoints(dev->of_node);
In their probe function. Anyhow, see below...

> I want to keep the ability to walk the graph without requiring all components 
> to be probed by their respective driver.

Could you explain why this is needed? Because for imx-drm, I probably
could live without that.

>What happened to your suggestion of parsing the whole DT once at boot
>time ?

It's not quite ready yet. My current draft looks somewhat like this:

>From 0ae3201b2fb7b7aac47f5a4dfe69b24ff1442040 Mon Sep 17 00:00:00 2001
From: Philipp Zabel <p.zabel@pengutronix.de>
Date: Tue, 11 Mar 2014 15:56:18 +0100
Subject: [PATCH] of: Parse OF graph into graph structure

This patch adds a function of_graph_populate() that parses the complete
device tree for port and endpoint nodes and stores them in a graph
structure.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/of/base.c        | 243
++++++++++++++++++++++++++++++++++++++++-------
 include/linux/of_graph.h |  17 +++-
 2 files changed, 224 insertions(+), 36 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index ebb001a..a844ca2 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -28,7 +28,33 @@
 
 #include "of_private.h"
 
+struct of_graph_entity {
+	struct device_node *of_node;
+	struct list_head list;
+	struct list_head ports;
+};
+
+struct of_graph_port {
+	struct device_node *of_node;
+	struct of_graph_entity *parent;
+	struct list_head list;
+	struct list_head endpoints;
+	int id;
+};
+
+struct of_graph_endpoint {
+	struct device_node *of_node;
+	struct of_graph_port *parent;
+	struct list_head list;
+	struct list_head global_list;
+	struct device_node *remote_node;
+	struct of_graph_endpoint *remote_endpoint;
+	int id;
+};
+
 LIST_HEAD(aliases_lookup);
+LIST_HEAD(entity_list);
+LIST_HEAD(endpoint_list);
 
 struct device_node *of_allnodes;
 EXPORT_SYMBOL(of_allnodes);
@@ -1984,6 +2010,19 @@ struct device_node *of_find_next_cache_node(const
struct device_node *np)
 	return NULL;
 }
 
+static struct of_graph_endpoint *__of_graph_lookup_endpoint(
+					const struct device_node *node)
+{
+	struct of_graph_endpoint *endpoint;
+
+	list_for_each_entry(endpoint, &endpoint_list, global_list) {
+		if (endpoint->of_node == node)
+			return endpoint;
+	}
+
+	return NULL;
+}
+
 /**
  * of_graph_parse_endpoint() - parse common endpoint node properties
  * @node: pointer to endpoint device_node
@@ -1994,22 +2033,17 @@ struct device_node
*of_find_next_cache_node(const struct device_node *np)
 int of_graph_parse_endpoint(const struct device_node *node,
 			    struct of_endpoint *endpoint)
 {
-	struct device_node *port_node = of_get_parent(node);
-
-	WARN_ONCE(!port_node, "%s(): endpoint %s has no parent node\n",
-		  __func__, node->full_name);
+	struct of_graph_endpoint *ep;
 
 	memset(endpoint, 0, sizeof(*endpoint));
 
-	endpoint->local_node = node;
-	/*
-	 * It doesn't matter whether the two calls below succeed.
-	 * If they don't then the default value 0 is used.
-	 */
-	of_property_read_u32(port_node, "reg", &endpoint->port);
-	of_property_read_u32(node, "reg", &endpoint->id);
+	ep = __of_graph_lookup_endpoint(node);
+	if (!ep || !ep->parent)
+		return -EINVAL;
 
-	of_node_put(port_node);
+	endpoint->local_node = ep->of_node;
+	endpoint->port = ep->parent->id;
+	endpoint->id = ep->id;
 
 	return 0;
 }
@@ -2136,21 +2170,16 @@ EXPORT_SYMBOL(of_graph_get_next_endpoint);
 struct device_node *of_graph_get_remote_port_parent(
 			       const struct device_node *node)
 {
-	struct device_node *np;
-	unsigned int depth;
+	struct of_graph_port *port;
+	struct of_graph_endpoint *ep  = __of_graph_lookup_endpoint(node);
+	if (!ep || !ep->remote_endpoint)
+		return NULL;
 
-	/* Get remote endpoint node. */
-	np = of_parse_phandle(node, "remote-endpoint", 0);
+	port = ep->remote_endpoint->parent;
+	if (!port || !port->parent)
+		return NULL;
 
-	/* Walk 3 levels up only if there is 'ports' node */
-	for (depth = 3; depth && np; depth--) {
-		np = of_get_next_parent(np);
-		if (depth == 3 && of_node_cmp(np->name, "port"))
-			break;
-		if (depth == 2 && of_node_cmp(np->name, "ports"))
-			break;
-	}
-	return np;
+	return port->parent->of_node;
 }
 EXPORT_SYMBOL(of_graph_get_remote_port_parent);
 
@@ -2163,17 +2192,161 @@ EXPORT_SYMBOL(of_graph_get_remote_port_parent);
  */
 struct device_node *of_graph_get_remote_port(const struct device_node
*node)
 {
-	struct device_node *np;
+	struct of_graph_endpoint *ep;
 
-	/* Get remote endpoint node. */
-	np = of_parse_phandle(node, "remote-endpoint", 0);
-	if (!np)
+	ep = __of_graph_lookup_endpoint(node);
+	if (!ep || !ep->remote_endpoint || !ep->remote_endpoint->parent)
 		return NULL;
-	np = of_get_next_parent(np);
-	if (of_node_cmp(np->name, "port")) {
-		of_node_put(np);
-		return NULL;
-	}
-	return np;
+
+	return ep->remote_endpoint->parent->of_node;
 }
 EXPORT_SYMBOL(of_graph_get_remote_port);
+
+static int of_graph_add_endpoint(struct of_graph_port *port,
+				struct device_node *node)
+{
+	struct of_graph_endpoint *ep = kzalloc(sizeof(*ep), GFP_KERNEL);
+	if (!ep)
+		return -ENOMEM;
+
+	ep->of_node = node;
+	ep->parent = port;
+	of_property_read_u32(node, "reg", &ep->id);
+	ep->remote_node = of_parse_phandle(node, "remote-endpoint", 0);
+
+	list_add_tail(&ep->global_list, &endpoint_list);
+	list_add_tail(&ep->list, &port->endpoints);
+	return 0;
+}
+
+static int of_graph_add_port(struct of_graph_entity *entity,
+				struct device_node *node)
+{
+	struct device_node *child;
+	struct of_graph_port *port = kzalloc(sizeof(*port), GFP_KERNEL);
+	if (!port)
+		return -ENOMEM;
+
+	port->of_node = node;
+	port->parent = entity;
+	of_property_read_u32(node, "reg", &port->id);
+	INIT_LIST_HEAD(&port->endpoints);
+
+	for_each_child_of_node(node, child) {
+		int rc;
+		if (of_node_cmp(child->name, "endpoint") != 0) {
+			pr_warn("%s(): non-endpoint node inside port %s\n",
+				__func__, node->full_name);
+			continue;
+		}
+
+		rc = of_graph_add_endpoint(port, child);
+		if (rc)
+			return rc;
+	}
+
+	list_add_tail(&port->list, &entity->ports);
+	return 0;
+}
+
+static int of_graph_add_entity(struct device_node *node,
+				struct device_node *child, bool ports_node)
+{
+	struct device_node *parent = node;
+	struct of_graph_entity *entity;
+	int rc = 0;
+
+	entity = kzalloc(sizeof(*entity), GFP_KERNEL);
+	if (!entity)
+		return -ENOMEM;
+
+	entity->of_node = node;
+	INIT_LIST_HEAD(&entity->ports);
+
+	if (ports_node) {
+		parent = child;
+		child = of_get_next_child(parent, NULL);
+	}
+	while (child) {
+		rc = of_graph_add_port(entity, child);
+		if (rc)
+			return rc;
+
+		do {
+			child = of_get_next_child(parent, child);
+			if (!child)
+				break;
+		} while (of_node_cmp(child->name, "port"));
+	}
+
+	list_add_tail(&entity->list, &entity_list);
+	return 0;
+}
+
+static int of_graph_recurse(struct device_node *node)
+{
+	struct device_node *child;
+	int rc = 0;
+
+	for_each_child_of_node(node, child) {
+		if (of_node_cmp(child->name, "ports") == 0) {
+			rc = of_graph_add_entity(node, child, true);
+			break;
+		} else if ((of_node_cmp(child->name, "port") == 0) &&
+			   (!of_find_property(child, "compatible", NULL))) {
+			rc = of_graph_add_entity(node, child, false);
+			break;
+		} else {
+			rc = of_graph_recurse(child);
+		}
+	}
+
+	return rc;
+}
+
+int of_graph_populate(struct device_node *root)
+{
+	struct of_graph_endpoint *ep1, *ep2;
+	struct of_graph_entity *entity;
+	struct of_graph_port *port;
+	int rc = 0;
+
+	/* Skip if the graph is already populated */
+	if (!list_empty(&endpoint_list))
+		return 0;
+
+	root = root ? of_node_get(root) : of_find_node_by_path("/");
+
+	/* Parse device tree */
+	rc = of_graph_recurse(root);
+	if (rc)
+		return rc;
+
+	/* Connect endpoints */
+	list_for_each_entry(ep1, &endpoint_list, global_list) {
+		ep2 = ep1;
+		list_for_each_entry_continue(ep2, &endpoint_list, global_list) {
+			struct of_graph_endpoint *from, *to;
+
+			if (ep1->remote_node) {
+				from = ep1;
+				to = ep2;
+			} else {
+				from = ep2;
+				to = ep1;
+			}
+			if (from->remote_node &&
+			    from->remote_node == to->of_node) {
+				WARN_ON(to->remote_node &&
+					to->remote_node != from->of_node);
+				to->remote_node = from->of_node;
+				to->remote_endpoint = from;
+				from->remote_endpoint = to;
+			}
+		}
+	}
+
+	of_node_put(root);
+	return rc;
+}
+EXPORT_SYMBOL(of_graph_populate);
diff --git a/include/linux/of_graph.h b/include/linux/of_graph.h
index 3a3c5a9..70f5809 100644
--- a/include/linux/of_graph.h
+++ b/include/linux/of_graph.h
@@ -23,7 +23,14 @@
 struct of_endpoint {
 	unsigned int port;
 	unsigned int id;
-	const struct device_node *local_node;
+	struct device_node *local_node;
+	struct device_node *remote_node;
+	struct of_endpoint *remote_ep;
+
+	/* Internal use only */
+	struct list_head list;
+	void (*callback)(struct of_endpoint *ep, void *data);
+	void *data;
 };
 
 #ifdef CONFIG_OF
@@ -35,6 +42,9 @@ struct device_node *of_graph_get_next_endpoint(const
struct device_node *parent,
 struct device_node *of_graph_get_remote_port_parent(
 					const struct device_node *node);
 struct device_node *of_graph_get_remote_port(const struct device_node
*node);
+
+int of_graph_populate(struct device_node *root);
+
 #else
 
 static inline int of_graph_parse_endpoint(const struct device_node
*node,
@@ -68,6 +78,11 @@ static inline struct device_node
*of_graph_get_remote_port(
 	return NULL;
 }
 
+static inline int of_graph_populate(struct device_node *root)
+{
+	return -ENOSYS;
+}
+
 #endif /* CONFIG_OF */
 
 #endif /* __LINUX_OF_GRAPH_H */
-- 
1.9.0

regards
Philipp

