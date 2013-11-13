Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759319Ab3KMJEC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 04:04:02 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:45233 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759070Ab3KMJDr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 04:03:47 -0500
Subject: Re: [PATCH 5/5] OF: Introduce utility helper functions
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <20131113013459.D3886C40F49@trevor.secretlab.ca>
Date: Wed, 13 Nov 2013 10:03:37 +0100
Cc: Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <F88335D9-6515-4E48-A21F-25039F16754A@antoniou-consulting.com>
References: <1383673816-29293-1-git-send-email-panto@antoniou-consulting.com> <1383673816-29293-6-git-send-email-panto@antoniou-consulting.com> <20131111163743.D136CC42330@trevor.secretlab.ca> <89491720-464B-47EC-A888-9CDE29B035F5@antoniou-consulting.com> <20131113013459.D3886C40F49@trevor.secretlab.ca>
To: Grant Likely <grant.likely@secretlab.ca>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Nov 13, 2013, at 2:34 AM, Grant Likely wrote:

> On Tue, 12 Nov 2013 11:39:08 +0100, Pantelis Antoniou <panto@antoniou-consulting.com> wrote:
>> Hi Grant,
>> 
>> On Nov 11, 2013, at 5:37 PM, Grant Likely wrote:
>> 
>>> On Tue,  5 Nov 2013 19:50:16 +0200, Pantelis Antoniou <panto@antoniou-consulting.com> wrote:
>>>> Introduce helper functions for working with the live DT tree.
>>>> 
>>>> __of_free_property() frees a dynamically created property
>>>> __of_free_tree() recursively frees a device node tree
>>>> __of_copy_property() copies a property dynamically
>>>> __of_create_empty_node() creates an empty node
>>>> __of_find_node_by_full_name() finds the node with the full name
>>>> and
>>>> of_multi_prop_cmp() performs a multi property compare but without
>>>> having to take locks.
>>>> 
>>>> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
>>> 
>>> So, this all looks like private stuff, or stuff that belongs in
>>> drivers/of/base.c. Can you move stuff around. I've made more comments
>>> below.
>>> 
>> 
>> Placement is no big issue;
>> 
>>> g.
>>> 
>> 
>> [snip]
>> 
>>>> +	} else {
>>>> +		pr_warn("%s: node %p cannot be freed; memory is gone\n",
>>>> +				__func__, node);
>>>> +	}
>>>> +}
>>> 
>>> All of the above is potentially dangerous. There is no way to determine
>>> if anything still holds a reference to a node. The proper way to handle
>>> removal of properties is to have a release method when the last
>>> of_node_put is called.
>>> 
>> 
>> This is safe, and expected to be called only on a dynamically created tree,
>> that's what all the checks against OF_DYNAMIC guard against.
>> 
>> It is not ever meant to be called on an arbitrary tree, created by unflattening
>> a blob.
> 
> I am talking about when being used on a dynamic tree. The problem is
> when a driver or other code holds a reference to a dynamic nodes, but
> doesn't release it correctly. The memory must not be freed until all of
> the references are relased. OF_DYNAMIC doesn't actually help in that
> case, and it is the reason for of_node_get()/of_node_put()
> 

I know, but even that is not enough. of_node_get()/of_node_put() handles the
case of references to the nodes, but not what happens with references to
properties. deadprops is mitigating the problem somewhat, but if we're going
to go to all the trouble of kobjectification let's do the props as well.

of_get_property could be modified to return a devm_kmalloced copy of the real
property and that would deal with most of the callers. Of course for
the small sized scalar data we can avoid the copy.

By using the devm_* interface we also avoid having to mess too much with the callers.

I.e. what about something like devm_of_get_property()?

