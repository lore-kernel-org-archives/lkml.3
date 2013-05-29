Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967140Ab3E2Wxb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 18:53:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47391 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967122Ab3E2WxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 18:53:21 -0400
Date: Thu, 30 May 2013 00:53:17 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Russ Anderson <rja@sgi.com>
Cc: Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <matthew.garrett@nebula.com>, matt.fleming@intel.com,
        linux-efi@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
 info to runtime code
In-Reply-To: <20130529224645.GA16582@sgi.com>
Message-ID: <alpine.LNX.2.00.1305300048520.30576@pobox.suse.cz>
References: <20130522162747.GA20816@sgi.com> <20130523115801.GJ14575@console-pimps.org> <20130523203234.GD20913@sgi.com> <20130524074331.GL14575@console-pimps.org> <20130529210115.GC28027@sgi.com> <alpine.LRH.2.00.1305300018180.1111@twin.jikos.cz>
 <20130529224645.GA16582@sgi.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 May 2013, Russ Anderson wrote:

> > Yes, but this call is clearly happening way before ExitBootServices() -- 
> > see the surrounding code, see for example this in efi_main():
> > 
> > [ ... snip ... ]
> > 	setup_efi_vars(boot_params);
> > 
> > 	setup_efi_pci(boot_params);
> > 
> > 	status = efi_call_phys3(sys_table->boottime->allocate_pool,
> > 				EFI_LOADER_DATA, sizeof(*gdt),
> > 				(void **)&gdt);
> > 	if (status != EFI_SUCCESS) {
> > 		efi_printk("Failed to alloc mem for gdt structure\n");
> > 		goto fail;
> > 	}
> > [ ... snip ... ]
> 
> Yes.  Note the failing call is sys_table->runtime while all the
> other calls are sys_table->boottime and seem to work.  Not sure
> why the sys_table->runtime call has a problem but it may be
> a clue.  Could something in the runtime path not be set up???

That was my original idea early today as well. My understanding of the 
UEFI spec is admittedly limited, but afaics calling runtime method from 
boot environment should be a valid thing to do ... ?

> > We are calling QueryVariableInfo() in setup_efi_vars(), and later on 
> > AllocatePool is being called (through boot table).
> 
> On my system the QueryVariableInfo() call fails, so AllocatePool()
> is not called in setup_efi_vars().

But it's being called later on coming back to efi_main(). That was just a 
poor man's demonstration attempt why this code is running before 
ExitBootServices() has been called.

-- 
Jiri Kosina
SUSE Labs
