Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839Ab3EaKNF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 06:13:05 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:52173 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754831Ab3EaKMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 06:12:55 -0400
Date: Fri, 31 May 2013 12:12:50 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Russ Anderson <rja@sgi.com>, joeyli <jlee@suse.com>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <matthew.garrett@nebula.com>, matt.fleming@intel.com,
        linux-efi@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
 info to runtime code
Message-ID: <20130531101250.GD30394@gmail.com>
References: <20130523115801.GJ14575@console-pimps.org>
 <20130523203234.GD20913@sgi.com>
 <20130524074331.GL14575@console-pimps.org>
 <20130529210115.GC28027@sgi.com>
 <alpine.LRH.2.00.1305300018180.1111@twin.jikos.cz>
 <20130529224645.GA16582@sgi.com>
 <alpine.LNX.2.00.1305300048520.30576@pobox.suse.cz>
 <1369880172.17397.11.camel@linux-s257.site>
 <20130530221737.GA11105@sgi.com>
 <alpine.LNX.2.00.1305310023020.30576@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1305310023020.30576@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Kosina <jkosina@suse.cz> wrote:

> On Thu, 30 May 2013, Russ Anderson wrote:
> 
> > > > > > Yes, but this call is clearly happening way before ExitBootServices() -- 
> > > > > > see the surrounding code, see for example this in efi_main():
> > > > > > 
> > > > > > [ ... snip ... ]
> > > > > > 	setup_efi_vars(boot_params);
> > > > > > 
> > > > > > 	setup_efi_pci(boot_params);
> > > > > > 
> > > > > > 	status = efi_call_phys3(sys_table->boottime->allocate_pool,
> > > > > > 				EFI_LOADER_DATA, sizeof(*gdt),
> > > > > > 				(void **)&gdt);
> > > > > > 	if (status != EFI_SUCCESS) {
> > > > > > 		efi_printk("Failed to alloc mem for gdt structure\n");
> > > > > > 		goto fail;
> > > > > > 	}
> > > > > > [ ... snip ... ]
> > > > > 
> > > > > Yes.  Note the failing call is sys_table->runtime while all the
> > > > > other calls are sys_table->boottime and seem to work.  Not sure
> > > > > why the sys_table->runtime call has a problem but it may be
> > > > > a clue.  Could something in the runtime path not be set up???
> > > > 
> > > > That was my original idea early today as well. My understanding of the 
> > > > UEFI spec is admittedly limited, but afaics calling runtime method from 
> > > > boot environment should be a valid thing to do ... ?
> > > 
> > > QueryVariableInfo() is a runtime services, all runtime services should
> > > available bother on boot time and runtime:
> > > 
> > > UEFI spec 2.3.1 P.109:
> > >   Runtime Services
> > >   Functions that are available before and after any call to  
> > >   ExitBootServices(). These functions are described in Section 7.
> > 
> > That's a great idea.  This patch moves the QueryVariableInfo()
> > call from bootime to runtime, in efi_late_init().  The attached
> > patch is consistent with the UEFI spec and avoids the problem.
> 
> Unfortunately that means that you can as well throw the patch away 
> completely.
> 
> The sole point is to run the QueryVariableInfo() from the boot 
> environment, in order to obtain more accurate information. And it's a 
> valid thing to do, according to UEFI specification.

Argh!

The 'UEFI specification', if contradicted by reality, has _NO VALUE_ 
whatsoever. Full stop.

Any specification is only valuable as long as it's followed by everyone: 
but once that is not the case, it does not matter much what the written 
wishes on the paper express.

What matters is that a system that booted fine with v3.8 does not boot 
anymore due to a change we did to the EFI code. And the only valid 
response to that is to make it work. Full stop!

And this is not only about SGI/UV systems: in this thread there were 
multiple systems mentioned that _DO NOT BOOT_ due to this change.

So this change needs to be reverted or fixed.

Thanks,

	Ingo
