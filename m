Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105AbaF3WxP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 18:53:15 -0400
Received: from avasout06.plus.net ([212.159.14.18]:50381 "EHLO
	avasout06.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727AbaF3WxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 18:53:14 -0400
X-Greylist: delayed 364 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Jun 2014 18:53:13 EDT
X-CM-Score: 0.00
X-CNFS-Analysis: v=2.1 cv=WL/xXxcR c=1 sm=1 tr=0
 a=fkd5KTHJFGKPA0tsLFcInQ==:117 a=fkd5KTHJFGKPA0tsLFcInQ==:17 a=gJibsqi4AAAA:8
 a=0Bzu9jTXAAAA:8 a=ekOJvlQLSnQA:10 a=tX4CYe1CkW8A:10 a=8nJEP1OIZ-IA:10
 a=AqDKUsGPAAAA:8 a=tOO0nKmCAAAA:8 a=TSbVqHtbAAAA:8 a=1XWaLZrsAAAA:8
 a=KW4IDUy-dQa9AZnEX5EA:9 a=wPNLvfGTeEIA:10 a=xPKy4yqXaTEA:10 a=Zaq_Gq3z9AEA:10
Message-ID: <53B1E8E5.6080808@baker-net.org.uk>
Date: Mon, 30 Jun 2014 23:47:01 +0100
From: Adam Baker <linux@baker-net.org.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Matwey V. Kornilov" <matwey@sai.msu.ru>, gregkh@linuxfoundation.org
CC: hsommer@eso.org, matwey.kornilov@gmail.com, linux-kernel@vger.kernel.org,
        linux-parport@lists.infradead.org
Subject: Re: [Linux-parport] [PATCH 2/2] parport: parport_pc: Add force_epp
 module option for parport_pc.
References: <alpine.LRH.2.00.1406301248200.15067@lnfm1.sai.msu.ru>
In-Reply-To: <alpine.LRH.2.00.1406301248200.15067@lnfm1.sai.msu.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/06/14 09:48, Matwey V. Kornilov wrote:
>
> The detection of Intel EPP bug is known to produce much false positives.
> The new option is introduced to force enable EPP in spite of the test
> result.

I can confirm that this check produces false positives on a range of 
hardware - I no longer have the machine that I experienced the problem 
with but when I posted about the issue in the past I had several 
responses from other users suffering from the problem.

>
> Tested-by: Heiko Andreas Sommer <hsommer@eso.org>
> Signed-off-by: Matwey V. Kornilov <matwey@sai.msu.ru>
> ---
>   drivers/parport/parport_pc.c | 9 ++++++++-
>   1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/parport/parport_pc.c b/drivers/parport/parport_pc.c
> index 4b851bb..1a15b9c 100644
> --- a/drivers/parport/parport_pc.c
> +++ b/drivers/parport/parport_pc.c
> @@ -105,6 +105,9 @@ static int user_specified;
>          (defined(CONFIG_PARPORT_1284) && defined(CONFIG_PARPORT_PC_FIFO))
>   static int verbose_probing;
>   #endif
> +#ifdef CONFIG_PARPORT_1284
> +static int force_epp;
> +#endif
>   static int pci_registered_parport;
>   static int pnp_registered_parport;
>
> @@ -1765,7 +1768,7 @@ static int parport_EPP_supported(struct parport *pb)
>           return 0;  /* No way to clear timeout */
>
>       /* Check for Intel bug. */
> -    if (intel_bug_present(pb))
> +    if (!force_epp && intel_bug_present(pb))
>           return 0;
>
>       pb->modes |= PARPORT_MODE_EPP;
> @@ -3148,6 +3151,10 @@ module_param_array(dma, charp, NULL, 0);
>   MODULE_PARM_DESC(verbose_probing, "Log chit-chat during initialisation");
>   module_param(verbose_probing, int, 0644);
>   #endif
> +#ifdef CONFIG_PARPORT_1284
> +MODULE_PARM_DESC(force_epp, "Do not disable EPP when it is detected to
> be broken (default is false)");

I think this needs some more explanation - how about
"Disable check for broken Intel EPP hardware that gives false positives 
on 2002 and newer hardware"

The 2002 date is based upon 
http://thread.gmane.org/gmane.linux.parport/322/focus=326

Last time fixing this was discussed Jonathan Nieder did some digging in 
the history and technical details and posted at the tail of the thread at

https://groups.google.com/forum/?_escaped_fragment_=topic/linux.debian.bugs.dist/nhK1ZU4x0Ok#!topic/linux.debian.bugs.dist/nhK1ZU4x0Ok


> +module_param(force_epp, int, 0);
> +#endif
>   #ifdef CONFIG_PCI
>   static char *init_mode;
>   MODULE_PARM_DESC(init_mode,

