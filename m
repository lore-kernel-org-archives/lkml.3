Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931Ab3K3R2H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 12:28:07 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:43780 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296Ab3K3R2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 12:28:05 -0500
Message-ID: <529A2026.4050605@cogentembedded.com>
Date: Sat, 30 Nov 2013 21:28:06 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Chris Ruehl <chris.ruehl@gtsys.com.hk>, alexander.shishkin@linux.intel.com,
        gregkh@linuxfoundation.org
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3 v3] usb: chipidea: Fix Internal error: : 808 [#1]
 ARM related to STS flag
References: <1385783513-22502-1-git-send-email-chris.ruehl@gtsys.com.hk>
In-Reply-To: <1385783513-22502-1-git-send-email-chris.ruehl@gtsys.com.hk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 30-11-2013 7:51, Chris Ruehl wrote:

> usb: chipidea: Fix Internal error: : 808 [#1] ARM related to STS flag

> * init the sts flag to 0 (missed)
> * Set PORTCS_STS only if VUSB_HS_PHY_TYPE > 1
>    otherwise the register is ReadOnly
> * Set/Reset correct BIT(28)/BIT(29) for STS

> Signed-off-by: Chris Ruehl <chris.ruehl@gtsys.com.hk>

    The coding style is still wrong at places...

> diff --git a/drivers/usb/chipidea/core.c b/drivers/usb/chipidea/core.c
> index 5075407..2c634c1 100644
> --- a/drivers/usb/chipidea/core.c
> +++ b/drivers/usb/chipidea/core.c
[...]
> @@ -273,10 +273,24 @@ static void hw_phymode_configure(struct ci_hdrc *ci)
>
>   	if (ci->hw_bank.lpm) {
>   		hw_write(ci, OP_DEVLC, DEVLC_PTS(7) | DEVLC_PTW, lpm);
> -		hw_write(ci, OP_DEVLC, DEVLC_STS, sts);
> +		if ( sts )

    Remove spaces around 'sts', please.

> +			hw_write(ci, OP_DEVLC, DEVLC_STS, BIT(28));
> +		else
> +			hw_write(ci, OP_DEVLC, DEVLC_STS, ~BIT(28));
>   	} else {
>   		hw_write(ci, OP_PORTSC, PORTSC_PTS(7) | PORTSC_PTW, portsc);
> -		hw_write(ci, OP_PORTSC, PORTSC_STS, sts);
> +		if (((portsc >> 30) & 0x3) > 1) {
> +			if (sts) {
> +				hw_write(ci, OP_PORTSC, PORTSC_STS, BIT(29));
> +			}
> +			else {

			} else {

> +				portsc = (ioread32(ci->hw_bank.regmap[OP_PORTSC])
> +						& PORTSC_STS);

    No need for outer (). And it's preferred that an operator is left at the 
end of a first line, not starts the continuation line.

WBR, Sergei

