Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982Ab3EHSlu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 14:41:50 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:42994 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab3EHSls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 14:41:48 -0400
Date: Wed, 8 May 2013 14:41:17 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com,
        mingo@redhat.com, fenghua.yu@intel.com, tglx@linutronix.de,
        xen-devel@lists.xensource.com, stable@vger.kernel.org
Subject: Re: [PATCH] x86, microcode: Add local mutex to not hit a deadlock.
Message-ID: <20130508184117.GC11906@phenom.dumpdata.com>
References: <1368029583-23337-1-git-send-email-konrad.wilk@oracle.com>
 <20130508182235.GE30955@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130508182235.GE30955@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 08, 2013 at 08:22:35PM +0200, Borislav Petkov wrote:
> On Wed, May 08, 2013 at 12:13:03PM -0400, Konrad Rzeszutek Wilk wrote:
> > This can easily be triggered if a new CPU is added (via
> > ACPI hotplug mechanism) and from user-space do:
> > 
> > echo 1 > /sys/devices/system/cpu/cpu3/online
> > 
> > (or wait for UDEV to do it) on a newly appeared CPU.
> > 
> > The deadlock is that the "store_online" in drivers/base/cpu.c
> > takes the cpu_hotplug_driver_lock() lock, then calls "cpu_up".
> > "cpu_up" eventually ends up calling "save_mc_for_early"
> > which also takes the cpu_hotplug_driver_lock() lock.
> > 
> > And here is that kernel thinks of it:
> > 
> > smpboot: Stack at about ffff880075c39f44
> > smpboot: CPU3: has booted.
> > microcode: CPU3 sig=0x206a7, pf=0x2, revision=0x25
> > 
> > =============================================
> > [ INFO: possible recursive locking detected ]
> > 3.9.0upstream-10129-g167af0e #1 Not tainted
> > ---------------------------------------------
> > sh/2487 is trying to acquire lock:
> >  (x86_cpu_hotplug_driver_mutex){+.+.+.}, at: [<ffffffff81075512>] cpu_hotplug_driver_lock+0x12/0x20
> > 
> > but task is already holding lock:
> >  (x86_cpu_hotplug_driver_mutex){+.+.+.}, at: [<ffffffff81075512>] cpu_hotplug_driver_lock+0x12/0x20
> > 
> > other info that might help us debug this:
> >  Possible unsafe locking scenario:
> > 
> >        CPU0
> >        ----
> >   lock(x86_cpu_hotplug_driver_mutex);
> >   lock(x86_cpu_hotplug_driver_mutex);
> > 
> >  *** DEADLOCK ***
> 
> Ok, just for my own understanding: is this something which can actually
> happen now?

Yes. Since v3.9 I've been getting this.
> 
> Judging by the presence of traces, it can be triggered in a guest,
> correct?

Correct. I don't have the hardware to test this on baremetal but looking
at how processor-driver.c works I would think this would be hit there as well.

> 
> Thanks.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> Sent from a fat crate under my desk. Formatting is fine.
> --
