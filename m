Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab3I0UrB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 16:47:01 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:56620 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab3I0Uq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 16:46:57 -0400
Message-ID: <5245EEAD.7010901@linux.vnet.ibm.com>
Date: Fri, 27 Sep 2013 13:46:37 -0700
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Alex Thorlton <athorlton@sgi.com>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
CC: "Eric W . Biederman" <ebiederm@xmission.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>, Dave Jones <davej@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Kees Cook <keescook@chromium.org>, Mel Gorman <mgorman@suse.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Rik van Riel <riel@redhat.com>, Robin Holt <robinmholt@gmail.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCHv4 02/10] mm: convert mm->nr_ptes to atomic_t
References: <1380287787-30252-1-git-send-email-kirill.shutemov@linux.intel.com> <1380287787-30252-3-git-send-email-kirill.shutemov@linux.intel.com>
In-Reply-To: <1380287787-30252-3-git-send-email-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092720-0928-0000-0000-000001F1F4AC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2013 06:16 AM, Kirill A. Shutemov wrote:
> With split page table lock for PMD level we can't hold
> mm->page_table_lock while updating nr_ptes.
>
> Let's convert it to atomic_t to avoid races.
>

> ---

> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 84e0c56e1e..99f19e850d 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -339,6 +339,7 @@ struct mm_struct {
>   	pgd_t * pgd;
>   	atomic_t mm_users;			/* How many users with user space? */
>   	atomic_t mm_count;			/* How many references to "struct mm_struct" (users count as 1) */
> +	atomic_t nr_ptes;			/* Page table pages */
>   	int map_count;				/* number of VMAs */
>
>   	spinlock_t page_table_lock;		/* Protects page tables and some counters */
> @@ -360,7 +361,6 @@ struct mm_struct {
>   	unsigned long exec_vm;		/* VM_EXEC & ~VM_WRITE */
>   	unsigned long stack_vm;		/* VM_GROWSUP/DOWN */
>   	unsigned long def_flags;
> -	unsigned long nr_ptes;		/* Page table pages */
>   	unsigned long start_code, end_code, start_data, end_data;
>   	unsigned long start_brk, brk, start_stack;
>   	unsigned long arg_start, arg_end, env_start, env_end;

Will 32bits always be enough here? Should atomic_long_t be used instead?

