Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112AbaKCKf0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 05:35:26 -0500
Received: from outbound-smtp01.blacknight.com ([81.17.249.7]:53049 "EHLO
	outbound-smtp01.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752076AbaKCKfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 05:35:22 -0500
Message-ID: <54575A68.7060009@nexus-software.ie>
Date: Mon, 03 Nov 2014 10:35:20 +0000
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Raymond Tan <raymond.tan@intel.com>, Lee Jones <lee.jones@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>
CC: linux-kernel@vger.kernel.org, Alvin Chen <alvin.chen@intel.com>,
        Andriy Shevchenko <andriy.shevchenko@intel.com>
Subject: Re: [PATCH 1/1] mfd: intel_quark_i2c_gpio: Add Intel Quark X1000
 I2C-GPIO MFD Driver
References: <1415000344-23575-1-git-send-email-raymond.tan@intel.com> <1415000344-23575-2-git-send-email-raymond.tan@intel.com>
In-Reply-To: <1415000344-23575-2-git-send-email-raymond.tan@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/14 07:39, Raymond Tan wrote:
> +	pdata->properties->irq	= pdev->irq;
> +	pdata->properties->irq_shared	= true;

OK I see it.

Thanks.

My question is. How extensively have edge triggered interrupts been 
tested on the GPIO block ?

The BSP reference code is quite explicit about not missing edge interrupts.

Have you tested GPIO input in edge mode ?

+irqreturn_t intel_qrk_gpio_isr(int irq, void *dev_id)
+{
+	irqreturn_t ret = IRQ_NONE;
+	u32 pending = 0, gpio = 0;
+	void __iomem *reg_pending = reg_base + PORTA_INT_STATUS;
+	void __iomem *reg_eoi = reg_base + PORTA_INT_EOI;
+
+	/* Which pin (if any) triggered the interrupt */
+	while ((pending = ioread32(reg_pending))) {
+		/*
+		 * Acknowledge all the asserted GPIO interrupt lines before
+		 * serving them, so that we don't lose an edge.
+		 * This has only effect on edge-triggered interrupts.
+		 */
+		iowrite32(pending, reg_eoi);
+
+		/* Serve each asserted interrupt */
+		do {
+			gpio = __ffs(pending);
+			generic_handle_irq(
+				gpio_to_irq(INTEL_QRK_GIP_GPIO_BASE + gpio));
+			pending &= ~BIT(gpio);
+			ret = IRQ_HANDLED;
+		} while(pending);
+	}
+
+	return ret;
+}

