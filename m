Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935816Ab3DHTil (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 15:38:41 -0400
Received: from www.sr71.net ([198.145.64.142]:43651 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935727Ab3DHTik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 15:38:40 -0400
Message-ID: <51631CC0.5010908@sr71.net>
Date: Mon, 08 Apr 2013 12:38:40 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3, RFC 09/34] thp: represent file thp pages in meminfo
 and friends
References: <1365163198-29726-1-git-send-email-kirill.shutemov@linux.intel.com> <1365163198-29726-10-git-send-email-kirill.shutemov@linux.intel.com>
In-Reply-To: <1365163198-29726-10-git-send-email-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2013 04:59 AM, Kirill A. Shutemov wrote:
> The patch adds new zone stat to count file transparent huge pages and
> adjust related places.
> 
> For now we don't count mapped or dirty file thp pages separately.

I can understand tracking NR_FILE_TRANSPARENT_HUGEPAGES itself.  But,
why not also account for them in NR_FILE_PAGES?  That way, you don't
have to special-case each of the cases below:

> --- a/fs/proc/meminfo.c
> +++ b/fs/proc/meminfo.c
> @@ -41,6 +41,9 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
>  
>  	cached = global_page_state(NR_FILE_PAGES) -
>  			total_swapcache_pages() - i.bufferram;
> +	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
> +		cached += global_page_state(NR_FILE_TRANSPARENT_HUGEPAGES) *
> +			HPAGE_PMD_NR;
>  	if (cached < 0)
>  		cached = 0;
....
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -135,6 +135,9 @@ int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin)
>  	if (sysctl_overcommit_memory == OVERCOMMIT_GUESS) {
>  		free = global_page_state(NR_FREE_PAGES);
>  		free += global_page_state(NR_FILE_PAGES);
> +		if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
> +			free += global_page_state(NR_FILE_TRANSPARENT_HUGEPAGES)
> +				* HPAGE_PMD_NR;
...
> -	printk("%ld total pagecache pages\n", global_page_state(NR_FILE_PAGES));
> +	cached = global_page_state(NR_FILE_PAGES);
> +	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
> +		cached += global_page_state(NR_FILE_TRANSPARENT_HUGEPAGES) *
> +			HPAGE_PMD_NR;
> +	printk("%ld total pagecache pages\n", cached);

