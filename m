Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116Ab3LFRU5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 12:20:57 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:41129 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120Ab3LFRUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 12:20:55 -0500
MIME-Version: 1.0
In-Reply-To: <1386344529-25617-1-git-send-email-jonas.jensen@gmail.com>
References: <1386344529-25617-1-git-send-email-jonas.jensen@gmail.com>
Date: Fri, 6 Dec 2013 09:20:53 -0800
Message-ID: <CAPcyv4iBg_=UxGOffXhwQROPB6CjcPhVzckff8K9=eZLpwBYbw@mail.gmail.com>
Subject: Re: [PATCH] dma: fix vchan_cookie_complete() debug print
From: Dan Williams <dan.j.williams@intel.com>
To: Jonas Jensen <jonas.jensen@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        arm@kernel.org, Vinod Koul <vinod.koul@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 6, 2013 at 7:42 AM, Jonas Jensen <jonas.jensen@gmail.com> wrote:
> vd->tx.cookie is set zero on dma_cookie_complete(),
> save to local before printing it.
>
> Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
> ---
>
> Notes:
>     dev_vdbg() could also be moved to happen earlier, what do you prefer?
>
>     Applies to next-20131206
>
>  drivers/dma/virt-dma.h | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/dma/virt-dma.h b/drivers/dma/virt-dma.h
> index 85c19d6..181b9526 100644
> --- a/drivers/dma/virt-dma.h
> +++ b/drivers/dma/virt-dma.h
> @@ -84,10 +84,12 @@ static inline bool vchan_issue_pending(struct virt_dma_chan *vc)
>  static inline void vchan_cookie_complete(struct virt_dma_desc *vd)
>  {
>         struct virt_dma_chan *vc = to_virt_chan(vd->tx.chan);
> +       dma_cookie_t cookie;
>
> +       cookie = vd->tx.cookie;
>         dma_cookie_complete(&vd->tx);
>         dev_vdbg(vc->chan.device->dev, "txd %p[%x]: marked complete\n",
> -               vd, vd->tx.cookie);
> +                vd, cookie);
>         list_add_tail(&vd->node, &vc->desc_completed);


This is a bit smaller:

diff --git a/drivers/dma/virt-dma.h b/drivers/dma/virt-dma.h
index 85c19d63f9fb..7d6f611c7654 100644
--- a/drivers/dma/virt-dma.h
+++ b/drivers/dma/virt-dma.h
@@ -85,9 +85,9 @@ static inline void vchan_cookie_complete(struct
virt_dma_desc *vd)
 {
        struct virt_dma_chan *vc = to_virt_chan(vd->tx.chan);

-       dma_cookie_complete(&vd->tx);
        dev_vdbg(vc->chan.device->dev, "txd %p[%x]: marked complete\n",
                vd, vd->tx.cookie);
+       dma_cookie_complete(&vd->tx);
        list_add_tail(&vd->node, &vc->desc_completed);
