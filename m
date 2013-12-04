Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079Ab3LDKsm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 05:48:42 -0500
Received: from smtp.citrix.com ([66.165.176.89]:38361 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755369Ab3LDKsi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 05:48:38 -0500
X-IronPort-AV: E=Sophos;i="4.93,824,1378857600"; 
   d="scan'208";a="80442664"
Date: Wed, 4 Dec 2013 10:48:17 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <stefano.stabellini@eu.citrix.com>, <ian.campbell@citrix.com>,
        <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        <boris.ostrovsky@oracle.com>, <david.vrabel@citrix.com>,
        <leosilva@linux.vnet.ibm.com>, <ashley@ashleylai.com>,
        <peterhuewe@gmx.de>, <mail@srajiv.net>, <tpmdd@selhorst.net>,
        <tpmdd@sirrix.com>, <dmitry.torokhov@gmail.com>, <bhelgaas@google.com>,
        <plagnioj@jcrosoft.com>, <tomi.valkeinen@ti.com>,
        <tpmdd-devel@lists.sourceforge.net>, <linux-input@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH] xen/pvhvm: If xen_platform_pci=0 is set don't blow up.
In-Reply-To: <1386105246-14337-1-git-send-email-konrad.wilk@oracle.com>
Message-ID: <alpine.DEB.2.02.1312041047200.7093@kaball.uk.xensource.com>
References: <1386105246-14337-1-git-send-email-konrad.wilk@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Dec 2013, Konrad Rzeszutek Wilk wrote:
> diff --git a/arch/x86/xen/platform-pci-unplug.c b/arch/x86/xen/platform-pci-unplug.c
> index 0a78524..087dfeb 100644
> --- a/arch/x86/xen/platform-pci-unplug.c
> +++ b/arch/x86/xen/platform-pci-unplug.c
> @@ -69,6 +69,24 @@ static int check_platform_magic(void)
>  	return 0;
>  }
>  
> +bool xen_has_pv_devices(void)
> +{
> +	if (!xen_domain())
> +		return false;
> +
> +	if (xen_hvm_domain()) {
> +		/* User requested no unplug, so no PV drivers. */
> +		if (xen_emul_unplug & XEN_UNPLUG_NEVER)
> +			return false;

Considering that if (xen_emul_unplug & XEN_UNPLUG_NEVER) we never set
xen_platform_pci_unplug, this check is redundant.


> +		/* And user has xen_platform_pci=0 set in guest config as
> +		 * driver did not modify the value. */
> +		if (!xen_platform_pci_unplug)
> +			return false;
> +	}
> +	return true;
> +}
> +EXPORT_SYMBOL_GPL(xen_has_pv_devices);
> +
>  void xen_unplug_emulated_devices(void)
>  {
>  	int r;
