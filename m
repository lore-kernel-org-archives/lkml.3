Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933326AbaCDVTw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 16:19:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40994 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756207AbaCDUD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:03:26 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>
Subject: [PATCH 3.13 078/172] cgroup: fix error return value in cgroup_mount()
Date: Tue,  4 Mar 2014 12:02:42 -0800
Message-Id: <20140304200302.237338084@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit eb46bf89696972b856a9adb6aebd5c7b65c266e4 upstream.

When cgroup_mount() fails to allocate an id for the root, it didn't
set ret before jumping to unlock_drop ending up returning 0 after a
failure.  Fix it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/cgroup.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1580,10 +1580,10 @@ static struct dentry *cgroup_mount(struc
 		mutex_lock(&cgroup_mutex);
 		mutex_lock(&cgroup_root_mutex);
 
-		root_cgrp->id = idr_alloc(&root->cgroup_idr, root_cgrp,
-					   0, 1, GFP_KERNEL);
-		if (root_cgrp->id < 0)
+		ret = idr_alloc(&root->cgroup_idr, root_cgrp, 0, 1, GFP_KERNEL);
+		if (ret < 0)
 			goto unlock_drop;
+		root_cgrp->id = ret;
 
 		/* Check for name clashes with existing mounts */
 		ret = -EBUSY;


