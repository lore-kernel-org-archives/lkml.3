Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755AbaCSVC4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 17:02:56 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:37992 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755324AbaCSVCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 17:02:53 -0400
MIME-Version: 1.0
In-Reply-To: <CAL_Jsq+cpgnTYUxe1FRgVDak963y3E5_EFqc=fBM-3hq4wgqbg@mail.gmail.com>
References: <1395179560-31384-1-git-send-email-pantelis.antoniou@konsulko.com> <CAL_Jsq+cpgnTYUxe1FRgVDak963y3E5_EFqc=fBM-3hq4wgqbg@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 19 Mar 2014 21:02:32 +0000
X-Google-Sender-Auth: ChdOwGPYxc2gbDXoaoaBphp2lxg
Message-ID: <CACxGe6sg5KUe1c53-LhWSgCU1V0VhHJygfmKpHXomvrrik0Fmg@mail.gmail.com>
Subject: Re: [PATCH] OF: Add [__]of_find_node_by_full_name
To: Rob Herring <robherring2@gmail.com>
Cc: Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
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
        Matt Ranostay <mranostay@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pete Popov <pete.popov@konsulko.com>,
        Dan Malek <dan.malek@konsulko.com>,
        Georgi Vlaev <georgi.vlaev@konsulko.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 12:26 PM, Rob Herring <robherring2@gmail.com> wrote:
> On Tue, Mar 18, 2014 at 4:52 PM, Pantelis Antoniou
> <pantelis.antoniou@konsulko.com> wrote:
>> __of_find_node_by_full_name recursively searches for a matching node
>> with the given full name without taking any locks.
>>
>> of_find_node_by_full_name takes locks and takes a reference on the
>> matching node.
>>
>> Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
>> ---
>>  drivers/of/base.c  | 58 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  include/linux/of.h |  4 ++++
>>  2 files changed, 62 insertions(+)
>>
>> diff --git a/drivers/of/base.c b/drivers/of/base.c
>> index 19bcdb4..08156e6 100644
>> --- a/drivers/of/base.c
>> +++ b/drivers/of/base.c
>> @@ -1142,6 +1142,64 @@ static void *of_find_property_value_of_size(const struct device_node *np,
>>  }
>>
>>  /**
>> + * __of_find_node_by_full_name - Find a node with the full name recursively
>> + * @node:      Root of the tree to perform the search
>> + * @full_name: Full name of the node to find.
>> + *
>> + * Find a node with the give full name by recursively following any of
>> + * the child node links.
>> + * Returns the matching node, or NULL if not found.
>> + * Note that the devtree lock is not taken, so this function is only
>> + * safe to call on either detached trees, or when devtree lock is already
>> + * taken.
>> + */
>> +struct device_node *__of_find_node_by_full_name(struct device_node *node,
>> +               const char *full_name)
>> +{
>> +       struct device_node *child, *found;
>> +
>> +       if (node == NULL)
>
> Just !node is preferred.
>
>> +               return NULL;
>> +
>> +       /* check */
>> +       if (of_node_cmp(node->full_name, full_name) == 0)
>> +               return node;
>> +
>> +       __for_each_child_of_node(node, child) {
>> +               found = __of_find_node_by_full_name(child, full_name);
>> +               if (found != NULL)
>
> "if (found)" is preferred.
>
>> +                       return found;
>> +       }
>> +
>> +       return NULL;
>> +}
>> +EXPORT_SYMBOL(__of_find_node_by_full_name);
>
> Does this need to be exported?
>
> In any case, use EXPORT_SYMBOL_GPL.
>
>> +
>> +/**
>> + * of_find_node_by_full_name - Find a node with the full name recursively
>> + * @node:      Root of the tree to perform the search
>> + * @full_name: Full name of the node to find.
>> + *
>> + * Find a node with the give full name by recursively following any of
>> + * the child node links.
>> + * Returns the matching node (with a ref taken), or NULL if not found.
>> + */
>> +struct device_node *of_find_node_by_full_name(struct device_node *node,
>> +               const char *full_name)
>> +{
>> +       unsigned long flags;
>> +       struct device_node *np;
>> +
>> +       raw_spin_lock_irqsave(&devtree_lock, flags);
>> +       np = of_find_node_by_full_name(node, full_name);
>
> Don't you need __of_find_node_by_full_name here.

!?!  Did this code get tested?

g.
