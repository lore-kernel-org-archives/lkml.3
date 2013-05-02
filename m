Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568Ab3EBPF2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 11:05:28 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:55003 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703Ab3EBPF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 11:05:27 -0400
MIME-Version: 1.0
X-Originating-IP: [188.6.195.195]
In-Reply-To: <51525328.2070407@gmail.com>
References: <51525328.2070407@gmail.com>
Date: Thu, 2 May 2013 17:05:25 +0200
Message-ID: <CAJfpegvYY_fUMOA_CE1vg849Jga_iSvaswVs2Fb6EUJPH2f0uw@mail.gmail.com>
Subject: Re: [PATCH] fuse: Consider the ->big_writes for allocing fuse_req
 when do writing
From: Miklos Szeredi <miklos@szeredi.hu>
To: majianpeng <majianpeng@gmail.com>
Cc: fuse-devel <fuse-devel@lists.sourceforge.net>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 3:02 AM, majianpeng <majianpeng@gmail.com> wrote:
> If fc->big_writes == 0, for write-operation it only do 4k in func fuse_fill_write_pages.
> So when alloc fuse_req,we should consider this restrict in order to
> do additional operations.
> The additional operations are memset-opeartion in func fuse_requenst_alloc and alloc more space if nr_pages is larger than FUSE_REQ_MIN_PAGES.

Your mailer is removing whitespace from the patch.   Anyway, I applied
it by hand, thanks.

Miklos

>
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
> fs/fuse/file.c | 7 ++++++-
> 1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index 34b80ba..c584a31 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -912,8 +912,13 @@ static ssize_t fuse_perform_write(struct file *file,
> do {
> struct fuse_req *req;
> ssize_t count;
> - unsigned nr_pages = fuse_wr_pages(pos, iov_iter_count(ii));
> + unsigned nr_pages;
>
> + if (!fc->big_writes)
> + nr_pages = 1;
> + else
> + nr_pages = fuse_wr_pages(pos, iov_iter_count(ii));
> +
> req = fuse_get_req(fc, nr_pages);
> if (IS_ERR(req)) {
> err = PTR_ERR(req);
> --
> 1.8.2.rc2.4.g7799588
>
