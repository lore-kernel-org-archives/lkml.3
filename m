Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab3LaRZq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 12:25:46 -0500
Received: from 6.mo2.mail-out.ovh.net ([87.98.165.38]:40428 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753931Ab3LaRZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 12:25:45 -0500
Message-ID: <52C2FE14.1020806@overkiz.com>
Date: Tue, 31 Dec 2013 18:25:40 +0100
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: jjhiblot@traphandler.com, nicolas.ferre@atmel.com
CC: jean-jacques hiblot <jean-jacques.hiblot@jdsu.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] at91: ohci: fixed broken sanity check
References: <1388507624-10636-1-git-send-email-jjhiblot@traphandler.com>
In-Reply-To: <1388507624-10636-1-git-send-email-jjhiblot@traphandler.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 18308821336953616473
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrvddvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrvddvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jean-Jacques,

On 31/12/2013 17:33, jjhiblot@traphandler.com wrote:
> From: jean-jacques hiblot <jean-jacques.hiblot@jdsu.com>
>
> The test (pdev->resource[1].flags != IORESOURCE_IRQ) is broken because the flags
> value may contain not only the information IORESSOURCE_IRQ but also the IRQ type
> (IORESOURCE_IRQ_HIGHLEVEL for example).
>

This is already fixed: we moved to platform_get_irq and
platform_get_ressource instead of directly accessing platform
resource table.

See http://lists.openwall.net/linux-kernel/2013/12/08/128.

This solves both the problem you're reporting and another problem when
resources are in a different order (nothing guarantees the resources
order when using DT).

Best Regards,

Boris

> Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
> ---
>   drivers/usb/host/ohci-at91.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/usb/host/ohci-at91.c b/drivers/usb/host/ohci-at91.c
> index 418444e..df9c8a4 100644
> --- a/drivers/usb/host/ohci-at91.c
> +++ b/drivers/usb/host/ohci-at91.c
> @@ -142,8 +142,8 @@ static int usb_hcd_at91_probe(const struct hc_driver *driver,
>   		return -ENODEV;
>   	}
>
> -	if ((pdev->resource[0].flags != IORESOURCE_MEM)
> -			|| (pdev->resource[1].flags != IORESOURCE_IRQ)) {
> +	if (!(pdev->resource[0].flags & IORESOURCE_MEM)
> +			|| !(pdev->resource[1].flags & IORESOURCE_IRQ)) {
>   		pr_debug("hcd probe: invalid resource type\n");
>   		return -ENODEV;
>   	}
>

