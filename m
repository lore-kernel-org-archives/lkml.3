Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758872Ab3IBSee (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 14:34:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5132 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756484Ab3IBSed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 14:34:33 -0400
Date: Mon, 02 Sep 2013 14:34:13 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Tony Luck <tony.luck@intel.com>,
        gong.chen@linux.intel.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Message-ID: <1378146853-8l8t62o0-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1378125224-12794-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1378125224-12794-1-git-send-email-liwanp@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/4] mm/hwpoison: fix traverse hugetlbfs page to avoid
 printk flood
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 02, 2013 at 08:33:41PM +0800, Wanpeng Li wrote:
> madvise_hwpoison won't check if the page is small page or huge page and traverse 
> in small page granularity against the range unconditional, which result in a printk 
> flood "MCE xxx: already hardware poisoned" if the page is huge page. This patch fix 
> it by increase compound_order(compound_head(page)) for huge page iterator.
> 
> Testcase:
> 
> #define _GNU_SOURCE
> #include <stdlib.h>
> #include <stdio.h>
> #include <sys/mman.h>
> #include <unistd.h>
> #include <fcntl.h>
> #include <sys/types.h>
> #include <errno.h>
> 
> #define PAGES_TO_TEST 3
> #define PAGE_SIZE	4096 * 512
> 
> int main(void)
> {
> 	char *mem;
> 	int i;
> 
> 	mem = mmap(NULL, PAGES_TO_TEST * PAGE_SIZE,
> 			PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, 0, 0);
> 
> 	if (madvise(mem, PAGES_TO_TEST * PAGE_SIZE, MADV_HWPOISON) == -1)
> 		return -1;
> 	
> 	munmap(mem, PAGES_TO_TEST * PAGE_SIZE);
> 
> 	return 0;
> }
> 
> Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>

Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

> ---
>  mm/madvise.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 6975bc8..539eeb9 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -343,10 +343,11 @@ static long madvise_remove(struct vm_area_struct *vma,
>   */
>  static int madvise_hwpoison(int bhv, unsigned long start, unsigned long end)
>  {
> +	struct page *p;
>  	if (!capable(CAP_SYS_ADMIN))
>  		return -EPERM;
> -	for (; start < end; start += PAGE_SIZE) {
> -		struct page *p;
> +	for (; start < end; start += PAGE_SIZE <<
> +				compound_order(compound_head(p))) {
>  		int ret;
>  
>  		ret = get_user_pages_fast(start, 1, 0, &p);
> -- 
> 1.8.1.2
>
