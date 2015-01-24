Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbbAXOD6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 09:03:58 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:49995 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332AbbAXODu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 09:03:50 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 01/32] cpumask: always use nr_cpu_ids in formatting and parsing functions
Date: Sat, 24 Jan 2015 09:03:07 -0500
Message-Id: <1422108218-25398-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1422108218-25398-1-git-send-email-tj@kernel.org>
References: <1422108218-25398-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the formatting and parsing functions in cpumask.h use
nr_cpumask_bits like other cpumask functions; however, nr_cpumask_bits
is either NR_CPUS or nr_cpu_ids depending on CONFIG_CPUMASK_OFFSTACK.
This leads to inconsistent behaviors.

With CONFIG_NR_CPUS=512 and !CONFIG_CPUMASK_OFFSTACK

  # cat /sys/devices/virtual/net/lo/queues/rx-0/rps_cpus
  00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000
  # cat /proc/self/status | grep Cpus_allowed:
  Cpus_allowed:   f

With CONFIG_NR_CPUS=1024 and CONFIG_CPUMASK_OFFSTACK (fedora default)

  # cat /sys/devices/virtual/net/lo/queues/rx-0/rps_cpus
  0
  # cat /proc/self/status | grep Cpus_allowed:
  Cpus_allowed:   f

Note that /proc/self/status is always using nr_cpu_ids regardless of
config.  This is because seq cpumask formattings functions always use
nr_cpu_ids.

Given that the same output fields may switch between the two forms,
converging on nr_cpu_ids always isn't too likely to surprise userland.
This patch updates the formatting and parsing functions in cpumask.h
to always use nr_cpu_ids.  There's no point in dealing with CPUs which
aren't even possible on the machine.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---
Hello,

Linus, this is the first of the three pre-requisite patches to convert
the users of the dedicated bitmap formatting functions over to
'%*pb[l]' formatting.

If this approach is agreed upon, I think it'd be best to route these
three patches through mainline soon so that subsystem conversion
patches can pull these in and apply per-subsystem conversion patches.

Thanks.

 include/linux/cpumask.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index b950e9d..98939d1 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -550,7 +550,7 @@ static inline void cpumask_copy(struct cpumask *dstp,
 static inline int cpumask_scnprintf(char *buf, int len,
 				    const struct cpumask *srcp)
 {
-	return bitmap_scnprintf(buf, len, cpumask_bits(srcp), nr_cpumask_bits);
+	return bitmap_scnprintf(buf, len, cpumask_bits(srcp), nr_cpu_ids);
 }
 
 /**
@@ -564,7 +564,7 @@ static inline int cpumask_scnprintf(char *buf, int len,
 static inline int cpumask_parse_user(const char __user *buf, int len,
 				     struct cpumask *dstp)
 {
-	return bitmap_parse_user(buf, len, cpumask_bits(dstp), nr_cpumask_bits);
+	return bitmap_parse_user(buf, len, cpumask_bits(dstp), nr_cpu_ids);
 }
 
 /**
@@ -579,7 +579,7 @@ static inline int cpumask_parselist_user(const char __user *buf, int len,
 				     struct cpumask *dstp)
 {
 	return bitmap_parselist_user(buf, len, cpumask_bits(dstp),
-							nr_cpumask_bits);
+				     nr_cpu_ids);
 }
 
 /**
@@ -595,7 +595,7 @@ static inline int cpulist_scnprintf(char *buf, int len,
 				    const struct cpumask *srcp)
 {
 	return bitmap_scnlistprintf(buf, len, cpumask_bits(srcp),
-				    nr_cpumask_bits);
+				    nr_cpu_ids);
 }
 
 /**
@@ -610,7 +610,7 @@ static inline int cpumask_parse(const char *buf, struct cpumask *dstp)
 	char *nl = strchr(buf, '\n');
 	unsigned int len = nl ? (unsigned int)(nl - buf) : strlen(buf);
 
-	return bitmap_parse(buf, len, cpumask_bits(dstp), nr_cpumask_bits);
+	return bitmap_parse(buf, len, cpumask_bits(dstp), nr_cpu_ids);
 }
 
 /**
@@ -622,7 +622,7 @@ static inline int cpumask_parse(const char *buf, struct cpumask *dstp)
  */
 static inline int cpulist_parse(const char *buf, struct cpumask *dstp)
 {
-	return bitmap_parselist(buf, cpumask_bits(dstp), nr_cpumask_bits);
+	return bitmap_parselist(buf, cpumask_bits(dstp), nr_cpu_ids);
 }
 
 /**
@@ -817,7 +817,7 @@ static inline ssize_t
 cpumap_print_to_pagebuf(bool list, char *buf, const struct cpumask *mask)
 {
 	return bitmap_print_to_pagebuf(list, buf, cpumask_bits(mask),
-				      nr_cpumask_bits);
+				      nr_cpu_ids);
 }
 
 /*
-- 
2.1.0

