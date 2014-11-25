Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463AbaKYK7h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:59:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59021 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963AbaKYKnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:43:12 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: William Cohen <wcohen@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 204/254] Correct the race condition in aarch64_insn_patch_text_sync()
Date: Tue, 25 Nov 2014 10:39:14 +0000
Message-Id: <1416912004-5928-205-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: William Cohen <wcohen@redhat.com>

commit 899d5933b2dd2720f2b20b01eaa07871aa6ad096 upstream.

When experimenting with patches to provide kprobes support for aarch64
smp machines would hang when inserting breakpoints into kernel code.
The hangs were caused by a race condition in the code called by
aarch64_insn_patch_text_sync().  The first processor in the
aarch64_insn_patch_text_cb() function would patch the code while other
processors were still entering the function and incrementing the
cpu_count field.  This resulted in some processors never observing the
exit condition and exiting the function.  Thus, processors in the
system hung.

The first processor to enter the patching function performs the
patching and signals that the patching is complete with an increment
of the cpu_count field. When all the processors have incremented the
cpu_count field the cpu_count will be num_cpus_online()+1 and they
will return to normal execution.

Fixes: ae16480785de arm64: introduce interfaces to hotpatch kernel and module code
Signed-off-by: William Cohen <wcohen@redhat.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm64/kernel/insn.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/insn.c b/arch/arm64/kernel/insn.c
index 92f36835486b..565e26f23f31 100644
--- a/arch/arm64/kernel/insn.c
+++ b/arch/arm64/kernel/insn.c
@@ -156,9 +156,10 @@ static int __kprobes aarch64_insn_patch_text_cb(void *arg)
 		 * which ends with "dsb; isb" pair guaranteeing global
 		 * visibility.
 		 */
-		atomic_set(&pp->cpu_count, -1);
+		/* Notify other processors with an additional increment. */
+		atomic_inc(&pp->cpu_count);
 	} else {
-		while (atomic_read(&pp->cpu_count) != -1)
+		while (atomic_read(&pp->cpu_count) <= num_online_cpus())
 			cpu_relax();
 		isb();
 	}
-- 
2.1.0

