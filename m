Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237AbaLELGM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 06:06:12 -0500
Received: from mta-out1.inet.fi ([62.71.2.227]:55714 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909AbaLELGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 06:06:11 -0500
Date: Fri, 5 Dec 2014 13:05:32 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'Konstantin Khlebnikov'" <koct9i@gmail.com>,
        "'akpm@linux-foundation.org'" <akpm@linux-foundation.org>,
        "'n-horiguchi@ah.jp.nec.com'" <n-horiguchi@ah.jp.nec.com>
Subject: Re: [RFC V2] mm:add KPF_ZERO_PAGE flag for /proc/kpageflags
Message-ID: <20141205110532.GA8782@node.dhcp.inet.fi>
References: <35FD53F367049845BC99AC72306C23D103E688B313EE@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E688B313F1@CNBJMBX05.corpusers.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35FD53F367049845BC99AC72306C23D103E688B313F1@CNBJMBX05.corpusers.net>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2014 at 06:21:17PM +0800, Wang, Yalin wrote:
> This patch add KPF_ZERO_PAGE flag for zero_page,
> so that userspace process can notice zero_page from
> /proc/kpageflags, and then do memory analysis more accurately.
> 
> Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
> ---
>  fs/proc/page.c                         | 14 +++++++++++---
>  include/linux/huge_mm.h                | 12 ++++++++++++
>  include/uapi/linux/kernel-page-flags.h |  1 +
>  mm/huge_memory.c                       |  7 +------
>  4 files changed, 25 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/proc/page.c b/fs/proc/page.c
> index 1e3187d..dbe5630 100644
> --- a/fs/proc/page.c
> +++ b/fs/proc/page.c
> @@ -5,6 +5,7 @@
>  #include <linux/ksm.h>
>  #include <linux/mm.h>
>  #include <linux/mmzone.h>
> +#include <linux/huge_mm.h>
>  #include <linux/proc_fs.h>
>  #include <linux/seq_file.h>
>  #include <linux/hugetlb.h>
> @@ -121,9 +122,16 @@ u64 stable_page_flags(struct page *page)
>  	 * just checks PG_head/PG_tail, so we need to check PageLRU/PageAnon
>  	 * to make sure a given page is a thp, not a non-huge compound page.
>  	 */
> -	else if (PageTransCompound(page) && (PageLRU(compound_head(page)) ||
> -					     PageAnon(compound_head(page))))
> -		u |= 1 << KPF_THP;
> +	else if (PageTransCompound(page)) {
> +		struct page *head = compound_head(page);
> +
> +		if (PageLRU(head) || PageAnon(head))
> +			u |= 1 << KPF_THP;
> +		else if (is_huge_zero_page(head))
> +			u |= 1 << KPF_ZERO_PAGE;

IIUC, KPF_THP bit should be set for huge zero page too.

-- 
 Kirill A. Shutemov
