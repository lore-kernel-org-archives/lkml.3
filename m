Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756408AbaIILiA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 07:38:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13275 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753498AbaIILh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 07:37:59 -0400
From: Baoquan He <bhe@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: hpa@zytor.com, vgoyal@redhat.com, ebiederm@xmission.com,
        tglx@linutronix.de, mingo@redhat.com, Baoquan He <bhe@redhat.com>
Subject: [Patch v2 2/3] check if crashk_res_low exists when exclude it from crash mem ranges
Date: Tue,  9 Sep 2014 19:36:19 +0800
Message-Id: <1410262580-1561-2-git-send-email-bhe@redhat.com>
In-Reply-To: <1410262580-1561-1-git-send-email-bhe@redhat.com>
References: <1410262580-1561-1-git-send-email-bhe@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a check if crashk_res_low exists just like GART region does. If
crashk_res_low doesn't exist, calling exclude_mem_range is unnecessary.

Meanwhile, since crashk_res_low has been initialized at definition, it's
safe just use "if (crashk_low_res.end)" to check if it's exist. And this
can make it consistent with other places of check.

Signed-off-by: Baoquan He <bhe@redhat.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
---
 arch/x86/kernel/crash.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index a618fcd..f5ab56d 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -237,7 +237,7 @@ static void fill_up_crash_elf_data(struct crash_elf_data *ced,
 	ced->max_nr_ranges++;
 
 	/* If crashk_low_res is not 0, another range split possible */
-	if (crashk_low_res.end != 0)
+	if (crashk_low_res.end)
 		ced->max_nr_ranges++;
 }
 
@@ -335,9 +335,11 @@ static int elf_header_exclude_ranges(struct crash_elf_data *ced,
 	if (ret)
 		return ret;
 
-	ret = exclude_mem_range(cmem, crashk_low_res.start, crashk_low_res.end);
-	if (ret)
-		return ret;
+	if (crashk_low_res.end) {
+		ret = exclude_mem_range(cmem, crashk_low_res.start, crashk_low_res.end);
+		if (ret)
+			return ret;
+	}
 
 	/* Exclude GART region */
 	if (ced->gart_end) {
-- 
1.8.5.3

