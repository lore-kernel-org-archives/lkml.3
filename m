Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545Ab3LRDdQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 22:33:16 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:48262 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465Ab3LRDdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 22:33:15 -0500
Message-ID: <52B11765.8030005@oracle.com>
Date: Tue, 17 Dec 2013 22:32:53 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Michel Lespinasse <walken@google.com>, Bob Liu <bob.liu@oracle.com>,
        npiggin@suse.de, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com,
        David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
        Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/mlock: fix BUG_ON unlocked page for nolinear VMAs
References: <1387267550-8689-1-git-send-email-liwanp@linux.vnet.ibm.com> <52b1138b.0201430a.19a8.605dSMTPIN_ADDED_BROKEN@mx.google.com> <20131218032329.GA6044@hacker.(null)>
In-Reply-To: <20131218032329.GA6044@hacker.(null)>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2013 10:23 PM, Wanpeng Li wrote:
> -			mlock_vma_page(page);   /* no-op if already mlocked */
> -			if (page == check_page)
> +			if (page != check_page && trylock_page(page)) {
> +				mlock_vma_page(page);   /* no-op if already mlocked */
> +				unlock_page(page);
> +			} else if (page == check_page) {
> +				mlock_vma_page(page);  /* no-op if already mlocked */
>   				ret = SWAP_MLOCK;
> +			}

Previously, if page != check_page and the page was locked, we'd call mlock_vma_page()
anyways. With this change, we don't. In fact, we'll just skip that entire block not doing
anything.

If that's something that's never supposed to happen, can we add a

	VM_BUG_ON(page != check_page && PageLocked(page))

Just to cover this new code path?


Thanks,
Sasha
