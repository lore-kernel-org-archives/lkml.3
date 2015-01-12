Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331AbbALSbH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:31:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58451 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755296AbbALSbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:31:01 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Kara <jack@suse.cz>, Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 202/216] isofs: Fix unchecked printing of ER records
Date: Mon, 12 Jan 2015 18:29:40 +0000
Message-Id: <1421087394-2712-90-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 4e2024624e678f0ebb916e6192bd23c1f9fdf696 upstream.

We didn't check length of rock ridge ER records before printing them.
Thus corrupted isofs image can cause us to access and print some memory
behind the buffer with obvious consequences.

Reported-and-tested-by: Carl Henrik Lunde <chlunde@ping.uio.no>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
2.1.4

