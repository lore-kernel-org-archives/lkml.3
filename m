Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751289AbaDAAa7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 20:30:59 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:50567 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbaDAAa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 20:30:57 -0400
Date: Tue, 1 Apr 2014 01:30:56 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Levente Kurusa <levex@linux.com>, Ralf Baechle <ralf@linux-mips.org>
cc: LKML <linux-kernel@vger.kernel.org>, linux-mips@linux-mips.org
Subject: Re: [PATCH] tc: account for device_register() failure
In-Reply-To: <52863D5E.7080606@linux.com>
Message-ID: <alpine.LFD.2.11.1404010108270.27402@eddie.linux-mips.org>
References: <52863D5E.7080606@linux.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Nov 2013, Levente Kurusa wrote:

> This patch makes the TURBOchannel driver bail out if the call
> to device_register() failed.
> 
> Signed-off-by: Levente Kurusa <levex@linux.com>

Acked-by: Maciej W. Rozycki <macro@linux-mips.org>

This fixes some build warnings:

drivers/tc/tc.c: In function 'tc_bus_add_devices':
drivers/tc/tc.c:132: warning: ignoring return value of 'device_register', 
declared with attribute warn_unused_result
drivers/tc/tc.c: In function 'tc_init':
drivers/tc/tc.c:151: warning: ignoring return value of 'device_register', 
declared with attribute warn_unused_result

Levente, thanks for your fix and apologies for the long RTT -- can you 
please resend your patch to <linux-mips@linux-mips.org> and Ralf so that 
it'll be pulled via the MIPS tree?  I'll post a follow-up update to fix 
some issues with `tc_init' that I noticed thanks to your change.

> ---
>  tc.c |   10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/tc/tc.c b/drivers/tc/tc.c
> index a8aaf6a..6b3a038 100644
> --- a/drivers/tc/tc.c
> +++ b/drivers/tc/tc.c
> @@ -129,7 +129,10 @@ static void __init tc_bus_add_devices(struct tc_bus *tbus)
> 
>  		tc_device_get_irq(tdev);
> 
> -		device_register(&tdev->dev);
> +		if (device_register(&tdev->dev)) {
> +			put_device(&tdev->dev);
> +			goto out_err;
> +		}
>  		list_add_tail(&tdev->node, &tbus->devices);
> 
>  out_err:
> @@ -148,7 +151,10 @@ static int __init tc_init(void)
> 
>  	INIT_LIST_HEAD(&tc_bus.devices);
>  	dev_set_name(&tc_bus.dev, "tc");
> -	device_register(&tc_bus.dev);
> +	if (device_register(&tc_bus.dev)) {
> +		put_device(&tc_bus.dev);
> +		return 0;	
> +	}
> 
>  	if (tc_bus.info.slot_size) {
>  		unsigned int tc_clock = tc_get_speed(&tc_bus) / 100000;
> 

  Maciej
