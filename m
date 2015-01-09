Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757641AbbAIKxT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:53:19 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44523 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757400AbbAIKc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:32:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 49/78] isofs: Fix unchecked printing of ER records
Date: Fri,  9 Jan 2015 11:31:58 +0100
Message-Id: <2329c797a9dc66982946026cbc1783e072ab8e33.1420799385.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
References: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
In-Reply-To: <cover.1420799385.git.jslaby@suse.cz>
References: <cover.1420799385.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 4e2024624e678f0ebb916e6192bd23c1f9fdf696 upstream.

We didn't check length of rock ridge ER records before printing them.
Thus corrupted isofs image can cause us to access and print some memory
behind the buffer with obvious consequences.

Reported-and-tested-by: Carl Henrik Lunde <chlunde@ping.uio.no>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/isofs/rock.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/isofs/rock.c b/fs/isofs/rock.c
index bb63254ed848..735d7522a3a9 100644
--- a/fs/isofs/rock.c
+++ b/fs/isofs/rock.c
@@ -362,6 +362,9 @@ repeat:
 			rs.cont_size = isonum_733(rr->u.CE.size);
 			break;
 		case SIG('E', 'R'):
+			/* Invalid length of ER tag id? */
+			if (rr->u.ER.len_id + offsetof(struct rock_ridge, u.ER.data) > rr->len)
+				goto out;
 			ISOFS_SB(inode->i_sb)->s_rock = 1;
 			printk(KERN_DEBUG "ISO 9660 Extensions: ");
 			{
-- 
2.2.1

