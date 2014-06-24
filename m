Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbaFXNzo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 09:55:44 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:61407 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521AbaFXNzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 09:55:42 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/6] OF: Add [__]of_find_node_by_full_name
To: Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Guenter Roeck <linux@roeck-us.net>
Cc: Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, Joel Becker <jlbec@evilplan.org>,
        devicetree@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        linux-i2c@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pete Popov <pete.popov@konsulko.com>,
        Dan Malek <dan.malek@konsulko.com>,
        Georgi Vlaev <georgi.vlaev@konsulko.com>
In-Reply-To: <4F4A55EC-744B-49CC-96FA-811C9483A43D@konsulko.com>
References: <1403430039-15085-1-git-send-email-pantelis.antoniou@konsulko.com>
	<1403430039-15085-3-git-send-email-pantelis.antoniou@konsulko.com>
	<53A86ADA.9000903@roeck-us.net>
	<4F4A55EC-744B-49CC-96FA-811C9483A43D@konsulko.com>
Date: Tue, 24 Jun 2014 14:55:23 +0100
Message-Id: <20140624135523.99956C40B84@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jun 2014 21:00:39 +0300, Pantelis Antoniou <pantelis.antoniou@konsulko.com> wrote:
> Hi Guenter,
> 
> On Jun 23, 2014, at 8:58 PM, Guenter Roeck wrote:
> 
> > On 06/22/2014 02:40 AM, Pantelis Antoniou wrote:
> >> __of_find_node_by_full_name recursively searches for a matching node
> >> with the given full name without taking any locks.
> >> 
> >> of_find_node_by_full_name takes locks and takes a reference on the
> >> matching node.
> >> 
> >> Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
> >> ---
> >>  drivers/of/base.c  | 58 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >>  include/linux/of.h |  4 ++++
> >>  2 files changed, 62 insertions(+)
> >> 
> >> diff --git a/drivers/of/base.c b/drivers/of/base.c
> >> index d3493e1..80fef33 100644
> >> --- a/drivers/of/base.c
> >> +++ b/drivers/of/base.c
> >> @@ -1201,6 +1201,64 @@ static void *of_find_property_value_of_size(const struct device_node *np,
> >>  }
> >> 
> >>  /**
> >> + * __of_find_node_by_full_name - Find a node with the full name recursively
> >> + * @node:	Root of the tree to perform the search
> >> + * @full_name:	Full name of the node to find.
> >> + *
> >> + * Find a node with the give full name by recursively following any of
> >> + * the child node links.
> >> + * Returns the matching node, or NULL if not found.
> >> + * Note that the devtree lock is not taken, so this function is only
> >> + * safe to call on either detached trees, or when devtree lock is already
> >> + * taken.
> >> + */
> >> +struct device_node *__of_find_node_by_full_name(struct device_node *node,
> >> +		const char *full_name)
> >> +{
> >> +	struct device_node *child, *found;
> >> +
> >> +	if (node == NULL)
> >> +		return NULL;
> >> +
> >> +	/* check */
> >> +	if (of_node_cmp(node->full_name, full_name) == 0)
> >> +		return node;
> >> +
> >> +	__for_each_child_of_node(node, child) {
> >> +		found = __of_find_node_by_full_name(child, full_name);
> >> +		if (found != NULL)
> >> +			return found;
> >> +	}
> >> +
> >> +	return NULL;
> >> +}
> >> +EXPORT_SYMBOL(__of_find_node_by_full_name);
> >> +
> >> +/**
> >> + * of_find_node_by_full_name - Find a node with the full name recursively
> >> + * @node:	Root of the tree to perform the search
> >> + * @full_name:	Full name of the node to find.
> >> + *
> >> + * Find a node with the give full name by recursively following any of
> >> + * the child node links.
> >> + * Returns the matching node (with a ref taken), or NULL if not found.
> >> + */
> >> +struct device_node *of_find_node_by_full_name(struct device_node *node,
> >> +		const char *full_name)
> >> +{
> >> +	unsigned long flags;
> >> +	struct device_node *np;
> >> +
> >> +	raw_spin_lock_irqsave(&devtree_lock, flags);
> >> +	np = of_find_node_by_full_name(node, full_name);
> > 
> > Should this be __of_find_node_by_full_name, or am I missing something ?
> > 
> 
> Ugh, you're not missing something. This slipped through since this is not 
> used in the current code

Then perhaps the function shouldn't exist at all.

g.

