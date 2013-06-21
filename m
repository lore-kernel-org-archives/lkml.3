Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965742Ab3FUL4c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 07:56:32 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:49767 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965513Ab3FUL4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 07:56:31 -0400
Date: Fri, 21 Jun 2013 12:56:28 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Linux EFI <linux-efi@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH -v2 4/4] x86, efi: Map runtime services 1:1
Message-ID: <20130621115628.GF5386@console-pimps.org>
References: <1371491416-11037-1-git-send-email-bp@alien8.de>
 <1371491416-11037-5-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371491416-11037-5-git-send-email-bp@alien8.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Jun, at 07:50:16PM, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> Due to the braindead design of EFI, we cannot map runtime services more
> than once for the duration of a booted system. Thus, if we want to use
> EFI runtime services in a kexec'ed kernel, maybe the only possible and
> sensible approach would be to map them 1:1 so that when the kexec kernel
> loads, it can simply call those addresses without the need for remapping
> (which doesn't work anyway).
> 
> Furthermore, this mapping approach could be of help with b0rked EFI
> implementations for a different set of reasons.
> 
> This implementation is 64-bit only for now.
> 
> Signed-off-by: Borislav Petkov <bp@suse.de>
> ---
>  arch/x86/include/asm/efi.h          |  67 +++++++++++----
>  arch/x86/platform/efi/efi.c         | 165 +++++++++++++++++++++++++++++-------
>  arch/x86/platform/efi/efi_stub_64.S |  56 ++++++++++++
>  3 files changed, 240 insertions(+), 48 deletions(-)

[...]

> +	.macro SWITCH_PGT
> +	cmpb $0, efi_use_11_map
> +	je 1f;

Actually, this needs to be,

	cmpb $0, efi_use_11_map(%rip)

because this code is built into the EFI boot stub which isn't loaded at
a fixed address and needs to be position independent.

-- 
Matt Fleming, Intel Open Source Technology Center
