Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027Ab3LDLk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 06:40:27 -0500
Received: from ns.iliad.fr ([212.27.33.1]:45042 "EHLO ns.iliad.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754550Ab3LDLk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 06:40:26 -0500
Message-ID: <529F14A8.3020109@freebox.fr>
Date: Wed, 04 Dec 2013 12:40:24 +0100
From: Nicolas Schichan <nschichan@freebox.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Leigh Brown <leigh@solinno.co.uk>
CC: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Florian Fainelli <florian@openwrt.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Spurious timeouts in mvmdio
References: <529CA42A.3040504@freebox.fr> <20131203122346.GD29282@titan.lakedaemon.net> <20131203124033.GT16735@n2100.arm.linux.org.uk> <abe249f5cba5c267e2c536bd62c57908@doppler.thel33t.co.uk> <529E5F03.8040607@gmail.com> <8d65780eb7bfe49bb0734a09f05f70a6@doppler.thel33t.co.uk> <529E66A4.4050000@gmail.com> <ae69666fd3b61411d7bbd9ac993cec13@doppler.thel33t.co.uk> <20131203234209.GW16735@n2100.arm.linux.org.uk>
In-Reply-To: <20131203234209.GW16735@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2013 12:42 AM, Russell King - ARM Linux wrote:
>> This will make it correct when using interrupts but it will make the
>> loop wait one jiffie longer than it should when polling.
>
> Alternatively, code it like this instead.
>
>   drivers/net/ethernet/marvell/mvmdio.c |   32 +++++++++++++++-----------------
>   1 files changed, 15 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/net/ethernet/marvell/mvmdio.c b/drivers/net/ethernet/marvell/mvmdio.c
> index 7354960b583b..a6f59831fc5b 100644
> --- a/drivers/net/ethernet/marvell/mvmdio.c
> +++ b/drivers/net/ethernet/marvell/mvmdio.c
> @@ -76,31 +76,29 @@ static int orion_mdio_wait_ready(struct mii_bus *bus)
>   {
>   	struct orion_mdio_dev *dev = bus->priv;
>   	unsigned long timeout = usecs_to_jiffies(MVMDIO_SMI_TIMEOUT);
> -	unsigned long end = jiffies + timeout;
> -	int timedout = 0;
>
> -	while (1) {
> -	        if (orion_mdio_smi_is_done(dev))
> +	if (dev->err_interrupt > 0) {
> +		if (wait_event_timeout(dev->smi_busy_wait,
> +				       orion_mdio_smi_is_done(dev),
> +				       1 + timeout))
>   			return 0;
> -	        else if (timedout)
> -			break;
> +	} else {
> +		unsigned long end = jiffies + timeout;
>
> -	        if (dev->err_interrupt <= 0) {
> -			usleep_range(MVMDIO_SMI_POLL_INTERVAL_MIN,
> -				     MVMDIO_SMI_POLL_INTERVAL_MAX);
> +		while (1) {
> +	        	if (orion_mdio_smi_is_done(dev))
> +				return 0;
>
>   			if (time_is_before_jiffies(end))
> -				++timedout;
> -	        } else {
> -			wait_event_timeout(dev->smi_busy_wait,
> -				           orion_mdio_smi_is_done(dev),
> -				           timeout);
> -
> -			++timedout;
> -	        }
> +				break;
> +
> +			usleep_range(MVMDIO_SMI_POLL_INTERVAL_MIN,
> +				     MVMDIO_SMI_POLL_INTERVAL_MAX);
> +		}
>   	}
>
>   	dev_err(bus->parent, "Timeout: SMI busy for too long\n");
> +
>   	return  -ETIMEDOUT;
>   }

Hi Russell,

I have just tested your patch on MV88F6281 and MV88F6282 both in polling and 
irq mode and it works just fine.

I had a similar patch almost ready to submit but you were faster than me.

Feel free to add my:

Tested-by: Nicolas Schichan <nschichan@freebox.fr>

Thanks,

-- 
Nicolas Schichan
Freebox SAS
