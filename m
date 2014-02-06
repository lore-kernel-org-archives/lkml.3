Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775AbaBFPSt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 10:18:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43926 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbaBFPSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 10:18:46 -0500
Date: Thu, 6 Feb 2014 07:18:26 -0800
From: tip-bot for Peter Oberparleiter <tipbot@zytor.com>
Message-ID: <tip-6583327c4dd55acbbf2a6f25e775b28b3abf9a42@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, oberpar@linux.vnet.ibm.com, hpa@zytor.com,
        mingo@kernel.org, stable@vger.kernel.org, akpm@linux-foundation.org,
        mroos@linux.ee, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, oberpar@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, mroos@linux.ee, tglx@linutronix.de
In-Reply-To: <52F3A30C.7050205@linux.vnet.ibm.com>
References: <52F3A30C.7050205@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, hweight:
  Fix BUG when booting with CONFIG_GCOV_PROFILE_ALL=y
Git-Commit-ID: 6583327c4dd55acbbf2a6f25e775b28b3abf9a42
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 06 Feb 2014 07:18:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6583327c4dd55acbbf2a6f25e775b28b3abf9a42
Gitweb:     http://git.kernel.org/tip/6583327c4dd55acbbf2a6f25e775b28b3abf9a42
Author:     Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
AuthorDate: Thu, 6 Feb 2014 15:58:20 +0100
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 6 Feb 2014 07:15:20 -0800

x86, hweight: Fix BUG when booting with CONFIG_GCOV_PROFILE_ALL=y

Commit d61931d89b, "x86: Add optimized popcnt variants" introduced
compile flag -fcall-saved-rdi for lib/hweight.c. When combined with
options -fprofile-arcs and -O2, this flag causes gcc to generate
broken constructor code. As a result, a 64 bit x86 kernel compiled
with CONFIG_GCOV_PROFILE_ALL=y prints message "gcov: could not create
file" and runs into sproadic BUGs during boot.

The gcc people indicate that these kinds of problems are endemic when
using ad hoc calling conventions.  It is therefore best to treat any
file compiled with ad hoc calling conventions as an isolated
environment and avoid things like profiling or coverage analysis,
since those subsystems assume a "normal" calling conventions.

This patch avoids the bug by excluding lib/hweight.o from coverage
profiling.

Reported-by: Meelis Roos <mroos@linux.ee>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/52F3A30C.7050205@linux.vnet.ibm.com
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: <stable@vger.kernel.org>
---
 lib/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/Makefile b/lib/Makefile
index a459c31..04944e9 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -43,6 +43,7 @@ obj-$(CONFIG_HAS_IOMEM) += iomap_copy.o devres.o
 obj-$(CONFIG_CHECK_SIGNATURE) += check_signature.o
 obj-$(CONFIG_DEBUG_LOCKING_API_SELFTESTS) += locking-selftest.o
 
+GCOV_PROFILE_hweight.o := n
 CFLAGS_hweight.o = $(subst $(quote),,$(CONFIG_ARCH_HWEIGHT_CFLAGS))
 obj-$(CONFIG_GENERIC_HWEIGHT) += hweight.o
 
