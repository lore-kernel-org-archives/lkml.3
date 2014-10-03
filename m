Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543AbaJCWHG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:07:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46651 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755592AbaJCWGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:06:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steve French <smfrench@gmail.com>, Sachin Prabhu <sprabhu@redhat.com>
Subject: [PATCH 3.14 134/238] SMB3: Fix oops when creating symlinks on smb3
Date: Fri,  3 Oct 2014 14:30:49 -0700
Message-Id: <20141003212917.963067769@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve French <smfrench@gmail.com>

commit da80659d4aa758dc6935b10ec64513f0b67bc969 upstream.

We were not checking for symlink support properly for SMB2/SMB3
mounts so could oops when mounted with mfsymlinks when try
to create symlink when mfsymlinks on smb2/smb3 mounts

Signed-off-by: Steve French <smfrench@gmail.com>
CC: Sachin Prabhu <sprabhu@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/link.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -213,8 +213,12 @@ create_mf_symlink(const unsigned int xid
 	if (rc)
 		goto out;
 
-	rc = tcon->ses->server->ops->create_mf_symlink(xid, tcon, cifs_sb,
-					fromName, buf, &bytes_written);
+	if (tcon->ses->server->ops->create_mf_symlink)
+		rc = tcon->ses->server->ops->create_mf_symlink(xid, tcon,
+					cifs_sb, fromName, buf, &bytes_written);
+	else
+		rc = -EOPNOTSUPP;
+
 	if (rc)
 		goto out;
 


