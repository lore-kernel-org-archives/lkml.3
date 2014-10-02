Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538AbaJBLUC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 07:20:02 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:40492 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbaJBLUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 07:20:00 -0400
Date: Thu, 2 Oct 2014 12:19:51 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Pinski <apinski@cavium.com>,
        "pinskia@gmail.com" <pinskia@gmail.com>
Subject: Re: [PATCH 08/24] Allow a 32bit ABI to use the naming of the 64bit
 ABI syscalls to avoid confusion of not splitting the registers
Message-ID: <20141002111949.GC32147@e104818-lin.cambridge.arm.com>
References: <1409779158-30963-1-git-send-email-apinski@cavium.com>
 <3318813.yqP9pCQtAB@wuerfel>
 <20141001124226.GI12702@e104818-lin.cambridge.arm.com>
 <3372851.lJtjj0EtDO@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3372851.lJtjj0EtDO@wuerfel>
Thread-Topic: [PATCH 08/24] Allow a 32bit ABI to use the naming of the 64bit
 ABI syscalls to avoid confusion of not splitting the registers
Accept-Language: en-GB, en-US
Content-Language: en-US
acceptlanguage: en-GB, en-US
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2014 at 03:00:54PM +0100, Arnd Bergmann wrote:
> On Wednesday 01 October 2014 13:42:27 Catalin Marinas wrote:
> > On Thu, Sep 04, 2014 at 11:11:04AM +0100, Arnd Bergmann wrote:
> > > On Wednesday 03 September 2014 14:19:02 Andrew Pinski wrote:
> > > > + * For 32bit abis where 64bit can be passed via one
> > > > + * register, use the same naming as the 64bit ones
> > > > + * as they will only have a 64 bit off_t.
> > > >   */
> > > > -#if __BITS_PER_LONG == 64 && !defined(__SYSCALL_COMPAT)
> > > > +#if (__BITS_PER_LONG == 64 && !defined(__SYSCALL_COMPAT)) || \
> > > > +       defined(__ARCH_WANT_64BIT_SYSCALLS)
> > > 
> > > I'm not sure if __ARCH_WANT_64BIT_SYSCALLS is the best name for
> > > this, since it's really only about off_t. It took me a while
> > > to understand what you are doing here.
> > 
> > I'm not sure I fully get it yet. So with this change, we avoid using
> > syscall numbers like __NR_ftruncate64 in favour of __NR_ftruncate. Why?
> > (maybe there's a valid reason, just not getting it).
> 
> glibc depends on the name to decide which calling conventions it
> uses. I assume this is the same on IPL32 ARM.
> 
> The general rule is that on a 32-bit architecture, __NR_ftruncate refers
> to the system call that takes a 32-bit off_t argument, while __NR_ftruncate64
> refers to the syscall that takes a 64-bit loff_t.
> 
> I would assume that the new ABI does not actually allow using 32-bit off_t
> in applications (that would be silly) and defaults to using 64-bit offsets,
> but it still needs to generate the right system calls.

OK, so since ILP32 would have a 64-bit off_t, we want to use
__NR_ftruncate and sys_ftruncate with the off_t argument (rather than
loff_t).

> > Either way, ILP32 would still end up calling sys_ftruncate64() (rather
> > than the native sys_ftruncate()).
> 
> sys_ftruncate64 does not exist in 64-bit kernels, it can either call
> compat_sys_ftruncate64_wrapper or sys_ftruncate. I'd assume it would
> call the latter and pass a single 64-bit register, but that is another
> matter.

I think I get it now. Just for the record, we define __NR_ftruncate to
__NR3264_ftruncate. When we build the syscall table as per patch 21/24,
given that the kernel is built with __LP64__, we get the following
macros for the syscall function name:

#define __SC_3264(_nr, _32, _64) __SYSCALL(_nr, _64)
#define __SC_COMP_3264(_nr, _32, _64, _comp) __SC_3264(_nr, _32, _64)
...
__SC_COMP_3264(__NR3264_ftruncate, sys_ftruncate64, sys_ftruncate, \
	       compat_sys_ftruncate64)

Which would result in using sys_ftruncate rather than sys_ftruncate64.

I agree, maybe the name could be __ARCH_WANT_64BIT_OFF_T as that's the
only reason for these definitions.

-- 
Catalin
