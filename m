Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643AbaEDGgR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 02:36:17 -0400
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:54858 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753497AbaEDGgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 02:36:16 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhYUAKPfZVNXQzLC/2dsb2JhbABZgwaCQXyoOAoFAZoGAgKBDxd0glMTHCMYgQIkE4hFAcoThVaIfIRGAQOPGooZAZJ0gzY7
Date: Sun, 4 May 2014 08:36:04 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 1/1] fs/affs/super.c: bugfix / double free
Message-Id: <20140504083604.7ecda0d8ace7927aa41ff98d@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

842a859db26b70
("affs: use ->kill_sb() to simplify ->put_super() and failure exits of ->mount()")
adds .kill_sb which frees sbi but doesn't remove sbi free in case of parse_options
error causing double free+random crash.

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/affs/super.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/affs/super.c b/fs/affs/super.c
index 6d589f2..895ac7d 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -340,8 +340,6 @@ static int affs_fill_super(struct super_block *sb, void *data, int silent)
 				&blocksize,&sbi->s_prefix,
 				sbi->s_volume, &mount_flags)) {
 		printk(KERN_ERR "AFFS: Error parsing options\n");
-		kfree(sbi->s_prefix);
-		kfree(sbi);
 		return -EINVAL;
 	}
 	/* N.B. after this point s_prefix must be released */
-- 
1.8.4.5

