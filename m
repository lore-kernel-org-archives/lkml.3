Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933068AbaLBM7c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 07:59:32 -0500
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:37819 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932998AbaLBM73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 07:59:29 -0500
Subject: Re: [PATCH] misc: genwqe: check for error from
 get_user_pages_fast()
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
Reply-To: haver@linux.vnet.ibm.com
To: Ian Abbott <abbotti@mev.co.uk>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Thadeu Lima De Souza Cascardo <thadeul@br.ibm.com>
In-Reply-To: <1415291019-6178-1-git-send-email-abbotti@mev.co.uk>
References: <1415291019-6178-1-git-send-email-abbotti@mev.co.uk>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Tue, 02 Dec 2014 13:59:20 +0100
Message-ID: <1417525160.2010.4.camel@oc7383187364.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120212-0017-0000-0000-0000020E921F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ian,

thanks for reviewing our code and sorry for not answering immediately.

Am Donnerstag, den 06.11.2014, 16:23 +0000 schrieb Ian Abbott:
> `genwqe_user_vmap()` calls `get_user_pages_fast()` and if the return
> value is less than the number of pages requested, it frees the pages and
> returns an error (`-EFAULT`).  However, it fails to consider a negative
> error return value from `get_user_pages_fast()`.  In that case, the test
> `if (rc < m->nr_pages)` will be false (due to promotion of `rc` to a
> large `unsigned int`) and the code will continue on to call
> `genwqe_map_pages()` with an invalid list of page pointers.  Fix it by
> bailing out if `get_user_pages_fast()` returns a negative error value.

True. Did you find this by manual inspection of the code or did you use
tools to figure it out?

> 
> Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
> Cc: <stable@vger.kernel.org> # 3.14.x # 3.15.x # 3.16.x # 3.17.x
> ---
>  drivers/misc/genwqe/card_utils.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/misc/genwqe/card_utils.c b/drivers/misc/genwqe/card_utils.c
> index 7cb3b7e..1ca94e6 100644
> --- a/drivers/misc/genwqe/card_utils.c
> +++ b/drivers/misc/genwqe/card_utils.c
> @@ -590,6 +590,8 @@ int genwqe_user_vmap(struct genwqe_dev *cd, struct dma_mapping *m, void *uaddr,
>  				 m->nr_pages,
>  				 1,		/* write by caller */
>  				 m->page_list);	/* ptrs to pages */
> +	if (rc < 0)
> +		goto fail_get_user_pages;
> 
>  	/* assumption: get_user_pages can be killed by signals. */
>  	if (rc < m->nr_pages) {

Regards

Frank

Acked-by: Frank Haverkamp <haver@linux.vnet.ibm.com>


