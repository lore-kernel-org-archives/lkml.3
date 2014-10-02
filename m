Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111AbaJBTYt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 15:24:49 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:59317 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200AbaJBTYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 15:24:42 -0400
MIME-Version: 1.0
In-Reply-To: <1412266416-9172-1-git-send-email-piastry@etersoft.ru>
References: <1412266416-9172-1-git-send-email-piastry@etersoft.ru>
From: Steve French <smfrench@gmail.com>
Date: Thu, 2 Oct 2014 14:24:19 -0500
Message-ID: <CAH2r5mu_RbGoLRDu2yWCaFDvHnwvwbnedk+nwFVRan00x5jFjA@mail.gmail.com>
Subject: Re: [PATCH] CIFS: Fix readpages retrying on reconnects
To: Pavel Shilovsky <piastry@etersoft.ru>
Cc: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        Pavel Shilovsky <pshilovsky@samba.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Merged into cifs-2.6.git for-next (and for-linus)

I would like to get this and also
http://git.samba.org/?p=sfrench/cifs-2.6.git;a=commit;h=19e81573fca7b87ced7701e01ba164b968d929bd
upstream ASAP but timing is getting tight, will need to wait at least
a day for the normal linux-next build processes to complete and any
additional test results.

On Thu, Oct 2, 2014 at 11:13 AM, Pavel Shilovsky <piastry@etersoft.ru> wrote:
> From: Pavel Shilovsky <pshilovsky@samba.org>
>
> If we got a reconnect error from async readv we re-add pages back
> to page_list and continue loop. That is wrong because these pages
> have been already added to the pagecache but page_list has pages that
> have not been added to the pagecache yet. This ends up with a general
> protection fault in put_pages after readpages. Fix it by not retrying
> the read of these pages and falling back to readpage instead.
>
> Signed-off-by: Pavel Shilovsky <pshilovsky@samba.org>
> ---
>  fs/cifs/file.c |    8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 7c018a1..5f29354 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -3568,15 +3568,9 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
>                                 lru_cache_add_file(page);
>                                 unlock_page(page);
>                                 page_cache_release(page);
> -                               if (rc == -EAGAIN)
> -                                       list_add_tail(&page->lru, &tmplist);
>                         }
> +                       /* Fallback to the readpage in error/reconnect cases */
>                         kref_put(&rdata->refcount, cifs_readdata_release);
> -                       if (rc == -EAGAIN) {
> -                               /* Re-add pages to the page_list and retry */
> -                               list_splice(&tmplist, page_list);
> -                               continue;
> -                       }
>                         break;
>                 }
>
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
