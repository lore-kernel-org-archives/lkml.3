Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758467Ab3G0DD0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 23:03:26 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:45043 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756301Ab3G0DDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 23:03:25 -0400
From: Hanjun Guo <hanjun.guo@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Chris Metcalf <cmetcalf@tilera.com>
Cc: patches@linaro.org, linaro-kernel@lists.linaro.org,
        Mike Travis <travis@sgi.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linaro-acpi@lists.linaro.org, Al Stone <al.stone@linaro.org>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Naresh Bhat <naresh.bhat@linaro.org>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>,
        Hanjun Guo <hanjun.guo@linaro.org>
Subject: [PATCH 1/3] cpu topology: remove stale arch_provides_topology_pointers and define_siblings_show_map/list()
Date: Sat, 27 Jul 2013 11:00:49 +0800
Message-Id: <1374894051-31634-1-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch_provides_topology_pointers was introduced in commit 23ca4bba3 (x86:
cleanup early per cpu variables/accesses v4) to indicate pointers to the
topology cpumask_t maps are valid to avoid copying data on to/off of the
stack.

But later in commit fbd59a8d (cpumask: Use topology_core_cpumask()/
topology_thread_cpumask()), the pointers to the topology struct cpumask maps
are always valid.

After that commit, the only difference is that there is a redundant
"unsigned int cpu = dev->id;" if arch_provides_topology_pointers defined, but
dev->id is type 'u32' which devolves to 'unsigned int' on all supported arches.
So this arch_provides_topology_pointers define is pointless and only cause
obfuscation now, remove it.

Tested on x86 machine, topology information in sys/devices/system/cpu/
cpuX/topology/ is the same after appling this patch set.

Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 drivers/base/topology.c |   20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/drivers/base/topology.c b/drivers/base/topology.c
index 2f5919e..94ffee3 100644
--- a/drivers/base/topology.c
+++ b/drivers/base/topology.c
@@ -62,25 +62,6 @@ static ssize_t show_cpumap(int type, const struct cpumask *mask, char *buf)
 }
 #endif
 
-#ifdef arch_provides_topology_pointers
-#define define_siblings_show_map(name)					\
-static ssize_t show_##name(struct device *dev,				\
-			   struct device_attribute *attr, char *buf)	\
-{									\
-	unsigned int cpu = dev->id;					\
-	return show_cpumap(0, topology_##name(cpu), buf);		\
-}
-
-#define define_siblings_show_list(name)					\
-static ssize_t show_##name##_list(struct device *dev,			\
-				  struct device_attribute *attr,	\
-				  char *buf)				\
-{									\
-	unsigned int cpu = dev->id;					\
-	return show_cpumap(1, topology_##name(cpu), buf);		\
-}
-
-#else
 #define define_siblings_show_map(name)					\
 static ssize_t show_##name(struct device *dev,				\
 			   struct device_attribute *attr, char *buf)	\
@@ -95,7 +76,6 @@ static ssize_t show_##name##_list(struct device *dev,			\
 {									\
 	return show_cpumap(1, topology_##name(dev->id), buf);		\
 }
-#endif
 
 #define define_siblings_show_func(name)		\
 	define_siblings_show_map(name); define_siblings_show_list(name)
-- 
1.7.9.5

