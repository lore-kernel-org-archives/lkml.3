Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401AbaE1EPe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 00:15:34 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:65076 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbaE1EPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 00:15:33 -0400
Date: Tue, 27 May 2014 21:14:21 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Vitaly Wool <vitaly.vul@sonymobile.com>
cc: linux-kernel@vger.kernel.org, Izik Eidus <izik.eidus@ravellosystems.com>,
        bjorn.andersson@sonymobile.com
Subject: Re: [RFC/PATCH] ksm: add vma size threshold parameter
In-Reply-To: <5384FF76.4010704@sonymobile.com>
Message-ID: <alpine.LSU.2.11.1405272053170.1126@eggly.anvils>
References: <5384FF76.4010704@sonymobile.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2014, Vitaly Wool wrote:

> Hi,
> 
> I have recently been poking around saving memory on low-RAM Android devices,
> basically
> following the Google KSM+ZRAM guidelines for KitKat and measuring the
> gain/performance.
> While getting quite some RAM savings indeed (in the range of 10k-20k pages)
> we noticed
> that kswapd used a lot of CPU cycles most of the time, and that iowait times
> reported
> by e. g. top were sometimes off the reasonable limits (up to 40%). From what
> I could see,
> the reason for that behavior at least in part is that KSM has to traverse
> really long
> VMA lists.
> 
> Android userspace should be held somewhat responsible for that since it
> "advises" KSM all
> MAP_PRIVATE|MAP_ANONYMOUS mmap'ed pages are mergeable while this seems to be
> exhaustive
> and not quite following the kernel KSM Documentation piece saying:
> "Applications should be considerate in their use of MADV_MERGEABLE,
> restricting its use to areas likely to benefit.  KSM's scans may use a lot
> of processing power: some installations will disable KSM for that reason."
> 
> As a mitigation to this, we suggest an additional parameter to be added to
> KSM
> sysfs-exported ones. It will allow for bypassing small VM areas advertised as
> mergeable
> and only add bigger ones to KSM lists, keeping the default behavior intact.
> 
> The RFC/patch code may then look like this:
> 
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 68710e8..069f6b0 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -232,6 +232,10 @@ static int ksm_nr_node_ids = 1;
>  #define ksm_nr_node_ids		1
>  #endif
>  +/* Threshold for minimal VMA size to consider */
> +static unsigned long ksm_vma_size_threshold = 4096;
> +
> +
>  #define KSM_RUN_STOP	0
>  #define KSM_RUN_MERGE	1
>  #define KSM_RUN_UNMERGE	2
> @@ -1757,6 +1761,9 @@ int ksm_madvise(struct vm_area_struct *vma, unsigned
> long start,
>  			return 0;
>  #endif
>  +		if (end - start < ksm_vma_size_threshold)
> +			return 0;
> +
>  		if (!test_bit(MMF_VM_MERGEABLE, &mm->flags)) {
>  			err = __ksm_enter(mm);
>  			if (err)
> @@ -2240,6 +2247,29 @@ static ssize_t merge_across_nodes_store(struct kobject
> *kobj,
>  KSM_ATTR(merge_across_nodes);
>  #endif
>  +static ssize_t vma_size_threshold_show(struct kobject *kobj,
> +			struct kobj_attribute *attr, char *buf)
> +{
> +	return sprintf(buf, "%lu\n", ksm_vma_size_threshold);
> +}
> +
> +static ssize_t vma_size_threshold_store(struct kobject *kobj,
> +			struct kobj_attribute *attr,
> +			const char *buf, size_t count)
> +{
> +	int err;
> +	unsigned long thresh;
> +
> +	err = strict_strtoul(buf, 10, &thresh);
> +	if (err || thresh > UINT_MAX)
> +		return -EINVAL;
> +
> +	ksm_vma_size_threshold = thresh;
> +
> +	return count;
> +}
> +KSM_ATTR(vma_size_threshold);
> +
>  static ssize_t pages_shared_show(struct kobject *kobj,
>  				 struct kobj_attribute *attr, char *buf)
>  {
> @@ -2297,6 +2327,7 @@ static struct attribute *ksm_attrs[] = {
>  #ifdef CONFIG_NUMA
>  	&merge_across_nodes_attr.attr,
>  #endif
> +	&vma_size_threshold_attr.attr,
>  	NULL,
>  };
> 
> With our (narrow) use case, setting vma_size_threshold to 65536 significantly
> decreases the
> iowait time and the CPU idle load, while the KSM gain descreases quite
> slightly (by 5-15%).
> 
> Any comments will be greatly appreciated,

It's interesting, even amusing, but I think the emphasis has to be on
your "(narrow) use case".

I can't see any particular per-vma overhead in KSM's scan; and what
little per-vma overhead there is (find_vma, vma->vm_next) includes
the non-mergeable vmas along with the mergeable ones.

And I don't think it's a universal rule of nature that small vmas are
less likely to contain identical pages than large ones - beyond, of
course, the obvious fact that small vmas are likely to contain fewer
pages than large ones, so to that degree less likely to have merge hits.

But you see a significantly/slightly effect beyond that: any theory why?

I think it's just a feature of your narrow use case, and the adjustment
for it best made in userspace (or hacked into your own kernel if you
wish); but I cannot at present see the case for doing this in an
upstream kernel.

Hugh
