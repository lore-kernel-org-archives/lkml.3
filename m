Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab3AUK7p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 05:59:45 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:36065 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751833Ab3AUK7o convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 05:59:44 -0500
Subject: Re: [PATCH 5/6] OF: Introduce Device Tree resolve support.
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <20130121044836.GB24829@truffula.fritz.box>
Date: Mon, 21 Jan 2013 12:59:15 +0200
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Jon Loeliger <jdl@jdl.com>, Tony Lindgren <tony@atomide.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Benoit Cousson <b-cousson@ti.com>, Mitch Bradley <wmb@firmworks.com>,
        Alan Tull <atull@altera.com>, linux-omap@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, Koen Kooi <koen@dominion.thruhere.net>,
        Joel A Fernandes <agnel.joel@gmail.com>,
        Rob Clark <robdclark@gmail.com>,
        Jason Kridner <jkridner@beagleboard.org>,
        Matt Ranostay <mranostay@gmail.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <EEEDB0B2-7410-456B-BED7-89FD5E407553@antoniou-consulting.com>
References: <1357327870-13615-1-git-send-email-panto@antoniou-consulting.com> <1357327870-13615-6-git-send-email-panto@antoniou-consulting.com> <20130121044836.GB24829@truffula.fritz.box>
To: David Gibson <david@gibson.dropbear.id.au>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David

On Jan 21, 2013, at 6:48 AM, David Gibson wrote:

> On Fri, Jan 04, 2013 at 09:31:09PM +0200, Pantelis Antoniou wrote:
>> Introduce support for dynamic device tree resolution.
>> Using it, it is possible to prepare a device tree that's
>> been loaded on runtime to be modified and inserted at the kernel
>> live tree.
>> 
>> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
>> ---
>> .../devicetree/dynamic-resolution-notes.txt        |  25 ++
>> drivers/of/Kconfig                                 |   9 +
>> drivers/of/Makefile                                |   1 +
>> drivers/of/resolver.c                              | 394 +++++++++++++++++++++
>> include/linux/of.h                                 |  17 +
>> 5 files changed, 446 insertions(+)
>> create mode 100644 Documentation/devicetree/dynamic-resolution-notes.txt
>> create mode 100644 drivers/of/resolver.c
>> 
>> diff --git a/Documentation/devicetree/dynamic-resolution-notes.txt b/Documentation/devicetree/dynamic-resolution-notes.txt
>> new file mode 100644
>> index 0000000..0b396c4
>> --- /dev/null
>> +++ b/Documentation/devicetree/dynamic-resolution-notes.txt
>> @@ -0,0 +1,25 @@
>> +Device Tree Dynamic Resolver Notes
>> +----------------------------------
>> +
>> +This document describes the implementation of the in-kernel
>> +Device Tree resolver, residing in drivers/of/resolver.c and is a
>> +companion document to Documentation/devicetree/dt-object-internal.txt[1]
>> +
>> +How the resolver works
>> +----------------------
>> +
>> +The resolver is given as an input an arbitrary tree compiled with the
>> +proper dtc option and having a /plugin/ tag. This generates the
>> +appropriate __fixups__ & __local_fixups__ nodes as described in [1].
>> +
>> +In sequence the resolver works by the following steps:
>> +
>> +1. Get the maximum device tree phandle value from the live tree + 1.
>> +2. Adjust all the local phandles of the tree to resolve by that amount.
>> +3. Using the __local__fixups__ node information adjust all local references
>> +   by the same amount.
>> +4. For each property in the __fixups__ node locate the node it references
>> +   in the live tree. This is the label used to tag the node.
>> +5. Retrieve the phandle of the target of the fixup.
>> +5. For each fixup in the property locate the node:property:offset location
>> +   and replace it with the phandle value.
> 
> Hrm.  So, I'm really still not convinced by this approach.
> 
> 	First, I think it's unwise to allow overlays to change
> essentially anything in the base tree, rather than having the base
> tree define sockets of some sort where things can be attached.
> 

One could say that the labels define the sockets. It's not just things
to be attached, properties might have to change, or something more complex,
as we've found out in practice.

As far as the unwise part, a good deal of care has been taken so that 
people that don't use the overlay functionality have absolutely no
overhead, or anything modified in the way they use DT.

