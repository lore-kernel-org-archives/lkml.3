Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759978AbaJ1Gl1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 02:41:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45928 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422AbaJ1DuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:50:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dmitry Kasatkin <d.kasatkin@samsung.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [PATCH 3.14 056/100] ima: provide flag to identify new empty files
Date: Tue, 28 Oct 2014 11:35:41 +0800
Message-Id: <20141028033503.105596371@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033500.670583608@linuxfoundation.org>
References: <20141028033500.670583608@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Kasatkin <d.kasatkin@samsung.com>

commit b151d6b00bbb798c58f2f21305e7d43fa763f34f upstream.

On ima_file_free(), newly created empty files are not labeled with
an initial security.ima value, because the iversion did not change.
Commit dff6efc "fs: fix iversion handling" introduced a change in
iversion behavior.  To verify this change use the shell command:

  $ (exec >foo)
  $ getfattr -h -e hex -d -m security foo

This patch defines the IMA_NEW_FILE flag.  The flag is initially
set, when IMA detects that a new file is created, and subsequently
checked on the ima_file_free() hook to set the initial security.ima
value.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/integrity/ima/ima_appraise.c |    7 +++++--
 security/integrity/ima/ima_main.c     |   12 +++++++-----
 security/integrity/integrity.h        |    1 +
 3 files changed, 13 insertions(+), 7 deletions(-)

--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -194,8 +194,11 @@ int ima_appraise_measurement(int func, s
 			goto out;
 
 		cause = "missing-hash";
-		status =
-		    (inode->i_size == 0) ? INTEGRITY_PASS : INTEGRITY_NOLABEL;
+		status = INTEGRITY_NOLABEL;
+		if (inode->i_size == 0) {
+			iint->flags |= IMA_NEW_FILE;
+			status = INTEGRITY_PASS;
+		}
 		goto out;
 	}
 
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -131,11 +131,13 @@ static void ima_check_last_writer(struct
 		return;
 
 	mutex_lock(&inode->i_mutex);
-	if (atomic_read(&inode->i_writecount) == 1 &&
-	    iint->version != inode->i_version) {
-		iint->flags &= ~IMA_DONE_MASK;
-		if (iint->flags & IMA_APPRAISE)
-			ima_update_xattr(iint, file);
+	if (atomic_read(&inode->i_writecount) == 1) {
+		if ((iint->version != inode->i_version) ||
+		    (iint->flags & IMA_NEW_FILE)) {
+			iint->flags &= ~(IMA_DONE_MASK | IMA_NEW_FILE);
+			if (iint->flags & IMA_APPRAISE)
+				ima_update_xattr(iint, file);
+		}
 	}
 	mutex_unlock(&inode->i_mutex);
 }
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -31,6 +31,7 @@
 #define IMA_DIGSIG		0x01000000
 #define IMA_DIGSIG_REQUIRED	0x02000000
 #define IMA_PERMIT_DIRECTIO	0x04000000
+#define IMA_NEW_FILE		0x08000000
 
 #define IMA_DO_MASK		(IMA_MEASURE | IMA_APPRAISE | IMA_AUDIT | \
 				 IMA_APPRAISE_SUBMASK)


