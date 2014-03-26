Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020AbaCZS6F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 14:58:05 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:51311 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755861AbaCZS6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 14:58:02 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgYHAFgiM1NXQ457/2dsb2JhbABZgwaCSYEVwCmBHBd0glMTHCMYgQIkE4d9AdEWjnGEPwEDmEwBilqHWYMvPA
Date: Wed, 26 Mar 2014 19:57:59 +0100
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: "fengguang.wu" <fengguang.wu@intel.com>
Subject: [PATCH linux-next] ufs: sb mutex merge + mutex_destroy: fix
Message-Id: <20140326195759.9d0700eaf743d0df04c89fab@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mutex_destroy was also called when trying to mount volume in read/write without write support enabled.

Reported by Fengguang Wu.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ufs/super.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ufs/super.c b/fs/ufs/super.c
index d05cf89..dd4144e 100644
--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -798,7 +798,7 @@ static int ufs_fill_super(struct super_block *sb, void *data, int silent)
 	if (!(sb->s_flags & MS_RDONLY)) {
 		printk("ufs was compiled with read-only support, "
 		"can't be mounted as read-write\n");
-		goto failed;
+		goto failed_noreadwrite;
 	}
 #endif
 	mutex_init(&sbi->mutex);
@@ -1255,10 +1255,12 @@ magic_found:
 	return 0;
 
 failed:
+	mutex_destroy(&sbi->mutex);
+
+failed_noreadwrite:
 	if (ubh)
 		ubh_brelse_uspi (uspi);
 	kfree (uspi);
-	mutex_destroy(&sbi->mutex);
 	kfree(sbi);
 	sb->s_fs_info = NULL;
 	UFSD("EXIT (FAILED)\n");
