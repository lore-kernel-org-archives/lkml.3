Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022AbaBLLSF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 06:18:05 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:63556 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbaBLLSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 06:18:04 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Takahiro Akashi <takahiro.akashi@linaro.org>
Subject: Re: [PATCH 1/2] arm64: Add seccomp support
Date: Wed, 12 Feb 2014 12:17:45 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        wad <wad@chromium.org>, Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>, "arndb@arndb.de" <arndb@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1391767892-5395-1-git-send-email-takahiro.akashi@linaro.org> <CAB5YjtB6XnXRd90AUw=rJCOBKyfcngTQd3Kxft33XLCK+K=Vuw@mail.gmail.com> <201402121205.10802.arnd@arndb.de>
In-Reply-To: <201402121205.10802.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201402121217.45763.arnd@arndb.de>
X-Provags-ID: V02:K0:wkD/YjLsVBtM2d/yM+1EcvaTI+xfvdtSJRi0he731hm
 Ii98RY5qwhKX5mQlSYR7waIA4Z+E6e9MtI2B/deU6BN5hJ/5w7
 pl9QQmmQ+X1PvWSRdf9PH9I777fZJCLJ89qQooqeKLeP3qDhVL
 Hb45LdBqLOS/4bUc1oOXWHSXKAPQrAkgiv1Rqqh4paXgasqfbu
 7cr3fEE6Gtws9Ivkww2t8oxLXGP1SqtOKx8Ag7hkkVj6+2T0uu
 BgofZul/WeRC6eLkO2Zpml5ydeP48KGZgjJ0//ZjOEqcXoUKAO
 a77t54E7yn+7MyQP0Jdpr1nhSi43I3mcyjUT3i0/5a9sS+6RLJ
 jkommhUHkKd3OVNCtRhk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 February 2014, Arnd Bergmann wrote:
> 
> On Wednesday 12 February 2014, Takahiro Akashi wrote:
> > Thank you for your comment.
> > I'm afraid that I can't do so because how compat syscall numbers
> > are named varies from arch to arch. __NR_compat_read is used
> > only on arm64, while __NR_ia32_read on x86. On other archs,
> > __NR_read is common to 32-bit and 64-bit tasks.
> 
> It's fine, I'm the maintainer for asm-generic ;-)
> 
> All future architectures are required to do it the same way as
> arm64 and use the generic syscall ABI. It just means we won't be
> able to share this header with x86 or other architectures that
> use a nonstandard string. We should have it in the generic place
> even if arm64 is the only user for now.
> 

Ok, I was wrong. The generic header file should only be used for
architectures on which both ABIs use the generic syscall numbers,
and arm64 obviously doesn't do that for arm32 compatibility.

The proper generic header file should contain

#if defined(CONFIG_COMPAT) && !defined(__NR_seccomp_read_32)
#define __NR_seccomp_read_32           __NR_read
#define __NR_seccomp_write_32          __NR_write
#define __NR_seccomp_exit_32           __NR_exit
#define __NR_seccomp_sigreturn_32      __NR_rt_sigreturn
#endif /* CONFIG_COMPAT && ! already defined */

#define __NR_seccomp_read              __NR_read
#define __NR_seccomp_write             __NR_write
#define __NR_seccomp_exit              __NR_exit
#define __NR_seccomp_sigreturn         __NR_rt_sigreturn

and then have arm64 override the first four by defining its
own. I would still prefer having it done this way, but it actually
doesn't gain us that much since this default wouldn't work on
any 64-bit architecture currently implementing seccomp. I'll leave
it up to you whether you want to do it or not.

	Arnd
