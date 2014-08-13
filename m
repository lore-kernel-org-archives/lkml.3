Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbaHMOSl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 10:18:41 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:45428 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbaHMOSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 10:18:39 -0400
Date: Wed, 13 Aug 2014 15:18:36 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Matt Fleming <matt.fleming@intel.com>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] firmware: Do not use WARN_ON(!spin_is_locked())
Message-ID: <20140813141836.GQ15082@console-pimps.org>
References: <1407729253-31341-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407729253-31341-1-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Aug, at 08:54:13PM, Guenter Roeck wrote:
> spin_is_locked() always returns false for uniprocessor configurations,
> so do not use WARN_ON with it. WARN_ON_SMP() exists for that very
> purpose and must be used instead.
 
Good catch, though I worry that WARN_ON_SMP() doesn't seem to be a very
common pattern,

arch/x86/pci/i386.c:	WARN_ON_SMP(!spin_is_locked(&pcibios_fwaddrmap_lock));
drivers/gpu/drm/drm_irq.c:	WARN_ON_SMP(!spin_is_locked(&dev->event_lock));
include/asm-generic/bug.h: * WARN_ON_SMP() is for cases that the warning is either
include/asm-generic/bug.h: *	WARN_ON_SMP(!zoot->bar);
include/asm-generic/bug.h: * For CONFIG_SMP, WARN_ON_SMP() should act the same as WARN_ON(),
include/asm-generic/bug.h: * if (WARN_ON_SMP(x)) returns true only when CONFIG_SMP is set
include/asm-generic/bug.h:# define WARN_ON_SMP(x)			WARN_ON(x)
include/asm-generic/bug.h: * Use of ({0;}) because WARN_ON_SMP(x) may be used either as
include/asm-generic/bug.h:# define WARN_ON_SMP(x)			({0;})
kernel/futex.c:	if (WARN_ON_SMP(!q->lock_ptr || !spin_is_locked(q->lock_ptr))

and people must want to do this kind of checking all the time.

How about lockdep_assert_held()? That seems to be much more popular.

-- 
Matt Fleming, Intel Open Source Technology Center
