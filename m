Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbaHFVH6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 17:07:58 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:57807 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900AbaHFVH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 17:07:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Peter Griffin <peter.griffin@linaro.org>
Subject: Re: [PATCH v3 2/6] usb: host: ehci-st: Add EHCI support for ST STB devices
Date: Wed, 6 Aug 2014 23:07:18 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, stern@rowland.harvard.edu,
        srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com, lee.jones@linaro.org,
        devicetree@vger.kernel.org, linux-usb@vger.kernel.org
References: <1407344589-24863-1-git-send-email-peter.griffin@linaro.org> <1407344589-24863-3-git-send-email-peter.griffin@linaro.org>
In-Reply-To: <1407344589-24863-3-git-send-email-peter.griffin@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201408062307.18851.arnd@arndb.de>
X-Provags-ID: V02:K0:ULiVF6FZ626SPQG0K5YUMl6s+IbuK/sqFcl1cliLPk1
 iJbjQ3in5wCMpw7iKTB8DTQNSrbm+Gh5tzMw30Vj4AKhNzxUnV
 UMEfF/vvZ264Xpkb0IMFXy2zU+44NhOR/SFrNn/8MNtKmWaH70
 5/Fv5bdUiHOOr9Ug7i0bJ5F1l4j0NJPkG4IIpdAInrzK7LeyRV
 oC/lfXAvB+DLcyaWj8J8COPDcdYkdU7SrlB7x0aEYaBKG0UNJY
 hFReZAD4RwVNrVTDAAFyUWGSdtOSak0hRKJfAzOKl9jL1XXWag
 ivlOMAQGta2pACuptENzpUBH0sze6llji1ufMRsCQkhCkOHAvH
 zIZDWniMbx7Iq/fpqUeyBx27XkEREnmoOFjBEFTko
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 August 2014, Peter Griffin wrote:

> +static int st_ehci_platform_reset(struct usb_hcd *hcd)
> +{
> +	struct platform_device *pdev = to_platform_device(hcd->self.controller);
> +	struct usb_ehci_pdata *pdata = dev_get_platdata(&pdev->dev);
> +	struct ehci_hcd *ehci = hcd_to_ehci(hcd);
> +	int retval;
> +
> +	if (pdata->pre_setup) {
> +		retval = pdata->pre_setup(hcd);
> +		if (retval < 0)
> +			return retval;
> +	}

What is the point in going through a platform data function pointer here?
Can't you just open-code st_ehci_configure_bus() here?

> +static int st_ehci_platform_probe(struct platform_device *dev)
> +{
> +	struct usb_hcd *hcd;
> +	struct resource *res_mem;
> +	struct usb_ehci_pdata *pdata = dev_get_platdata(&dev->dev);
> +	struct st_platform_priv *priv;
> +	struct ehci_hcd *ehci;
> +	int err, irq, clk = 0;
> +
> +	if (usb_disabled())
> +		return -ENODEV;
> +
> +	/*
> +	 * Use reasonable defaults so platforms don't have to provide these
> +	 * with DT probing on ARM.
> +	 */
> +	if (!pdata)
> +		pdata = &ehci_platform_defaults;

How would you ever get here with pdata set?

> +	err = dma_coerce_mask_and_coherent(&dev->dev, DMA_BIT_MASK(32));
> +	if (err)
> +		return err;

Remove this here, and rely on the correct mask to be set from the DT scan.

	Arnd
