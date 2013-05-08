Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049Ab3EHSTx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 14:19:53 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:47008 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757870Ab3EHSTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 14:19:49 -0400
Message-ID: <1368037185.30363.58.camel@misato.fc.hp.com>
Subject: Re: v3.9 - CPU hotplug and microcode earlier loading hits a mutex
 deadlock (x86_cpu_hotplug_driver_mutex)
From: Toshi Kani <toshi.kani@hp.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Borislav Petkov <bp@alien8.de>, prarit@redhat.com,
        rafael.j.wysocki@intel.com, isimatu.yasuaki@jp.fujitsu.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, fenghua.yu@intel.com,
        xen-devel@lists.xensource.com
Date: Wed, 08 May 2013 12:19:45 -0600
In-Reply-To: <20130508163249.GB369@phenom.dumpdata.com>
References: <20130506125937.GA14036@phenom.dumpdata.com>
	 <20130507190024.GA4303@phenom.dumpdata.com>
	 <20130508125414.GB30955@pd.tnic>
	 <20130508140342.GA8152@phenom.dumpdata.com>
	 <20130508142949.GC30955@pd.tnic> <20130508163249.GB369@phenom.dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-08 at 12:32 -0400, Konrad Rzeszutek Wilk wrote:
> On Wed, May 08, 2013 at 04:29:49PM +0200, Borislav Petkov wrote:
> > On Wed, May 08, 2013 at 10:03:42AM -0400, Konrad Rzeszutek Wilk wrote:
> > 
> > [ … snip some funky BIOS code ]
> > 
> > > [here it shifts and continues on testing each CPU bit]
> > > 
> > > > Questions over questions...?
> > > 
> > > I probably went overboard with my answers :-)
> > 
> > Konrad, you're killing me! :-) You actually went and looked at the
> > BIOS disassembly voluntarily. You must be insane, I think you should
> > immediately go to the doctor now for a thorough checkup. :-)
> > 
> > I think I know who I can sling BIOS issues now to.
> 
> Great .. :-)
> > 
> > > > Looks like save_mc_for_early would need another, local mutex to fix that.
> > > 
> > > Let me try that. Thanks for the suggestion.
> > 
> > Ok, seriously now: yeah, this was just an idea, it should at least get
> > the nesting out of the way.
> > 
> > About the BIOS deal: you're probably staring at some BIOS out there
> > but is this the way that it is actually going to be implemented on
> > the physical hotplug BIOS? I mean, I've only heard rumors about IVB
> > supporting physical hotplug but do you even have access to such BIOS to
> > verify?
> 
> Unfortunatly not. I am getting an IvyTown box so hopefully that has this
> support. But I thought that Fenghua did since he mentioned in the patch.
> 
> Besides that I think this can also appear on VMWare if one is doing 
> CPU hotplug and on some HP machines - let me CC the relevant people
> extracted from drivers/acpi/processor_driver.c.
> (see  https://lkml.org/lkml/2013/5/7/588 for the thread)

>From the stack trace, it looks like a bug in save_mc_for_early().  This
function may not call cpu_hotplug_driver_lock() during CPU online.  I
suppose it intends to protect from CPU offline when microcode is updated
outside of the boot/CPU online context.  If it indeed supports updating
the microcode without using reboot/cpu hotplug, the lock should be held
when such update request is made.

Thanks,
-Toshi

