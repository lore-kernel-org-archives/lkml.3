Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363AbbALSed (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:34:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58473 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755318AbbALSbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:31:06 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Kara <jack@suse.cz>, Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 207/216] udf: Check component length before reading it
Date: Mon, 12 Jan 2015 18:29:45 +0000
Message-Id: <1421087394-2712-95-git-send-email-luis.henriques@canonical.com>
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

commit e237ec37ec154564f8690c5bd1795339955eeef9 upstream.

Check that length specified in a component of a symlink fits in the
input buffer we are reading. Also properly ignore component length for
component types that do not use it. Otherwise we read memory after end
of buffer for corrupted udf image.

Reported-by: Carl Henrik Lunde <chlunde@ping.uio.no>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/udf/symlink.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/udf/symlink.c b/fs/udf/symlink.c
index 2d0c3720e9af..0422b7b8369f 100644
--- a/fs/udf/symlink.c
+++ b/fs/udf/symlink.c
@@ -42,14 +42,17 @@ static int udf_pc_to_char(struct super_block *sb, unsigned char *from,
 	tolen--;
 	while (elen < fromlen) {
 		pc = (struct pathComponent *)(from + elen);
+		elen += sizeof(struct pathComponent);
 		switch (pc->componentType) {
 		case 1:
 			/*
 			 * Symlink points to some place which should be agreed
  			 * upon between originator and receiver of the media. Ignore.
 			 */
-			if (pc->lengthComponentIdent > 0)
+			if (pc->lengthComponentIdent > 0) {
+				elen += pc->lengthComponentIdent;
 				break;
+			}
 			/* Fall through */
 		case 2:
 			if (tolen == 0)
@@ -74,6 +77,9 @@ static int udf_pc_to_char(struct super_block *sb, unsigned char *from,
 			/* that would be . - just ignore */
 			break;
 		case 5:
+			elen += pc->lengthComponentIdent;
+			if (elen > fromlen)
+				return -EIO;
 			comp_len = udf_get_filename(sb, pc->componentIdent,
 						    pc->lengthComponentIdent,
 						    p, tolen);
@@ -85,7 +91,6 @@ static int udf_pc_to_char(struct super_block *sb, unsigned char *from,
 			tolen--;
 			break;
 		}
-		elen += sizeof(struct pathComponent) + pc->lengthComponentIdent;
 	}
 	if (p > to + 1)
 		p[-1] = '\0';
-- 
2.1.4

