Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802Ab3HMCGG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 22:06:06 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:26990 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756648Ab3HMCGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 22:06:03 -0400
Message-ID: <52099487.8010601@huawei.com>
Date: Tue, 13 Aug 2013 10:05:59 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>
Subject: [PATCH][3.11] cpuset: fix the return value of cpuset_write_u64()
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Writing to this file always returns -ENODEV:

  # echo 1 > cpuset.memory_pressure_enabled
  -bash: echo: write error: No such device

Signed-off-by: Li Zefan <lizefan@huawei.com>
Cc: <stable@vger.kernel.org> # 3.9+
---
 kernel/cpuset.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 1b9c315..c602ab8 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1607,11 +1607,13 @@ static int cpuset_write_u64(struct cgroup *cgrp, struct cftype *cft, u64 val)
 {
 	struct cpuset *cs = cgroup_cs(cgrp);
 	cpuset_filetype_t type = cft->private;
-	int retval = -ENODEV;
+	int retval = 0;
 
 	mutex_lock(&cpuset_mutex);
-	if (!is_cpuset_online(cs))
+	if (!is_cpuset_online(cs)) {
+		retval = -ENODEV;
 		goto out_unlock;
+	}
 
 	switch (type) {
 	case FILE_CPU_EXCLUSIVE:
-- 
1.8.0.2

