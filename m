Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227AbaEOIRb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 04:17:31 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:52093 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958AbaEOIR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 04:17:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andrew Bresticker <abrestic@chromium.org>
Cc: linux-tegra@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [RFC PATCH 06/10] usb: xhci: Add Tegra XHCI host-controller driver
Date: Thu, 15 May 2014 10:17:10 +0200
Message-ID: <15599140.PsD4j7x3tZ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1400113986-339-7-git-send-email-abrestic@chromium.org>
References: <1400113986-339-1-git-send-email-abrestic@chromium.org> <1400113986-339-7-git-send-email-abrestic@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:4hGzi4IboSq1M2MfFZgNoy46OpzgF4+xbYeDCFB4a1r
 ELytutQVjPrkI+PdQdJagMrCEG1lcJkvIz1iiBMqzJeEorh6LX
 AIadqNbKx2TC03YnCj5groKYZHIM7zISrCnGE6gmlYxDo1YTD1
 5k/ECNc7EkYq5946BRBMHcDK5xpt9NNPK12orm7/XCBRT/6sAr
 RVo6A3jZ2pjosShFyUDaoZnwsTTUpnJt9YTv4FSvd6X3B99ruX
 6LlAJHm9OuUAha9sB/fXvhAt0dY5Ig+R8forrrEEjBlqwKIYOT
 sMeL/uZd2yUXwl3RXNWdiP3fwah0j3On83bURiEQ+ppTL6C7JV
 abrD5aLA42ru+pIwfYZU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 May 2014 17:33:02 Andrew Bresticker wrote:
> +
> +int tegra_xhci_register_mbox_notifier(struct notifier_block *nb)
> +{
> +	int ret;
> +
> +	mutex_lock(&tegra_xhci_mbox_lock);
> +	ret = raw_notifier_chain_register(&tegra_xhci_mbox_notifiers, nb);
> +	mutex_unlock(&tegra_xhci_mbox_lock);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(tegra_xhci_register_mbox_notifier);
> +
> +void tegra_xhci_unregister_mbox_notifier(struct notifier_block *nb)
> +{
> +	mutex_lock(&tegra_xhci_mbox_lock);
> +	raw_notifier_chain_unregister(&tegra_xhci_mbox_notifiers, nb);
> +	mutex_unlock(&tegra_xhci_mbox_lock);
> +}
> +EXPORT_SYMBOL(tegra_xhci_unregister_mbox_notifier);

What driver would use these?

My feeling is that if you have a mailbox that is used by multiple
drivers, you should use a proper mailbox driver to operate them,
and have the drivers register with that API instead of a custom one.

> +	/* Create child xhci-plat device */
> +	memset(xhci_resources, 0, sizeof(xhci_resources));
> +	res = platform_get_resource(to_platform_device(dev), IORESOURCE_IRQ, 0);
> +	if (!res) {
> +		dev_err(dev, "Missing XHCI IRQ\n");
> +		ret = -ENODEV;
> +		goto out;
> +	}
> +	xhci_resources[0].start = res->start;
> +	xhci_resources[0].end = res->end;
> +	xhci_resources[0].flags = res->flags;
> +	xhci_resources[0].name = res->name;
> +	res = platform_get_resource(to_platform_device(dev), IORESOURCE_MEM, 0);
> +	if (!res) {
> +		dev_err(dev, "Missing XHCI registers\n");
> +		ret = -ENODEV;
> +		goto out;
> +	}
> +	xhci_resources[1].start = res->start;
> +	xhci_resources[1].end = res->end;
> +	xhci_resources[1].flags = res->flags;
> +	xhci_resources[1].name = res->name;
> +
> +	xhci = platform_device_alloc("xhci-hcd", PLATFORM_DEVID_AUTO);
> +	if (!xhci) {
> +		dev_err(dev, "Failed to allocate XHCI host\n");
> +		ret = -ENOMEM;
> +		goto out;
> +	}

This does not feel appropriate at all: Rather than creating a child device,
you should have a specific driver that hooks into functions exported
by the xhci core. See Documentation/driver-model/design-patterns.txt

	Arnd

