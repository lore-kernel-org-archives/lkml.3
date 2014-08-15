Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747AbaHOQsw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 12:48:52 -0400
Received: from linuxhacker.ru ([217.76.32.60]:41251 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751663AbaHOQss (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 12:48:48 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Oleg Drokin <green@linuxhacker.ru>, Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 08/10] staging/lustre/llite: Fix integer overflow in ll_fid2path
Date: Fri, 15 Aug 2014 12:48:13 -0400
Message-Id: <1408121295-29115-9-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408121295-29115-1-git-send-email-green@linuxhacker.ru>
References: <1408121295-29115-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported by Dan Carpenter <dan.carpenter@oracle.com>

outsize = sizeof(*gfout) + gfin->gf_pathlen;

Where outsize is int and gf_pathlen is u32 from userspace
can lead to integer overflowwhere outsize is some small number
less than sizeof(*gfout)

Add a check for pathlen to be of sensical size.

Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
Reviewed-on: http://review.whamcloud.com/11412
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-5476
Reviewed-by: Dmitry Eremin <dmitry.eremin@intel.com>
Reviewed-by: John L. Hammond <john.hammond@intel.com>
---
 drivers/staging/lustre/lustre/llite/file.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index d3874e1..4a33638 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -1719,6 +1719,9 @@ int ll_fid2path(struct inode *inode, void __user *arg)
 	if (get_user(pathlen, &gfin->gf_pathlen))
 		return -EFAULT;
 
+	if (pathlen > PATH_MAX)
+		return -EINVAL;
+
 	outsize = sizeof(*gfout) + pathlen;
 
 	OBD_ALLOC(gfout, outsize);
-- 
1.9.3

