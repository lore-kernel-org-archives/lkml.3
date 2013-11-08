Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450Ab3KHPBt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 10:01:49 -0500
Received: from demumfd001.nsn-inter.net ([93.183.12.32]:13144 "EHLO
	demumfd001.nsn-inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757338Ab3KHPBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 10:01:40 -0500
Message-ID: <527CFCB3.90107@nsn.com>
Date: Fri, 08 Nov 2013 16:01:07 +0100
From: Alexander Sverdlin <alexander.sverdlin@nsn.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: ext Guenter Roeck <linux@roeck-us.net>,
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
References: <1383855454-15191-1-git-send-email-panto@antoniou-consulting.com> <1383855454-15191-6-git-send-email-panto@antoniou-consulting.com> <527CA9F4.9080003@nsn.com> <527CFB36.5000205@roeck-us.net>
In-Reply-To: <527CFB36.5000205@roeck-us.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-purgate-type: clean
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: clean
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate-size: 2633
X-purgate-ID: 151667::1383922870-00004A43-E2A439A3/0-0/0-0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On 08/11/13 15:54, ext Guenter Roeck wrote:
>>> +struct property *__of_copy_property(const struct property *prop, gfp_t flags)
>>> +{
>>> +    struct property *propn;
>>> +
>>> +    propn = kzalloc(sizeof(*prop), flags);
>>> +    if (propn == NULL)
>>> +        return NULL;
>>> +
>>> +    propn->name = kstrdup(prop->name, flags);
>>> +    if (propn->name == NULL)
>>> +        goto err_fail_name;
>>> +
>>> +    if (prop->length > 0) {
>>          ^^^^^^^^^^^^^^^^^^^^^^^
>> As Ioan already mentioned, this is really a problem.
>> There is a bunch of places, where properties without values are used.
>> Like gpio-controller; ranges; interrupt-controller;
>> Refer, for example, to of_irq_map_raw() which checks
>> of_get_property(ipar, "interrupt-controller", NULL) != NULL
>> and some other occurrences of exactly same construct.
>> This will simply be broken for merged device-tree parts.
>>
> 
> Folks,
> 
> it might help if you explain what exactly is broken, and how to fix it.
> It is not as if the property is not copied, only its value
> is not copied. And the value does not exist.

Existing kernel code relies on the fact, that when the value doesn't exist, the pointer is still not NULL.
>From the db-unflattening code there will be a pointer from kmalloc(0, ...).
 
> What do you think the code needs to do differently ? Obviously it can
> not copy a non-existing value. So what would have to be in the else case ?

Actually, it can copy non-existing value. memcpy(..., ..., 0) works perfectly fine and
kmalloc(0, flags) does exactly what is required here.

So we fixed this just by removing the if() statement, executing the block unconditionally.
There can be other solutions, but all of them are larger from the code foot-print.

> Thanks,
> Guenter
> 
>>> +        propn->value = kmalloc(prop->length, flags);
>>> +        if (propn->value == NULL)
>>> +            goto err_fail_value;
>>> +        memcpy(propn->value, prop->value, prop->length);
>>> +        propn->length = prop->length;
>>> +    }
>>> +
>>> +    /* mark the property as dynamic */
>>> +    of_property_set_flag(propn, OF_DYNAMIC);
>>> +
>>> +    return propn;
>>> +
>>> +err_fail_value:
>>> +    kfree(propn->name);
>>> +err_fail_name:
>>> +    kfree(propn);
>>> +    return NULL;
>>> +}
>>> +
>>
>> ...
>>
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
Best regards,
Alexander Sverdlin.
