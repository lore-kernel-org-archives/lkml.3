Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758212Ab3HMQ1B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:27:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4213 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758030Ab3HMQ0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 12:26:53 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=GjT_N-4gJBcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=8deh_h-DGewA:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=MSl-tDqOz04A:10 a=0kPLrQdw3YYA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130813155833.555097083@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 13 Aug 2013 11:57:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: David Disseldorp <ddiss@suse.de>, Steve French <smfrench@gmail.com>
Subject: [63/88] use sensible file nlink values if unprovided
References: <20130813155654.069291373@goodmis.org>
Content-Disposition: inline; filename=0063-use-sensible-file-nlink-values-if-unprovided.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.7-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Steve French <smfrench@gmail.com>

[ Upstream commit 6658b9f70ebca5fc0795b1d6d733996af1e2caa7 ]

Certain servers may not set the NumberOfLinks field in query file/path
info responses. In such a case, cifs_inode_needs_reval() assumes that
all regular files are hardlinks and triggers revalidation, leading to
excessive and unnecessary network traffic.

This change hardcodes cf_nlink (and subsequently i_nlink) when not
returned by the server, similar to what already occurs in cifs_mkdir().

Cc: <stable@vger.kernel.org>
Signed-off-by: David Disseldorp <ddiss@suse.de>
Signed-off-by: Steve French <smfrench@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/cifs/inode.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 8808dce..4a640e3 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -545,6 +545,11 @@ cifs_all_info_to_fattr(struct cifs_fattr *fattr, FILE_ALL_INFO *info,
 			fattr->cf_mode &= ~(S_IWUGO);
 
 		fattr->cf_nlink = le32_to_cpu(info->NumberOfLinks);
+		if (fattr->cf_nlink < 1) {
+			cifserror("replacing bogus file nlink value %u\n",
+				fattr->cf_nlink);
+			fattr->cf_nlink = 1;
+		}
 	}
 
 	fattr->cf_uid = cifs_sb->mnt_uid;
-- 
1.7.10.4