> 	Second, even allowing overlays to change anything, I don't see
> a lot of reason to do this kind of resolution within the kernel and
> with data stored in the dtb itself, rather than doing the resolution
> in userspace from an annotated overlay dts or dtb, then inserting the
> fully resolved product into the kernel.  In either case, the overlay
> needs to be constructed with pretty intimate knowledge of the base
> tree.
> 

Fair enough, but that's one more thing of user-space crud to drag along, which
will get enabled pretty late in the boot sequence. Meaning a whole bunch of devices,
like consoles, and root filesystems on the devices that need an overlay to operate
won't work easily enough.

> That said, I have some implementation comments below.
> 
> [snip]
>> +/**
>> + * Find a subtree's maximum phandle value.
>> + */
>> +static phandle __of_get_tree_max_phandle(struct device_node *node,
>> +		phandle max_phandle)
>> +{
>> +	struct device_node *child;
>> +
>> +	if (node->phandle != 0 && node->phandle != OF_PHANDLE_ILLEGAL &&
>> +			node->phandle > max_phandle)
>> +		max_phandle = node->phandle;
>> +
>> +	__for_each_child_of_node(node, child)
>> +		max_phandle = __of_get_tree_max_phandle(child, max_phandle);
> 
> Recursion is best avoided given the kernel's limited stack space.
> This is also trivial to implement non-recursively, using the allnext
> pointer.
> 

The caller passes a tree that's not yet been inserted in the live tree.
So there's no allnodes pointer yet. Care has been taken for the function
to not have excessive local variables. I would guess about 20-32 bytes for
the stack frame + the local variables, so with a 4K stack we would overflow at a 
nest level of 128, which has a pretty slim chance for a real system.
  

>> +
>> +	return max_phandle;
>> +}
>> +
>> +/**
>> + * Find live tree's maximum phandle value.
>> + */
>> +static phandle of_get_tree_max_phandle(void)
>> +{
>> +	struct device_node *node;
>> +	phandle phandle;
>> +
>> +	/* get root node */
>> +	node = of_find_node_by_path("/");
>> +	if (node == NULL)
>> +		return OF_PHANDLE_ILLEGAL;
>> +
>> +	/* now search recursively */
>> +	read_lock(&devtree_lock);
>> +	phandle = __of_get_tree_max_phandle(node, 0);
>> +	read_unlock(&devtree_lock);
>> +
>> +	of_node_put(node);
>> +
>> +	return phandle;
>> +}
>> +
>> +/**
>> + * Adjust a subtree's phandle values by a given delta.
>> + * Makes sure not to just adjust the device node's phandle value,
>> + * but modify the phandle properties values as well.
>> + */
>> +static void __of_adjust_tree_phandles(struct device_node *node,
>> +		int phandle_delta)
>> +{
>> +	struct device_node *child;
>> +	struct property *prop;
>> +	phandle phandle;
>> +
>> +	/* first adjust the node's phandle direct value */
>> +	if (node->phandle != 0 && node->phandle != OF_PHANDLE_ILLEGAL)
>> +		node->phandle += phandle_delta;
> 
> You need to have some kind of check for overflow here, or the adjusted
> phandle could be one of the illegal values (0 or -1) - or wrap around
> and colllide with existing phandle values in the base tree.  dtc
> (currently) allocates phandles from the bottom, but there's no
> guarantee that a base tree will only have low phandle values - it only
> takes one node with phandle set to 0xfffffffe in the base tree to have
> this function make a mess of things.

Correct, I'll take care of handling the overflow.

> 
> 
>> +	/* now adjust phandle & linux,phandle values */
>> +	for_each_property_of_node(node, prop) {
>> +
>> +		/* only look for these two */
>> +		if (of_prop_cmp(prop->name, "phandle") != 0 &&
>> +		    of_prop_cmp(prop->name, "linux,phandle") != 0)
>> +			continue;
>> +
>> +		/* must be big enough */
>> +		if (prop->length < 4)
>> +			continue;
> 
> If prop->length != 4 (including > 4) something is pretty wrong, and
> you should probably bail with an error message.

OK, just playing it safe here.

> 
>> +
>> +		/* read phandle value */
>> +		phandle = be32_to_cpu(*(uint32_t *)prop->value);
>> +		if (phandle == OF_PHANDLE_ILLEGAL)	/* unresolved */
>> +			continue;
>> +
>> +		/* adjust */
>> +		*(uint32_t *)prop->value = cpu_to_be32(node->phandle);
>> +	}
>> +
>> +	/* now do the children recursively */
>> +	__for_each_child_of_node(node, child)
>> +		__of_adjust_tree_phandles(child, phandle_delta);
> 
> Again, recursion is not a good idea.
> 

No other way to handle it. This is not a node that's in the live tree yet.

>> +}
>> +
>> +/**
>> + * Adjust the local phandle references by the given phandle delta.
>> + * Assumes the existances of a __local_fixups__ node at the root
>> + * of the tree. Does not take any devtree locks so make sure you
>> + * call this on a tree which is at the detached state.
>> + */
>> +static int __of_adjust_tree_phandle_references(struct device_node *node,
>> +		int phandle_delta)
>> +{
>> +	phandle phandle;
>> +	struct device_node *refnode, *child;
>> +	struct property *rprop, *sprop;
>> +	char *propval, *propcur, *propend, *nodestr, *propstr, *s;
>> +	int offset, propcurlen;
>> +	int err;
>> +
>> +	/* locate the symbols & fixups nodes on resolve */
>> +	__for_each_child_of_node(node, child)
>> +		if (of_node_cmp(child->name, "__local_fixups__") == 0)
>> +			break;
>> +
>> +	/* no local fixups */
>> +	if (child == NULL)
>> +		return 0;
>> +
>> +	/* find the local fixups property */
>> +	for_each_property_of_node(child, rprop) {
>> +
>> +		/* skip properties added automatically */
>> +		if (of_prop_cmp(rprop->name, "name") == 0)
>> +			continue;
> 
> Ok, so you're interpreting any property except name in the
> __local_fixups__ node in exactly the same way?  That's a bit strange.
> Why not just have a single property rather than a node's worth in that
> case.

It saves space. For example you might have to resolve a label reference
more than once. So instead of doing:

	label = "/foo:bar:0";
	label = "/bar:foo:4";

You can do this:

	label = "/foo:bar:0", "/bar/foo:4";
> 
>> +		/* make a copy */
>> +		propval = kmalloc(rprop->length, GFP_KERNEL);
>> +		if (propval == NULL) {
>> +			pr_err("%s: Could not copy value of '%s'\n",
>> +					__func__, rprop->name);
>> +			return -ENOMEM;
>> +		}
>> +		memcpy(propval, rprop->value, rprop->length);
>> +
>> +		propend = propval + rprop->length;
>> +		for (propcur = propval; propcur < propend;
>> +				propcur += propcurlen + 1) {
>> +
>> +			propcurlen = strlen(propcur);
>> +
>> +			nodestr = propcur;
>> +			s = strchr(propcur, ':');
> 
> So, using strings with separators like this doesn't sit will with
> existing device tree practice.  More similar to existing things would
> have NUL separators and the integer values in binary, rather than
> text (and yes, there is precedent for mixed string and integer content
> in properties).
> 

Hmm, I guess it can be done, but I wouldn't expect any space savings.
Most offsets are very small integer multiple of 4 since the usual case is 

	foo =<&label>;

And you lose the ability to dump a string and figure out what's going on.

Not a big problem to change.

> 
>> +			if (s == NULL) {
>> +				pr_err("%s: Illegal symbol entry '%s' (1)\n",
>> +					__func__, propcur);
>> +				err = -EINVAL;
>> +				goto err_fail;
>> +			}
>> +			*s++ = '\0';
> 
> And using the separators you do leads to this rather ugly copy then
> mangle-in-place approach to parsing.
> 
>> +			propstr = s;
>> +			s = strchr(s, ':');
>> +			if (s == NULL) {
>> +				pr_err("%s: Illegal symbol entry '%s' (2)\n",
>> +					__func__, (char *)rprop->value);
>> +				err = -EINVAL;
>> +				goto err_fail;
>> +			}
>> +
>> +			*s++ = '\0';
>> +			offset = simple_strtoul(s, NULL, 10);
>> +
>> +			/* look into the resolve node for the full path */
>> +			refnode = __of_find_node_by_full_name(node, nodestr);
>> +			if (refnode == NULL) {
>> +				pr_warn("%s: Could not find refnode '%s'\n",
>> +					__func__, (char *)rprop->value);
>> +				continue;
>> +			}
>> +
>> +			/* now find the property */
>> +			for_each_property_of_node(refnode, sprop) {
>> +				if (of_prop_cmp(sprop->name, propstr) == 0)
>> +					break;
>> +			}
>> +
>> +			if (sprop == NULL) {
>> +				pr_err("%s: Could not find property '%s'\n",
>> +					__func__, (char *)rprop->value);
>> +				err = -ENOENT;
>> +				goto err_fail;
>> +			}
>> +
>> +			phandle = be32_to_cpu(*(uint32_t *)
>> +					(sprop->value + offset));
>> +			*(uint32_t *)(sprop->value + offset) =
>> +				cpu_to_be32(phandle + phandle_delta);
>> +		}
>> +
>> +		kfree(propval);
>> +	}
>> +
>> +	return 0;
>> +
>> +err_fail:
>> +	kfree(propval);
>> +	return err;
>> +}
>> +
>> +/**
>> + * of_resolve	- Resolve the given node against the live tree.
>> + *
>> + * @resolve:	Node to resolve
>> + *
>> + * Perform dynamic Device Tree resolution against the live tree
>> + * to the given node to resolve. This depends on the live tree
>> + * having a __symbols__ node, and the resolve node the __fixups__ &
>> + * __local_fixups__ nodes (if needed).
>> + * The result of the operation is a resolve node that it's contents
>> + * are fit to be inserted or operate upon the live tree.
>> + * Returns 0 on success or a negative error value on error.
>> + */
>> +int of_resolve(struct device_node *resolve)
>> +{
>> +	struct device_node *child, *refnode;
>> +	struct device_node *root_sym, *resolve_sym, *resolve_fix;
>> +	struct property *rprop, *sprop;
>> +	const char *refpath;
>> +	char *propval, *propcur, *propend, *nodestr, *propstr, *s;
>> +	int offset, propcurlen;
>> +	phandle phandle, phandle_delta;
>> +	int err;
>> +
>> +	/* the resolve node must exist, and be detached */
>> +	if (resolve == NULL ||
>> +			!of_node_check_flag(resolve, OF_DETACHED)) {
>> +		return -EINVAL;
>> +	}
>> +
>> +	/* first we need to adjust the phandles */
>> +	phandle_delta = of_get_tree_max_phandle() + 1;
>> +	__of_adjust_tree_phandles(resolve, phandle_delta);
>> +	err = __of_adjust_tree_phandle_references(resolve, phandle_delta);
>> +	if (err != 0)
>> +		return err;
>> +
>> +	root_sym = NULL;
>> +	resolve_sym = NULL;
>> +	resolve_fix = NULL;
>> +
>> +	/* this may fail (if no fixups are required) */
>> +	root_sym = of_find_node_by_path("/__symbols__");
>> +
>> +	/* locate the symbols & fixups nodes on resolve */
>> +	__for_each_child_of_node(resolve, child) {
>> +
>> +		if (resolve_sym == NULL &&
> 
> No need for the NULL check.  If there are duplicate node names, you've
> already got big trouble, and picking the last matching will do no
> worse than picking the first matching.

OK

> 
>> +				of_node_cmp(child->name, "__symbols__") == 0)
>> +			resolve_sym = child;
>> +
>> +		if (resolve_fix == NULL &&
>> +				of_node_cmp(child->name, "__fixups__") == 0)
>> +			resolve_fix = child;
>> +
>> +		/* both found, don't bother anymore */
>> +		if (resolve_sym != NULL && resolve_fix != NULL)
>> +			break;
>> +	}
>> +
>> +	/* we do allow for the case where no fixups are needed */
>> +	if (resolve_fix == NULL)
>> +		goto merge_sym;
> 
> Hrm.  I'm not convinced that's one of the kernel-allowed forms of
> goto.
> 

OK

>> +
>> +	/* we need to fixup, but no root symbols... */
>> +	if (root_sym == NULL)
>> +		return -EINVAL;
>> +
>> +	for_each_property_of_node(resolve_fix, rprop) {
>> +
>> +		/* skip properties added automatically */
>> +		if (of_prop_cmp(rprop->name, "name") == 0)
>> +			continue;
>> +
>> +		err = of_property_read_string(root_sym,
>> +				rprop->name, &refpath);
>> +		if (err != 0) {
>> +			pr_err("%s: Could not find symbol '%s'\n",
>> +					__func__, rprop->name);
>> +			goto err_fail;
>> +		}
>> +
>> +		refnode = of_find_node_by_path(refpath);
>> +		if (refnode == NULL) {
>> +			pr_err("%s: Could not find node by path '%s'\n",
>> +					__func__, refpath);
>> +			err = -ENOENT;
>> +			goto err_fail;
>> +		}
>> +
>> +		phandle = refnode->phandle;
>> +		of_node_put(refnode);
>> +
>> +		pr_debug("%s: %s phandle is 0x%08x\n",
>> +				__func__, rprop->name, phandle);
>> +
>> +		/* make a copy */
>> +		propval = kmalloc(rprop->length, GFP_KERNEL);
>> +		if (propval == NULL) {
>> +			pr_err("%s: Could not copy value of '%s'\n",
>> +					__func__, rprop->name);
>> +			err = -ENOMEM;
>> +			goto err_fail;
>> +		}
>> +
>> +		memcpy(propval, rprop->value, rprop->length);
>> +
>> +		propend = propval + rprop->length;
>> +		for (propcur = propval; propcur < propend;
>> +				propcur += propcurlen + 1) {
>> +			propcurlen = strlen(propcur);
>> +
>> +			nodestr = propcur;
>> +			s = strchr(propcur, ':');
>> +			if (s == NULL) {
>> +				pr_err("%s: Illegal symbol "
>> +					"entry '%s' (1)\n",
>> +					__func__, (char *)rprop->value);
>> +				kfree(propval);
>> +				err = -EINVAL;
>> +				goto err_fail;
>> +			}
>> +			*s++ = '\0';
>> +
>> +			propstr = s;
>> +			s = strchr(s, ':');
>> +			if (s == NULL) {
>> +				pr_err("%s: Illegal symbol "
>> +					"entry '%s' (2)\n",
>> +					__func__, (char *)rprop->value);
>> +				kfree(propval);
>> +				err = -EINVAL;
>> +				goto err_fail;
>> +			}
>> +
>> +			*s++ = '\0';
>> +			offset = simple_strtoul(s, NULL, 10);
>> +
>> +			/* look into the resolve node for the full path */
>> +			refnode = __of_find_node_by_full_name(resolve,
>> +					nodestr);
> 
> Re-using the 'refnode' variable here is pretty confusing, since it
> means very different things earlier and here (node pointed to, versus
> node containing the property which points).
> 

OK

>> +			if (refnode == NULL) {
>> +				pr_err("%s: Could not find refnode '%s'\n",
>> +					__func__, (char *)rprop->value);
>> +				kfree(propval);
>> +				err = -ENOENT;
>> +				goto err_fail;
>> +			}
>> +
>> +			/* now find the property */
>> +			for_each_property_of_node(refnode, sprop) {
>> +				if (of_prop_cmp(sprop->name, propstr) == 0)
>> +					break;
>> +			}
>> +
>> +			if (sprop == NULL) {
>> +				pr_err("%s: Could not find property '%s'\n",
>> +					__func__, (char *)rprop->value);
>> +				kfree(propval);
>> +				err = -ENOENT;
>> +				goto err_fail;
>> +			}
>> +
>> +			*(uint32_t *)(sprop->value + offset) =
>> +				cpu_to_be32(phandle);
>> +		}
>> +
>> +		kfree(propval);
>> +	}
>> +
>> +merge_sym:
>> +
>> +	of_node_put(root_sym);
>> +
>> +	return 0;
>> +
>> +err_fail:
>> +
>> +	if (root_sym != NULL)
>> +		of_node_put(root_sym);
>> +
>> +	return err;
>> +}
>> diff --git a/include/linux/of.h b/include/linux/of.h
>> index c38e41a..ab52243 100644
>> --- a/include/linux/of.h
>> +++ b/include/linux/of.h
>> @@ -650,4 +650,21 @@ static inline int of_multi_prop_cmp(const struct property *prop, const char *val
>> 
>> #endif	/* !CONFIG_OF */
>> 
>> +
>> +/* illegal phandle value (set when unresolved) */
>> +#define OF_PHANDLE_ILLEGAL	0xdeadbeef
> 
> Ugh.  0 and -1 are already reserved as illegal phandle values, don't
> invent a new one.

OK

> 
>> +
>> +#ifdef CONFIG_OF_RESOLVE
>> +
>> +int of_resolve(struct device_node *resolve);
>> +
>> +#else
>> +
>> +static inline int of_resolve(struct device_node *resolve)
>> +{
>> +	return -ENOTSUPP;
>> +}
>> +
>> +#endif
>> +
>> #endif /* _LINUX_OF_H */
> 
> -- 
> David Gibson			| I'll have my music baroque, and my code
> david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
> 				| _way_ _around_!
> http://www.ozlabs.org/~dgibson

