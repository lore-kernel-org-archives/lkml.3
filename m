Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193AbaLSTGi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 14:06:38 -0500
Received: from mout.gmx.net ([212.227.17.20]:63954 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384AbaLSTGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 14:06:37 -0500
Message-ID: <549474B8.4010408@gmx.de>
Date: Fri, 19 Dec 2014 19:55:52 +0100
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, Arnd Bergmann <arnd@arndb.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] urandom: handle signals immediately
References: <54707352.8050208@gmx.de> <1417252349-808-1-git-send-email-xypron.glpk@gmx.de> <20141219165739.GA11655@thunk.org>
In-Reply-To: <20141219165739.GA11655@thunk.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:lpRmYJBnUYuqizXRcKI+UnRxAQE9PeFD0S2RgIw3cn/ki+VyCKq
 44mm0KrkWQxVNRaW4YqXFIVKD5RDP0jTE8vmdZraXd+f/XWnyW2CYBGiav8gIV7tg9I8lLU
 02eSDjljfcfPTp128VU5BlB3Zmbuh5TqQRG5y1Ph0md1hRjUKJ2sODE6wcaMFSspt09TbFq
 d2yZ2qf3vAc76Kg+btllw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ted,

thanks for the review.

On 19.12.2014 17:57, Theodore Ts'o wrote:
> On Sat, Nov 29, 2014 at 10:12:29AM +0100, Heinrich Schuchardt wrote:
>...
> I'm not sure where you are getting 30 seconds from,

The example code is in https://lkml.org/lkml/2014/11/22/41 .
Running it on an EdgeRouter Lite which has a Cavium Octeon MIPS 
processor, it took more than 30s to get a response for an interrupt 
(after creating of 0x12345678 = 305,419,896 pseudo random bytes).

> but you're right
> that it would be better to check signal_pending() on each loop.  That
> being said, your patch isn't right.
>
>> +		/*
>> +		 * getrandom must not be interrupted by a signal while
>> +		 * reading up to 256 bytes.
>> +		 */
>> +		if (signal_pending(current) && ret > 256)
>> +			break;
>> +		if (need_resched())
>>   			schedule();
>> -		}
>
> This means that we can reschedule even for small requests, and that's
> no good; getrandom *must* be atomic.

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=c6e9d6f38894798696f23c8084ca7edbf16ee895
does not indicate this as a necessary property.

Could you, please, explain why getrandom must be atomic.
I would like to add a comment line with the next version of my patch.

>  You also need to return
> -ERESTARTSYS if we get interrupted with no bytes.  So this needs to be
> something like this:
>
> 		if (ret > 256) {
> 			if (signal_pending(current)) {
> 				if (ret == 0)

This line will never be reached because ret > 256.

The idea in my patch was, that we will not react to an interrupt during
the generation of the first 256 bytes. Hence there is not need to return 
ERESTARTSYS. Instead we will always return a positive number except if 
the entropy buffer is not yet intialized.

This just removes the inconsistency that ERESTARTSYS may arise for calls 
for more than 256 bytes, but not for calls up to 256 bytes.

Do you see any need to react to an interrupt before copying the first byte?

> 					ret = -ERESTARTSYS;
> 				break;
> 			}
> 			if (need_resched())
> 				schedule();
> 		}

Best regards

Heinrich Schuchardt

