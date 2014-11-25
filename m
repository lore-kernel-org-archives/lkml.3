Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703AbaKYK5k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:57:40 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40982 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131AbaKYK5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:57:19 -0500
Message-ID: <1416913037.2741.1.camel@pengutronix.de>
Subject: Re: [RFC PATCH] regulator: core: do not disable regulator if
 boot_on is set
From: Lucas Stach <l.stach@pengutronix.de>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: linux-kernel@vger.kernel.org, broonie@kernel.org, lgirdwood@gmail.com,
        linux-arm-kernel@lists.infradead.org
Date: Tue, 25 Nov 2014 11:57:17 +0100
In-Reply-To: <1416912803-10772-1-git-send-email-pramod.gurav@smartplayin.com>
References: <1416912803-10772-1-git-send-email-pramod.gurav@smartplayin.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.6-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:fa0f:41ff:fe58:4010
X-SA-Exim-Mail-From: l.stach@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 25.11.2014, 16:23 +0530 schrieb Pramod Gurav:
> Currently the regulator core disables the regulators which are unused
> or whose reference count is zero or if they are configured always_on.
> This change adds a check in this logic to see if a regulator is
> configured as boot_on and does not disable it if found true.
> 
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
> 
> ---
> 
> The issue was found on apq8064 based IFC6410 on which a fixed regulator
> configured as regulator-boot-on in DT and was being disabled when not in
> use. Tested this change on this board and found working.
> 
Um, why would this be the correct fix? regulator-boot-on just tells the
regulator core that the bootloader might have left this regulator
enabled. If you want it to stay on after the kernel finished init you
need to mark it as always-on.

>  drivers/regulator/core.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
> index cd87c0c..9f7a13f 100644
> --- a/drivers/regulator/core.c
> +++ b/drivers/regulator/core.c
> @@ -4019,7 +4019,7 @@ static int __init regulator_init_complete(void)
>  		ops = rdev->desc->ops;
>  		c = rdev->constraints;
>  
> -		if (c && c->always_on)
> +		if (c && (c->always_on || c->boot_on))
>  			continue;
>  
>  		if (c && !(c->valid_ops_mask & REGULATOR_CHANGE_STATUS))

-- 
Pengutronix e.K.             | Lucas Stach                 |
Industrial Linux Solutions   | http://www.pengutronix.de/  |

