Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603AbaABWA7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 17:00:59 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:59677 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbaABWA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 17:00:58 -0500
Message-ID: <52C5EFAA.2070403@cogentembedded.com>
Date: Fri, 03 Jan 2014 02:00:58 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, Karsten Keil <isdn@linux-pingi.de>,
        netdev@vger.kernel.org
Subject: Re: [PATCH, RFC 21/30] isdn: divert, hysdn: fix interruptible_sleep_on
 race
References: <1388664474-1710039-1-git-send-email-arnd@arndb.de> <1388664474-1710039-22-git-send-email-arnd@arndb.de> <52C57F3B.9070509@cogentembedded.com> <3610183.tucaANtxQk@wuerfel>
In-Reply-To: <3610183.tucaANtxQk@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 01/02/2014 07:48 PM, Arnd Bergmann wrote:

>>> diff --git a/drivers/isdn/divert/divert_procfs.c b/drivers/isdn/divert/divert_procfs.c
>>> index fb4f1ba..1c5dc34 100644
>>> --- a/drivers/isdn/divert/divert_procfs.c
>>> +++ b/drivers/isdn/divert/divert_procfs.c
>>> @@ -86,12 +86,13 @@ isdn_divert_read(struct file *file, char __user *buf, size_t count, loff_t *off)
>>>        struct divert_info *inf;
>>>        int len;
>>>
>>> -     if (!*((struct divert_info **) file->private_data)) {
>>> +     if (!(inf = *((struct divert_info **) file->private_data))) {

>>      checkpatch.pl shouldn't approve assignment inside *if*. Though you're
>> moving it from the existing code, it wouldn't hurt to fix it.

> I tried to touch as little as possible, and while I wouldn't use that
> style myself, it is applied consistently in this driver, including the
> wait_event line I'm adding, where I feel it actually makes sense.

    I wasn't feeling sure about that one. It seems to me now that it doesn't 
make much sense -- we could do the assignment beforehand.

>>>                if (file->f_flags & O_NONBLOCK)
>>>                        return -EAGAIN;
>>> -             interruptible_sleep_on(&(rd_queue));
>>> +             wait_event_interruptible(rd_queue, (inf =
>>> +                     *((struct divert_info **) file->private_data)));

>>      Parens around assignment are hardly useful.

> We get a gcc warning without them:

> drivers/isdn/divert/divert_procfs.c:95:14: warning: suggest parentheses around assignment used as truth value [-Wparentheses]
>      *((struct divert_info **) file->private_data));

    Ah...

> I can still change the first one (in both files) if you think it's important,

    I always prefer checkpatch.pl-clean patches, though some people do argue 
when they are just moving the badly styled code around.

> but I'd rather not spend too much energy at coding style changes.

    Let's wait for the maintainer's opinion on this.

> 	Arnd

WBR, Sergei

