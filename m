Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758925Ab3IBSep (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 14:34:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10658 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756551Ab3IBSej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 14:34:39 -0400
Date: Mon, 02 Sep 2013 14:34:30 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Tony Luck <tony.luck@intel.com>,
        gong.chen@linux.intel.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Message-ID: <1378146870-g7zzncdn-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1378125224-12794-4-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1378125224-12794-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <1378125224-12794-4-git-send-email-liwanp@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/4] mm/hwpoison: fix the lack of one reference count
 against poisoned page
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <1378125224-12794-4-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 02, 2013 at 08:33:44PM +0800, Wanpeng Li wrote:
> The lack of one reference count against poisoned page for hwpoison_inject w/o 
> hwpoison_filter enabled result in hwpoison detect -1 users still referenced 
> the page, however, the number should be 0 except the poison handler held one 
> after successfully unmap. This patch fix it by hold one referenced count against 
> poisoned page for hwpoison_inject w/ and w/o hwpoison_filter enabled.
> 
> Before patch:
> 
> [   71.902112] Injecting memory failure at pfn 224706
> [   71.902137] MCE 0x224706: dirty LRU page recovery: Failed
> [   71.902138] MCE 0x224706: dirty LRU page still referenced by -1 users
> 
> After patch:
> 
> [   94.710860] Injecting memory failure at pfn 215b68
> [   94.710885] MCE 0x215b68: dirty LRU page recovery: Recovered
> 
> Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>

Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

> ---
>  mm/hwpoison-inject.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/hwpoison-inject.c b/mm/hwpoison-inject.c
> index afc2daa..4c84678 100644
> --- a/mm/hwpoison-inject.c
> +++ b/mm/hwpoison-inject.c
> @@ -20,8 +20,6 @@ static int hwpoison_inject(void *data, u64 val)
>  	if (!capable(CAP_SYS_ADMIN))
>  		return -EPERM;
>  
> -	if (!hwpoison_filter_enable)
> -		goto inject;
>  	if (!pfn_valid(pfn))
>  		return -ENXIO;
>  
> @@ -33,6 +31,9 @@ static int hwpoison_inject(void *data, u64 val)
>  	if (!get_page_unless_zero(hpage))
>  		return 0;
>  
> +	if (!hwpoison_filter_enable)
> +		goto inject;
> +
>  	if (!PageLRU(p) && !PageHuge(p))
>  		shake_page(p, 0);
>  	/*
> -- 
> 1.8.1.2
>
