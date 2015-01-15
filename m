Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974AbbAOWK1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 17:10:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:50450 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930AbbAOWKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 17:10:11 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Kara <jack@suse.cz>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 13/19] isofs: Fix unchecked printing of ER records
Date: Thu, 15 Jan 2015 14:09:49 -0800
Message-Id: <1421359795-11155-14-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421359795-11155-1-git-send-email-kamal@canonical.com>
References: <1421359795-11155-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 4e2024624e678f0ebb916e6192bd23c1f9fdf696 upstream.

We didn't check length of rock ridge ER records before printing them.
Thus corrupted isofs image can cause us to access and print some memory
behind the buffer with obvious consequences.

Reported-and-tested-by: Carl Henrik Lunde <chlunde@ping.uio.no>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/isofs/rock.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/isofs/rock.c b/fs/isofs/rock.c
index bb63254..735d752 100644
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
1.9.1

