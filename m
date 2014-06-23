Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbaFWBh2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 21:37:28 -0400
Received: from linuxhacker.ru ([217.76.32.60]:39729 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814AbaFWBcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 21:32:42 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Nathaniel Clark <nathaniel.l.clark@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 03/18] staging/lustre/llite: Only kill SGID/SUID bits
Date: Sun, 22 Jun 2014 21:32:07 -0400
Message-Id: <1403487142-4880-4-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1403487142-4880-1-git-send-email-green@linuxhacker.ru>
References: <1403487142-4880-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nathaniel Clark <nathaniel.l.clark@intel.com>

Check that attr mode is valid before using it when determining if to
clear SGID and SUID bits in ll_setattr.

Signed-off-by: Nathaniel Clark <nathaniel.l.clark@intel.com>
Reviewed-on: http://review.whamcloud.com/10153
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4924
Reviewed-by: Lai Siyao <lai.siyao@intel.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/llite/llite_lib.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/llite_lib.c b/drivers/staging/lustre/lustre/llite/llite_lib.c
index deca27e..7eadd60 100644
--- a/drivers/staging/lustre/lustre/llite/llite_lib.c
+++ b/drivers/staging/lustre/lustre/llite/llite_lib.c
@@ -1537,12 +1537,14 @@ int ll_setattr(struct dentry *de, struct iattr *attr)
 	      !(attr->ia_mode & S_ISGID))))
 		attr->ia_valid |= ATTR_FORCE;
 
-	if ((mode & S_ISUID) &&
+	if ((attr->ia_valid & ATTR_MODE) &&
+	    (mode & S_ISUID) &&
 	    !(attr->ia_mode & S_ISUID) &&
 	    !(attr->ia_valid & ATTR_KILL_SUID))
 		attr->ia_valid |= ATTR_KILL_SUID;
 
-	if (((mode & (S_ISGID|S_IXGRP)) == (S_ISGID|S_IXGRP)) &&
+	if ((attr->ia_valid & ATTR_MODE) &&
+	    ((mode & (S_ISGID|S_IXGRP)) == (S_ISGID|S_IXGRP)) &&
 	    !(attr->ia_mode & S_ISGID) &&
 	    !(attr->ia_valid & ATTR_KILL_SGID))
 		attr->ia_valid |= ATTR_KILL_SGID;
-- 
1.9.0

