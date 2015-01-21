Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbbAUKzW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 05:55:22 -0500
Received: from mail-yh0-f48.google.com ([209.85.213.48]:50396 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbbAUKzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 05:55:16 -0500
MIME-Version: 1.0
In-Reply-To: <1419072462-3168-9-git-send-email-prabhakar.csengg@gmail.com>
References: <1419072462-3168-1-git-send-email-prabhakar.csengg@gmail.com>
	<1419072462-3168-9-git-send-email-prabhakar.csengg@gmail.com>
Date: Wed, 21 Jan 2015 18:55:15 +0800
Message-ID: <CAHG8p1DBJd8hf86ejOVWaqdf4GpL7zAUzXoc2zsH_sEPKD8VDQ@mail.gmail.com>
Subject: Re: [PATCH 08/15] media: blackfin: bfin_capture: use vb2_ioctl_* helpers
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        adi-buildroot-devel@lists.sourceforge.net,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-12-20 18:47 GMT+08:00 Lad, Prabhakar <prabhakar.csengg@gmail.com>:
> this patch adds support to vb2_ioctl_* helpers.
>
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---
>  drivers/media/platform/blackfin/bfin_capture.c | 107 +++++--------------------
>  1 file changed, 22 insertions(+), 85 deletions(-)
>
> diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
> index 30f1fe0..80a0efc 100644
> --- a/drivers/media/platform/blackfin/bfin_capture.c
> +++ b/drivers/media/platform/blackfin/bfin_capture.c
> @@ -272,15 +272,28 @@ static int bcap_start_streaming(struct vb2_queue *vq, unsigned int count)
>         struct ppi_if *ppi = bcap_dev->ppi;
>         struct bcap_buffer *buf, *tmp;
>         struct ppi_params params;
> +       dma_addr_t addr;
>         int ret;
>
>         /* enable streamon on the sub device */
>         ret = v4l2_subdev_call(bcap_dev->sd, video, s_stream, 1);
>         if (ret && (ret != -ENOIOCTLCMD)) {
>                 v4l2_err(&bcap_dev->v4l2_dev, "stream on failed in subdev\n");
> +               bcap_dev->cur_frm = NULL;
>                 goto err;
>         }
>
> +       /* get the next frame from the dma queue */
> +       bcap_dev->cur_frm = list_entry(bcap_dev->dma_queue.next,
> +                                       struct bcap_buffer, list);
> +       /* remove buffer from the dma queue */
> +       list_del_init(&bcap_dev->cur_frm->list);
> +       addr = vb2_dma_contig_plane_dma_addr(&bcap_dev->cur_frm->vb, 0);
> +       /* update DMA address */
> +       ppi->ops->update_addr(ppi, (unsigned long)addr);
> +       /* enable ppi */
> +       ppi->ops->start(ppi);
> +

Absolutely wrong here. You can't start ppi before you set ppi params.
In fact  vb2_streamon() is called before this in bcap_streamon().
