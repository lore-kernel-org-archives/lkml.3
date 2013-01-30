Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab3A3BmX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 20:42:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43893 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab3A3BmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 20:42:20 -0500
Date: Tue, 29 Jan 2013 17:42:09 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-084d1283986a530828b8898f206adf44d5d3146d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1359058816-7615-23-git-send-email-yinghai@kernel.org>
References: <1359058816-7615-23-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86, kexec:
  Set ident mapping for kernel that is above max_pfn
Git-Commit-ID: 084d1283986a530828b8898f206adf44d5d3146d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 29 Jan 2013 17:42:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  084d1283986a530828b8898f206adf44d5d3146d
Gitweb:     http://git.kernel.org/tip/084d1283986a530828b8898f206adf44d5d3146d
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Thu, 24 Jan 2013 12:20:03 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 29 Jan 2013 15:26:26 -0800

x86, kexec: Set ident mapping for kernel that is above max_pfn

When first kernel is booted with memmap= or mem=  to limit max_pfn.
kexec can load second kernel above that max_pfn.

We need to set ident mapping for whole image in this case instead of just
for first 2M.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1359058816-7615-23-git-send-email-yinghai@kernel.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/machine_kexec_64.c | 43 ++++++++++++++++++++++++++++++++------
 1 file changed, 37 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
index b3ea9db..be14ee1 100644
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -56,6 +56,25 @@ out:
 	return result;
 }
 
+static int ident_mapping_init(struct kimage *image, pgd_t *level4p,
+				unsigned long mstart, unsigned long mend)
+{
+	int result;
+
+	mstart = round_down(mstart, PMD_SIZE);
+	mend   = round_up(mend - 1, PMD_SIZE);
+
+	while (mstart < mend) {
+		result = init_one_level2_page(image, level4p, mstart);
+		if (result)
+			return result;
+
+		mstart += PMD_SIZE;
+	}
+
+	return 0;
+}
+
 static void init_level2_page(pmd_t *level2p, unsigned long addr)
 {
 	unsigned long end_addr;
@@ -184,22 +203,34 @@ err:
 	return result;
 }
 
-
 static int init_pgtable(struct kimage *image, unsigned long start_pgtable)
 {
+	unsigned long mstart, mend;
 	pgd_t *level4p;
 	int result;
+	int i;
+
 	level4p = (pgd_t *)__va(start_pgtable);
 	result = init_level4_page(image, level4p, 0, max_pfn << PAGE_SHIFT);
 	if (result)
 		return result;
+
 	/*
-	 * image->start may be outside 0 ~ max_pfn, for example when
-	 * jump back to original kernel from kexeced kernel
+	 * segments's mem ranges could be outside 0 ~ max_pfn,
+	 * for example when jump back to original kernel from kexeced kernel.
+	 * or first kernel is booted with user mem map, and second kernel
+	 * could be loaded out of that range.
 	 */
-	result = init_one_level2_page(image, level4p, image->start);
-	if (result)
-		return result;
+	for (i = 0; i < image->nr_segments; i++) {
+		mstart = image->segment[i].mem;
+		mend   = mstart + image->segment[i].memsz;
+
+		result = ident_mapping_init(image, level4p, mstart, mend);
+
+		if (result)
+			return result;
+	}
+
 	return init_transition_pgtable(image, level4p);
 }
 
