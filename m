Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016AbbAGCYy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:24:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47126 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757701AbbAGCSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 21:18:04 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Carl Henrik Lunde <chlunde@ping.uio.no>, Jan Kara <jack@suse.cz>
Subject: [PATCH 3.17 65/73] udf: Check component length before reading it
Date: Tue,  6 Jan 2015 18:16:26 -0800
Message-Id: <20150107021559.499780756@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107021557.521276020@linuxfoundation.org>
References: <20150107021557.521276020@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit e237ec37ec154564f8690c5bd1795339955eeef9 upstream.

Check that length specified in a component of a symlink fits in the
input buffer we are reading. Also properly ignore component length for
component types that do not use it. Otherwise we read memory after end
of buffer for corrupted udf image.

Reported-by: Carl Henrik Lunde <chlunde@ping.uio.no>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/udf/symlink.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/fs/udf/symlink.c
+++ b/fs/udf/symlink.c
@@ -42,14 +42,17 @@ static int udf_pc_to_char(struct super_b
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
@@ -74,6 +77,9 @@ static int udf_pc_to_char(struct super_b
 			/* that would be . - just ignore */
 			break;
 		case 5:
+			elen += pc->lengthComponentIdent;
+			if (elen > fromlen)
+				return -EIO;
 			comp_len = udf_get_filename(sb, pc->componentIdent,
 						    pc->lengthComponentIdent,
 						    p, tolen);
@@ -85,7 +91,6 @@ static int udf_pc_to_char(struct super_b
 			tolen--;
 			break;
 		}
-		elen += sizeof(struct pathComponent) + pc->lengthComponentIdent;
 	}
 	if (p > to + 1)
 		p[-1] = '\0';


