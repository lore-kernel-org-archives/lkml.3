Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359Ab3JBQ1h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 12:27:37 -0400
Received: from mail-yh0-f53.google.com ([209.85.213.53]:46674 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461Ab3JBQ1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 12:27:34 -0400
Message-ID: <524C499B.9090707@gmail.com>
Date: Wed, 02 Oct 2013 12:28:11 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        kosaki.motohiro@gmail.com
Subject: Re: [PATCH 16/26] mm: Provide get_user_pages_unlocked()
References: <1380724087-13927-1-git-send-email-jack@suse.cz> <1380724087-13927-17-git-send-email-jack@suse.cz>
In-Reply-To: <1380724087-13927-17-git-send-email-jack@suse.cz>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(10/2/13 10:27 AM), Jan Kara wrote:
> Provide a wrapper for get_user_pages() which takes care of acquiring and
> releasing mmap_sem. Using this function reduces amount of places in
> which we deal with mmap_sem.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>   include/linux/mm.h | 14 ++++++++++++++
>   1 file changed, 14 insertions(+)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 8b6e55ee8855..70031ead06a5 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1031,6 +1031,20 @@ long get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
>   		    struct vm_area_struct **vmas);
>   int get_user_pages_fast(unsigned long start, int nr_pages, int write,
>   			struct page **pages);
> +static inline long
> +get_user_pages_unlocked(struct task_struct *tsk, struct mm_struct *mm,
> +		 	unsigned long start, unsigned long nr_pages,
> +			int write, int force, struct page **pages)
> +{
> +	long ret;
> +
> +	down_read(&mm->mmap_sem);
> +	ret = get_user_pages(tsk, mm, start, nr_pages, write, force, pages,
> +			     NULL);
> +	up_read(&mm->mmap_sem);
> +	return ret;
> +}

Hmmm. I like the idea, but I really dislike this name. I don't like xx_unlocked 
function takes a lock. It is a source of confusing, I believe. 







