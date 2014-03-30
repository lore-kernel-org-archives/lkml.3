Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbaC3Xnu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:43:50 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37332 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754706AbaC3Xnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:43:40 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Li Zefan" <lizefan@huawei.com>,
        "Tejun Heo" <tj@kernel.org>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.126353580@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 152/200] cpuset: fix a race condition in
 __cpuset_node_allowed_softwall()
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Li Zefan <lizefan@huawei.com>

commit 99afb0fd5f05aac467ffa85c36778fec4396209b upstream.

It's not safe to access task's cpuset after releasing task_lock().
Holding callback_mutex won't help.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/cpuset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2366,9 +2366,9 @@ int __cpuset_node_allowed_softwall(int n
 
 	task_lock(current);
 	cs = nearest_hardwall_ancestor(task_cs(current));
+	allowed = node_isset(node, cs->mems_allowed);
 	task_unlock(current);
 
-	allowed = node_isset(node, cs->mems_allowed);
 	mutex_unlock(&callback_mutex);
 	return allowed;
 }

