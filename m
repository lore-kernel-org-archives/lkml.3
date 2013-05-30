Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967343Ab3E3CjY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 22:39:24 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:49209 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab3E3CjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 22:39:16 -0400
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
 info to runtime code
From: joeyli <jlee@suse.com>
To: Russ Anderson <rja@sgi.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <matthew.garrett@nebula.com>, matt.fleming@intel.com,
        linux-efi@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Borislav Petkov <bp@alien8.de>
In-Reply-To: <20130529224645.GA16582@sgi.com>
References: <20130522162747.GA20816@sgi.com>
	 <20130523115801.GJ14575@console-pimps.org> <20130523203234.GD20913@sgi.com>
	 <20130524074331.GL14575@console-pimps.org> <20130529210115.GC28027@sgi.com>
	 <alpine.LRH.2.00.1305300018180.1111@twin.jikos.cz>
	 <20130529224645.GA16582@sgi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 May 2013 10:38:33 +0800
Message-ID: <1369881513.17397.51.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 三，2013-05-29 於 17:46 -0500，Russ Anderson 提到：
> On Thu, May 30, 2013 at 12:22:13AM +0200, Jiri Kosina wrote:
> > On Wed, 29 May 2013, Russ Anderson wrote:
> > 
> > > > What appears to be happening is that your the EFI runtime services code
> > > > is calling into the EFI boot services code, which is definitely a bug in
> > > > your firmware because we're at runtime, but we've seen other machines
> > > > that do similar things so we usually handle it just fine. However, what
> > > > makes your case different, and the reason you see the above splat, is
> > > > that it's using the physical address of the EFI boot services region,
> > > > not the virtual one we setup with SetVirtualAddressMap(). Which is a
> > > > second firmware bug. Again, we have seen other machines that access
> > > > physical addresses after SetVirtualAddressMap(), but until now we
> > > > haven't had any non-optional code that triggered them.
> > > > 
> > > > The only reason I can see that the offending commit would introduce this
> > > > problem is because it calls QueryVariableInfo() at boot time. I notice
> > > > that your machine is an SGI UV one, is there any chance you could get a
> > > > firmware fix for this? If possible, it would be also good to confirm
> > > > that it's this chunk of code in setup_efi_vars(),
> > > > 
> > > > 	status = efi_call_phys4(sys_table->runtime->query_variable_info,
> > > > 				EFI_VARIABLE_NON_VOLATILE |
> > > > 				EFI_VARIABLE_BOOTSERVICE_ACCESS |
> > > > 				EFI_VARIABLE_RUNTIME_ACCESS, &store_size,
> > > > 				&remaining_size, &var_size);
> > > 
> > > This does trigger the problem.  Note that the definition of
> > > QueryVariableInfo() in the UEFI spec says:
> > > 
> > >   The returned MaximumVariableStorageSize, RemainingVariableStorageSize,
> > >   MaximumVariableSize information may change immediately after the call
> > >   based on other runtime activities including asynchronous error events.
> > >   Also, these values associated with different attributes are not
> > >   additive in nature.
> > > 
> > > Note the values may be accurate at the point in time when returned,
> > > but may not be after that.
> > > 
> > >   After the system has transitioned into runtime (after
> > >   ExitBootServices() is called), an implementation may not be able to
> > >   accurately return information about the Boot Services variable store.
> > >   In such cases, EFI_INVALID_PARAMETER should be returned.
> > > 
> > > It is not clear to me exactly when ExitBootServices() is called.
> > > Our bios is returning a failing indication on the call.
> > 
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
> 

Per UEFI spec Section 6, all runtime services should a available both on
boot time and runtime. And, we query the EFI_VARIABLE_BOOTSERVICE_ACCESS
space information before ExitBootServices(), that means we call it in
boot time, so, QueryVariableInfo() should return information to us.

Back to the kernel oops, the oops happened in runtime environment when
efivar_init running. As Matt's point out as following:

於 五，2013-05-24 於 08:43 +0100，Matt Fleming 提到： 
> On Thu, 23 May, at 03:32:34PM, Russ Anderson wrote:
> >    efi: mem127: type=4, attr=0xf, range=[0x000000006bb22000-0x000000007ca9c000) (271MB)
> 
> EFI_BOOT_SERVICES_CODE

Per UEFI 2.3.1 Section 6.2, type 4 is EfiBootServicesCode. This area available for
OS using after ExitBootServices():

UEFI 2.3.1 P.133
 EfiBootServicesData Memory available for general use.

So, any runtime services should not access this area, it's the first thing need to check
the BIOS code for why.

> >    efi: mem133: type=5, attr=0x800000000000000f, range=[0x000000007daff000-0x000000007dbff000) (1MB)
> 
> EFI_RUNTIME_SERVICES_CODE
> 
> >    EFI Variables Facility v0.08 2004-May-17
> >    BUG: unable to handle kernel paging request at 000000007ca95b10
> >    IP: [<ffff88007dbf2140>] 0xffff88007dbf213f
[...]
What appears to be happening is that your the EFI runtime services code
> is calling into the EFI boot services code, which is definitely a bug in
> your firmware because we're at runtime, but we've seen other machines
> that do similar things so we usually handle it just fine. However, what
> makes your case different, and the reason you see the above splat, is
> that it's using the physical address of the EFI boot services region,
> not the virtual one we setup with SetVirtualAddressMap(). Which is a
> second firmware bug. Again, we have seen other machines that access
> physical addresses after SetVirtualAddressMap(), but until now we
> haven't had any non-optional code that triggered them.

Actually, when efivars doing init, system is already in virtual mode not just runtime
mode, that means OS already call SetVirtualAddressMap() to set the EfiBootServicesCode 
and EfiBootServicesData to virtual address.

As Matt's point out, the second things need to check is why does paging fault
happen on physical address after SetVirtualAddressMap().

Currently, the only clue is we call QueryVariableInfo() in boottime for grab the space
information of EFI_VARIABLE_BOOTSERVICE_ACCESS, but it should permitted because it's 
in boot time:

於 五，2013-05-24 於 08:43 +0100，Matt Fleming 提到：
>         status = efi_call_phys4(sys_table->runtime->query_variable_info,
>                                 EFI_VARIABLE_NON_VOLATILE |
>                                 EFI_VARIABLE_BOOTSERVICE_ACCESS |
>                                 EFI_VARIABLE_RUNTIME_ACCESS, &store_size,
>                                 &remaining_size, &var_size); 

Thanks a lot!
Joey Lee

