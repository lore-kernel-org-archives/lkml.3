Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934451Ab3CNA0i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 20:26:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:18511 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932357Ab3CNA0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 20:26:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,840,1355126400"; 
   d="scan'208";a="302206316"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: "tglx@linutronix.de" <tglx@linutronix.de>
CC: "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/3] genirq: Do not consider the irqs with
 IRQF_NO_SUSPEND in check_wakeup_irqs()
Thread-Topic: [PATCH 2/3] genirq: Do not consider the irqs with
 IRQF_NO_SUSPEND in check_wakeup_irqs()
Thread-Index: AQHOHrs9zBjWcDkk/EuSrmtq0bC7upikVznw
Date: Thu, 14 Mar 2013 00:26:32 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A258027@SHSMSX101.ccr.corp.intel.com>
References: <1363024396.31506.60.camel@cliu38-desktop-build>
	 <1363024631.31506.64.camel@cliu38-desktop-build>
 <1363082294.7518.4.camel@cliu38-desktop-build>
In-Reply-To: <1363082294.7518.4.camel@cliu38-desktop-build>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r2E0Qdnx027031

Hello Thomas,

Sorry to miss the V2 in the subject.
I have updated the comments in this new patch, could you consider to take it into upstream?

Thanks.

Best Regards
Liu chuansheng

> -----Original Message-----
> From: Liu, Chuansheng
> Sent: Tuesday, March 12, 2013 5:58 PM
> To: tglx@linutronix.de
> Cc: mingo@redhat.com; linux-kernel@vger.kernel.org; Liu, Chuansheng
> Subject: [PATCH 2/3] genirq: Do not consider the irqs with IRQF_NO_SUSPEND
> in check_wakeup_irqs()
> 
> 
> According to commit 9c6079aa1bf(genirq: Do not consider disabled
> wakeup irqs), we should not break the suspend when one interrupt has
> been disabled before suspending and is pending there.
> 
> But there is another case missed:
> If an interrupt which is marked IRQF_NO_SUSPEND has been disabled
> before suspend invocation then desc->depth is 1 and therefor it should
> not be checked for IRQS_PENDING in check_wakeup_irqs().
> 
> Here also checking if the desc->istate & IRQS_SUSPENDED is true to avoid
> this case.
> 
> Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
> ---
>  kernel/irq/pm.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/irq/pm.c b/kernel/irq/pm.c
> index cb228bf..f02a03d 100644
> --- a/kernel/irq/pm.c
> +++ b/kernel/irq/pm.c
> @@ -107,9 +107,16 @@ int check_wakeup_irqs(void)
>  		 * Only interrupts which are marked as wakeup source
>  		 * and have not been disabled before the suspend check
>  		 * can abort suspend.
> +		 *
> +		 * Meanwhile, if an interrupt which is marked IRQF_NO_SUSPEND
> +		 * has been disabled before suspend invocation then
> +		 * desc->depth is 1 and therefor it should not be checked
> +		 * for IRQS_PENDING, so also adding the checking of
> +		 * desc->istate & IRQS_SUSPENDED for this case.
>  		 */
>  		if (irqd_is_wakeup_set(&desc->irq_data)) {
> -			if (desc->depth == 1 && desc->istate & IRQS_PENDING)
> +			if (desc->depth == 1 && (desc->istate & IRQS_PENDING)
> +				&& (desc->istate & IRQS_SUSPENDED))
>  				return -EBUSY;
>  			continue;
>  		}
> --
> 1.7.0.4
> 
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
