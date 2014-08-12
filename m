Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234AbaHLFbC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 01:31:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12677 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752193AbaHLFa7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 01:30:59 -0400
From: Baoquan He <bhe@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: ebiederm@xmission.com, vgoyal@redhat.com, hpa@zytor.com,
        akpm@linux-foundation.org, Baoquan He <bhe@redhat.com>
Subject: [PATCH 2/2] check if crashk_res_low exists when exclude it from crash mem ranges
Date: Tue, 12 Aug 2014 13:29:28 +0800
Message-Id: <1407821368-2358-2-git-send-email-bhe@redhat.com>
In-Reply-To: <1407821368-2358-1-git-send-email-bhe@redhat.com>
References: <1407821368-2358-1-git-send-email-bhe@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a check if crashk_res_low exists just like GART region does. If
crashk_res_low doesn't exist, calling exclude_mem_range is unnecessary.

Meanwhile, since crashk_res_low has been initialized at definition, it's
safe just use "if (crashk_low_res.end)" to check if it's exist. And this
can make it consistent with other places of check.

Signed-off-by: Baoquan He <bhe@redhat.com>
---
 arch/x86/kernel/crash.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index 0553a34..c9e83f9 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -238,7 +238,7 @@ static void fill_up_crash_elf_data(struct crash_elf_data *ced,
 	ced->max_nr_ranges++;
 
 	/* If crashk_low_res is not 0, another range split possible */
-	if (crashk_low_res.end != 0)
+	if (crashk_low_res.end)
 		ced->max_nr_ranges++;
 }
 
@@ -336,9 +336,11 @@ static int elf_header_exclude_ranges(struct crash_elf_data *ced,
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

