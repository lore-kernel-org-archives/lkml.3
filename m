Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820Ab3EXLNK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 07:13:10 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52182 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091Ab3EXLNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 07:13:07 -0400
Date: Fri, 24 May 2013 13:09:11 +0200
From: Borislav Petkov <bp@alien8.de>
To: Matt Fleming <matt@console-pimps.org>
Cc: Russ Anderson <rja@sgi.com>, Matthew Garrett <matthew.garrett@nebula.com>,
        matt.fleming@intel.com, linux-efi@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
 info to runtime code
Message-ID: <20130524110911.GA32220@nazgul.tnic>
References: <20130522162747.GA20816@sgi.com>
 <20130523115801.GJ14575@console-pimps.org>
 <20130523203234.GD20913@sgi.com>
 <20130524074331.GL14575@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130524074331.GL14575@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 24, 2013 at 08:43:31AM +0100, Matt Fleming wrote:
> What appears to be happening is that your the EFI runtime services
> code is calling into the EFI boot services code, which is definitely
> a bug in your firmware because we're at runtime, but we've seen
> other machines that do similar things so we usually handle it just
> fine. However, what makes your case different, and the reason you
> see the above splat, is that it's using the physical address of
> the EFI boot services region, not the virtual one we setup with
> SetVirtualAddressMap(). Which is a second firmware bug.

I'm speechless. Let's have someone else do the ranting this time:

http://www.happyassassin.net/2013/05/03/a-day-in-the-life-of-a-firmware-engineer/

> Again, we have seen other machines that access
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

What do you mean, map boot time functions 1:1 too?

In any case, I think I have an idea about the bug I was discussing with
hpa recently but I need to do more experimenting. I have the next week
off, though, so don't hold your breath just yet :).
