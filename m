Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050AbaANUsg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 15:48:36 -0500
Received: from mail1.windriver.com ([147.11.146.13]:33679 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbaANUsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 15:48:21 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 1/3] mm: make creation of the mm_kobj happen earlier than device_initcall
Date: Tue, 14 Jan 2014 15:44:46 -0500
Message-ID: <1389732288-4389-2-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1389732288-4389-1-git-send-email-paul.gortmaker@windriver.com>
References: <1389732288-4389-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The use of __initcall is to be eventually replaced by choosing
one from the prioritized groupings laid out in init.h header:

	pure_initcall               0
	core_initcall               1
	postcore_initcall           2
	arch_initcall               3
	subsys_initcall             4
	fs_initcall                 5
	device_initcall             6
	late_initcall               7

In the interim, all __initcall are mapped onto device_initcall,
which as can be seen above, comes quite late in the ordering.

Currently the mm_kobj is created with __initcall in mm_sysfs_init().
This means that any other initcalls that want to reference the
mm_kobj have to be device_initcall (or later), otherwise we will
for example, trip the BUG_ON(!kobj) in sysfs's internal_create_group().
This unfairly restricts those users; for example something that clearly
makes sense to be an arch_initcall will not be able to choose that.

However, upon examination, it is only this way for historical
reasons (i.e. simply not reprioritized yet).  We see that sysfs is
ready quite earlier in init/main.c via:

 vfs_caches_init
 |_ mnt_init
    |_ sysfs_init

well ahead of the processing of the prioritized calls listed above.

So we can recategorize mm_sysfs_init to be a pure_initcall, which
in turn allows any mm_kobj initcall users a wider range (1 --> 7)
of initcall priorities to choose from.

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 mm/mm_init.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 68562e92d50c..857a6434e3a5 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -202,5 +202,4 @@ static int __init mm_sysfs_init(void)
 
 	return 0;
 }
-
-__initcall(mm_sysfs_init);
+pure_initcall(mm_sysfs_init);
-- 
1.8.5.2

