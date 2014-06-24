Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476AbaFXILT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 04:11:19 -0400
Received: from demumfd002.nsn-inter.net ([93.183.12.31]:36286 "EHLO
	demumfd002.nsn-inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbaFXILN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 04:11:13 -0400
Message-ID: <53A93259.8000301@nsn.com>
Date: Tue, 24 Jun 2014 10:10:01 +0200
From: Alexander Sverdlin <alexander.sverdlin@nsn.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Ioan Nicu <ioan.nicu.ext@nsn.com>,
        ext Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Grant Likely <grant.likely@secretlab.ca>
CC: Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, Joel Becker <jlbec@evilplan.org>,
        devicetree@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        linux-i2c@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pete Popov <pete.popov@konsulko.com>,
        Dan Malek <dan.malek@konsulko.com>,
        Georgi Vlaev <georgi.vlaev@konsulko.com>
Subject: Re: [PATCH 5/6] OF: Utility helper functions for dynamic nodes
References: <1403430039-15085-1-git-send-email-pantelis.antoniou@konsulko.com> <1403430039-15085-6-git-send-email-pantelis.antoniou@konsulko.com> <53A85549.7040809@nsn.com> <6E91A461-4361-4A18-BE32-CECDD789C114@konsulko.com> <20140623183343.GA10389@heimdall>
In-Reply-To: <20140623183343.GA10389@heimdall>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-purgate-type: clean
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: clean
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate-size: 2590
X-purgate-ID: 151667::1403597411-00007A71-6D884700/0/0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pantelis, Grant,

On 23/06/14 20:33, Ioan Nicu wrote:
>>> On 22/06/14 11:40, ext Pantelis Antoniou wrote:
>>>> Introduce helper functions for working with the live DT tree,
>>>> all of them related to dynamically adding/removing nodes and
>>>> properties.
>>>>
>>>> __of_copy_property() copies a property dynamically
>>>> __of_create_empty_node() creates an empty node
>>>>
>>>> Bug fix about prop->len == 0 by Ionut Nicu <ioan.nicu.ext@nsn.com>
>>>
>>> Are you sure about this? (see below...)
>>>
> 
> Alexander is right, my fix was lost even though it's mentioned in this patch.
> 
>>>> Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
>>>> ---
>>
>> [snip]
>>>> +
>>>> +	if (prop->length > 0) {
>>>        ^^^^^^^^^^^^^^^^^^^^^
>>> Seems, that length==0 case will still produce value==NULL results,
>>> which will brake some checks in the kernel... Or am I missing something in
>>> the new version?
>>>
>>
>> prop->value will be set to NULL, and length will be set to zero (kzalloc).
>> This is a normal zero length property.
>>
>> I don't know of any place in the kernel accessing the value if prop->length==0
>>
> 
> We have a simple use case. We have an overlay which adds an interrupt controller.
> If you look in drivers/of/irq.c, in of_irq_parse_raw():
> 
> [...]
> 	/* Now start the actual "proper" walk of the interrupt tree */
> 	while (ipar != NULL) {
> 		/* Now check if cursor is an interrupt-controller and if it is
> 		 * then we are done
> 		 */
> 		if (of_get_property(ipar, "interrupt-controller", NULL) !=

We have to define, if it's allowed for an empty property to have NULL value.
Several places in the kernel use of_get_property() to check for property existence.
We either have to make a tree-wide patch and replace of_get_property() with of_find_property() in those cases,
or ensure value != NULL in this copy function...

Grant, what do you think?

> 				NULL) {
> 			pr_debug(" -> got it !\n");
> 			return 0;
> 		}
> [...]
> 
> A node is identified as an interrupt controller if it has a zero-length property
> called "interrupt-controller" but with a non-NULL value.
> 
> My proposed fix for this was to remove the if () condition. propn->value will be
> allocated with kmalloc(0) which returns ZERO_SIZE_PTR which is != NULL.
> 
> 
>>
>> [snip]
>>
>>>> +
>>>> #endif /* _LINUX_OF_H */
>>>>
>>>
>>> -- 
>>> Best regards,
>>> Alexander Sverdlin.
>>
>> Regards
>>
>> -- Pantelis
>>
> 
> Regards,
> Ionut Nicu
> 

-- 
Best regards,
Alexander Sverdlin.
