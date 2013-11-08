Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818Ab3KHJI6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 04:08:58 -0500
Received: from demumfd002.nsn-inter.net ([93.183.12.31]:14959 "EHLO
	demumfd002.nsn-inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562Ab3KHJIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 04:08:53 -0500
Message-ID: <527CA9F4.9080003@nsn.com>
Date: Fri, 08 Nov 2013 10:08:04 +0100
From: Alexander Sverdlin <alexander.sverdlin@nsn.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: ext Pantelis Antoniou <panto@antoniou-consulting.com>,
        Grant Likely <grant.likely@secretlab.ca>
CC: Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 5/5] OF: Introduce utility helper functions
References: <1383855454-15191-1-git-send-email-panto@antoniou-consulting.com> <1383855454-15191-6-git-send-email-panto@antoniou-consulting.com>
In-Reply-To: <1383855454-15191-6-git-send-email-panto@antoniou-consulting.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-purgate-type: clean
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: clean
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate-size: 2156
X-purgate-ID: 151667::1383901688-00005753-F45BA546/0-0/0-0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Pantelis,

On 07/11/13 21:17, ext Pantelis Antoniou wrote:
> Introduce helper functions for working with the live DT tree.
> 
> __of_free_property() frees a dynamically created property
> __of_free_tree() recursively frees a device node tree
> __of_copy_property() copies a property dynamically
> __of_create_empty_node() creates an empty node
> __of_find_node_by_full_name() finds the node with the full name
> and
> of_multi_prop_cmp() performs a multi property compare but without
> having to take locks.
> 
> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
> ---
>  drivers/of/Makefile |   2 +-
>  drivers/of/util.c   | 253 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/of.h  |  59 ++++++++++++
>  3 files changed, 313 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/of/util.c
> 

...

> +struct property *__of_copy_property(const struct property *prop, gfp_t flags)
> +{
> +	struct property *propn;
> +
> +	propn = kzalloc(sizeof(*prop), flags);
> +	if (propn == NULL)
> +		return NULL;
> +
> +	propn->name = kstrdup(prop->name, flags);
> +	if (propn->name == NULL)
> +		goto err_fail_name;
> +
> +	if (prop->length > 0) {
        ^^^^^^^^^^^^^^^^^^^^^^^
As Ioan already mentioned, this is really a problem.
There is a bunch of places, where properties without values are used.
Like gpio-controller; ranges; interrupt-controller;
Refer, for example, to of_irq_map_raw() which checks
of_get_property(ipar, "interrupt-controller", NULL) != NULL
and some other occurrences of exactly same construct.
This will simply be broken for merged device-tree parts.

> +		propn->value = kmalloc(prop->length, flags);
> +		if (propn->value == NULL)
> +			goto err_fail_value;
> +		memcpy(propn->value, prop->value, prop->length);
> +		propn->length = prop->length;
> +	}
> +
> +	/* mark the property as dynamic */
> +	of_property_set_flag(propn, OF_DYNAMIC);
> +
> +	return propn;
> +
> +err_fail_value:
> +	kfree(propn->name);
> +err_fail_name:
> +	kfree(propn);
> +	return NULL;
> +}
> +

...

-- 
Best regards,
Alexander Sverdlin.
