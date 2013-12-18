Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607Ab3LRWPh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 17:15:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35811 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330Ab3LRVJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:09:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nico Golde <nico@ngolde.de>, Fabian Yamaguchi <fabs@goesec.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Dave Chinner <dchinner@redhat.com>, Ben Myers <bpm@sgi.com>
Subject: [PATCH 3.4 09/31] xfs: underflow bug in xfs_attrlist_by_handle()
Date: Wed, 18 Dec 2013 13:08:17 -0800
Message-Id: <20131218210523.060189630@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218210522.790152625@linuxfoundation.org>
References: <20131218210522.790152625@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 31978b5cc66b8ba8a7e8eef60b12395d41b7b890 upstream.

If we allocate less than sizeof(struct attrlist) then we end up
corrupting memory or doing a ZERO_PTR_SIZE dereference.

This can only be triggered with CAP_SYS_ADMIN.

Reported-by: Nico Golde <nico@ngolde.de>
Reported-by: Fabian Yamaguchi <fabs@goesec.de>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/xfs/xfs_ioctl.c   |    3 ++-
 fs/xfs/xfs_ioctl32.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -400,7 +400,8 @@ xfs_attrlist_by_handle(
 		return -XFS_ERROR(EPERM);
 	if (copy_from_user(&al_hreq, arg, sizeof(xfs_fsop_attrlist_handlereq_t)))
 		return -XFS_ERROR(EFAULT);
-	if (al_hreq.buflen > XATTR_LIST_MAX)
+	if (al_hreq.buflen < sizeof(struct attrlist) ||
+	    al_hreq.buflen > XATTR_LIST_MAX)
 		return -XFS_ERROR(EINVAL);
 
 	/*
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -361,7 +361,8 @@ xfs_compat_attrlist_by_handle(
 	if (copy_from_user(&al_hreq, arg,
 			   sizeof(compat_xfs_fsop_attrlist_handlereq_t)))
 		return -XFS_ERROR(EFAULT);
-	if (al_hreq.buflen > XATTR_LIST_MAX)
+	if (al_hreq.buflen < sizeof(struct attrlist) ||
+	    al_hreq.buflen > XATTR_LIST_MAX)
 		return -XFS_ERROR(EINVAL);
 
 	/*


