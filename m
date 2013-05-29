Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967070Ab3E2VB1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 17:01:27 -0400
Received: from relay1.sgi.com ([192.48.179.29]:37278 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967053Ab3E2VBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 17:01:18 -0400
Date: Wed, 29 May 2013 16:01:16 -0500
From: Russ Anderson <rja@sgi.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Matthew Garrett <matthew.garrett@nebula.com>, matt.fleming@intel.com,
        linux-efi@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
	info to runtime code
Message-ID: <20130529210115.GC28027@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20130522162747.GA20816@sgi.com> <20130523115801.GJ14575@console-pimps.org> <20130523203234.GD20913@sgi.com> <20130524074331.GL14575@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130524074331.GL14575@console-pimps.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 24, 2013 at 08:43:31AM +0100, Matt Fleming wrote:
> On Thu, 23 May, at 03:32:34PM, Russ Anderson wrote:
> >    efi: mem127: type=4, attr=0xf, range=[0x000000006bb22000-0x000000007ca9c000) (271MB)
> 
> EFI_BOOT_SERVICES_CODE
> 
> >    efi: mem133: type=5, attr=0x800000000000000f, range=[0x000000007daff000-0x000000007dbff000) (1MB)
> 
> EFI_RUNTIME_SERVICES_CODE
> 
> >    EFI Variables Facility v0.08 2004-May-17
> >    BUG: unable to handle kernel paging request at 000000007ca95b10
> >    IP: [<ffff88007dbf2140>] 0xffff88007dbf213f
> 
> >     [<ffffffff810499b3>] ?  efi_call3+0x43/0x80
> >     [<ffffffff810492a7>] ?  virt_efi_get_next_variable+0x47/0x1c0
> >     [<ffffffff814c8cc0>] ?  create_efivars_bin_attributes+0x150/0x150
> >     [<ffffffff814c7b55>] ?  efivar_init+0xd5/0x390
> >     [<ffffffff814c8ae0>] ?  efivar_update_sysfs_entries+0x90/0x90
> >     [<ffffffff812f906b>] ?  kobject_uevent+0xb/0x10
> >     [<ffffffff812f812b>] ?  kset_register+0x5b/0x70
> >     [<ffffffff814c8cc0>] ?  create_efivars_bin_attributes+0x150/0x150
> >     [<ffffffff814c8d47>] ?  efivars_sysfs_init+0x87/0xf0
> >     [<ffffffff8100032a>] ?  do_one_initcall+0x15a/0x1b0
> >     [<ffffffff81a17831>] ?  do_basic_setup+0xad/0xce
> >     [<ffffffff81a17ae3>] ?  kernel_init_freeable+0x291/0x291
> >     [<ffffffff81a3708a>] ?  sched_init_smp+0x15b/0x162
> >     [<ffffffff81a17a5f>] ?  kernel_init_freeable+0x20d/0x291
> >     [<ffffffff81601eb0>] ?  rest_init+0x80/0x80
> >     [<ffffffff81601ebe>] ?  kernel_init+0xe/0x180
> >     [<ffffffff8162179c>] ?  ret_from_fork+0x7c/0xb0
> >     [<ffffffff81601eb0>] ?  rest_init+0x80/0x80
> 
> Here's the real call stack leading up to the crash.
> 
> What appears to be happening is that your the EFI runtime services code
> is calling into the EFI boot services code, which is definitely a bug in
> your firmware because we're at runtime, but we've seen other machines
> that do similar things so we usually handle it just fine. However, what
> makes your case different, and the reason you see the above splat, is
> that it's using the physical address of the EFI boot services region,
> not the virtual one we setup with SetVirtualAddressMap(). Which is a
> second firmware bug. Again, we have seen other machines that access
> physical addresses after SetVirtualAddressMap(), but until now we
> haven't had any non-optional code that triggered them.
> 
> The only reason I can see that the offending commit would introduce this
> problem is because it calls QueryVariableInfo() at boot time. I notice
> that your machine is an SGI UV one, is there any chance you could get a
> firmware fix for this? If possible, it would be also good to confirm
> that it's this chunk of code in setup_efi_vars(),
> 
> 	status = efi_call_phys4(sys_table->runtime->query_variable_info,
> 				EFI_VARIABLE_NON_VOLATILE |
> 				EFI_VARIABLE_BOOTSERVICE_ACCESS |
> 				EFI_VARIABLE_RUNTIME_ACCESS, &store_size,
> 				&remaining_size, &var_size);

This does trigger the problem.  Note that the definition of
QueryVariableInfo() in the UEFI spec says:

  The returned MaximumVariableStorageSize, RemainingVariableStorageSize,
  MaximumVariableSize information may change immediately after the call
  based on other runtime activities including asynchronous error events.
  Also, these values associated with different attributes are not
  additive in nature.

Note the values may be accurate at the point in time when returned,
but may not be after that.

  After the system has transitioned into runtime (after
  ExitBootServices() is called), an implementation may not be able to
  accurately return information about the Boot Services variable store.
  In such cases, EFI_INVALID_PARAMETER should be returned.

It is not clear to me exactly when ExitBootServices() is called.
Our bios is returning a failing indication on the call.


The description from commit cc5a080c5d40c36089bb08a8a16fa3fc7047fe0f is:

  efi: Pass boot services variable info to runtime code

  EFI variables can be flagged as being accessible only within boot
  services. This makes it awkward for us to figure out how much space
  they use at runtime. In theory we could figure this out by simply
  comparing the results from QueryVariableInfo() to the space used by
  all of our variables, but that fails if the platform doesn't garbage
  collect on every boot. Thankfully, calling QueryVariableInfo() while
  still inside boot services gives a more reliable answer. This patch
  passes that information from the EFI boot stub up to the efi platform
  code. 

"more reliable" is a relative answer.  Saving those values for later
use seems inconsistent with the UEFI spec.

> that later makes GetNextVariable() jump to the physical address of the
> EFI Boot Services region. Because if not, we need to do some more
> digging.
> 
> Borislav, how are your 1:1 mapping patches coming along? In theory, once
> those are merged we can gracefully workaround these kinds of issues.
> 
> -- 
> Matt Fleming, Intel Open Source Technology Center

-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
