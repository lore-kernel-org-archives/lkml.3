Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbaHMOhm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 10:37:42 -0400
Received: from mail.active-venture.com ([67.228.131.205]:63779 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbaHMOhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 10:37:40 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53EB7831.4080306@roeck-us.net>
Date: Wed, 13 Aug 2014 07:37:37 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>
CC: Matt Fleming <matt.fleming@intel.com>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] firmware: Do not use WARN_ON(!spin_is_locked())
References: <1407729253-31341-1-git-send-email-linux@roeck-us.net> <20140813141836.GQ15082@console-pimps.org>
In-Reply-To: <20140813141836.GQ15082@console-pimps.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2014 07:18 AM, Matt Fleming wrote:
> On Sun, 10 Aug, at 08:54:13PM, Guenter Roeck wrote:
>> spin_is_locked() always returns false for uniprocessor configurations,
>> so do not use WARN_ON with it. WARN_ON_SMP() exists for that very
>> purpose and must be used instead.
>
> Good catch, though I worry that WARN_ON_SMP() doesn't seem to be a very
> common pattern,
>
> arch/x86/pci/i386.c:	WARN_ON_SMP(!spin_is_locked(&pcibios_fwaddrmap_lock));
> drivers/gpu/drm/drm_irq.c:	WARN_ON_SMP(!spin_is_locked(&dev->event_lock));
> include/asm-generic/bug.h: * WARN_ON_SMP() is for cases that the warning is either
> include/asm-generic/bug.h: *	WARN_ON_SMP(!zoot->bar);
> include/asm-generic/bug.h: * For CONFIG_SMP, WARN_ON_SMP() should act the same as WARN_ON(),
> include/asm-generic/bug.h: * if (WARN_ON_SMP(x)) returns true only when CONFIG_SMP is set
> include/asm-generic/bug.h:# define WARN_ON_SMP(x)			WARN_ON(x)
> include/asm-generic/bug.h: * Use of ({0;}) because WARN_ON_SMP(x) may be used either as
> include/asm-generic/bug.h:# define WARN_ON_SMP(x)			({0;})
> kernel/futex.c:	if (WARN_ON_SMP(!q->lock_ptr || !spin_is_locked(q->lock_ptr))
>
> and people must want to do this kind of checking all the time.
>
> How about lockdep_assert_held()? That seems to be much more popular.
>

WARN_ON and WARN_ON_SMP are unconditional. lockdep_assert_held()
is only active if lockdep debugging is enabled. Not knowing the code,
nor the reason why the unconditional method was chosen, I prefer
to refrain from functional changes and limit myself to bug fixes.

Also, if and how the code can be optimized is another question,
which in my opinion should be separate from a bug fix.

Anyway, this specific bug doesn't affect me at this time;
I only noticed the problem since mainline currently crashes
on several non-SMP platforms due to the same problem. So
I don't mind if this patch is not or not immediately applied
until the discussion about how to best fix it is complete.

Guenter

