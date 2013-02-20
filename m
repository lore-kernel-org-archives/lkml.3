Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935347Ab3BTNJn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 08:09:43 -0500
Received: from mail-qc0-f195.google.com ([209.85.216.195]:65197 "EHLO
	mail-qc0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934593Ab3BTNJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 08:09:42 -0500
X-Greylist: delayed 1088 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Feb 2013 08:09:42 EST
Message-ID: <5124C6CF.1020001@gmail.com>
Date: Wed, 20 Feb 2013 20:51:27 +0800
From: Ric Mason <ric.masonn@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: mlock: document scary-looking stack expansion mlock
 chain
References: <1359699013-7160-1-git-send-email-hannes@cmpxchg.org>
In-Reply-To: <1359699013-7160-1-git-send-email-hannes@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2013 02:10 PM, Johannes Weiner wrote:
> The fact that mlock calls get_user_pages, and get_user_pages might
> call mlock when expanding a stack looks like a potential recursion.

Why expand stack need call mlock? I can't find it in the codes, could 
you point out to me?

>
> However, mlock makes sure the requested range is already contained
> within a vma, so no stack expansion will actually happen from mlock.
>
> Should this ever change: the stack expansion mlocks only the newly
> expanded range and so will not result in recursive expansion.
>
> Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>   mm/mlock.c | 4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/mm/mlock.c b/mm/mlock.c
> index b1647fb..78c4924 100644
> --- a/mm/mlock.c
> +++ b/mm/mlock.c
> @@ -185,6 +185,10 @@ long __mlock_vma_pages_range(struct vm_area_struct *vma,
>   	if (vma->vm_flags & (VM_READ | VM_WRITE | VM_EXEC))
>   		gup_flags |= FOLL_FORCE;
>   
> +	/*
> +	 * We made sure addr is within a VMA, so the following will
> +	 * not result in a stack expansion that recurses back here.
> +	 */
>   	return __get_user_pages(current, mm, addr, nr_pages, gup_flags,
>   				NULL, NULL, nonblocking);
>   }

