Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966961Ab3HIFQn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 01:16:43 -0400
Received: from mail-bk0-f67.google.com ([209.85.214.67]:63887 "EHLO
	mail-bk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944Ab3HIFQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 01:16:42 -0400
MIME-Version: 1.0
Date: Fri, 9 Aug 2013 13:16:41 +0800
Message-ID: <CAMyfujfZayb8_673vkb2hdE9J_w+wPTD4aQ6TsY+aWxb9EzY8A@mail.gmail.com>
Subject: [PATCH 1/1] pagemap: fix buffer overflow in add_page_map()
From: yonghua zheng <younghua.zheng@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Motohiro KOSAKI <kosaki.motohiro@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Recently we met quite a lot of random kernel panic issues after enable
CONFIG_PROC_PAGE_MONITOR in kernel, after debuggint sometime we found
this has something to do with following bug in pagemap:

In struc pagemapread:

struct pagemapread {
    int pos, len;
    pagemap_entry_t *buffer;
    bool v2;
};

pos is number of PM_ENTRY_BYTES in buffer, but len is the size of buffer,
it is a mistake to compare pos and len in add_page_map() for checking
buffer is full or not, and this can lead to buffer overflow and random
kernel panic issue.

Correct len to be total number of PM_ENTRY_BYTES in buffer.

Signed-off-by: Yonghua Zheng <younghua.zheng@gmail.com>
---
 fs/proc/task_mmu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index dbf61f6..cb98853 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1116,8 +1116,8 @@ static ssize_t pagemap_read(struct file *file,
char __user *buf,
         goto out_task;

     pm.v2 = soft_dirty_cleared;
-    pm.len = PM_ENTRY_BYTES * (PAGEMAP_WALK_SIZE >> PAGE_SHIFT);
-    pm.buffer = kmalloc(pm.len, GFP_TEMPORARY);
+    pm.len = (PAGEMAP_WALK_SIZE >> PAGE_SHIFT);
+    pm.buffer = kmalloc(pm.len * PM_ENTRY_BYTES, GFP_TEMPORARY);
     ret = -ENOMEM;
     if (!pm.buffer)
         goto out_task;

-- 
1.7.9.5
