Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357AbaEPKy6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 06:54:58 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:60669 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932340AbaEPKy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 06:54:56 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH 2/3] of: Make of_find_node_by_path() handle /aliases
To: frowand.list@gmail.com
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        David Daney <david.daney@cavium.com>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>
In-Reply-To: <53757D25.1060005@gmail.com>
References: <1399993115-21552-1-git-send-email-grant.likely@linaro.org>
	<1399993115-21552-3-git-send-email-grant.likely@linaro.org>
	<53757D25.1060005@gmail.com>
Date: Fri, 16 May 2014 11:54:44 +0100
Message-Id: <20140516105444.C1DB7C42277@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2014 19:51:17 -0700, Frank Rowand <frowand.list@gmail.com> wrote:
> On 5/13/2014 7:58 AM, Grant Likely wrote:
> > Make of_find_node_by_path() handle aliases as prefixes. To make this
> > work the name search is refactored to search by path component instead
> > of by full string. This should be a more efficient search, and it makes
> > it possible to start a search at a subnode of a tree.
> > 
> > Signed-off-by: David Daney <david.daney@cavium.com>
> > Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
> > [grant.likely: Rework to not require allocating at runtime]
> > Acked-by: Rob Herring <robh@kernel.org>
> > Signed-off-by: Grant Likely <grant.likely@linaro.org>
> > ---
> >  drivers/of/base.c | 60 +++++++++++++++++++++++++++++++++++++++++++++++++++----
> >  1 file changed, 56 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/of/base.c b/drivers/of/base.c
> > index 6e240698353b..60089b9a3014 100644
> > --- a/drivers/of/base.c
> > +++ b/drivers/of/base.c
> > @@ -771,9 +771,38 @@ struct device_node *of_get_child_by_name(const struct device_node *node,
> >  }
> >  EXPORT_SYMBOL(of_get_child_by_name);
> >  
> > +static struct device_node *__of_find_node_by_path(struct device_node *parent,
> > +						const char *path)
> > +{
> > +	struct device_node *child;
> > +	int len = strchrnul(path, '/') - path;
> > +
> > +	if (!len)
> > +		return parent;
> 
> (!len) is true if the the final character of the path passed into of_find_node_by_path()
> was "/".  Strictly speaking, ->full_name will never end with "/", so the return value
> should be NULL, indicating that the match fails.

Ah, good catch. I should add a test case for that.

> 
> > +
> > +	for_each_child_of_node(parent, child) {
> > +		const char *name = strrchr(child->full_name, '/');
> > +		if (WARN(!name, "malformed device_node %s\n", child->full_name))
> > +			continue;
> > +		name++;
> 
> Why go to the effort of finding the final component of child->full_name instead
> of just using child->name?

Because child->name and the final component of child->full_name is not
the same thing. child->name has the unit address stripped off. It is
part of how OpenFirmware expects to be used. New drivers are never
supposed to be matching by node name, but I don't currently have a good
way to go through any driver depending on the OpenFirmware behaviour.

Ideally I'd like to get rid of the difference.

> 
> > +		if (strncmp(path, name, len) == 0 && (strlen(name) == len))
> > +			return child;
> > +	}
> > +	return NULL;
> > +}
> > +
> >  /**
> >   *	of_find_node_by_path - Find a node matching a full OF path
> >   *	@path:	The full path to match
> > + *	@path: Either the full path to match, or if the path does not
> 
> Delete the old @path description.

Oops, thanks.

> 
> 
> > + *	       start with '/', the name of a property of the /aliases
> > + *	       node (an alias).  In the case of an alias, the node
> > + *	       matching the alias' value will be returned.
> > + *
> > + *	Valid paths:
> > + *		/foo/bar	Full path
> > + *		foo		Valid alias
> > + *		foo/bar		Valid alias + relative path
> >   *
> >   *	Returns a node pointer with refcount incremented, use
> >   *	of_node_put() on it when done.
> > @@ -781,13 +810,36 @@ EXPORT_SYMBOL(of_get_child_by_name);
> >  struct device_node *of_find_node_by_path(const char *path)
> >  {
> >  	struct device_node *np = of_allnodes;
> > +	struct property *pp;
> >  	unsigned long flags;
> >  
> > +	/* The path could begin with an alias */
> > +	if (*path != '/') {
> > +		char *p = strchrnul(path, '/');
> > +		int len = p - path;
> > +
> > +		/* of_aliases must not be NULL */
> > +		if (!of_aliases)
> > +			return NULL;
> > +
> > +		np = NULL;
> > +		for_each_property_of_node(of_aliases, pp) {
> > +			if (strlen(pp->name) == len && !strncmp(pp->name, path, len)) {
> > +				np = of_find_node_by_path(pp->value);
> > +				break;
> > +			}
> > +		}
> > +		if (!np)
> > +			return NULL;
> > +		path = p;
> > +	}
> > +
> > +	/* Step down the tree matching path components */
> >  	raw_spin_lock_irqsave(&devtree_lock, flags);
> > -	for (; np; np = np->allnext) {
> > -		if (np->full_name && (of_node_cmp(np->full_name, path) == 0)
> > -		    && of_node_get(np))
> > -			break;
> > +	while (np && *path == '/') {
> > +		path++; /* Increment past '/' delimiter */
> > +		np = __of_find_node_by_path(np, path);
> > +		path = strchrnul(path, '/');
> >  	}
> >  	raw_spin_unlock_irqrestore(&devtree_lock, flags);
> >  	return np;
> > 
> 

