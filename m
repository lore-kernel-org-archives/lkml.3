Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab3A1Pqo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 10:46:44 -0500
Received: from smtp5.epfl.ch ([128.178.224.8]:57889 "HELO smtp5.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751757Ab3A1Pqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 10:46:42 -0500
Message-ID: <51069D5E.7030108@epfl.ch>
Date: Mon, 28 Jan 2013 16:46:38 +0100
From: Florian Vaussard <florian.vaussard@epfl.ch>
Reply-To: florian.vaussard@epfl.ch
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Bryan Wu <cooloney@gmail.com>, linux-kernel@vger.kernel.org,
        Richard Purdie <rpurdie@rpsys.net>, linux-leds@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/3] pwm: Add pwm_cansleep() as exported API to users
References: <1359121471-21457-1-git-send-email-florian.vaussard@epfl.ch> <1359121471-21457-2-git-send-email-florian.vaussard@epfl.ch> <20130126054024.GB29243@avionic-0098.adnet.avionic-design.de> <51063AB5.2060108@ti.com> <51064687.5090605@epfl.ch> <20130128150113.GL23505@n2100.arm.linux.org.uk>
In-Reply-To: <20130128150113.GL23505@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Le 28/01/2013 16:01, Russell King - ARM Linux a écrit :
> On Mon, Jan 28, 2013 at 10:36:07AM +0100, Florian Vaussard wrote:
>> Hello,
>>
>> Le 28/01/2013 09:45, Peter Ujfalusi a écrit :
>>> hi Thierry,
>>>
>>> On 01/26/2013 06:40 AM, Thierry Reding wrote:
>>>>> +{
>>>>> +	return pwm->chip->can_sleep;
>>>>> +}
>>>>> +EXPORT_SYMBOL_GPL(pwm_cansleep);
>>>>
>>>> Would it make sense to check for NULL pointers here? I guess that
>>>> passing NULL into the function could be considered a programming error
>>>> and an oops would be okay, but in that case there's no point in making
>>>> the function return an int. Also see my next comment.
>>>
>>> While it is unlikely to happen it is better to be safe, something like this
>>> will do:
>>>
>>> return pwm ? pwm->chip->can_sleep : 0;
>>>
>>
>> Ok. And what about:
>>
>> BUG_ON(pwm == NULL);
>> return pwm->chip->can_sleep;
>
> Let's get something straight.
>
> 1. Don't use BUG_ON() as some kind of willy nilly assert() replacement.
>     Linus refused to have assert() in the kernel because assert() gets not
>     only over-used, but also gets inappropriately used too.
>
>     _Only_ _ever_ use BUG_ON() if continuing is going to cause user
>     noticable data loss which is not reportable to userspace.  In other
>     words, block device queue corruption or the like - where bringing the
>     system down is going to _save_ the system from itself.
>
>     Otherwise, return an error and/or use WARN_ON().
>
> 2. If you want a slow kernel, then by all means check your arguments to
>     your functions.  While you're at it, why not check that strings which
>     are passed contain only the characters you expect them to?  And, if
>     you're bothering to check against a NULL pointer, what about NULL+1
>     pointers which are also invalid?  Why not invent some function to
>     ensure that the pointer is a valid kernel pointer.  Maybe you'll have
>     to interate the vmalloc lists too - yay, more code to be executed!
>     That must be good!
>
> In your example, if you're going to check that pwm is non-NULL, what
> if pwm->chip is non-NULL?  How far do you take this?
>
> Or... just like most of the core kernel does, it does _not_ verify on
> function entry that the pointer is "correct" unless it is explicitly
> defined that the function may take a NULL pointer (like kfree()).
> Everything else just goes right on and does the dereference - and if
> the pointer was wrong, we hope that the MMU faults and we get a kernel
> oops.
>
> Have a read through the code in fs/ or kernel/ and see how many functions
> you can spot in there which validate their pointers which aren't dealing
> with data from userland.
>
> You'll find almost no function checking that an inode pointer is not NULL.
> Or a struct file pointer.  Or a struct path pointer... etc.
>
> Yet, you come to ARM code, and it seems "popular" that pointer arguments
> need to be verified on every single function call.  Why is this?
>
> I don't know if Andrew would like to inject something here (I've added
> him) on this subject...
>

The v3 does not contain the check.

Thank you,

Florian
