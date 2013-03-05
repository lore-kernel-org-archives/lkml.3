Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849Ab3CEXqg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 18:46:36 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:58867 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888Ab3CEXqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 18:46:35 -0500
Message-ID: <513683D5.1080401@gmail.com>
Date: Wed, 06 Mar 2013 07:46:29 +0800
From: Simon Jeons <simon.jeons@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Andrew Shewmaker <agshew@gmail.com>
CC: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
        ric.masonn@gmail.com
Subject: Re: [PATCH v4 001/002] mm: limit growth of 3% hardcoded other user
 reserve
References: <20130305233811.GA1948@localhost.localdomain>
In-Reply-To: <20130305233811.GA1948@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2013 07:38 AM, Andrew Shewmaker wrote:
> Limit the growth of the memory reserved for other processes
> to the smaller of 3% or 8MB.
>
> This affects only OVERCOMMIT_NEVER.
>
> Signed-off-by: Andrew Shewmaker <agshew@gmail.com>

Please add changelog, otherwise it's for other guys to review.

>
> ---
>
> Rebased onto v3.8-mmotm-2013-03-01-15-50
>
> No longer assumes 4kb pages.
> Code duplicated for nommu.
>
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 49dc7d5..4eb2b1a 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -184,9 +184,11 @@ int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin)
>   	allowed += total_swap_pages;
>   
>   	/* Don't let a single process grow too big:
> -	   leave 3% of the size of this process for other processes */
> +	 * leave the smaller of 3% of the size of this process
> +         * or 8MB for other processes
> +         */
>   	if (mm)
> -		allowed -= mm->total_vm / 32;
> +		allowed -= min(mm->total_vm / 32, 1 << (23 - PAGE_SHIFT));
>   
>   	if (percpu_counter_read_positive(&vm_committed_as) < allowed)
>   		return 0;
> diff --git a/mm/nommu.c b/mm/nommu.c
> index f5d57a3..a93d214 100644
> --- a/mm/nommu.c
> +++ b/mm/nommu.c
> @@ -1945,9 +1945,11 @@ int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin)
>   	allowed += total_swap_pages;
>   
>   	/* Don't let a single process grow too big:
> -	   leave 3% of the size of this process for other processes */
> +	 * leave the smaller of 3% of the size of this process
> +         * or 8MB for other processes
> +         */
>   	if (mm)
> -		allowed -= mm->total_vm / 32;
> +		allowed -= min(mm->total_vm / 32, 1 << (23 - PAGE_SHIFT));
>   
>   	if (percpu_counter_read_positive(&vm_committed_as) < allowed)
>   		return 0;

