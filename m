Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517AbaBLDpS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 22:45:18 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41365 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbaBLDpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 22:45:16 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <52FAEE24.8090509@jp.fujitsu.com>
Date: Wed, 12 Feb 2014 12:44:36 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Luiz Capitulino <lcapitulino@redhat.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <akpm@linux-foundation.org>, <mtosatti@redhat.com>, <mgorman@suse.de>,
        <aarcange@redhat.com>, <andi@firstfloor.org>, <riel@redhat.com>
Subject: Re: [PATCH 3/4] hugetlb: add hugepagesnid= command-line option
References: <1392053268-29239-1-git-send-email-lcapitulino@redhat.com> <1392053268-29239-4-git-send-email-lcapitulino@redhat.com>
In-Reply-To: <1392053268-29239-4-git-send-email-lcapitulino@redhat.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/02/11 2:27), Luiz Capitulino wrote:
> From: Luiz capitulino <lcapitulino@redhat.com>
> 
> The HugeTLB command-line option hugepages= allow the user to specify
> how many huge pages should be allocated at boot-time. On NUMA systems,
> this option will try to automatically distribute the allocation equally
> among nodes. For example, if you have a 2-node NUMA system and allocates
> 200 huge pages, than hugepages= will try to allocate 100 huge pages from
> node0 and 100 from node1.
> 
> The hugepagesnid= option introduced by this commit allows the user
> to specify the nodes from which huge pages are allocated. For example,
> if you have a 2-node NUMA system and want 300 2M huge pages to be
> allocated from node1, you could do:
> 
>   hugepagesnid=1,300,2M
> 
> Or, say you want node0 to allocate 100 huge pages and node1 to
> allocate 200 huge pages, you do:
> 
>   hugepagesnid=0,100,2M hugepagesnid=1,200,1M
> 
> This commit adds support only for 2M huge pages, next commit will
> add support for 1G huge pages.
> 
> Signed-off-by: Luiz Capitulino <lcapitulino@redhat.com>
> ---
>   Documentation/kernel-parameters.txt |  8 ++++
>   arch/x86/mm/hugetlbpage.c           | 35 +++++++++++++++++
>   include/linux/hugetlb.h             |  2 +
>   mm/hugetlb.c                        | 77 +++++++++++++++++++++++++++++++++++++
>   4 files changed, 122 insertions(+)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 7116fda..3cbe950 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -1125,6 +1125,14 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>   			registers.  Default set by CONFIG_HPET_MMAP_DEFAULT.
>   
>   	hugepages=	[HW,X86-32,IA-64] HugeTLB pages to allocate at boot.
> +	hugepagesnid= [X86-64] HugeTLB pages to allocate at boot on a NUMA system.
> +				Format: <nid>,<nrpages>,<size>
> +				nid: NUMA node id to allocate pages from
> +				nrpages: number of huge pages to allocate
> +				size: huge pages size (see hugepagsz below)
> +			This argument can be specified multiple times for different
> +			NUMA nodes, but it shouldn't be mixed with hugepages= and
> +			hugepagesz=.
>   	hugepagesz=	[HW,IA-64,PPC,X86-64] The size of the HugeTLB pages.
>   			On x86-64 and powerpc, this option can be specified
>   			multiple times interleaved with hugepages= to reserve
> diff --git a/arch/x86/mm/hugetlbpage.c b/arch/x86/mm/hugetlbpage.c
> index 8c9f647..91c5c98 100644
> --- a/arch/x86/mm/hugetlbpage.c
> +++ b/arch/x86/mm/hugetlbpage.c
> @@ -188,4 +188,39 @@ static __init int setup_hugepagesz(char *opt)
>   	return 1;
>   }
>   __setup("hugepagesz=", setup_hugepagesz);
> +
> +static __init int setup_hugepagesnid(char *opt)
> +{
> +	unsigned long order, ps, nid, nr_pages;
> +	char size_str[3];
> +
> +	size_str[2] = '\0';
> +	if (sscanf(opt, "%lu,%lu,%c%c",
> +			&nid, &nr_pages, &size_str[0], &size_str[1]) < 4) {
> +		printk(KERN_ERR "hugepagesnid: failed to parse arguments\n");
> +			return 0;
> +	}
> +
> +	if (!nr_pages) {
> +		printk(KERN_ERR
> +			"hugepagesnid: zero number of pages, ignoring\n");
> +		return 0;
> +	}
> +
> +	ps = memparse(size_str, NULL);
> +	if (ps == PMD_SIZE) {
> +		order = PMD_SHIFT - PAGE_SHIFT;
> +	} else if (ps == PUD_SIZE && cpu_has_gbpages) {
> +		order = PUD_SHIFT - PAGE_SHIFT;
> +	} else {
> +		printk(KERN_ERR "hugepagesnid: Unsupported page size %lu M\n",
> +			ps >> 20);
> +		return 0;
> +	}

You must check that nid is valid or not. When nid is MAX_NUMNODES or more,
hugetlb_add_nrpages_nid() sets nr_pages to wrong memory region.

Thanks,
Yasuaki Ishimatsu

> +
> +	hugetlb_add_nrpages_nid(order, nid, nr_pages);
> +	return 1;
> +}
> +__setup("hugepagesnid=", setup_hugepagesnid);
> +
>   #endif
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 8c43cc4..aae2f9b 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -274,6 +274,8 @@ struct page *alloc_huge_page_noerr(struct vm_area_struct *vma,
>   int __init alloc_bootmem_huge_page(struct hstate *h);
>   
>   void __init hugetlb_add_hstate(unsigned order);
> +void __init hugetlb_add_nrpages_nid(unsigned order, unsigned long nid,
> +				unsigned long nr_pages);
>   struct hstate *size_to_hstate(unsigned long size);
>   
>   #ifndef HUGE_MAX_HSTATE
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index c01cb9f..439c3b7 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -46,6 +46,7 @@ __initdata LIST_HEAD(huge_boot_pages);
>   static struct hstate * __initdata parsed_hstate;
>   static unsigned long __initdata default_hstate_max_huge_pages;
>   static unsigned long __initdata default_hstate_size;
> +static unsigned long __initdata boot_alloc_nodes[HUGE_MAX_HSTATE][MAX_NUMNODES];
>   
>   /*
>    * Protects updates to hugepage_freelists, hugepage_activelist, nr_huge_pages,
> @@ -1348,6 +1349,50 @@ static void __init hugetlb_hstate_alloc_pages(struct hstate *h)
>   	h->max_huge_pages = i;
>   }
>   
> +static unsigned long __init alloc_huge_pages_nid(struct hstate *h,
> +						int nid,
> +						unsigned long nr_pages)
> +{
> +	unsigned long i;
> +	struct page *page;
> +
> +	for (i = 0; i < nr_pages; i++) {
> +		page = alloc_fresh_huge_page_node(h, nid);
> +		if (!page) {
> +			count_vm_event(HTLB_BUDDY_PGALLOC_FAIL);
> +			break;
> +		}
> +		count_vm_event(HTLB_BUDDY_PGALLOC);
> +	}
> +
> +	return i;
> +}
> +
> +static unsigned long __init alloc_huge_pages_nodes(struct hstate *h)
> +{
> +	unsigned long i, *entry, ret = 0;
> +
> +	for (i = 0; i < MAX_NUMNODES; i++) {
> +		entry = &boot_alloc_nodes[hstate_index(h)][i];
> +		if (*entry > 0)
> +			ret += alloc_huge_pages_nid(h, i, *entry);
> +	}
> +
> +	return ret;
> +}
> +
> +static void __init hugetlb_init_hstates_nodes(void)
> +{
> +	struct hstate *h;
> +	unsigned long ret;
> +
> +	for_each_hstate(h)
> +		if (h->order < MAX_ORDER) {
> +			ret = alloc_huge_pages_nodes(h);
> +			h->max_huge_pages += ret;
> +		}
> +}
> +
>   static void __init hugetlb_init_hstates(void)
>   {
>   	struct hstate *h;
> @@ -1966,6 +2011,7 @@ static int __init hugetlb_init(void)
>   		default_hstate.max_huge_pages = default_hstate_max_huge_pages;
>   
>   	hugetlb_init_hstates();
> +	hugetlb_init_hstates_nodes();
>   	gather_bootmem_prealloc();
>   	report_hugepages();
>   
> @@ -2005,6 +2051,37 @@ void __init hugetlb_add_hstate(unsigned order)
>   	parsed_hstate = h;
>   }
>   
> +void __init hugetlb_add_nrpages_nid(unsigned order, unsigned long nid,
> +				unsigned long nr_pages)
> +{
> +	struct hstate *h;
> +	unsigned long *p;
> +
> +	if (parsed_hstate) {
> +		printk(KERN_WARNING
> +			"hugepagesnid: hugepagesz= specified, ignoring\n");
> +		return;
> +	}
> +
> +	for_each_hstate(h)
> +		if (h->order == order)
> +			break;
> +
> +	if (h->order != order) {
> +		hugetlb_add_hstate(order);
> +		parsed_hstate = NULL;
> +	}
> +
> +	p = &boot_alloc_nodes[hstate_index(h)][nid];
> +	if (*p != 0) {
> +		printk(KERN_WARNING
> +			"hugepagesnid: node %lu already specified, ignoring\n", nid);
> +		return;
> +	}
> +
> +	*p = nr_pages;
> +}
> +
>   static int __init hugetlb_nrpages_setup(char *s)
>   {
>   	unsigned long *mhp;
> 


