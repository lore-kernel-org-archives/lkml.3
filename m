Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752Ab3JBQbz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 12:31:55 -0400
Received: from mail-yh0-f44.google.com ([209.85.213.44]:37367 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339Ab3JBQby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 12:31:54 -0400
Message-ID: <524C4AA1.7000409@gmail.com>
Date: Wed, 02 Oct 2013 12:32:33 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        kosaki.motohiro@gmail.com
Subject: Re: [PATCH 18/26] mm: Convert process_vm_rw_pages() to use get_user_pages_unlocked()
References: <1380724087-13927-1-git-send-email-jack@suse.cz> <1380724087-13927-19-git-send-email-jack@suse.cz>
In-Reply-To: <1380724087-13927-19-git-send-email-jack@suse.cz>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(10/2/13 10:27 AM), Jan Kara wrote:
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>   mm/process_vm_access.c | 8 ++------
>   1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/process_vm_access.c b/mm/process_vm_access.c
> index fd26d0433509..c1bc47d8ed90 100644
> --- a/mm/process_vm_access.c
> +++ b/mm/process_vm_access.c
> @@ -64,12 +64,8 @@ static int process_vm_rw_pages(struct task_struct *task,
>   	*bytes_copied = 0;
>   
>   	/* Get the pages we're interested in */
> -	down_read(&mm->mmap_sem);
> -	pages_pinned = get_user_pages(task, mm, pa,
> -				      nr_pages_to_copy,
> -				      vm_write, 0, process_pages, NULL);
> -	up_read(&mm->mmap_sem);
> -
> +	pages_pinned = get_user_pages_unlocked(task, mm, pa, nr_pages_to_copy,
> +					       vm_write, 0, process_pages);
>   	if (pages_pinned != nr_pages_to_copy) {
>   		rc = -EFAULT;
>   		goto end;

This is wrong because original code is wrong. In this function, page may be pointed to 
anon pages. Then, you should keep to take mmap_sem until finish to copying. Otherwise
concurrent fork() makes nasty COW issue.


