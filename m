Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966059Ab3GSFvt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 01:51:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39337 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965138Ab3GSFWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 01:22:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Disseldorp <ddiss@suse.de>, Steve French <smfrench@gmail.com>
Subject: [ 01/38] CIFS use sensible file nlink values if unprovided
Date: Thu, 18 Jul 2013 22:21:17 -0700
Message-Id: <20130719052047.974456539@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20130719052047.858393825@linuxfoundation.org>
References: <20130719052047.858393825@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve French <smfrench@gmail.com>

commit 6658b9f70ebca5fc0795b1d6d733996af1e2caa7 upstream.

Certain servers may not set the NumberOfLinks field in query file/path
info responses. In such a case, cifs_inode_needs_reval() assumes that
all regular files are hardlinks and triggers revalidation, leading to
excessive and unnecessary network traffic.

This change hardcodes cf_nlink (and subsequently i_nlink) when not
returned by the server, similar to what already occurs in cifs_mkdir().

Signed-off-by: David Disseldorp <ddiss@suse.de>
Signed-off-by: Steve French <smfrench@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/inode.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -556,6 +556,11 @@ cifs_all_info_to_fattr(struct cifs_fattr
 			fattr->cf_mode &= ~(S_IWUGO);
 
 		fattr->cf_nlink = le32_to_cpu(info->NumberOfLinks);
+		if (fattr->cf_nlink < 1) {
+			cifs_dbg(1, "replacing bogus file nlink value %u\n",
+				fattr->cf_nlink);
+			fattr->cf_nlink = 1;
+		}
 	}
 
 	fattr->cf_uid = cifs_sb->mnt_uid;


