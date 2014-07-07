Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbaGGNym (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 09:54:42 -0400
Received: from mout.gmx.net ([212.227.15.15]:63711 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563AbaGGNyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 09:54:40 -0400
MIME-Version: 1.0
Message-ID: <trinity-8380f6e4-393a-40f8-ba95-3ab03baa85b7-1404741277414@3capp-gmx-bs54>
From: "Helge Deller" <deller@gmx.de>
To: "Heiko Carstens" <heiko.carstens@de.ibm.com>
Cc: "Eric Paris" <eparis@redhat.com>,
        "Linux Kernel" <linux-kernel@vger.kernel.org>,
        "Heinrich Schuchardt" <xypron.glpk@gmx.de>,
        linux-parisc@vger.kernel.org,
        "James Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Dave Anglin" <dave.anglin@bell.net>
Subject: Aw: Re: [PATCH] fix fanotify_mark() breakage on big endian 32bit
 kernel
Content-Type: text/plain; charset=UTF-8
Date: Mon, 7 Jul 2014 15:54:37 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <20140706091530.GA3589@osiris>
References: <20140704151235.GA22454@ls3530.dhcp.wdf.sap.corp>,
 <20140706091530.GA3589@osiris>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K0:vjrAtmYiruBZXjAtBW6PZpj0hhFiIfTRlS+q0zswNFn
 VepxjNEgNQtgaz4ZBQrUvH008/Xtc8+nM4W9TKSuCS9p5dYRkC
 RjvB5M2vocy3zUYuX6cHu31hskrEO4eumKKTSQ21Te2Z20K/XM
 Q7vSQx423447lUz4il6RIliFufiGyXf1HgzCXXsWRo5LHRyCmr
 kjcNHRoTn0wborUBRCiThEnv8IYXo1X2AOd8nX8MqgyMYaD0jv
 MnhQq+ZmpDNB3IuaF1I8q4gMz2GKk4r3sSwnrs4ufHCQr1tIT5 2BYf/c=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Heiko,

> On Fri, Jul 04, 2014 at 05:12:35PM +0200, Helge Deller wrote:
> > This patch affects big endian architectures only.
> > 
> > On those with 32bit userspace and 64bit kernel (CONFIG_COMPAT=y) the
> > 64bit mask parameter is correctly constructed out of two 32bit values in
> > the compat_fanotify_mark() function and then passed as 64bit parameter
> > to the fanotify_mark() syscall.
> > 
> > But for the CONFIG_COMPAT=n case (32bit kernel & userspace),
> > compat_fanotify_mark() isn't used and the fanotify_mark syscall implementation
> > is used directly. In that case the upper and lower 32 bits of the 64bit mask
> > parameter is still swapped on big endian machines and thus leads to
> > fanotify_mark failing with -EINVAL.
> 
> Why do you think upper and lower 32 bits are swapped on big endian machines?

I assumed it, because I see this behaviour on parisc, and because of this commit
from you regarding the compat-case. I do recognize, that in this patch the u64 value
is constructed out of the two 32bit values to hand it over. So, this patch is OK.

commit 592f6b842f64e416c7598a1b97c649b34241e22d
Author: Heiko Carstens <heiko.carstens@de.ibm.com>
Date:   Mon Jan 27 17:07:19 2014 -0800

    compat: fix sys_fanotify_mark
    
    Commit 91c2e0bcae72 ("unify compat fanotify_mark(2), switch to
    COMPAT_SYSCALL_DEFINE") added a new unified compat fanotify_mark syscall
    to be used by all architectures.
    
    Unfortunately the unified version merges the split mask parameter in a
    wrong way: the lower and higher word got swapped.
    
    This was discovered with glibc's tst-fanotify test case.


> > Here is a strace of the same 32bit executable (fanotify01 testcase from LTP):
> > 
> > On a 64bit kernel it suceeds:
> > syscall_322(0, 0, 0x3, 0x3, 0x266c8, 0x1) = 0x3
> > syscall_323(0x3, 0x1, 0, 0x3b, 0xffffff9c, 0x266c8) = 0
> > 
> > On a 32bit kernel it fails:
> > syscall_322(0, 0, 0x3, 0x3, 0x266c8, 0x1) = 0x3
> > syscall_323(0x3, 0x1, 0, 0x3b, 0xffffff9c, 0x266c8) = -1 (errno 22)
> 
> So "0" and "0x3b" together should be the 64 bit "0x3b" mask, this looks just
> fine.
> 
> > diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
> > index 3fdc8a3..374261c 100644
> > --- a/fs/notify/fanotify/fanotify_user.c
> > +++ b/fs/notify/fanotify/fanotify_user.c
> > @@ -787,6 +787,10 @@ SYSCALL_DEFINE5(fanotify_mark, int, fanotify_fd, unsigned int, flags,
> >  	struct path path;
> >  	int ret;
> > 
> > +#if defined(__BIG_ENDIAN) && !defined(CONFIG_64BIT)
> > +	mask = (mask << 32) | (mask >> 32);
> > +#endif
> > +
> >  	pr_debug("%s: fanotify_fd=%d flags=%x dfd=%d pathname=%p mask=%llx\n",
> >  		 __func__, fanotify_fd, flags, dfd, pathname, mask);
> 
> Did you activate this pr_debug()? I'm really wondering what the output looks
> like on your machine.

Just tested it.
On 3.16.0-rc4-32bit (without my patch)
syscall_323(0x3, 0x1, 0, 0x3b, 0xffffff9c, 0x266c8) = -1 (errno 22)
gives:
SYSC_fanotify_mark: fanotify_fd=3 flags=1 dfd=-100 pathname=000266c8 mask=3b00000000

and on 3.16.0-rc4-32bit+ (*with* my patch, same executable file):
syscall_323(0x3, 0x1, 0, 0x3b, 0xffffff9c, 0x266c8) = 0
gives:
SYSC_fanotify_mark: fanotify_fd=3 flags=1 dfd=-100 pathname=000266c8 mask=3b

So, my patch works as expected.

The Linux Test Project (LTP) uses in testcases/kernel/syscalls/fanotify/fanotify.h this coding, which is IMHO 
correct as it would break your commit 592f6b842f64e416c7598a1b97c649b34241e22d otherwise:
long myfanotify_mark(int fd, unsigned int flags, uint64_t mask,
                     int dfd, const char *pathname)
{
#if LTP_USE_64_ABI
        return ltp_syscall(__NR_fanotify_mark, fd, flags, mask, dfd, pathname);
#else
        return ltp_syscall(__NR_fanotify_mark, fd, flags,
                         __LONG_LONG_PAIR((unsigned long) (mask >> 32),
                                          (unsigned long) mask),
                         dfd, (unsigned long) pathname);
#endif
}

with __LONG_LONG_PAIR() defined in /usr/include/endian.h:
#if __BYTE_ORDER == __LITTLE_ENDIAN
# define __LONG_LONG_PAIR(HI, LO) LO, HI
#elif __BYTE_ORDER == __BIG_ENDIAN
# define __LONG_LONG_PAIR(HI, LO) HI, LO
#endif

and in glibc sysdeps/unix/sysv/linux/sys/fanotify.h I see:
extern int fanotify_mark (int __fanotify_fd, unsigned int __flags, uint64_t __mask, int __dfd, const char *__pathname);
with
sysdeps/unix/sysv/linux/s390/s390-32/syscalls.list:fanotify_mark        EXTRA   fanotify_mark   i:iiiiis        fanotify_mark


> At least an s390 the C ABI defines that 64 bit values are split into an
> even odd register pair, where the most significant bits are in the even numbered
> register.

and Dave wrote for hppa:
> In GCC, we typically have an odd even register pair to hold 64-bit
> values as register r0 is not usable.

This seems different.

> So for sys_fanotify_mark everything is fine on s390, and probably most other
> architectures as well. Having a 64 bit syscall parameter indeed does work,
> if all the architecture specific details have been correctly considered.

I think this is the problem!
For parisc the architecture specifc details have not been considered correctly.
I tried this test:

static int low32, high32;
SYSCALL_DEFINE5(fanotify_mark_test, int, fanotify_fd, unsigned int, flags,
                   __u64, mask, int, dfd, const char  __user *, pathname)
{
        low32 = (int) mask;
        high32 = (int) (mask >> 32);
}

and got:

        .section        .text.SyS_fanotify_mark_test,"ax",@progbits
        .align 4
.globl SyS_fanotify_mark_test
        .type   SyS_fanotify_mark_test, @function
SyS_fanotify_mark_test:
        .PROC
        .CALLINFO FRAME=64,NO_CALLS,SAVE_SP,ENTRY_GR=3
        .ENTRY
        copy %r3,%r1
        copy %r30,%r3
        stwm %r1,64(%r30)
        addil LR'low32-$global$,%r27
        ldi 0,%r28
        stw %r24,RR'low32-$global$(%r1)
        addil LR'high32-$global$,%r27
        stw %r23,RR'high32-$global$(%r1)
        ldo 64(%r3),%r30
        bv %r0(%r2)
        ldwm -64(%r30),%r3
        .EXIT
        .PROCEND

So on hppa r26 is fanotify_fd, %r25 is flags, %r24/%r23 is lower/higher 32bits of mask.
For the mask parameter this is different to what the __LONG_LONG_PAIR() marcro
would hand over to the syscall (which would be %r24/%r23 as higher/lower 32bits).

So, the problem is the usage of __u64 in the 32bit API. It has to be handled architecture-specific.
It seems to work for little-endian machines, and probably (by luck?!?) for s390, but I'm not sure if
it maybe breaks (like on parisc) on other arches, e.g. what about sparc?

For parisc I can work around that problem in the architecture-specifc coding, but I still
think using __64 here is wrong and just may lead to such bugs.

Helge
