Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050AbaBDL6Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 06:58:25 -0500
Received: from smtp-out-089.synserver.de ([212.40.185.89]:1115 "EHLO
	smtp-out-089.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbaBDL6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 06:58:21 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 31909
Message-ID: <52F0D5E1.3040409@metafoo.de>
Date: Tue, 04 Feb 2014 12:58:25 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Andy Gross <agross@codeaurora.org>
CC: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        dmaengine@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [Patch v4 1/2] dmaengine: add Qualcomm BAM dma driver
References: <1391468687-4347-1-git-send-email-agross@codeaurora.org> <1391468687-4347-2-git-send-email-agross@codeaurora.org>
In-Reply-To: <1391468687-4347-2-git-send-email-agross@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2014 12:04 AM, Andy Gross wrote:
[...]
> +static int bam_dma_remove(struct platform_device *pdev)
> +{
> +	struct bam_device *bdev = platform_get_drvdata(pdev);
> +	u32 i;
> +
> +	dma_async_device_unregister(&bdev->common);
> +	of_dma_controller_free(pdev->dev.of_node);

The controller should first be removed from the of lookup table, then free 
the device.

> +
> +	/* mask all interrupts for this execution environment */
> +	writel_relaxed(0, bdev->regs + BAM_IRQ_SRCS_MSK_EE(bdev->ee));

You still need to free the interrupt to make this race free, especially on a 
multi-processor system. free_irq() acts as a synchronization point that 
makes sure that interrupt handler has finished running and that no new 
interrupt handlers are being run after this point. Just masking the 
interrupt in the control register does not provide these guarantees.

> +
> +	for (i = 0; i < bdev->num_channels; i++) {
> +		bam_dma_terminate_all(&bdev->channels[i]);
> +		tasklet_kill(&bdev->channels[i].vc.task);
> +	}
> +
> +	tasklet_kill(&bdev->task);
> +
> +	clk_disable_unprepare(bdev->bamclk);
> +
> +	return 0;
> +}
[...]

