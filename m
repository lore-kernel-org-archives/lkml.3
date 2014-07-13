Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118AbaGMBF7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 21:05:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2286 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751563AbaGMBFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 21:05:54 -0400
Date: Sun, 13 Jul 2014 09:05:46 +0800
From: Baoquan He <bhe@redhat.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        qiuxishi@huawei.com, paul.gortmaker@windriver.com
Subject: Re: [PATCH v2] not adding modules range to kcore if it's equal to
 vmcore range
Message-ID: <20140713010546.GA2832@dhcp-17-102.nay.redhat.com>
References: <1405212144-2725-1-git-send-email-bhe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405212144-2725-1-git-send-email-bhe@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some ARCHs modules range is eauql to vmalloc range. E.g on i686
"#define MODULES_VADDR   VMALLOC_START"
"#define MODULES_END     VMALLOC_END"
This will cause 2 duplicate program segments in /proc/kcore, makes
user confused. In this patch a judgment added to check if modules
range is equal to vmalloc range. If yes, just skip adding the modules
range.

Signed-off-by: Baoquan He <bhe@redhat.com>
---
 fs/proc/kcore.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/proc/kcore.c b/fs/proc/kcore.c
index 39e6ef3..bf5127c 100644
--- a/fs/proc/kcore.c
+++ b/fs/proc/kcore.c
@@ -610,8 +610,10 @@ static void __init proc_kcore_text_init(void)
 struct kcore_list kcore_modules;
 static void __init add_modules_range(void)
 {
-	kclist_add(&kcore_modules, (void *)MODULES_VADDR,
-			MODULES_END - MODULES_VADDR, KCORE_VMALLOC);
+	if (MODULES_VADDR != VMALLOC_START) {
+		kclist_add(&kcore_modules, (void *)MODULES_VADDR,
+				MODULES_END - MODULES_VADDR, KCORE_VMALLOC);
+	}
 }
 #else
 static void __init add_modules_range(void)
-- 
1.9.3

