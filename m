Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852AbbAUX0j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 18:26:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35215 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752578AbbAUX0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 18:26:32 -0500
Message-ID: <1421882779.6130.454.camel@redhat.com>
Subject: Re: [PATCH v12 10/18] vfio/platform: trigger an interrupt via
 eventfd
From: Alex Williamson <alex.williamson@redhat.com>
To: Baptiste Reynal <b.reynal@virtualopensystems.com>
Cc: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-fundation.org,
        will.deacon@arm.com, tech@virtualopensystems.com,
        christoffer.dall@linaro.org, eric.auger@linaro.org,
        kim.phillips@freescale.com, marc.zyngier@arm.com,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        "open list:VFIO DRIVER" <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Date: Wed, 21 Jan 2015 16:26:19 -0700
In-Reply-To: <1421844606-24751-11-git-send-email-b.reynal@virtualopensystems.com>
References: <1421844606-24751-1-git-send-email-b.reynal@virtualopensystems.com>
	 <1421844606-24751-11-git-send-email-b.reynal@virtualopensystems.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2015-01-21 at 13:49 +0100, Baptiste Reynal wrote:
> From: Antonios Motakis <a.motakis@virtualopensystems.com>
> 
> This patch allows to set an eventfd for a platform device's interrupt,
> and also to trigger the interrupt eventfd from userspace for testing.
> Level sensitive interrupts are marked as maskable and are handled in
> a later patch. Edge triggered interrupts are not advertised as maskable
> and are implemented here using a simple and efficient IRQ handler.
> 
> Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
> [Baptiste Reynal: fix masked interrupt initialization]
> Signed-off-by: Baptiste Reynal <b.reynal@virtualopensystems.com>
> ---
>  drivers/vfio/platform/vfio_platform_irq.c     | 98 ++++++++++++++++++++++++++-
>  drivers/vfio/platform/vfio_platform_private.h |  2 +
>  2 files changed, 98 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
> index df5c919..4b1ee22 100644
> --- a/drivers/vfio/platform/vfio_platform_irq.c
> +++ b/drivers/vfio/platform/vfio_platform_irq.c
> @@ -39,12 +39,96 @@ static int vfio_platform_set_irq_unmask(struct vfio_platform_device *vdev,
>  	return -EINVAL;
>  }
>  
> +static irqreturn_t vfio_irq_handler(int irq, void *dev_id)
> +{
> +	struct vfio_platform_irq *irq_ctx = dev_id;
> +
> +	eventfd_signal(irq_ctx->trigger, 1);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int vfio_set_trigger(struct vfio_platform_device *vdev, int index,
> +			    int fd, irq_handler_t handler)
> +{
> +	struct vfio_platform_irq *irq = &vdev->irqs[index];
> +	struct eventfd_ctx *trigger;
> +	int ret;
> +
> +	if (irq->trigger) {
> +		free_irq(irq->hwirq, irq);
> +		kfree(irq->name);
> +		eventfd_ctx_put(irq->trigger);
> +		irq->trigger = NULL;
> +	}
> +
> +	if (fd < 0) /* Disable only */
> +		return 0;
> +
> +	irq->name = kasprintf(GFP_KERNEL, "vfio-irq[%d](%s)",
> +						irq->hwirq, vdev->name);
> +	if (!irq->name)
> +		return -ENOMEM;
> +
> +	trigger = eventfd_ctx_fdget(fd);
> +	if (IS_ERR(trigger)) {
> +		kfree(irq->name);
> +		return PTR_ERR(trigger);
> +	}
> +
> +	irq->trigger = trigger;
> +
> +	irq_set_status_flags(irq->hwirq, IRQ_NOAUTOEN);
> +	ret = request_irq(irq->hwirq, handler, 0, irq->name, irq);
> +	if (ret) {
> +		kfree(irq->name);
> +		eventfd_ctx_put(trigger);
> +		irq->trigger = NULL;
> +		return ret;
> +	}
> +
> +	if (!irq->masked)
> +		enable_irq(irq->hwirq);

Unfortunately, irq->masked doesn't exist until the next patch.  Thanks,

Alex

