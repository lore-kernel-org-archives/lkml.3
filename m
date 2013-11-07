Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948Ab3KGAzx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 19:55:53 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35498 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab3KGAzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 19:55:52 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <527AE4DE.3050209@jp.fujitsu.com>
Date: Thu, 07 Nov 2013 09:54:54 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
CC: "vgoyal@redhat.com" <vgoyal@redhat.com>, "bhe@redhat.com" <bhe@redhat.com>,
        "tom.vaden@hp.com" <tom.vaden@hp.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "ptesarik@suse.cz" <ptesarik@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lisa.mitchell@hp.com" <lisa.mitchell@hp.com>,
        "anderson@redhat.com" <anderson@redhat.com>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "jingbai.ma@hp.com" <jingbai.ma@hp.com>
Subject: Re: [PATCH 0/3] makedumpfile: hugepage filtering for vmcore dump
References: <20131105134532.32112.78008.stgit@k.asiapacific.hpqcorp.net> <20131105202631.GC4598@redhat.com> <0910DD04CBD6DE4193FCF86B9C00BE971BB7A9@BPXM01GP.gisp.nec.co.jp>
In-Reply-To: <0910DD04CBD6DE4193FCF86B9C00BE971BB7A9@BPXM01GP.gisp.nec.co.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/11/06 11:21), Atsushi Kumagai wrote:
> (2013/11/06 5:27), Vivek Goyal wrote:
>> On Tue, Nov 05, 2013 at 09:45:32PM +0800, Jingbai Ma wrote:
>>> This patch set intend to exclude unnecessary hugepages from vmcore dump file.
>>>
>>> This patch requires the kernel patch to export necessary data structures into
>>> vmcore: "kexec: export hugepage data structure into vmcoreinfo"
>>> http://lists.infradead.org/pipermail/kexec/2013-November/009997.html
>>>
>>> This patch introduce two new dump levels 32 and 64 to exclude all unused and
>>> active hugepages. The level to exclude all unnecessary pages will be 127 now.
>>
>> Interesting. Why hugepages should be treated any differentely than normal
>> pages?
>>
>> If user asked to filter out free page, then it should be filtered and
>> it should not matter whether it is a huge page or not?
>
> I'm making a RFC patch of hugepages filtering based on such policy.
>
> I attach the prototype version.
> It's able to filter out also THPs, and suitable for cyclic processing
> because it depends on mem_map and looking up it can be divided into
> cycles. This is the same idea as page_is_buddy().
>
> So I think it's better.
>

> @@ -4506,14 +4583,49 @@ __exclude_unnecessary_pages(unsigned long mem_map,
>    		    && !isAnon(mapping)) {
>    			if (clear_bit_on_2nd_bitmap_for_kernel(pfn))
>    				pfn_cache_private++;
> +			/*
> +			 * NOTE: If THP for cache is introduced, the check for
> +			 *       compound pages is needed here.
> +			 */
>    		}
>    		/*
>    		 * Exclude the data page of the user process.
>    		 */
> -		else if ((info->dump_level & DL_EXCLUDE_USER_DATA)
> -		    && isAnon(mapping)) {
> -			if (clear_bit_on_2nd_bitmap_for_kernel(pfn))
> -				pfn_user++;
> +		else if (info->dump_level & DL_EXCLUDE_USER_DATA) {
> +			/*
> +			 * Exclude the anonnymous pages as user pages.
> +			 */
> +			if (isAnon(mapping)) {
> +				if (clear_bit_on_2nd_bitmap_for_kernel(pfn))
> +					pfn_user++;
> +
> +				/*
> +				 * Check the compound page
> +				 */
> +				if (page_is_hugepage(flags) && compound_order > 0) {
> +					int i, nr_pages = 1 << compound_order;
> +
> +					for (i = 1; i < nr_pages; ++i) {
> +						if (clear_bit_on_2nd_bitmap_for_kernel(pfn + i))
> +							pfn_user++;
> +					}
> +					pfn += nr_pages - 2;
> +					mem_map += (nr_pages - 1) * SIZE(page);
> +				}
> +			}
> +			/*
> +			 * Exclude the hugetlbfs pages as user pages.
> +			 */
> +			else if (hugetlb_dtor == SYMBOL(free_huge_page)) {
> +				int i, nr_pages = 1 << compound_order;
> +
> +				for (i = 0; i < nr_pages; ++i) {
> +					if (clear_bit_on_2nd_bitmap_for_kernel(pfn + i))
> +						pfn_user++;
> +				}
> +				pfn += nr_pages - 1;
> +				mem_map += (nr_pages - 1) * SIZE(page);
> +			}
>    		}
>    		/*
>    		 * Exclude the hwpoison page.

I'm concerned about the case that filtering is not performed to part of mem_map
entries not belonging to the current cyclic range.

If maximum value of compound_order is larger than maximum value of
CONFIG_FORCE_MAX_ZONEORDER, which makedumpfile obtains by ARRAY_LENGTH(zone.free_area),
it's necessary to align info->bufsize_cyclic with larger one in
check_cyclic_buffer_overrun().

-- 
Thanks.
HATAYAMA, Daisuke

