Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155Ab3JKJwV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 05:52:21 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:44650 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932139Ab3JKJwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 05:52:18 -0400
Message-ID: <5257CA45.6000001@huawei.com>
Date: Fri, 11 Oct 2013 17:52:05 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>
Subject: [PATCH v2 12/12] cpuset: export effective masks to userspace
References: <5257C9A1.1030404@huawei.com>
In-Reply-To: <5257C9A1.1030404@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpuset.cpus and cpuset.mems are the configured masks, and we need
to export effective masks to userspace, so users know the real
cpus_allowed and mems_allowed that apply to the tasks in a cpuset.

cpuset.effective_cpus and cpuset.effective_mems will be created for
sane_behavior only.

v2:
- export those masks unconditionally, suggested by Tejun.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cpuset.c | 34 ++++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index a98723d..c8ba514 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1614,6 +1614,8 @@ typedef enum {
 	FILE_MEMORY_MIGRATE,
 	FILE_CPULIST,
 	FILE_MEMLIST,
+	FILE_EFFECTIVE_CPULIST,
+	FILE_EFFECTIVE_MEMLIST,
 	FILE_CPU_EXCLUSIVE,
 	FILE_MEM_EXCLUSIVE,
 	FILE_MEM_HARDWALL,
@@ -1762,23 +1764,23 @@ out_unlock:
  * across a page fault.
  */
 
-static size_t cpuset_sprintf_cpulist(char *page, struct cpuset *cs)
+static size_t cpuset_sprintf_cpulist(char *page, struct cpumask *pmask)
 {
 	size_t count;
 
 	mutex_lock(&callback_mutex);
-	count = cpulist_scnprintf(page, PAGE_SIZE, cs->cpus_allowed);
+	count = cpulist_scnprintf(page, PAGE_SIZE, pmask);
 	mutex_unlock(&callback_mutex);
 
 	return count;
 }
 
-static size_t cpuset_sprintf_memlist(char *page, struct cpuset *cs)
+static size_t cpuset_sprintf_memlist(char *page, nodemask_t mask)
 {
 	size_t count;
 
 	mutex_lock(&callback_mutex);
-	count = nodelist_scnprintf(page, PAGE_SIZE, cs->mems_allowed);
+	count = nodelist_scnprintf(page, PAGE_SIZE, mask);
 	mutex_unlock(&callback_mutex);
 
 	return count;
@@ -1802,10 +1804,16 @@ static ssize_t cpuset_common_file_read(struct cgroup_subsys_state *css,
 
 	switch (type) {
 	case FILE_CPULIST:
-		s += cpuset_sprintf_cpulist(s, cs);
+		s += cpuset_sprintf_cpulist(s, cs->cpus_allowed);
 		break;
 	case FILE_MEMLIST:
-		s += cpuset_sprintf_memlist(s, cs);
+		s += cpuset_sprintf_memlist(s, cs->mems_allowed);
+		break;
+	case FILE_EFFECTIVE_CPULIST:
+		s += cpuset_sprintf_cpulist(s, cs->effective_cpus);
+		break;
+	case FILE_EFFECTIVE_MEMLIST:
+		s += cpuset_sprintf_memlist(s, cs->effective_mems);
 		break;
 	default:
 		retval = -EINVAL;
@@ -1880,6 +1888,13 @@ static struct cftype files[] = {
 	},
 
 	{
+		.name = "effective_cpus",
+		.read = cpuset_common_file_read,
+		.max_write_len = (100U + 6 * NR_CPUS),
+		.private = FILE_EFFECTIVE_CPULIST,
+	},
+
+	{
 		.name = "mems",
 		.read = cpuset_common_file_read,
 		.write_string = cpuset_write_resmask,
@@ -1888,6 +1903,13 @@ static struct cftype files[] = {
 	},
 
 	{
+		.name = "effective_mems",
+		.read = cpuset_common_file_read,
+		.max_write_len = (100U + 6 * MAX_NUMNODES),
+		.private = FILE_EFFECTIVE_MEMLIST,
+	},
+
+	{
 		.name = "cpu_exclusive",
 		.read_u64 = cpuset_read_u64,
 		.write_u64 = cpuset_write_u64,
-- 
1.8.0.2

