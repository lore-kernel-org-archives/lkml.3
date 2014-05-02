Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbaEBTza (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 15:55:30 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:34707 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbaEBTz2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 15:55:28 -0400
Date: Fri, 2 May 2014 15:55:25 -0400
From: Jeff Layton <jlayton@poochiereds.net>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] cifs: Use min_t() when comparing "size_t" and
 "unsigned long"
Message-ID: <20140502155525.02dde4de@tlielax.poochiereds.net>
In-Reply-To: <1397414783-28098-1-git-send-email-geert@linux-m68k.org>
References: <1397414783-28098-1-git-send-email-geert@linux-m68k.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Apr 2014 20:46:21 +0200
Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> On 32 bit, size_t is "unsigned int", not "unsigned long", causing the
> following warning when comparing with PAGE_SIZE, which is always "unsigned
> long":
> 
> fs/cifs/file.c: In function ‘cifs_readdata_to_iov’:
> fs/cifs/file.c:2757: warning: comparison of distinct pointer types lacks a cast
> 
> Introduced by commit 7f25bba819a38ab7310024a9350655f374707e20
> ("cifs_iovec_read: keep iov_iter between the calls of
> cifs_readdata_to_iov()"), which changed the signedness of "remaining"
> and the code from min_t() to min().
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
> PAGE_SIZE should really be size_t, but that would require lots of changes
> all over the place.
> 
>  fs/cifs/file.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 8807442c94dd..8add25538a3b 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -2754,7 +2754,7 @@ cifs_readdata_to_iov(struct cifs_readdata *rdata, struct iov_iter *iter)
>  
>  	for (i = 0; i < rdata->nr_pages; i++) {
>  		struct page *page = rdata->pages[i];
> -		size_t copy = min(remaining, PAGE_SIZE);
> +		size_t copy = min_t(size_t, remaining, PAGE_SIZE);
>  		size_t written = copy_page_to_iter(page, 0, copy, iter);
>  		remaining -= written;
>  		if (written < copy && iov_iter_count(iter) > 0)

Reviewed-by: Jeff Layton <jlayton@poochiereds.net>
