Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab3I1Jj5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 05:39:57 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:26105 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533Ab3I1Jjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 05:39:54 -0400
Date: Sat, 28 Sep 2013 12:39:43 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Petr Vandrovec <petr@vandrovec.name>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] ncpfs: add a sanity check in ncp_is_nfs_extras()
Message-ID: <20130928093943.GD26611@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "volnum" can come from the server and my static checker complains
that we can't trust it.  In theory, it could lead to an info leak but
in real life, it is unlikely.

One way this comes from the server is ncp_obtain_info() initializes
target by calling:

	ncp_extract_file_info(ncp_reply_data(server, 0), target);

It then passes target to ncp_obtain_nfs_info() and from there to
ncp_is_nfs_extras().

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/ncpfs/ncplib_kernel.h b/fs/ncpfs/ncplib_kernel.h
index 32c0658..ae08b9f 100644
--- a/fs/ncpfs/ncplib_kernel.h
+++ b/fs/ncpfs/ncplib_kernel.h
@@ -119,6 +119,7 @@ int ncp_create_new(struct inode *dir, struct dentry *dentry,
 static inline int ncp_is_nfs_extras(struct ncp_server* server, unsigned int volnum) {
 #ifdef CONFIG_NCPFS_NFS_NS
 	return (server->m.flags & NCP_MOUNT_NFS_EXTRAS) &&
+	       (volnum < ARRAY_SIZE(server->name_space)) &&
 	       (server->name_space[volnum] == NW_NS_NFS);
 #else
 	return 0;
