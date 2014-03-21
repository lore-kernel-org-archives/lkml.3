Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759983AbaCUDV2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 23:21:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35144 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751613AbaCUDV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 23:21:26 -0400
From: WANG Chao <chaowang@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>, Greg Pearson <greg.pearson@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>, bhe@redhat.com
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] vmcore: continue vmcore initialization if PT_NOTE is found empty
Date: Fri, 21 Mar 2014 11:20:53 +0800
Message-Id: <1395372053-19794-1-git-send-email-chaowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently when an empty PT_NOTE is detected, vmcore initialization
fails. It sounds too harsh. Because PT_NOTE could be empty, for example,
one offlined a cpu but never restarted kdump service, and after crash,
PT_NOTE program header is there but no data contains. It's better to
warn about the empty PT_NOTE and continue to initialise vmcore.

And ultimately the multiple PT_NOTE are merged into a single one, all
empty PT_NOTE are discarded naturally during the merge. So empty PT_NOTE
is not visible to user space and vmcore is as good as expected.

Signed-off-by: WANG Chao <chaowang@redhat.com>
---
 fs/proc/vmcore.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 88d4585..dc71bf9 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -484,7 +484,6 @@ static int __init update_note_header_size_elf64(const Elf64_Ehdr *ehdr_ptr)
 		phdr_ptr->p_memsz = real_sz;
 		if (real_sz == 0) {
 			pr_warn("Warning: Zero PT_NOTE entries found\n");
-			return -EINVAL;
 		}
 	}
 
@@ -671,7 +670,6 @@ static int __init update_note_header_size_elf32(const Elf32_Ehdr *ehdr_ptr)
 		phdr_ptr->p_memsz = real_sz;
 		if (real_sz == 0) {
 			pr_warn("Warning: Zero PT_NOTE entries found\n");
-			return -EINVAL;
 		}
 	}
 
-- 
1.8.5.3

