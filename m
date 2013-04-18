Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759315Ab3DRJS2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 05:18:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40287 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759145Ab3DRJSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 05:18:23 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sachin Prabhu <sprabhu@redhat.com>, Steve French <sfrench@us.ibm.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 57/72] cifs: Allow passwords which begin with a delimitor
Date: Thu, 18 Apr 2013 10:16:42 +0100
Message-Id: <1366276617-3553-58-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
References: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sachin Prabhu <sprabhu@redhat.com>

commit c369c9a4a7c82d33329d869cbaf93304cc7a0c40 upstream.

Fixes a regression in cifs_parse_mount_options where a password
which begins with a delimitor is parsed incorrectly as being a blank
password.

Signed-off-by: Sachin Prabhu <sprabhu@redhat.com>
Acked-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/cifs/connect.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index f027c2b..9169ae3 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1644,14 +1644,24 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 			}
 			break;
 		case Opt_blank_pass:
-			vol->password = NULL;
-			break;
-		case Opt_pass:
 			/* passwords have to be handled differently
 			 * to allow the character used for deliminator
 			 * to be passed within them
 			 */
 
+			/*
+			 * Check if this is a case where the  password
+			 * starts with a delimiter
+			 */
+			tmp_end = strchr(data, '=');
+			tmp_end++;
+			if (!(tmp_end < end && tmp_end[1] == delim)) {
+				/* No it is not. Set the password to NULL */
+				vol->password = NULL;
+				break;
+			}
+			/* Yes it is. Drop down to Opt_pass below.*/
+		case Opt_pass:
 			/* Obtain the value string */
 			value = strchr(data, '=');
 			value++;
-- 
1.8.1.2

