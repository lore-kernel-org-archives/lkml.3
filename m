Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933030Ab3DZCzB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 22:55:01 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:59203 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756519Ab3DZCy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 22:54:59 -0400
Message-ID: <5179EC7C.5060208@huawei.com>
Date: Fri, 26 Apr 2013 10:54:52 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] cgroup: restore the call to eventfd->poll()
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I mistakenly removed the call to eventfd->poll() while I was actually
intending to remove the return value...

Calling evenfd->poll() will hook cgroup_event_wake() to the poll
waitqueue, which will be called to unregister eventfd when rmdir a
cgroup or close eventfd.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index a45aa12..4b0f2ef 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3882,6 +3882,8 @@ static int cgroup_write_event_control(struct cgroup *cgrp, struct cftype *cft,
 	if (ret)
 		goto fail;
 
+	efile->f_op->poll(efile, &event->pt);
+
 	/*
 	 * Events should be removed after rmdir of cgroup directory, but before
 	 * destroying subsystem state objects. Let's take reference to cgroup
-- 
1.8.0.2

