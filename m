Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580AbaBILof (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 06:44:35 -0500
Received: from www84.your-server.de ([213.133.104.84]:35222 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbaBILoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 06:44:34 -0500
Message-ID: <1391946317.18067.11.camel@wall-e.seibold.net>
Subject: Re: [PATCH v13 8/9] Add 32 bit VDSO time support for 32 bit kernel
From: Stefani Seibold <stefani@seibold.net>
To: Andi Kleen <ak@linux.intel.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        aarcange@redhat.com, john.stultz@linaro.org, luto@amacapital.net,
        xemul@parallels.com, gorcunov@openvz.org,
        andriy.shevchenko@linux.intel.com, Martin.Runge@rohde-schwarz.com,
        Andreas.Brief@rohde-schwarz.com
Date: Sun, 09 Feb 2014 12:45:17 +0100
In-Reply-To: <20140209100536.GM12219@tassilo.jf.intel.com>
References: <1391894951-6381-1-git-send-email-stefani@seibold.net>
	 <1391894951-6381-9-git-send-email-stefani@seibold.net>
	 <20140209052230.GL12219@tassilo.jf.intel.com>
	 <1391933453.1014.20.camel@wall-e.seibold.net>
	 <20140209100536.GM12219@tassilo.jf.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, den 09.02.2014, 02:05 -0800 schrieb Andi Kleen:
> > EBX is a reserved as the base register when compiling with -fPIC.
> > Otherwise it get a "error: can't find a register in class 'BREG' while
> > reloading 'asm'".
> 
> In this case you have to dwarf annotate the push/pop
> 
> >  
> > > Also I if this calls syscall.S:__kernel_vsyscall it clobbers more registers
> > > (ecx at least?) and you need to describe that to gcc with a + 
> > 
> > Sine ECX is in use as the second parameter it is still marked as
> > clobbered. 
> 
> No input parameters are not clobbered.
> 
> > I think it should word... As i know a system call will preserve all
> > register expect the EAX, which is marked as in and out for this asm()
> > directive. 
> 
> Yes the syscall does, but the vsyscall stub does not (for the !0x80 case)
> 

I cross check all kinds of vsyscall and all do save the ECX registers. 

So IMHO i see no register modification other than EAX, which is declared
as the output register in the asm() directive.

This following is what i get with objdump -d.

./arch/x86/vdso/vdso32-sysenter.so:

__kernel_vsyscall:
push   %ecx
push   %edx
push   %ebp
mov    %esp,%ebp
sysenter 
nop
nop
nop
nop
nop
nop
nop
int    $0x80
pop    %ebp
pop    %edx
pop    %ecx
ret    

./arch/x86/vdso/vdso32-int80.so:

__kernel_vsyscall:
int    $0x80
ret

./arch/x86/vdso/vdso32-syscall.so:

__kernel_vsyscall:
push   %ebp
mov    %ecx,%ebp
syscall 
mov    $0x2b,%ecx
mov    %ecx,%ss
mov    %ebp,%ecx
pop    %ebp
ret

BTW, it is not possible to mark an input parameter with +, this can only
done for an output parameter.

If there is really an issue what i have overseen, a working solution
would be to use an other register for the second parameter (ESI or EDI)
and add ECX to the clobber list.

- Stefani


