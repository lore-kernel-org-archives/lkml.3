Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884Ab3GVPSj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 11:18:39 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:33886 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756092Ab3GVPSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 11:18:38 -0400
X-IronPort-AV: E=Sophos;i="4.89,720,1367971200"; 
   d="scan'208";a="36602392"
Message-ID: <51ED4D4A.3060705@citrix.com>
Date: Mon, 22 Jul 2013 16:18:34 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Daniel De Graaf <dgdegra@tycho.nsa.gov>
CC: <konrad.wilk@oracle.com>, <tpmdd-devel@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>, <leosilva@linux.vnet.ibm.com>,
        <shpedoikal@gmail.com>, <xen-devel@lists.xen.org>, <mail@srajiv.net>,
        <adlai@linux.vnet.ibm.com>, <tpmdd@sirrix.com>, <PeterHuewe@gmx.de>
Subject: Re: [PATCH v4] drivers/tpm: add xen tpmfront interface
References: <1372714468-28120-1-git-send-email-dgdegra@tycho.nsa.gov>
In-Reply-To: <1372714468-28120-1-git-send-email-dgdegra@tycho.nsa.gov>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/13 22:34, Daniel De Graaf wrote:
> This is a complete rewrite of the Xen TPM frontend driver, taking
> advantage of a simplified frontend/backend interface and adding support
> for cancellation and timeouts.  The backend for this driver is provided
> by a vTPM stub domain using the interface in Xen 4.3.
[...]
> --- /dev/null
> +++ b/Documentation/xen-tpmfront.txt

Suggest putting this in Documentation/tpm/.

> --- /dev/null
> +++ b/drivers/char/tpm/xen-tpmfront.c
[...]
> +static void backend_changed(struct xenbus_device *dev,
> +		enum xenbus_state backend_state)
> +{
> +	int val;

Hrm. I don't like how every front/back pair invents their own variation
of the state machine.

Please document the front and back state machines in
xen/include/public/io/tpmif.h (and the correspoding copy in Linux).

> +
> +	switch (backend_state) {
> +	case XenbusStateInitialised:
> +	case XenbusStateConnected:

		if (dev->state == XenbusStateConnected)
			break;

Perhaps?

> +		if (xenbus_scanf(XBT_NIL, dev->otherend,
> +				"feature-protocol-v2", "%d", &val) < 0)
> +			val = 0;
> +		if (!val) {
> +			xenbus_dev_fatal(dev, -EINVAL,
> +					"vTPM protocol 2 required");
> +			return;
> +		}
> +		xenbus_switch_state(dev, XenbusStateConnected);
> +		break;
> +
> +	case XenbusStateClosing:
> +	case XenbusStateClosed:
> +		device_unregister(&dev->dev);
> +		xenbus_frontend_closed(dev);
> +		break;
> +	default:
> +		break;
> +	}
> +}

David
