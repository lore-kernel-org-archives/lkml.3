Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933037AbaBUNBw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:01:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47614 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932858AbaBUNBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 08:01:50 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Oberparleiter <oberpar@linux.vnet.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 12/60] x86, hweight: Fix BUG when booting with CONFIG_GCOV_PROFILE_ALL=y
Date: Fri, 21 Feb 2014 13:00:39 +0000
Message-Id: <1392987687-15367-13-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392987687-15367-1-git-send-email-luis.henriques@canonical.com>
References: <1392987687-15367-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.31 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>

commit 6583327c4dd55acbbf2a6f25e775b28b3abf9a42 upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 lib/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/Makefile b/lib/Makefile
index 8c31a0c..f1ab4e00 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -41,6 +41,7 @@ obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock_debug.o
 lib-$(CONFIG_RWSEM_GENERIC_SPINLOCK) += rwsem-spinlock.o
 lib-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem.o
 
+GCOV_PROFILE_hweight.o := n
 CFLAGS_hweight.o = $(subst $(quote),,$(CONFIG_ARCH_HWEIGHT_CFLAGS))
 obj-$(CONFIG_GENERIC_HWEIGHT) += hweight.o
 
-- 
1.9.0