>> Perhaps we could have a switch to control whether an unflattened tree is 
>> created dynamically and then freeing/releasing will work.
>> 
>> kobject-ifcation will require it anyway, don't you agree? 
> 
> Yes. Kobjectifcation will also take care of the release method.
> 
>> 
>>>> +
>>>> +/**
>>>> + * __of_copy_property - Copy a property dynamically.
>>>> + * @prop:	Property to copy
>>>> + * @flags:	Allocation flags (typically pass GFP_KERNEL)
>>>> + *
>>>> + * Copy a property by dynamically allocating the memory of both the
>>>> + * property stucture and the property name & contents. The property's
>>>> + * flags have the OF_DYNAMIC bit set so that we can differentiate between
>>>> + * dynamically allocated properties and not.
>>>> + * Returns the newly allocated property or NULL on out of memory error.
>>>> + */
>>> 
>>> What do you intend the use-case to be for this function? Will the
>>> duplicated property be immediately modified? If so, what happens if the
>>> property needs to be grown in size?
>>> 
>> 
>> No, the property will no be modified. If it needs to grow it will be moved to 
>> deadprops (since we don't track refs to props) and a new one will be allocated.
>> 
>>>> +struct property *__of_copy_property(const struct property *prop, gfp_t flags)
>>>> +{
>>>> +	struct property *propn;
>>>> +
>>>> +	propn = kzalloc(sizeof(*prop), flags);
>>>> +	if (propn == NULL)
>>>> +		return NULL;
>>>> +
>>>> +	propn->name = kstrdup(prop->name, flags);
>>>> +	if (propn->name == NULL)
>>>> +		goto err_fail_name;
>>>> +
>>>> +	if (prop->length > 0) {
>>>> +		propn->value = kmalloc(prop->length, flags);
>>>> +		if (propn->value == NULL)
>>>> +			goto err_fail_value;
>>>> +		memcpy(propn->value, prop->value, prop->length);
>>>> +		propn->length = prop->length;
>>>> +	}
>>>> +
>>>> +	/* mark the property as dynamic */
>>>> +	of_property_set_flag(propn, OF_DYNAMIC);
>>>> +
>>>> +	return propn;
>>>> +
>>>> +err_fail_value:
>>>> +	kfree(propn->name);
>>>> +err_fail_name:
>>>> +	kfree(propn);
>>>> +	return NULL;
>>>> +}
>>>> +
>>>> +/**
>>>> + * __of_create_empty_node - Create an empty device node dynamically.
>>>> + * @name:	Name of the new device node
>>>> + * @type:	Type of the new device node
>>>> + * @full_name:	Full name of the new device node
>>>> + * @phandle:	Phandle of the new device node
>>>> + * @flags:	Allocation flags (typically pass GFP_KERNEL)
>>>> + *
>>>> + * Create an empty device tree node, suitable for further modification.
>>>> + * The node data are dynamically allocated and all the node flags
>>>> + * have the OF_DYNAMIC & OF_DETACHED bits set.
>>>> + * Returns the newly allocated node or NULL on out of memory error.
>>>> + */
>>>> +struct device_node *__of_create_empty_node(
>>>> +		const char *name, const char *type, const char *full_name,
>>>> +		phandle phandle, gfp_t flags)
>>> 
>>> I would like to see a user of this function in the core DT paths that
>>> allocate nodes. It will make for less chance of breakage if the fdt and
>>> pdt paths change something, but this function isn't updated.
>>> 
>> 
>> Hmm, where do you think it can be used? Perhaps the unflatten parts?
> 
> Yes. In unflattening the tree, fdt.c and in extracting the trea from
> real OFW (pdt.c).
> 
>> 
>>> g.
>>> 
>>>> +{
>>>> +	struct device_node *node;
>>>> +
>>>> +	node = kzalloc(sizeof(*node), flags);
>>>> +	if (node == NULL)
>>>> +		return NULL;
>>>> +
>>>> +	node->name = kstrdup(name, flags);
>>>> +	if (node->name == NULL)
>>>> +		goto err_return;
>>>> +
>>>> +	node->type = kstrdup(type, flags);
>>>> +	if (node->type == NULL)
>>>> +		goto err_return;
>>>> +
>>>> +	node->full_name = kstrdup(full_name, flags);
>>>> +	if (node->type == NULL)
>>>> +		goto err_return;
>>> 
>>> Again, who do you expect the user of this function to be? If it is part
>>> of unflattening an overlay tree, is there a reason that the passed in
>>> names cannot be used directly instead of kmallocing them?
>>> 
>> 
>> I want to be able to get rid of the blob eventually; I don't need to keep
>> dragging it around.
> 
> Why? It really doesn't hurt and it means data does not need to be
> copied.

Copying data lead to less problems that having to drag that blob around. 
That's just preference, so not a big issue.

> 
>> 
>>>> +
>>>> +	node->phandle = phandle;
>>>> +	kref_init(&node->kref);
>>>> +	of_node_set_flag(node, OF_DYNAMIC);
>>>> +	of_node_set_flag(node, OF_DETACHED);
>>>> +
>>>> +	return node;
>>>> +
>>>> +err_return:
>>>> +	__of_free_tree(node);
>>>> +	return NULL;
>>>> +}
>>>> +
>>>> +/**
>>>> + * __of_find_node_by_full_name - Find a node with the full name recursively
>>>> + * @node:	Root of the tree to perform the search
>>>> + * @full_name:	Full name of the node to find.
>>>> + *
>>>> + * Find a node with the give full name by recursively following any of 
>>>> + * the child node links.
>>>> + * Returns the matching node, or NULL if not found.
>>>> + * Note that the devtree lock is not taken, so this function is only
>>>> + * safe to call on either detached trees, or when devtree lock is already
>>>> + * taken.
>>>> + */
>>>> +struct device_node *__of_find_node_by_full_name(struct device_node *node,
>>>> +		const char *full_name)
>>> 
>>> Sounds like something that should be in drivers/of/base.c
>>> 
>> 
>> Yes.
>> 
>>>> +{
>>>> +	struct device_node *child, *found;
>>>> +
>>>> +	if (node == NULL)
>>>> +		return NULL;
>>>> +
>>>> +	/* check */
>>>> +	if (of_node_cmp(node->full_name, full_name) == 0)
>>>> +		return node;
>>>> +
>>>> +	__for_each_child_of_node(node, child) {
>>>> +		found = __of_find_node_by_full_name(child, full_name);
>>>> +		if (found != NULL)
>>>> +			return found;
>>>> +	}
>>> 
>>> I'm not a huge fan of recursive calls. Why doesn't a slightly modified
>>> of_fund_node_by_name() work here?
>>> 
>>> I agree that of_find_node_by_name is not particularly elegant and it
>>> would be good to have something more efficient, but it works and
>>> following the same method would be consistent.
>>> 
>> 
>> of_find_node_by_name is not iterating on the passed tree and it's subnodes,
>> it is a global search starting from:
>> 
>> 	np = from ? from->allnext : of_allnodes;
>> 
>> This is just broken, since it depends on unflattening creating nodes in the
>> allnodes list in sequence. I.e. that child nodes are after the parent node.
>> This assumption breaks down when doing dynamic insertions of nodes.
>> A detached tree in not linked on of_allnodes anyway.
> 
> It would be good to have a root-of-tree structure for both the core tree
> and the overlay trees so that a common iterator can be implemented.
> 

I don't know. The overlay trees while being built are not affecting the
kernel in any way until they're applied. They're just a bunch of private
data.

Consider the case of an overlay tree that's not applied, but contains bad 
data, for example a name of a node clashes with one of the live tree. 
Linking it into the kernel's real live tree can lead to problems, like
shadowing the real node.

> g.
> 

Regards

-- Pantelis

