Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933893AbaKSV7O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:59:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56599 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933462AbaKSVEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:04:22 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        William Cohen <wcohen@redhat.com>, Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 3.14 049/122] Correct the race condition in aarch64_insn_patch_text_sync()
Date: Wed, 19 Nov 2014 12:51:39 -0800
Message-Id: <20141119205210.435255991@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205208.812884198@linuxfoundation.org>
References: <20141119205208.812884198@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kernel/insn.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/arm64/kernel/insn.c
+++ b/arch/arm64/kernel/insn.c
@@ -156,9 +156,10 @@ static int __kprobes aarch64_insn_patch_
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


