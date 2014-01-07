Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbaAGONU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 09:13:20 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:53838 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbaAGONO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 09:13:14 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] scripts/kallsyms: filter symbols not in kernel address space
Date: Tue, 7 Jan 2014 15:12:33 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Ming Lei <tom.leiming@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Russell King <linux@arm.linux.org.uk>
References: <1382975339-25831-1-git-send-email-tom.leiming@gmail.com>
In-Reply-To: <1382975339-25831-1-git-send-email-tom.leiming@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201401071512.34016.arnd@arndb.de>
X-Provags-ID: V02:K0:H/WCHUHmCLxlxWHYAhV5wWrLRaoXYKKKHGqKFd7x5IT
 rCskgDc83jUIYW5v14acms7C/B+ZPGgaSzna+Ecx24Gun19Fp7
 8RkUuITDTQWoufpfSjTwX4oOP8G2BqnPNNGU4900mKeo4eKBIz
 GAc/1gcb/tX8Kkd2YTSo2xVD0TLuqNwSMHJ4WJM+oY9RhCrZZC
 ZlN6CwBDD81+bkon14fZP1ispPPO2EyV23R+ihzTgiLcaFA0cd
 bPqR69j43i6fD4IIaraqbJo+ybH4pjOgV7qxQYeWL5qcX1QcFm
 kjULqripGkjgq2/MXzvoXJ7T03mVxpj3/u3fMS3jJfNvt84nPe
 lu74RTuGZ47AAbT8QOQk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 October 2013, Ming Lei wrote:
> This patch uses CONFIG_PAGE_OFFSET to filter symbols which
> are not in kernel address space because these symbols are
> generally for generating code purpose and can't be run at
> kernel mode, so we needn't keep them in /proc/kallsyms.
> 
> For example, on ARM there are some symbols which are
> linked in relocatable code section, then perf can't parse
> symbols any more from /proc/kallsyms, and this patch fixes
> the problem.
> 
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: Michal Marek <mmarek@suse.cz>
> Acked-by: Rusty Russell <rusty@rustcorp.com.au>
> Signed-off-by: Ming Lei <tom.leiming@gmail.com>

Sorry for the late report, but I seem to have encountered a problem with this
patch, now that it has made it into all stable kernels.

When linking an ARM nommu kernel, I get the output "No valid symbol." twice,
from scripts/kallsyms. The problem evidently is that PAGE_OFFSET is still
set to 0xC0000000 on ARM NOMMU builds but the kernel is linked to start at
PLAT_PHYS_OFFSET instead, which may be elsehwere. For most platforms,
this is defined in Kconfig these days, so we could get away with

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index d1e4098..c477a7c 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1592,6 +1592,7 @@ endchoice
 
 config PAGE_OFFSET
 	hex
+	default PHYS_OFFSET if !MMU
 	default 0x40000000 if VMSPLIT_1G
 	default 0x80000000 if VMSPLIT_2G
 	default 0xC0000000

but there are still a few ARM platforms that define their own PLAT_PHYS_OFFSET
in memory.h, and it wouldn't help on non-ARM systems that might have the same
problem.

	Arnd
