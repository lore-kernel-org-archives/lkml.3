Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab3A2LLq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 06:11:46 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:43384 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720Ab3A2LLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 06:11:44 -0500
Message-ID: <5107AE4F.9000809@ahsoftware.de>
Date: Tue, 29 Jan 2013 12:11:11 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Bernie Thompson <bernie@plugable.com>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/3 v2] fb: udlfb: fix hang at disconnect
References: <50F2A310.5010006@ahsoftware.de> <1359139768-32294-1-git-send-email-holler@ahsoftware.de> <1359139768-32294-2-git-send-email-holler@ahsoftware.de> <20130128162238.7fba92fe.akpm@linux-foundation.org> <51071E21.9030008@ahsoftware.de> <5107A5ED.7020009@ahsoftware.de>
In-Reply-To: <5107A5ED.7020009@ahsoftware.de>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 29.01.2013 11:35, schrieb Alexander Holler:
> Am 29.01.2013 01:56, schrieb Alexander Holler:
>> Am 29.01.2013 01:22, schrieb Andrew Morton:
>>> On Fri, 25 Jan 2013 19:49:27 +0100
>>> Alexander Holler <holler@ahsoftware.de> wrote:
>>>
>>>> When a device was disconnected the driver may hang at waiting for
>>>> urbs it never
>>>> will get. Fix this by using a timeout while waiting for the used
>>>> semaphore.
>>>>
>>>> There is still a memory leak if a timeout happens, but at least the
>>>> driver
>>>> now continues his disconnect routine.
>>>>
>>>> ...
>>>>
>>>> --- a/drivers/video/udlfb.c
>>>> +++ b/drivers/video/udlfb.c
>>>> @@ -1832,8 +1832,9 @@ static void dlfb_free_urb_list(struct
>>>> dlfb_data *dev)
>>>>       /* keep waiting and freeing, until we've got 'em all */
>>>>       while (count--) {
>>>>
>>>> -        /* Getting interrupted means a leak, but ok at disconnect */
>>>> -        ret = down_interruptible(&dev->urbs.limit_sem);
>>>> +        /* Timeout likely occurs at disconnect (resulting in a
>>>> leak) */
>>>> +        ret = down_timeout_killable(&dev->urbs.limit_sem,
>>>> +                        FREE_URB_TIMEOUT);
>>>>           if (ret)
>>>>               break;
>>>
>>> This is rather a hack.  Do you have an understanding of the underlying
>>> bug?  Why is the driver waiting for things which will never happen?
>
> To add a bit more explanation:
>
> I've experienced that bug after moving the fb-damage-handling into a
> workqueue (to make the driver usable as console). This likely has
> increased the possibility that an urb gets missed when the usb-stack
> calls the (usb-)disconnect function of the driver. But I don't know as I
> couldn't use the driver before (as fbcon) so I don't really have a
> comparison.
>
> What currently happens here is something like that:
>
> fb -> damage -> workload which sends urb and waits for answer
> device disconnect -> dlfb_usb_disconnect() -> stall (no answer to the
> above urb)
>
> I don't know why the disconnect waits for all urbs. The code looks like
> it does that just to free the allocated memory. As I'm not very familiar
> with the usb-stack, I would have to read up about the urb-handling to
> find out how to free the memory otherwise.
>
> As the previous comment in the code suggests that urbs already got
> missed (on shutdown) before, I assume that even without my patch, which
> moved the damage into a workqueue, the problem could occur which then
> prevents a shutdown as there is no timeout. As I've experienced that
> problem not only on disconnect, but on shutdown too (no shutdown was
> possible), I have to assume, that the previous used down_interruptible()
> didn't get a signal on shutdown (if the driver is used as fbcon),
> therefor I consider the timeout as necessary.

To explain the problem on shutdown a bit further, I think the following 
happens (usb and driver are statically linked and started by the kernel):

shutdown -> kill signal -> usb stack shuts down -> udlfb waits (forever) 
for a kill or an urb which it doesn't get.

Maybe the sequence is different if the usb-stack and udlfb are used as a 
module and/or udlfb is used only for X/fb. I'm not sure what actually 
does shut down the usb-stack in such a case, but maybe more than one 
kill signal might be thrown around.

Regards,

Alexander

