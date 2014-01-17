Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbaAQTlR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 14:41:17 -0500
Received: from mail-ig0-f178.google.com ([209.85.213.178]:65080 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592AbaAQTlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 14:41:10 -0500
MIME-Version: 1.0
In-Reply-To: <1c441f670f33375b6c41e074baf6e84e6c7bb0c2.1389904166.git.agordeev@redhat.com>
References: <cover.1389904166.git.agordeev@redhat.com> <1c441f670f33375b6c41e074baf6e84e6c7bb0c2.1389904166.git.agordeev@redhat.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 17 Jan 2014 12:40:50 -0700
Message-ID: <CAErSpo4g_xm4vZWZDgyjtJu+z5ARSerQLrtJ6W_peXv4bKwcgg@mail.gmail.com>
Subject: Re: [PATCH v2 5/9] nvme: Fix invalid call to irq_set_affinity_hint()
To: Alexander Gordeev <agordeev@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <willy@linux.intel.com>, linux-nvme@lists.infradead.org,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 9:02 AM, Alexander Gordeev <agordeev@redhat.com> wrote:
> In case MSI-X and MSI initialization failed the function
> irq_set_affinity_hint() is called with uninitialized value
> in dev->entry[0].vector. This update fixes the issue.

dev->entry[0].vector is initialized in nvme_dev_map(), and it's used
for free_irq() above the area of your patch, so I don't think this is
actually a bug, though it might be somewhat confusing.

> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> ---
>  drivers/block/nvme-core.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
> index 26d03fa..e292450 100644
> --- a/drivers/block/nvme-core.c
> +++ b/drivers/block/nvme-core.c
> @@ -1790,15 +1790,15 @@ static int nvme_setup_io_queues(struct nvme_dev *dev)
>                         vecs = 32;
>                 for (;;) {
>                         result = pci_enable_msi_block(pdev, vecs);
> -                       if (result == 0) {
> -                               for (i = 0; i < vecs; i++)
> -                                       dev->entry[i].vector = i + pdev->irq;
> -                               break;
> +                       if (result > 0) {
> +                               vecs = result;
> +                               continue;
>                         } else if (result < 0) {
>                                 vecs = 1;
> -                               break;
>                         }
> -                       vecs = result;
> +                       for (i = 0; i < vecs; i++)
> +                               dev->entry[i].vector = i + pdev->irq;
> +                       break;
>                 }
>         }
>
> --
> 1.7.7.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
