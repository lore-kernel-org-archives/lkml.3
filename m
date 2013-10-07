Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab3JGM2a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 08:28:30 -0400
Received: from intranet.asianux.com ([58.214.24.6]:34821 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab3JGM23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 08:28:29 -0400
X-Spam-Score: -100.8
Message-ID: <5252A8AE.8040206@asianux.com>
Date: Mon, 07 Oct 2013 20:27:26 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: bsingharora@gmail.com
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] kernel/taskstats.c: return -ENOMEM when alloc memory fails
 in add_del_listener()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For registering in add_del_listener(), when kmalloc_node() fails, need
return -ENOMEM instead of success code, and cmd_attr_register_cpumask()
wants to know about it.

After modification, give a simple common test "build -> boot up ->
kernel/controllers/cgroup/getdelays by LTP tools".


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 kernel/taskstats.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/taskstats.c b/kernel/taskstats.c
index 1db6808..9f4618e 100644
--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -290,6 +290,7 @@ static int add_del_listener(pid_t pid, const struct cpumask *mask, int isadd)
 	struct listener_list *listeners;
 	struct listener *s, *tmp, *s2;
 	unsigned int cpu;
+	int ret = 0;
 
 	if (!cpumask_subset(mask, cpu_possible_mask))
 		return -EINVAL;
@@ -304,9 +305,10 @@ static int add_del_listener(pid_t pid, const struct cpumask *mask, int isadd)
 		for_each_cpu(cpu, mask) {
 			s = kmalloc_node(sizeof(struct listener),
 					GFP_KERNEL, cpu_to_node(cpu));
-			if (!s)
+			if (!s) {
+				ret = -ENOMEM;
 				goto cleanup;
-
+			}
 			s->pid = pid;
 			s->valid = 1;
 
@@ -339,7 +341,7 @@ cleanup:
 		}
 		up_write(&listeners->sem);
 	}
-	return 0;
+	return ret;
 }
 
 static int parse(struct nlattr *na, struct cpumask *mask)
-- 
1.7.7.6
