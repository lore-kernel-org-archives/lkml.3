Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933581Ab3E1IfN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 04:35:13 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:43073 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933518Ab3E1IfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 04:35:09 -0400
Date: Tue, 28 May 2013 10:35:05 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Russ Anderson <rja@sgi.com>, Matthew Garrett <matthew.garrett@nebula.com>,
        matt.fleming@intel.com, linux-efi@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
 info to runtime code
Message-ID: <20130528083505.GA30042@gmail.com>
References: <20130522162747.GA20816@sgi.com>
 <20130523115801.GJ14575@console-pimps.org>
 <20130523203234.GD20913@sgi.com>
 <20130524074331.GL14575@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130524074331.GL14575@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matt Fleming <matt@console-pimps.org> wrote:

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
> 
> that later makes GetNextVariable() jump to the physical address of the 
> EFI Boot Services region. Because if not, we need to do some more 
> digging.
> 
> Borislav, how are your 1:1 mapping patches coming along? In theory, once 
> those are merged we can gracefully workaround these kinds of issues.

Handling these gracefully without crashing boxes or expecting firmware to 
be sane (which is wishful thinking) would be _SO_ preferred ...

I suspect 1:1 mapped is what Windows does - and we simply need to provide 
a Windows-EFI compatible environment (which is reality), not just an 
EFI-spec environment (which is a fiction).

Thanks,

	Ingo
