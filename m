Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab3EGEA5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:00:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26614 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757217Ab3EGD67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 23:58:59 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=-pikkUIBh1oA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=hDBfsgf2-UsA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=fC4T7qsy4_4xvlMS5R0A:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035848.947144222@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:58:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Sachin Prabhu <sprabhu@redhat.com>, Jeff Layton <jlayton@redhat.com>,
        Steve French <sfrench@us.ibm.com>
Subject: [048/126] cifs: Allow passwords which begin with a delimitor
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0048-cifs-Allow-passwords-which-begin-with-a-delimitor.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Sachin Prabhu <sprabhu@redhat.com>

[ Upstream commit c369c9a4a7c82d33329d869cbaf93304cc7a0c40 ]

Fixes a regression in cifs_parse_mount_options where a password
which begins with a delimitor is parsed incorrectly as being a blank
password.

Signed-off-by: Sachin Prabhu <sprabhu@redhat.com>
Acked-by: Jeff Layton <jlayton@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/cifs/connect.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index b39bb4a..487db09 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1489,14 +1489,24 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
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
1.7.10.4


