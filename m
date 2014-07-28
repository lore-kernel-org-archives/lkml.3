Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968AbaG1XYY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 19:24:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:32943 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213AbaG1XYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 19:24:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,752,1400050800"; 
   d="scan'208";a="550397168"
Message-ID: <53D6DB9C.7030109@intel.com>
Date: Mon, 28 Jul 2014 16:24:12 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Zhang Zhen <zhenzhang.zhang@huawei.com>, shaohui.zheng@intel.com,
        mgorman@suse.de, mingo@redhat.com, Linux MM <linux-mm@kvack.org>,
        linux-kernel@vger.kernel.org, wangnan0@huawei.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH] memory hotplug: update the variables after memory removed
References: <1406550617-19556-1-git-send-email-zhenzhang.zhang@huawei.com> <53D642E5.2010305@huawei.com> <53D6685C.1060509@intel.com> <alpine.DEB.2.02.1407281610340.8998@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1407281610340.8998@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2014 04:12 PM, David Rientjes wrote:
> I agree, but I'm not sure the suggestion is any better than the patch.  I 
> think it would be better to just figure out whether anything needs to be 
> updated in the caller and then call a generic function.
> 
> So in arch_add_memory(), do
> 
> 	end_pfn = PFN_UP(start + size);
> 	if (end_pfn > max_pfn)
> 		update_end_of_memory_vars(end_pfn);
> 
> and in arch_remove_memory(),
> 
> 	end_pfn = PFN_UP(start);
> 	if (end_pfn < max_pfn)
> 		update_end_of_memory_vars(end_pfn);
> 
> and then update_end_of_memory_vars() becomes a three-liner.

That does look better than my suggestion, generally.

It is broken in the remove case, though.  In your example, the memory
being removed is assumed to be coming from the end of memory, and that
isn't always the case.  I think you need something like:

	if ((max_pfn >= start_pfn) && (max_pfn < end_pfn)
		update_end_of_memory_vars(start);

But, yeah, that's a lot better than new functions.
