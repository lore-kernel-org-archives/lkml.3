Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785AbaJVFmv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 01:42:51 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:37833 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbaJVFmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 01:42:50 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-47-544743d7fa89
Message-id: <544743D6.6040103@samsung.com>
Date: Wed, 22 Oct 2014 09:42:46 +0400
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>, akpm@linux-foundation.org
Cc: n-horiguchi@ah.jp.nec.com, aarcange@redhat.com, mgorman@suse.de,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm, hugetlb: correct bit shift in hstate_sizelog
References: <1413915307-20536-1-git-send-email-sasha.levin@oracle.com>
In-reply-to: <1413915307-20536-1-git-send-email-sasha.levin@oracle.com>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsVy+t/xa7rXnd1DDM58UrVYsH4pu8Wc9WvY
	LC7vmsNmcW/Nf1aLye+eMVp8WHuKxWLxkdvMDuweLxZuYfbY9GkSu8eJGb9ZPD4+vcXi8X7f
	VTaPzaerPT5vkgtgj+KySUnNySxLLdK3S+DK+Pr0DUvBN/aKlY/vsjYwbmfrYuTkkBAwkZj4
	6TELhC0mceHeeqA4F4eQwFJGiZP7ljNCOM1MEuu3rmMEqeIV0JL4v3sXK4jNIqAqsWvaIyYQ
	m01AT+LfLIipogIRElfWzIGqF5T4Mfke2AYRAWeJQ1t/MYPYzALlEv/fHwSzhQVcJS62fASz
	hQTcJPZ3rQbr5RRwl5h+/R3QTA6genWJKVNyIVrlJTavecs8gVFgFpINsxCqZiGpWsDIvIpR
	NLU0uaA4KT3XUK84Mbe4NC9dLzk/dxMjJOi/7GBcfMzqEKMAB6MSD+8MDvcQIdbEsuLK3EOM
	EhzMSiK8fRZAId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYyd3cae5g2tU3w3zmROkbspn12eeeCh
	q1fjtIkOW9/qfdS99bX28vHVrSkTg7l3fPd8ekqdM/f5FtYdmQE+XAfPpH6tlrU5qchqkCha
	7bP3aLTHxvc39f9yltp33p9qIXA9K3nXk5sdLYpFwWUlc27+bLuhfe5DrrVBa/r2aVs23gj3
	1C4+eEOJpTgj0VCLuag4EQDJJfVjWAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2014 10:15 PM, Sasha Levin wrote:
> hstate_sizelog() would shift left an int rather than long, triggering
> undefined behaviour and passing an incorrect value when the requested
> page size was more than 4GB, thus breaking >4GB pages.

> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> ---
>  include/linux/hugetlb.h |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 65e12a2..57e0dfd 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -312,7 +312,8 @@ static inline struct hstate *hstate_sizelog(int page_size_log)
>  {
>  	if (!page_size_log)
>  		return &default_hstate;
> -	return size_to_hstate(1 << page_size_log);
> +
> +	return size_to_hstate(1UL << page_size_log);

That still could be undefined on 32-bits. Either use 1ULL or reduce SHM_HUGE_MASK on 32bits.


>  }
>  
>  static inline struct hstate *hstate_vma(struct vm_area_struct *vma)
> 

