Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967303Ab3E3CRA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 22:17:00 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:37635 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966496Ab3E3CQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 22:16:51 -0400
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
 info to runtime code
From: joeyli <jlee@suse.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Russ Anderson <rja@sgi.com>, Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <matthew.garrett@nebula.com>, matt.fleming@intel.com,
        linux-efi@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Borislav Petkov <bp@alien8.de>
In-Reply-To: <alpine.LNX.2.00.1305300048520.30576@pobox.suse.cz>
References: <20130522162747.GA20816@sgi.com>
	 <20130523115801.GJ14575@console-pimps.org> <20130523203234.GD20913@sgi.com>
	 <20130524074331.GL14575@console-pimps.org> <20130529210115.GC28027@sgi.com>
	 <alpine.LRH.2.00.1305300018180.1111@twin.jikos.cz>
	 <20130529224645.GA16582@sgi.com>
	 <alpine.LNX.2.00.1305300048520.30576@pobox.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 May 2013 10:16:12 +0800
Message-ID: <1369880172.17397.11.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 四，2013-05-30 於 00:53 +0200，Jiri Kosina 提到：
> On Wed, 29 May 2013, Russ Anderson wrote:
> 
> > > Yes, but this call is clearly happening way before ExitBootServices() -- 
> > > see the surrounding code, see for example this in efi_main():
> > > 
> > > [ ... snip ... ]
> > > 	setup_efi_vars(boot_params);
> > > 
> > > 	setup_efi_pci(boot_params);
> > > 
> > > 	status = efi_call_phys3(sys_table->boottime->allocate_pool,
> > > 				EFI_LOADER_DATA, sizeof(*gdt),
> > > 				(void **)&gdt);
> > > 	if (status != EFI_SUCCESS) {
> > > 		efi_printk("Failed to alloc mem for gdt structure\n");
> > > 		goto fail;
> > > 	}
> > > [ ... snip ... ]
> > 
> > Yes.  Note the failing call is sys_table->runtime while all the
> > other calls are sys_table->boottime and seem to work.  Not sure
> > why the sys_table->runtime call has a problem but it may be
> > a clue.  Could something in the runtime path not be set up???
> 
> That was my original idea early today as well. My understanding of the 
> UEFI spec is admittedly limited, but afaics calling runtime method from 
> boot environment should be a valid thing to do ... ?

QueryVariableInfo() is a runtime services, all runtime services should
available bother on boot time and runtime:

UEFI spec 2.3.1 P.109:
  Runtime Services
  Functions that are available before and after any call to  
  ExitBootServices(). These functions are described in Section 7.

> 
> > > We are calling QueryVariableInfo() in setup_efi_vars(), and later on 
> > > AllocatePool is being called (through boot table).
> > 
> > On my system the QueryVariableInfo() call fails, so AllocatePool()
> > is not called in setup_efi_vars().
> 
> But it's being called later on coming back to efi_main(). That was just a 
> poor man's demonstration attempt why this code is running before 
> ExitBootServices() has been called.
> 

Yes, I agreed your point, the space information of
EFI_VARIABLE_BOOTSERVICE_ACCESS should still return by
QueryVariableInfo() because we call it before ExitBootServices():

arch/x86/boot/compressed/eboot.c
efi_main(void *handle, efi_system_table_t *_table, struct boot_params *boot_params)
	..
	sys_table = _table;
	/* Check if we were booted by the EFI firmware */
	if (sys_table->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
		goto fail;
	boot_params->secure_boot = get_secure_boot(sys_table)			/* check does BIOS in secure boot mode */
	setup_graphics(boot_params);
	setup_efi_vars(boot_params);						/* Pass boot services variable info to runtime code, call QueryVariableInfo() */
	...
	status = exit_boot(boot_params, handle);				/* call ExitBootServices() */
	...


Thanks a lot!
Joey Lee

