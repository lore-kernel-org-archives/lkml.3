Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478Ab3JGUkA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 16:40:00 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:56545 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598Ab3JGUj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 16:39:59 -0400
Message-ID: <52531C1B.9070502@lwfinger.net>
Date: Mon, 07 Oct 2013 15:39:55 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [RFC] Add inline routine to free memory used in kobject name
References: <5252f2cd.33yoX1hUWLRsRUrq%Larry.Finger@lwfinger.net> <20131007201044.GA6305@kroah.com>
In-Reply-To: <20131007201044.GA6305@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2013 03:10 PM, Greg KH wrote:
> On Mon, Oct 07, 2013 at 12:43:41PM -0500, Larry Finger wrote:
>> At present, if one wants to free the memory allocation used for
>> a dev->kobj name, it is necessary to go quite deeply into the structure.
>
> Why would you ever want to do this?
>
>> To avoid this much dependence on the structure details in driver
>> code, a new inline routine is created.
>>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> ---
>>
>> Index: wireless-testing-save/include/linux/device.h
>> ===================================================================
>> --- wireless-testing-save.orig/include/linux/device.h
>> +++ wireless-testing-save/include/linux/device.h
>> @@ -27,6 +27,7 @@
>>   #include <linux/ratelimit.h>
>>   #include <linux/uidgid.h>
>>   #include <asm/device.h>
>> +#include <linux/slab.h>
>>
>>   struct device;
>>   struct device_private;
>> @@ -789,6 +790,11 @@ static inline const char *dev_name(const
>>   	return kobject_name(&dev->kobj);
>>   }
>>
>> +static inline void dev_free_name(struct device *dev)
>> +{
>> +	kfree(dev->kobj.name);
>> +}
>
> Please show how you would use this function, I can't add functions that
> no one calls.
>
> And given that this type of thing hasn't been needed before, I'm
> thinking that it still isn't needed :)

In the thread at 
http://lkml.indiana.edu/hypermail/linux/kernel/1310.0/02008.html, I reported a 
leak of kobj->name in the error path of the memstick driver. My solution was to 
free it in the error path by using

	kfree(card->dev.kobj.name);

Catalin Marinas responded with "It looks weird to go into dev.kobj internals 
here for freeing the name. There is also memstick_free_card() which doesn't seem 
to do anything about the name freeing."

Later in the thread, he agreed that having a new function sounded like a good 
idea. I should have submitted the second patch using the new function as follows:

Index: wireless-testing-save/drivers/memstick/core/memstick.c
===================================================================
--- wireless-testing-save.orig/drivers/memstick/core/memstick.c
+++ wireless-testing-save/drivers/memstick/core/memstick.c
@@ -195,6 +195,7 @@ static void memstick_free_card(struct de
  {
  	struct memstick_dev *card = container_of(dev, struct memstick_dev,
  						 dev);
+	dev_free_name(&card->dev);
  	kfree(card);
  }

@@ -415,6 +416,7 @@ static struct memstick_dev *memstick_all
  	return card;
  err_out:
  	host->card = old_card;
+	dev_free_name(&card->dev);
  	kfree(card);
  	return NULL;
  }

These changes clear up the memory leak that started the whole subject. The 
difference would be between
	kfree(card->dev.kobj.name);
and
	dev_free_name(&card->dev);

I have not looked at every line in the kernel containing both "kfree" and "name" 
to see how many other places that the new routine could be used. I'm not even 
sure how other drivers free the space allocated for a name.

Larry
