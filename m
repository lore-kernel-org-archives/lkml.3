Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758940Ab3IBSer (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 14:34:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58324 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758926Ab3IBSep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 14:34:45 -0400
Date: Mon, 02 Sep 2013 14:34:26 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Tony Luck <tony.luck@intel.com>,
        gong.chen@linux.intel.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Message-ID: <1378146866-4o68qbq7-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1378125224-12794-3-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1378125224-12794-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <1378125224-12794-3-git-send-email-liwanp@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/4] mm/hwpoison: fix false report 2nd try page recovery
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <1378125224-12794-3-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 02, 2013 at 08:33:43PM +0800, Wanpeng Li wrote:
> If the page is poisoned by software inject w/ MF_COUNT_INCREASED flag, there
> is a false report 2nd try page recovery which is not truth, this patch fix it
> by report first try free buddy page recovery if MF_COUNT_INCREASED is set.
> 
> Before patch:
> 
> [  346.332041] Injecting memory failure at pfn 200010
> [  346.332189] MCE 0x200010: free buddy, 2nd try page recovery: Delayed
> 
> After patch:
> 
> [  297.742600] Injecting memory failure at pfn 200010
> [  297.742941] MCE 0x200010: free buddy page recovery: Delayed
> 
> Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>

Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

> ---
>  mm/memory-failure.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index b114570..6293164 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -1114,8 +1114,10 @@ int memory_failure(unsigned long pfn, int trapno, int flags)
>  			 * shake_page could have turned it free.
>  			 */
>  			if (is_free_buddy_page(p)) {
> -				action_result(pfn, "free buddy, 2nd try",
> -						DELAYED);
> +				if (flags & MF_COUNT_INCREASED)
> +					action_result(pfn, "free buddy", DELAYED);
> +				else
> +					action_result(pfn, "free buddy, 2nd try", DELAYED);
>  				return 0;
>  			}
>  			action_result(pfn, "non LRU", IGNORED);
> -- 
> 1.7.5.4
>
