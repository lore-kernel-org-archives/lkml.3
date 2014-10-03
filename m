Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668AbaJCWJa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:09:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46684 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686AbaJCWJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:09:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Zefan Li <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: [PATCH 3.14 126/238] cgroup: fix unbalanced locking
Date: Fri,  3 Oct 2014 14:30:41 -0700
Message-Id: <20141003212917.707982009@linuxfoundation.org>
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

From: Zefan Li <lizefan@huawei.com>

commit eb4aec84d6bdf98d00cedb41c18000f7a31e648a upstream.

cgroup_pidlist_start() holds cgrp->pidlist_mutex and then calls
pidlist_array_load(), and cgroup_pidlist_stop() releases the mutex.

It is wrong that we release the mutex in the failure path in
pidlist_array_load(), because cgroup_pidlist_stop() will be called
no matter if cgroup_pidlist_start() returns errno or not.

Fixes: 4bac00d16a8760eae7205e41d2c246477d42a210
Signed-off-by: Zefan Li <lizefan@huawei.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/cgroup.c |    1 -
 1 file changed, 1 deletion(-)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3663,7 +3663,6 @@ static int pidlist_array_load(struct cgr
 
 	l = cgroup_pidlist_find_create(cgrp, type);
 	if (!l) {
-		mutex_unlock(&cgrp->pidlist_mutex);
 		pidlist_free(array);
 		return -ENOMEM;
 	}


