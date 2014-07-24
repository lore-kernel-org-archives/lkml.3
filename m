Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758187AbaGXLQG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 07:16:06 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:62139 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbaGXLQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 07:16:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Peter Griffin <peter.griffin@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@st.com, patrice.chotard@st.com,
        gregkh@linuxfoundation.org, srinivas.kandagatla@gmail.com,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        lee.jones@linaro.org
Subject: Re: [PATCH v2 1/3] usb: host: st-hcd: Add USB HCD support for STi SoCs
Date: Thu, 24 Jul 2014 13:14 +0200
Message-ID: <11018717.Ey5qEJxGNJ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1406199616-10533-2-git-send-email-peter.griffin@linaro.org>
References: <1406199616-10533-1-git-send-email-peter.griffin@linaro.org> <1406199616-10533-2-git-send-email-peter.griffin@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:9B/YJtIOXdMLrV9C52DpyZN+Auws9SocDXcRtthZWAm
 B63t1MY10jL+neA17iiaXrULcUar6XfD9LVGaE7aIRzXN+uiYh
 CsunAOZHqvVQrJgyqqoT6um5C+laAIyeKlsph4JNIFdBR2hAsr
 8y/O1kizDXslE8JCxtaaiEZWYehnQq+DEfY5Sc3li4yQJ1bcgg
 v7EKQyTtfDbcolkDYN8yCQmjuN7O0fiTD0Gs55ph7n67pWZJKb
 YW0/6s6LixxzhKFCcAdCSrsIzCsKjPCJkBBAEcyIKLYdMZ2Nj9
 D5DRCQ6UBv7Jm6VnQSeFkYcHy6gpqmL7foEF04P9eNSRe+twtL
 iKjRyELVydT95jAJVg1U=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 July 2014 12:00:14 Peter Griffin wrote:
> This driver adds support for the USB HCD present in STi
> SoC's from STMicroelectronics. It has been tested on the
> stih416-b2020 board.

Unfortunately, this seems to be done in a rather strange way,
I suspect you'll have to start over, but I'll let Alan and Greg
weigh in.

> +
> +struct st_hcd_dev {
> +	int port_nr;
> +	struct platform_device *ehci_device;
> +	struct platform_device *ohci_device;
> +	struct clk *ic_clk;
> +	struct clk *ohci_clk;
> +	struct reset_control *pwr;
> +	struct reset_control *rst;
> +	struct phy *phy;
> +};

The way you do this apparently is to create a device that encapsulates
the OHCI and the EHCI and then goes on to create child devices that
are bound to the real drivers.

The way it should be done however is to put the two host controllers
into DT directly and describe their resources (phy, clock, reset, ...)
using the DT bindings for those.

Depending on what kind of special requirements the ST version has,
this can be done either by using the generic ohci/ehci bindings
with extensions where necessary, or by creating a new binding and
new driver files that use 'ohci_init_driver'/'ehci_init_driver'
to inherit from the common code.

The first of the two approaches is preferred.

> +	pdev->dev.parent = &parent->dev;
> +	pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
> +	pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);

This is something we shouldn't ever do these days, the DMA settings
should come directly from DT without driver interaction.

	Arnd
