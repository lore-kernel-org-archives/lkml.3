Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233AbaHEMTc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 08:19:32 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:34649 "EHLO
	smptrelay.restena.lu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752417AbaHEMTb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 08:19:31 -0400
Date: Tue, 5 Aug 2014 14:11:42 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: P J P <ppandit@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: 3.12 to 3.13 boot regression bisected - still applies to 3.16
Message-ID: <20140805141142.437ecb17@pluto>
In-Reply-To: <20140805135130.2d180b69@pluto>
References: <20140804113435.34ed8c76@pluto>
	<20140804122728.GH15082@console-pimps.org>
	<20140804150627.4563b6a7@pluto>
	<20140804135452.GJ15082@console-pimps.org>
	<20140805100242.425e1093@pluto>
	<20140805084542.GM15082@console-pimps.org>
	<20140805111330.3cf9319f@pluto>
	<20140805091848.GN15082@console-pimps.org>
	<20140805135130.2d180b69@pluto>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Aug 2014 13:51:30 +0200 Bruno Prémont wrote:

> On Tue, 5 Aug 2014 10:18:48 +0100 Matt Fleming wrote:
> > On Tue, 05 Aug, at 11:13:30AM, Bruno Prémont wrote:
> > > 
> > > I get at least to just before
> > >   status = efi_call_early(exit_boot_services, handle, key);
> > > in eboot.c on line 1310. A efi_printk inserted there is displayed.
> > 
> > This is worth pointing out in case you're unaware, but do you know that
> > it's not valid to call efi_printk() after ExitBootServices()? Doing so
> > will almost certainly cause your machine to fault.
> 
> I am aware that efi_printk() uses boot services!
> 
> 
> Now I tried out loops at many places and have gotten up to line 340 in
> 
>   arch/x86/kernel/head_64.S

oops, bad copy&paste, should have been
  arch/x86/boot/compressed/head_64.S

> System reboots within the following assembler instructions (does not
> reach line 359).
> 
> So efi_main() returns successfully but the assembler code following it
> gets something wrong.
> 
> I'm going to try further to determine which line between 340 and 359 is
> the "bad" one.

arch/x86/boot/compressed/head_64.S
341 /*
342  * Copy the compressed kernel to the end of our buffer
343  * where decompression in place becomes safe.
344  */
345         pushq   %rsi
346         leaq    (_bss-8)(%rip), %rsi
347         leaq    (_bss-8)(%rbx), %rdi
348         movq    $_bss /* - $startup_32 */, %rcx
349         shrq    $3, %rcx
350         std

code gets up to here

351         rep     movsq

this location is never reached but instead system reboots

352         cld
353         popq    %rsi
354 
355 /*      
356  * Jump to the relocated address.
357  */
 


Bruno
