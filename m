Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756410AbaH0AeV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 20:34:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29057 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756170AbaH0AeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 20:34:08 -0400
From: Baoquan He <bhe@redhat.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: qiuxishi@huawei.com, paul.gortmaker@windriver.com,
        Baoquan He <bhe@redhat.com>
Subject: [PATCH v4] not adding modules range to kcore if it's equal to vmcore range
Date: Wed, 27 Aug 2014 08:33:54 +0800
Message-Id: <1409099634-24899-1-git-send-email-bhe@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some ARCHs modules range is eauql to vmalloc range. E.g on i686
	"#define MODULES_VADDR   VMALLOC_START"
	"#define MODULES_END     VMALLOC_END"
This will cause 2 duplicate program segments in /proc/kcore, and no
any flag to indicate both of them are different. This is confusing.
And usually people who need check the elf header or read the content
of kcore will check memory ranges. Two program segments which are the
same completely are unnecessary.

So in this patch a judgment added to check if modules range is equal
to vmalloc range completely. If yes, just skip adding the modules
range.

Signed-off-by: Baoquan He <bhe@redhat.com>
---
 fs/proc/kcore.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/proc/kcore.c b/fs/proc/kcore.c
index 6df8d07..69cb67b 100644
--- a/fs/proc/kcore.c
+++ b/fs/proc/kcore.c
@@ -610,8 +610,11 @@ static void __init proc_kcore_text_init(void)
 struct kcore_list kcore_modules;
 static void __init add_modules_range(void)
 {
-	kclist_add(&kcore_modules, (void *)MODULES_VADDR,
+	if ( (MODULES_VADDR != VMALLOC_START) &&
+		(MODULES_END != VMALLOC_END) ) {
+		kclist_add(&kcore_modules, (void *)MODULES_VADDR,
 			MODULES_END - MODULES_VADDR, KCORE_VMALLOC);
+	}
 }
 #else
 static void __init add_modules_range(void)
-- 
1.9.0

