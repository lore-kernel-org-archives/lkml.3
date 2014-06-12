Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbaFLGbo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 02:31:44 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:32598 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbaFLGbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 02:31:42 -0400
Message-ID: <53994943.60703@huawei.com>
Date: Thu, 12 Jun 2014 14:31:31 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH 1/5] cgroup: fix broken css_has_online_children()
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After running:

  # mount -t cgroup cpu xxx /cgroup && mkdir /cgroup/sub && \
    rmdir /cgroup/sub && umount /cgroup

I found the cgroup root still existed:

  # cat /proc/cgroups
  #subsys_name    hierarchy       num_cgroups     enabled
  cpuset  0       1       1
  cpu     1       1       1
  ...

It turned out css_has_online_children() is broken.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 05b8ca4..1c65f24 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3327,7 +3327,7 @@ bool css_has_online_children(struct cgroup_subsys_state *css)
 
 	rcu_read_lock();
 	css_for_each_child(child, css) {
-		if (css->flags & CSS_ONLINE) {
+		if (child->flags & CSS_ONLINE) {
 			ret = true;
 			break;
 		}
-- 
1.8.0.2
