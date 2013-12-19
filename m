Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab3LSLd2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 06:33:28 -0500
Received: from mail-bk0-f43.google.com ([209.85.214.43]:50031 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109Ab3LSLd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:33:26 -0500
Message-ID: <52B2D97F.4070200@gmail.com>
Date: Thu, 19 Dec 2013 12:33:19 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
To: Leigh Brown <leigh@solinno.co.uk>, "David S. Miller" <davem@davemloft.net>
CC: Nicolas Schichan <nschichan@freebox.fr>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Florian Fainelli <florian@openwrt.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] net: mvmdio: fix interrupt timeout handling
References: <1387451589-15491-1-git-send-email-leigh@solinno.co.uk>
In-Reply-To: <1387451589-15491-1-git-send-email-leigh@solinno.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/13 12:13, Leigh Brown wrote:
> orion_mdio_wait_ready uses wait_event_timeout to wait for the
> SMI interrupt to fire.  wait_event_timeout waits for between
> "timeout - 1" and "timeout" jiffies.  In this case a 1ms timeout
> when HZ is 1000 results in a wait of 0 to 1 jiffies, causing
> premature timeouts.
>
> This fix ensures a minimum timeout of 2 jiffies, ensuring
> wait_event_timeout will always wait at least 1 jiffie.
>
> Issue reported by Nicolas Schichan.
>
> Tested-by: Nicolas Schichan <nschichan@freebox.fr>
> Signed-off-by: Leigh Brown <leigh@solinno.co.uk>
> ---
>   drivers/net/ethernet/marvell/mvmdio.c | 6 ++++++
>   1 file changed, 6 insertions(+)
>
> diff --git a/drivers/net/ethernet/marvell/mvmdio.c b/drivers/net/ethernet/marvell/mvmdio.c
> index 7354960..a42a750 100644
> --- a/drivers/net/ethernet/marvell/mvmdio.c
> +++ b/drivers/net/ethernet/marvell/mvmdio.c
> @@ -92,6 +92,12 @@ static int orion_mdio_wait_ready(struct mii_bus *bus)
>   			if (time_is_before_jiffies(end))
>   				++timedout;
>   	        } else {
> +			/* wait_event_timeout does not guarantee a delay of at
> +			 * least one whole jiffie, so timeout must be no less
> +			 * than two.
> +			 */
> +			 if (timeout < 2)
> +			 	timeout = 2;

Hi Leigh,

above two lines have a whitespace issue.

Sebastian

>   			wait_event_timeout(dev->smi_busy_wait,
>   				           orion_mdio_smi_is_done(dev),
>   				           timeout);
>

