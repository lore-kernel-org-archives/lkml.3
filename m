Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309AbaITGgD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 02:36:03 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:7049 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbaITGgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 02:36:00 -0400
Message-ID: <541D203F.4020902@huawei.com>
Date: Sat, 20 Sep 2014 14:35:43 +0800
From: Zefan Li <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] cgroup: fix missing unlock in cgroup_release_agent()
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch 971ff4935538: "cgroup: use a per-cgroup work for release
agent" from Sep 18, 2014, leads to the following static checker
warning:

	kernel/cgroup.c:5310 cgroup_release_agent()
	warn: 'mutex:&cgroup_mutex' is sometimes locked here and sometimes unlocked.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 kernel/cgroup.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 7f23551..33f15b3 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -5290,7 +5290,10 @@ static void cgroup_release_agent(struct work_struct *work)
 
 	mutex_unlock(&cgroup_mutex);
 	call_usermodehelper(argv[0], argv, envp, UMH_WAIT_EXEC);
+	goto out_free;
 out:
+	mutex_unlock(&cgroup_mutex);
+out_free:
 	kfree(agentbuf);
 	kfree(pathbuf);
 }
-- 
1.8.0.2

