Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967105Ab3E2Wqz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 18:46:55 -0400
Received: from relay1.sgi.com ([192.48.179.29]:40873 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966329Ab3E2Wqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 18:46:47 -0400
Date: Wed, 29 May 2013 17:46:45 -0500
From: Russ Anderson <rja@sgi.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <matthew.garrett@nebula.com>, matt.fleming@intel.com,
        linux-efi@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
	info to runtime code
Message-ID: <20130529224645.GA16582@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20130522162747.GA20816@sgi.com> <20130523115801.GJ14575@console-pimps.org> <20130523203234.GD20913@sgi.com> <20130524074331.GL14575@console-pimps.org> <20130529210115.GC28027@sgi.com> <alpine.LRH.2.00.1305300018180.1111@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1305300018180.1111@twin.jikos.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 12:22:13AM +0200, Jiri Kosina wrote:
> On Wed, 29 May 2013, Russ Anderson wrote:
> 
> > > What appears to be happening is that your the EFI runtime services code
> > > is calling into the EFI boot services code, which is definitely a bug in
> > > your firmware because we're at runtime, but we've seen other machines
> > > that do similar things so we usually handle it just fine. However, what
> > > makes your case different, and the reason you see the above splat, is
> > > that it's using the physical address of the EFI boot services region,
> > > not the virtual one we setup with SetVirtualAddressMap(). Which is a
> > > second firmware bug. Again, we have seen other machines that access
> > > physical addresses after SetVirtualAddressMap(), but until now we
> > > haven't had any non-optional code that triggered them.
> > > 
> > > The only reason I can see that the offending commit would introduce this
> > > problem is because it calls QueryVariableInfo() at boot time. I notice
> > > that your machine is an SGI UV one, is there any chance you could get a
> > > firmware fix for this? If possible, it would be also good to confirm
> > > that it's this chunk of code in setup_efi_vars(),
> > > 
> > > 	status = efi_call_phys4(sys_table->runtime->query_variable_info,
> > > 				EFI_VARIABLE_NON_VOLATILE |
> > > 				EFI_VARIABLE_BOOTSERVICE_ACCESS |
> > > 				EFI_VARIABLE_RUNTIME_ACCESS, &store_size,
> > > 				&remaining_size, &var_size);
> > 
> > This does trigger the problem.  Note that the definition of
> > QueryVariableInfo() in the UEFI spec says:
> > 
> >   The returned MaximumVariableStorageSize, RemainingVariableStorageSize,
> >   MaximumVariableSize information may change immediately after the call
> >   based on other runtime activities including asynchronous error events.
> >   Also, these values associated with different attributes are not
> >   additive in nature.
> > 
> > Note the values may be accurate at the point in time when returned,
> > but may not be after that.
> > 
> >   After the system has transitioned into runtime (after
> >   ExitBootServices() is called), an implementation may not be able to
> >   accurately return information about the Boot Services variable store.
> >   In such cases, EFI_INVALID_PARAMETER should be returned.
> > 
> > It is not clear to me exactly when ExitBootServices() is called.
> > Our bios is returning a failing indication on the call.
> 
> Yes, but this call is clearly happening way before ExitBootServices() -- 
> see the surrounding code, see for example this in efi_main():
> 
> [ ... snip ... ]
> 	setup_efi_vars(boot_params);
> 
> 	setup_efi_pci(boot_params);
> 
> 	status = efi_call_phys3(sys_table->boottime->allocate_pool,
> 				EFI_LOADER_DATA, sizeof(*gdt),
> 				(void **)&gdt);
> 	if (status != EFI_SUCCESS) {
> 		efi_printk("Failed to alloc mem for gdt structure\n");
> 		goto fail;
> 	}
> [ ... snip ... ]

Yes.  Note the failing call is sys_table->runtime while all the
other calls are sys_table->boottime and seem to work.  Not sure
why the sys_table->runtime call has a problem but it may be
a clue.  Could something in the runtime path not be set up???

> We are calling QueryVariableInfo() in setup_efi_vars(), and later on 
> AllocatePool is being called (through boot table).

On my system the QueryVariableInfo() call fails, so AllocatePool()
is not called in setup_efi_vars().

>                                                    That'd inherently fail 
> if we were calling it after ExitBootServices() has happened, but I believe 
> that call is succeeding on your affected system as well.
> 
> -- 
> Jiri Kosina
> SUSE Labs

-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
