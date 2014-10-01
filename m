Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445AbaJAOBZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 10:01:25 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:64045 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbaJAOBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 10:01:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Pinski <apinski@cavium.com>,
        "pinskia@gmail.com" <pinskia@gmail.com>
Subject: Re: [PATCH 08/24] Allow a 32bit ABI to use the naming of the 64bit ABI syscalls to avoid confusion of not splitting the registers
Date: Wed, 01 Oct 2014 16:00:54 +0200
Message-ID: <3372851.lJtjj0EtDO@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141001124226.GI12702@e104818-lin.cambridge.arm.com>
References: <1409779158-30963-1-git-send-email-apinski@cavium.com> <3318813.yqP9pCQtAB@wuerfel> <20141001124226.GI12702@e104818-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:qnm7Rzkc9hWM/+48gTceCV+fO10aSvRvY5sp54vVD11
 ExYoDlpUNjrkxqWcp0P4kVKXQnR7qRc9Y7qBluwom/erXE8TGk
 IE88cb5phnoG/zm09hNbEmg9T+Uv3SQ4nqNEJbiTyMJO3TJb04
 i9aKXTj6tYI5e7XJ44I8zYNsFWsVgOCEvFUH1Zj3nlbn8s36sd
 OtEtewBmTR0vlxMtUwag6VWR8uSuHGkBCZwTeo16mZWVOyYczu
 8uN3vAuV7ojAYTboTRRUzvk6BhQMxCIu9P7/oTUWFeNqIZGwcr
 9hoprhwRafb/AHUvrYtNCE4OSyq+e6kv+9tluZGPAg1vFzigTD
 7Q6F53Gk1Lcoj3FVTN08=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 October 2014 13:42:27 Catalin Marinas wrote:
> On Thu, Sep 04, 2014 at 11:11:04AM +0100, Arnd Bergmann wrote:
> > On Wednesday 03 September 2014 14:19:02 Andrew Pinski wrote:
> > > + * For 32bit abis where 64bit can be passed via one
> > > + * register, use the same naming as the 64bit ones
> > > + * as they will only have a 64 bit off_t.
> > >   */
> > > -#if __BITS_PER_LONG == 64 && !defined(__SYSCALL_COMPAT)
> > > +#if (__BITS_PER_LONG == 64 && !defined(__SYSCALL_COMPAT)) || \
> > > +       defined(__ARCH_WANT_64BIT_SYSCALLS)
> > 
> > I'm not sure if __ARCH_WANT_64BIT_SYSCALLS is the best name for
> > this, since it's really only about off_t. It took me a while
> > to understand what you are doing here.
> 
> I'm not sure I fully get it yet. So with this change, we avoid using
> syscall numbers like __NR_ftruncate64 in favour of __NR_ftruncate. Why?
> (maybe there's a valid reason, just not getting it).

glibc depends on the name to decide which calling conventions it
uses. I assume this is the same on IPL32 ARM.

The general rule is that on a 32-bit architecture, __NR_ftruncate refers
to the system call that takes a 32-bit off_t argument, while __NR_ftruncate64
refers to the syscall that takes a 64-bit loff_t.

I would assume that the new ABI does not actually allow using 32-bit off_t
in applications (that would be silly) and defaults to using 64-bit offsets,
but it still needs to generate the right system calls.

> Either way, ILP32 would still end up calling sys_ftruncate64() (rather
> than the native sys_ftruncate()).

sys_ftruncate64 does not exist in 64-bit kernels, it can either call
compat_sys_ftruncate64_wrapper or sys_ftruncate. I'd assume it would
call the latter and pass a single 64-bit register, but that is another
matter.

	Arnd
