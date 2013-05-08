Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758021Ab3EHSVL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 14:21:11 -0400
Received: from mail.skyhub.de ([78.46.96.112]:56009 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757701Ab3EHSVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 14:21:08 -0400
Date: Wed, 8 May 2013 20:22:35 +0200
From: Borislav Petkov <bp@alien8.de>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com,
        mingo@redhat.com, fenghua.yu@intel.com, tglx@linutronix.de,
        xen-devel@lists.xensource.com, stable@vger.kernel.org
Subject: Re: [PATCH] x86, microcode: Add local mutex to not hit a deadlock.
Message-ID: <20130508182235.GE30955@pd.tnic>
References: <1368029583-23337-1-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1368029583-23337-1-git-send-email-konrad.wilk@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 08, 2013 at 12:13:03PM -0400, Konrad Rzeszutek Wilk wrote:
> This can easily be triggered if a new CPU is added (via
> ACPI hotplug mechanism) and from user-space do:
> 
> echo 1 > /sys/devices/system/cpu/cpu3/online
> 
> (or wait for UDEV to do it) on a newly appeared CPU.
> 
> The deadlock is that the "store_online" in drivers/base/cpu.c
> takes the cpu_hotplug_driver_lock() lock, then calls "cpu_up".
> "cpu_up" eventually ends up calling "save_mc_for_early"
> which also takes the cpu_hotplug_driver_lock() lock.
> 
> And here is that kernel thinks of it:
> 
> smpboot: Stack at about ffff880075c39f44
> smpboot: CPU3: has booted.
> microcode: CPU3 sig=0x206a7, pf=0x2, revision=0x25
> 
> =============================================
> [ INFO: possible recursive locking detected ]
> 3.9.0upstream-10129-g167af0e #1 Not tainted
> ---------------------------------------------
> sh/2487 is trying to acquire lock:
>  (x86_cpu_hotplug_driver_mutex){+.+.+.}, at: [<ffffffff81075512>] cpu_hotplug_driver_lock+0x12/0x20
> 
> but task is already holding lock:
>  (x86_cpu_hotplug_driver_mutex){+.+.+.}, at: [<ffffffff81075512>] cpu_hotplug_driver_lock+0x12/0x20
> 
> other info that might help us debug this:
>  Possible unsafe locking scenario:
> 
>        CPU0
>        ----
>   lock(x86_cpu_hotplug_driver_mutex);
>   lock(x86_cpu_hotplug_driver_mutex);
> 
>  *** DEADLOCK ***

Ok, just for my own understanding: is this something which can actually
happen now?

Judging by the presence of traces, it can be triggered in a guest,
correct?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
