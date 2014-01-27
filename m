Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917AbaA0OuA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 09:50:00 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:19699 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753712AbaA0Ot7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 09:49:59 -0500
Date: Mon, 27 Jan 2014 14:49:23 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "eparis@redhat.com" <eparis@redhat.com>,
        "rgb@redhat.com" <rgb@redhat.com>, Will Deacon <Will.Deacon@arm.com>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-audit@redhat.com" <linux-audit@redhat.com>,
        "patches@linaro.org" <patches@linaro.org>
Subject: Re: [PATCH v2 1/6] audit: Enable arm64 support
Message-ID: <20140127144923.GF32608@arm.com>
References: <1389946399-4525-1-git-send-email-takahiro.akashi@linaro.org>
 <1389946399-4525-2-git-send-email-takahiro.akashi@linaro.org>
 <20140123141808.GD27520@arm.com>
 <52E5EAC1.2070306@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E5EAC1.2070306@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 05:12:33AM +0000, AKASHI Takahiro wrote:
> [To audit maintainers]
> 
> On 01/23/2014 11:18 PM, Catalin Marinas wrote:
> > On Fri, Jan 17, 2014 at 08:13:14AM +0000, AKASHI Takahiro wrote:
> >> --- a/include/uapi/linux/audit.h
> >> +++ b/include/uapi/linux/audit.h
> >> @@ -327,6 +327,8 @@ enum {
> >>   /* distinguish syscall tables */
> >>   #define __AUDIT_ARCH_64BIT 0x80000000
> >>   #define __AUDIT_ARCH_LE	   0x40000000
> >> +#define AUDIT_ARCH_AARCH64	(EM_AARCH64|__AUDIT_ARCH_64BIT|__AUDIT_ARCH_LE)
> >> +#define AUDIT_ARCH_AARCH64EB	(EM_AARCH64|__AUDIT_ARCH_64BIT)
> >>   #define AUDIT_ARCH_ALPHA	(EM_ALPHA|__AUDIT_ARCH_64BIT|__AUDIT_ARCH_LE)
> >>   #define AUDIT_ARCH_ARM		(EM_ARM|__AUDIT_ARCH_LE)
> >>   #define AUDIT_ARCH_ARMEB	(EM_ARM)
> >> diff --git a/init/Kconfig b/init/Kconfig
> >> index 79383d3..3aae602 100644
> >> --- a/init/Kconfig
> >> +++ b/init/Kconfig
> >> @@ -284,7 +284,7 @@ config AUDIT
> >>
> >>   config AUDITSYSCALL
> >>   	bool "Enable system-call auditing support"
> >> -	depends on AUDIT && (X86 || PARISC || PPC || S390 || IA64 || UML || SPARC64 || SUPERH || (ARM && AEABI && !OABI_COMPAT))
> >> +	depends on AUDIT && (X86 || PARISC || PPC || S390 || IA64 || UML || SPARC64 || SUPERH || (ARM && AEABI && !OABI_COMPAT) || ARM64)
> >
> > The usual comment for such changes: could you please clean this up and
> > just use something like "depends on HAVE_ARCH_AUDITSYSCALL"?
> 
> Do you agree to this change?
> 
> If so, I can create a patch, but have some concerns:
> 1) I can't verify it on other architectures than (arm &) arm64.

You could try to build. It's really a trivial change, could get away
with code inspection (and some automatic building when it gets to
linux-next).

In init/Kconfig:

config HAVE_ARCH_AUDITSYSCALL
	bool

and:

-	depends on AUDIT && (X86 || PARISC || PPC || S390 || IA64 || UML || SPARC64 || SUPERH || (ARM && AEABI && !OABI_COMPAT))
+	depends on HAVE_ARCH_AUDITSYSCALL

In the corresponding arch/*/Kconfig:

	select HAVE_ARCH_AUDITSYSCALL

> 2) Some architectures (microblaze, mips, openrisc) are not listed here, but

For those, you don't need to select HAVE_ARCH_AUDITSYSCALL.

>     their ptrace.c have a call to audit_syscall_entry/exit().
>     (audit_syscall_entry/exit are null if !AUDITSYSCALL, though)


They are not NULL but empty inline functions, so they don't have any
effect.

> So I'm afraid that the change might break someone's assumption.

I'm pretty sure it won't ;).

-- 
Catalin
