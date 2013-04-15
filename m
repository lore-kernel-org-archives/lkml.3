Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756952Ab3DOCrQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 22:47:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36499 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934073Ab3DOCny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 22:43:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sachin Prabhu <sprabhu@redhat.com>, Jeff Layton <jlayton@redhat.com>,
        Steve French <sfrench@us.ibm.com>
Subject: [ 15/27] cifs: Allow passwords which begin with a delimitor
Date: Sun, 14 Apr 2013 19:43:14 -0700
Message-Id: <20130415024232.494757969@linuxfoundation.org>
X-Mailer: git-send-email 1.8.2.1.368.g99c2266
In-Reply-To: <20130415024231.351969241@linuxfoundation.org>
References: <20130415024231.351969241@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sachin Prabhu <sprabhu@redhat.com>

commit c369c9a4a7c82d33329d869cbaf93304cc7a0c40 upstream.

Fixes a regression in cifs_parse_mount_options where a password
which begins with a delimitor is parsed incorrectly as being a blank
password.

Signed-off-by: Sachin Prabhu <sprabhu@redhat.com>
Acked-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/connect.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1546,14 +1546,24 @@ cifs_parse_mount_options(const char *mou
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


