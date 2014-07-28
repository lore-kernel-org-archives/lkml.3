Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768AbaG1PMe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 11:12:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:2388 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752332AbaG1PMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 11:12:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,749,1400050800"; 
   d="scan'208";a="550178357"
Message-ID: <53D6685C.1060509@intel.com>
Date: Mon, 28 Jul 2014 08:12:28 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Zhang Zhen <zhenzhang.zhang@huawei.com>, shaohui.zheng@intel.com,
        mgorman@suse.de, mingo@redhat.com, Linux MM <linux-mm@kvack.org>,
        linux-kernel@vger.kernel.org
CC: wangnan0@huawei.com, akpm@linux-foundation.org
Subject: Re: [PATCH] memory hotplug: update the variables after memory removed
References: <1406550617-19556-1-git-send-email-zhenzhang.zhang@huawei.com> <53D642E5.2010305@huawei.com>
In-Reply-To: <53D642E5.2010305@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2014 05:32 AM, Zhang Zhen wrote:
> -static void  update_end_of_memory_vars(u64 start, u64 size)
> +static void  update_end_of_memory_vars(u64 start, u64 size, bool flag)
>  {
> -	unsigned long end_pfn = PFN_UP(start + size);
> -
> -	if (end_pfn > max_pfn) {
> -		max_pfn = end_pfn;
> -		max_low_pfn = end_pfn;
> -		high_memory = (void *)__va(max_pfn * PAGE_SIZE - 1) + 1;
> +	unsigned long end_pfn;
> +
> +	if (flag) {
> +		end_pfn = PFN_UP(start + size);
> +		if (end_pfn > max_pfn) {
> +			max_pfn = end_pfn;
> +			max_low_pfn = end_pfn;
> +			high_memory = (void *)__va(max_pfn * PAGE_SIZE - 1) + 1;
> +		}
> +	} else {
> +		end_pfn = PFN_UP(start);
> +		if (end_pfn < max_pfn) {
> +			max_pfn = end_pfn;
> +			max_low_pfn = end_pfn;
> +			high_memory = (void *)__va(max_pfn * PAGE_SIZE - 1) + 1;
> +		}
>  	}
>  }

I would really prefer not to see code like this.

This patch takes a small function that did one thing, copies-and-pastes
its code 100%, subtly changes it, and makes it do two things.  The only
thing to tell us what the difference between these two subtly different
things is a variable called 'flag'.  So the variable is useless in
trying to figure out what each version is supposed to do.

But, this fixes a pretty glaring deficiency in the memory remove code.

I would suggest making two functions.  Make it clear that one is to be
used at remove time and the other at add time.  Maybe

	move_end_of_memory_vars_down()
and
	move_end_of_memory_vars_up()

?
