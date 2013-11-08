Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442Ab3KHOyu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 09:54:50 -0500
Received: from mail.active-venture.com ([67.228.131.205]:50154 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755903Ab3KHOys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 09:54:48 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <527CFB36.5000205@roeck-us.net>
Date: Fri, 08 Nov 2013 06:54:46 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        ext Pantelis Antoniou <panto@antoniou-consulting.com>,
        Grant Likely <grant.likely@secretlab.ca>
CC: Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Michael Stickel <ms@mycable.de>, Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 5/5] OF: Introduce utility helper functions
References: <1383855454-15191-1-git-send-email-panto@antoniou-consulting.com> <1383855454-15191-6-git-send-email-panto@antoniou-consulting.com> <527CA9F4.9080003@nsn.com>
In-Reply-To: <527CA9F4.9080003@nsn.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2013 01:08 AM, Alexander Sverdlin wrote:
> Hello Pantelis,
>
> On 07/11/13 21:17, ext Pantelis Antoniou wrote:
>> Introduce helper functions for working with the live DT tree.
>>
>> __of_free_property() frees a dynamically created property
>> __of_free_tree() recursively frees a device node tree
>> __of_copy_property() copies a property dynamically
>> __of_create_empty_node() creates an empty node
>> __of_find_node_by_full_name() finds the node with the full name
>> and
>> of_multi_prop_cmp() performs a multi property compare but without
>> having to take locks.
>>
>> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
>> ---
>>   drivers/of/Makefile |   2 +-
>>   drivers/of/util.c   | 253 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>>   include/linux/of.h  |  59 ++++++++++++
>>   3 files changed, 313 insertions(+), 1 deletion(-)
>>   create mode 100644 drivers/of/util.c
>>
>
> ...
>
>> +struct property *__of_copy_property(const struct property *prop, gfp_t flags)
>> +{
>> +	struct property *propn;
>> +
>> +	propn = kzalloc(sizeof(*prop), flags);
>> +	if (propn == NULL)
>> +		return NULL;
>> +
>> +	propn->name = kstrdup(prop->name, flags);
>> +	if (propn->name == NULL)
>> +		goto err_fail_name;
>> +
>> +	if (prop->length > 0) {
>          ^^^^^^^^^^^^^^^^^^^^^^^
> As Ioan already mentioned, this is really a problem.
> There is a bunch of places, where properties without values are used.
> Like gpio-controller; ranges; interrupt-controller;
> Refer, for example, to of_irq_map_raw() which checks
> of_get_property(ipar, "interrupt-controller", NULL) != NULL
> and some other occurrences of exactly same construct.
> This will simply be broken for merged device-tree parts.
>

Folks,

it might help if you explain what exactly is broken, and how to fix it.
It is not as if the property is not copied, only its value
is not copied. And the value does not exist.

What do you think the code needs to do differently ? Obviously it can
not copy a non-existing value. So what would have to be in the else case ?

Thanks,
Guenter

>> +		propn->value = kmalloc(prop->length, flags);
>> +		if (propn->value == NULL)
>> +			goto err_fail_value;
>> +		memcpy(propn->value, prop->value, prop->length);
>> +		propn->length = prop->length;
>> +	}
>> +
>> +	/* mark the property as dynamic */
>> +	of_property_set_flag(propn, OF_DYNAMIC);
>> +
>> +	return propn;
>> +
>> +err_fail_value:
>> +	kfree(propn->name);
>> +err_fail_name:
>> +	kfree(propn);
>> +	return NULL;
>> +}
>> +
>
> ...
>

