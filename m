Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992AbaBDTYa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 14:24:30 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:38524 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165AbaBDTY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 14:24:28 -0500
Date: Tue, 4 Feb 2014 13:24:26 -0600
From: Andy Gross <agross@codeaurora.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        dmaengine@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [Patch v4 1/2] dmaengine: add Qualcomm BAM dma driver
Message-ID: <20140204192426.GA16943@qualcomm.com>
References: <1391468687-4347-1-git-send-email-agross@codeaurora.org>
 <1391468687-4347-2-git-send-email-agross@codeaurora.org>
 <52F0D5E1.3040409@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F0D5E1.3040409@metafoo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 04, 2014 at 12:58:25PM +0100, Lars-Peter Clausen wrote:
> On 02/04/2014 12:04 AM, Andy Gross wrote:
> [...]
> >+static int bam_dma_remove(struct platform_device *pdev)
> >+{
> >+	struct bam_device *bdev = platform_get_drvdata(pdev);
> >+	u32 i;
> >+
> >+	dma_async_device_unregister(&bdev->common);
> >+	of_dma_controller_free(pdev->dev.of_node);
> 
> The controller should first be removed from the of lookup table,
> then free the device.
> 
Ah right, had this reversed.

> >+
> >+	/* mask all interrupts for this execution environment */
> >+	writel_relaxed(0, bdev->regs + BAM_IRQ_SRCS_MSK_EE(bdev->ee));
> 
> You still need to free the interrupt to make this race free,
> especially on a multi-processor system. free_irq() acts as a
> synchronization point that makes sure that interrupt handler has
> finished running and that no new interrupt handlers are being run
> after this point. Just masking the interrupt in the control register
> does not provide these guarantees.

ok i'll just add in a devm_free_irq().  The only good thing then about using the
devm_request_irq is the cleanup on error paths in the probe.

> >+
> >+	for (i = 0; i < bdev->num_channels; i++) {
> >+		bam_dma_terminate_all(&bdev->channels[i]);
> >+		tasklet_kill(&bdev->channels[i].vc.task);
> >+	}
> >+
> >+	tasklet_kill(&bdev->task);
> >+
> >+	clk_disable_unprepare(bdev->bamclk);
> >+
> >+	return 0;
> >+}
> [...]
> 

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
