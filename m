Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab3L3Chv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 21:37:51 -0500
Received: from gate.crashing.org ([63.228.1.57]:56109 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754561Ab3L3Cht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 21:37:49 -0500
Message-ID: <1388371049.4373.22.camel@pasglop>
Subject: Re: [PATCH] of/irq: Fix device_node refcount in of_irq_parse_raw()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: =?ISO-8859-1?Q?C=E9dric?= Le Goater <clg@fr.ibm.com>
Cc: grant.likely@linaro.org, devicetree@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Mon, 30 Dec 2013 13:37:29 +1100
In-Reply-To: <1387301573-30502-1-git-send-email-clg@fr.ibm.com>
References: <1387301573-30502-1-git-send-email-clg@fr.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-17 at 18:32 +0100, Cédric Le Goater wrote:
> Commit 2361613206e6, "of/irq: Refactor interrupt-map parsing" changed
> the refcount on the device_node causing an error in of_node_put():

Grant, Thierry, this is a regression, please send to Linus ASAP...

Cheers,
Ben.

> ERROR: Bad of_node_put() on /pci@800000020000000
> CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.13.0-rc3-dirty #2
> Call Trace:
> [c00000003e403500] [c0000000000144fc] .show_stack+0x7c/0x1f0 (unreliable)
> [c00000003e4035d0] [c00000000070f250] .dump_stack+0x88/0xb4
> [c00000003e403650] [c0000000005e8768] .of_node_release+0xd8/0xf0
> [c00000003e4036e0] [c0000000005eeafc] .of_irq_parse_one+0x10c/0x280
> [c00000003e4037a0] [c0000000005efd4c] .of_irq_parse_pci+0x3c/0x1d0
> [c00000003e403840] [c000000000038240] .pcibios_setup_device+0xa0/0x2e0
> [c00000003e403910] [c0000000000398f0] .pcibios_setup_bus_devices+0x60/0xd0
> [c00000003e403990] [c00000000003b3a4] .__of_scan_bus+0x1a4/0x2b0
> [c00000003e403a80] [c00000000003a62c] .pcibios_scan_phb+0x30c/0x410
> [c00000003e403b60] [c0000000009fe430] .pcibios_init+0x7c/0xd4
> 
> This patch adjusts the refcount in the walk of the interrupt tree.
> When a match is found, there is no need to increase the refcount 
> on 'out_irq->np' as 'newpar' is already holding a ref. The refcount
> balance between 'ipar' and 'newpar' is maintained in the skiplevel:
> goto label.
> 
> This patch also removes the usage of the device_node variable 'old' 
> which seems useless after the latest changes.
> 
> Signed-off-by: Cédric Le Goater <clg@fr.ibm.com>
> ---
> 
> This patch was tested on powerpc, pseries and powernv. This is a 
> new area for me so I might have missed a path. Please take a look.
> 
> We could now introduce an helper routine to look for #address-cells in
> of_irq_parse_raw(). This can be the subject of another patch.
> 
> Thanks,
> 
> C.
> 
>  drivers/of/irq.c |    5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/of/irq.c b/drivers/of/irq.c
> index 786b0b47fae4..27212402c532 100644
> --- a/drivers/of/irq.c
> +++ b/drivers/of/irq.c
> @@ -165,7 +165,6 @@ int of_irq_parse_raw(const __be32 *addr, struct of_phandle_args *out_irq)
>  		if (of_get_property(ipar, "interrupt-controller", NULL) !=
>  				NULL) {
>  			pr_debug(" -> got it !\n");
> -			of_node_put(old);
>  			return 0;
>  		}
>  
> @@ -250,8 +249,7 @@ int of_irq_parse_raw(const __be32 *addr, struct of_phandle_args *out_irq)
>  		 * Successfully parsed an interrrupt-map translation; copy new
>  		 * interrupt specifier into the out_irq structure
>  		 */
> -		of_node_put(out_irq->np);
> -		out_irq->np = of_node_get(newpar);
> +		out_irq->np = newpar;
>  
>  		match_array = imap - newaddrsize - newintsize;
>  		for (i = 0; i < newintsize; i++)
> @@ -268,7 +266,6 @@ int of_irq_parse_raw(const __be32 *addr, struct of_phandle_args *out_irq)
>  	}
>   fail:
>  	of_node_put(ipar);
> -	of_node_put(out_irq->np);
>  	of_node_put(newpar);
>  
>  	return -EINVAL;


