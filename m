Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760653Ab3DBM5K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 08:57:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760447Ab3DBM5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 08:57:09 -0400
Date: Tue, 2 Apr 2013 18:27:00 +0530 (IST)
From: P J P <ppandit@redhat.com>
X-X-Sender: pjp@javelin.pnq.redhat.com
To: linux-kernel@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org, Petr Matousek <pmatouse@redhat.com>
Subject: [PATCH] To add NULL pointer check
Message-ID: <alpine.LFD.2.03.1304021808410.12716@erqung.pbz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    Hello,

Commit - fa9150a84c - replaces a call to generic_writepages() in 
f2fs_write_data_pages() with write_cache_pages(), with a function pointer 
argument pointing to routine: __f2fs_writepage.

  -> https://git.kernel.org/linus/fa9150a84ca333f68127097c4fa1eda4b3913a22

The patch below adds a NULL pointer check, from generic_writepages(), to avoid 
a possible NULL pointer dereference, in case if - mapping->a_ops->writepage - 
is NULL.

===
$ git diff
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 7bd22a2..9841372 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -550,9 +550,16 @@ redirty_out:
  static int __f2fs_writepage(struct page *page, struct writeback_control *wbc,
                         void *data)
  {
+       int ret = 0;
         struct address_space *mapping = data;
-       int ret = mapping->a_ops->writepage(page, wbc);
+
+       /* deal with chardevs and other special file */
+       if (!mapping->a_ops->writepage)
+               return ret;
+
+       ret = mapping->a_ops->writepage(page, wbc);
         mapping_set_error(mapping, ret);
+
         return ret;
  }
===


Thank you.
--
Prasad J Pandit / Red Hat Security Response Team
DB7A 84C5 D3F9 7CD1 B5EB  C939 D048 7860 3655 602B
