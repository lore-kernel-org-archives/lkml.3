Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbaE0VLW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 17:11:22 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:6015 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753393AbaE0VLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 17:11:21 -0400
Message-ID: <5384FF76.4010704@sonymobile.com>
Date: Tue, 27 May 2014 23:11:18 +0200
From: Vitaly Wool <vitaly.vul@sonymobile.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>, Hugh Dickins <hughd@google.com>,
        Izik Eidus <izik.eidus@ravellosystems.com>
CC: <bjorn.andersson@sonymobile.com>
Subject: [RFC/PATCH] ksm: add vma size threshold parameter
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have recently been poking around saving memory on low-RAM Android devices, basically
following the Google KSM+ZRAM guidelines for KitKat and measuring the gain/performance.
While getting quite some RAM savings indeed (in the range of 10k-20k pages) we noticed
that kswapd used a lot of CPU cycles most of the time, and that iowait times reported
by e. g. top were sometimes off the reasonable limits (up to 40%). From what I could see,
the reason for that behavior at least in part is that KSM has to traverse really long
VMA lists.

Android userspace should be held somewhat responsible for that since it "advises" KSM all
MAP_PRIVATE|MAP_ANONYMOUS mmap'ed pages are mergeable while this seems to be exhaustive
and not quite following the kernel KSM Documentation piece saying:
"Applications should be considerate in their use of MADV_MERGEABLE,
restricting its use to areas likely to benefit.  KSM's scans may use a lot
of processing power: some installations will disable KSM for that reason."

As a mitigation to this, we suggest an additional parameter to be added to KSM
sysfs-exported ones. It will allow for bypassing small VM areas advertised as mergeable
and only add bigger ones to KSM lists, keeping the default behavior intact.

The RFC/patch code may then look like this:

diff --git a/mm/ksm.c b/mm/ksm.c
index 68710e8..069f6b0 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -232,6 +232,10 @@ static int ksm_nr_node_ids = 1;
  #define ksm_nr_node_ids		1
  #endif
  
+/* Threshold for minimal VMA size to consider */
+static unsigned long ksm_vma_size_threshold = 4096;
+
+
  #define KSM_RUN_STOP	0
  #define KSM_RUN_MERGE	1
  #define KSM_RUN_UNMERGE	2
@@ -1757,6 +1761,9 @@ int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
  			return 0;
  #endif
  
+		if (end - start < ksm_vma_size_threshold)
+			return 0;
+
  		if (!test_bit(MMF_VM_MERGEABLE, &mm->flags)) {
  			err = __ksm_enter(mm);
  			if (err)
@@ -2240,6 +2247,29 @@ static ssize_t merge_across_nodes_store(struct kobject *kobj,
  KSM_ATTR(merge_across_nodes);
  #endif
  
+static ssize_t vma_size_threshold_show(struct kobject *kobj,
+			struct kobj_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%lu\n", ksm_vma_size_threshold);
+}
+
+static ssize_t vma_size_threshold_store(struct kobject *kobj,
+			struct kobj_attribute *attr,
+			const char *buf, size_t count)
+{
+	int err;
+	unsigned long thresh;
+
+	err = strict_strtoul(buf, 10, &thresh);
+	if (err || thresh > UINT_MAX)
+		return -EINVAL;
+
+	ksm_vma_size_threshold = thresh;
+
+	return count;
+}
+KSM_ATTR(vma_size_threshold);
+
  static ssize_t pages_shared_show(struct kobject *kobj,
  				 struct kobj_attribute *attr, char *buf)
  {
@@ -2297,6 +2327,7 @@ static struct attribute *ksm_attrs[] = {
  #ifdef CONFIG_NUMA
  	&merge_across_nodes_attr.attr,
  #endif
+	&vma_size_threshold_attr.attr,
  	NULL,
  };

With our (narrow) use case, setting vma_size_threshold to 65536 significantly decreases the
iowait time and the CPU idle load, while the KSM gain descreases quite slightly (by 5-15%).

Any comments will be greatly appreciated,

Thanks,
    Vitaly

