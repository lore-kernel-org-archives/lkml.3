Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632Ab3FNTS3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 15:18:29 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:50934 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784Ab3FNTS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 15:18:28 -0400
Message-ID: <51BB6C80.1070704@linaro.org>
Date: Fri, 14 Jun 2013 12:18:24 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        rtc-linux@googlegroups.com, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [PATCH 7/9] RFC: rtc: implement rtc_read_timeval()
References: <51BA1FF7.4000206@ahsoftware.de> <1371228732-5749-1-git-send-email-holler@ahsoftware.de> <1371228732-5749-8-git-send-email-holler@ahsoftware.de> <51BB51A0.6050408@linaro.org> <51BB565A.1010305@ahsoftware.de>
In-Reply-To: <51BB565A.1010305@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2013 10:43 AM, Alexander Holler wrote:
> Am 14.06.2013 19:23, schrieb John Stultz:
>> On 06/14/2013 09:52 AM, Alexander Holler wrote:
>>> Some RTCs offer a higher resolution than seconds. To support reading 
>>> such
>>> high resolution timestamps from inside the kernel implement
>>> rtc_read_timeval() and add a read_timeval to the rtc-ops.
>>
>> So I like the direction this patch is going. But if we're going to add a
>> new interface, lets not use an already out-dated structure (timeval).
>>
>> Instead could you rework this to be timepsec based? Or ktime_t if its
>> really internal only?
>
> Sure, no problem. I wasn't aware timeval is out-dated and I've read 
> somewhere in the sources a comment that ktime_t has to disappear. I 
> had no clue if I should use timeval or timespec, and just have roled a 
> dice to decide between timeval and timespec.
>
> That "internal only" is only because I don't want to write changes for 
> the userspace api to handle RTCs with greater precision than seconds. 
> I don't have a writable RTC supporting such a precision and I want to 
> leave this for people which are developing such devices and earning 
> money with them.
>

Ok. Pushing it out to userland and the settime interfaces are probably 
logically separate enough.

That said, the the pain with this change is it leaves us with duplicate 
internal interfaces to read the time. So at some point we'll have to go 
through all the clocksource drivers and convert them to provide the 
timespec granular method, even if they just return the second portion.

Otherwise, you end up with a mishmash of some users using the second 
granular and some users using the highres and not all RTCs working for 
all users (or the users have to do their own fallback logic).

That said, I think such a transition is needed eventually, and this gets 
us at least started in that direction.

Alessandro: You have any thoughts here on how to best approach this sort 
of eventually far-reaching change?

thanks
-john

