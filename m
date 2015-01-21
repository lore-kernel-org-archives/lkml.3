Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522AbbAUGdj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 01:33:39 -0500
Received: from TYO202.gate.nec.co.jp ([210.143.35.52]:34115 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997AbbAUGdi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 01:33:38 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Shiraz Hashim <shashim@codeaurora.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "oleg@redhat.com" <oleg@redhat.com>,
        "gorcunov@openvz.org" <gorcunov@openvz.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: pagewalk: call pte_hole() for VM_PFNMAP during
 walk_page_range
Thread-Topic: [PATCH] mm: pagewalk: call pte_hole() for VM_PFNMAP during
 walk_page_range
Thread-Index: AQHQNUFsW7TkTQVVQUquc8HKtAxWvZzJhi2A
Date: Wed, 21 Jan 2015 06:30:53 +0000
Message-ID: <20150121063043.GA18835@hori1.linux.bs1.fc.nec.co.jp>
References: <1421820793-28883-1-git-send-email-shashim@codeaurora.org>
In-Reply-To: <1421820793-28883-1-git-send-email-shashim@codeaurora.org>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.128.101.10]
Content-Type: text/plain; charset="iso-2022-jp"
Content-ID: <66994E9CC2CE2C44A2D781CCB81E89BF@gisp.nec.co.jp>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 11:43:13AM +0530, Shiraz Hashim wrote:
> walk_page_range silently skips vma having VM_PFNMAP set,
> which leads to undesirable behaviour at client end (who
> called walk_page_range). For example for pagemap_read,
> when no callbacks are called against VM_PFNMAP vma,
> pagemap_read may prepare pagemap data for next virtual
> address range at wrong index.
> 
> Signed-off-by: Shiraz Hashim <shashim@codeaurora.org>

Thank you!

Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

> ---
> The fix is revised, based upon the suggestion here at
> http://www.spinics.net/lists/linux-mm/msg83058.html
> 
>  mm/pagewalk.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/pagewalk.c b/mm/pagewalk.c
> index ad83195..b264bda 100644
> --- a/mm/pagewalk.c
> +++ b/mm/pagewalk.c
> @@ -199,7 +199,10 @@ int walk_page_range(unsigned long addr, unsigned long end,
>  			 */
>  			if ((vma->vm_start <= addr) &&
>  			    (vma->vm_flags & VM_PFNMAP)) {
> -				next = vma->vm_end;
> +				if (walk->pte_hole)
> +					err = walk->pte_hole(addr, next, walk);
> +				if (err)
> +					break;
>  				pgd = pgd_offset(walk->mm, next);
>  				continue;
>  			}
> -- 
> Shiraz Hashim
> 
> QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a
> member of the Code Aurora Forum, hosted by The Linux Foundation
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>