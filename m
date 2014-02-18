Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028AbaBRXY2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 18:24:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50915 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895AbaBRWq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:46:26 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Meelis Roos <mroos@linux.ee>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Oberparleiter <oberpar@linux.vnet.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 3.10 20/26] x86, hweight: Fix BUG when booting with CONFIG_GCOV_PROFILE_ALL=y
Date: Tue, 18 Feb 2014 14:47:16 -0800
Message-Id: <20140218224530.982215773@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140218224530.398913499@linuxfoundation.org>
References: <20140218224530.398913499@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 lib/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/Makefile
+++ b/lib/Makefile
@@ -45,6 +45,7 @@ lib-$(CONFIG_RWSEM_GENERIC_SPINLOCK) +=
 lib-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem.o
 lib-$(CONFIG_PERCPU_RWSEM) += percpu-rwsem.o
 
+GCOV_PROFILE_hweight.o := n
 CFLAGS_hweight.o = $(subst $(quote),,$(CONFIG_ARCH_HWEIGHT_CFLAGS))
 obj-$(CONFIG_GENERIC_HWEIGHT) += hweight.o
 


