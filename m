Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab3GXQmJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 12:42:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37282 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab3GXQmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 12:42:08 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
        "Gavin Shan" <shangw@linux.vnet.ibm.com>
Subject: Re: [40/85] net/tg3: Avoid delay during MMIO access
References: <lsq.1374674565.832521875@decadent.org.uk>
Date: Wed, 24 Jul 2013 17:42:04 +0100
In-Reply-To: <lsq.1374674565.832521875@decadent.org.uk> (Ben Hutchings's
	message of "Wed, 24 Jul 2013 15:02:45 +0100")
Message-ID: <87zjtbzz8j.fsf@canonical.com>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Hutchings <ben@decadent.org.uk> writes:

> 3.2.49-rc1 review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Gavin Shan <shangw@linux.vnet.ibm.com>
>
> commit 6d446ec32f169c6a5d9bc90684a8082a6cbe90f6 upstream.
>
> When the EEH error is the result of a fenced host bridge, MMIO accesses
> can be very slow (milliseconds) to timeout and return all 1's,
> thus causing the driver various timeout loops to take way too long and
> trigger soft-lockup warnings (in addition to taking minutes to recover).
>
> It might be worthwhile to check if for any of these cases, ffffffff is
> a valid possible value, and if not, bail early since that means the HW
> is either gone or isolated. In the meantime, checking that the PCI channel
> is offline would be workaround of the problem.
>
> Signed-off-by: Gavin Shan <shangw@linux.vnet.ibm.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> [bwh: Backported to 3.2: adjust context, indentation]
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  drivers/net/ethernet/broadcom/tg3.c | 36 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 36 insertions(+)
>
> --- a/drivers/net/ethernet/broadcom/tg3.c
> +++ b/drivers/net/ethernet/broadcom/tg3.c
> @@ -688,6 +688,9 @@ static int tg3_ape_lock(struct tg3 *tp,
>  		status = tg3_ape_read32(tp, gnt + off);
>  		if (status == bit)
>  			break;
> +		if (pci_channel_offline(tp->pdev))
> +			break;
> +
>  		udelay(10);
>  	}
>  
> @@ -1465,6 +1468,9 @@ static void tg3_wait_for_event_ack(struc
>  	for (i = 0; i < delay_cnt; i++) {
>  		if (!(tr32(GRC_RX_CPU_EVENT) & GRC_RX_CPU_DRIVER_EVENT))
>  			break;
> +		if (pci_channel_offline(tp->pdev))
> +			break;
> +
>  		udelay(8);
>  	}
>  }
> @@ -1628,6 +1634,9 @@ static int tg3_poll_fw(struct tg3 *tp)
>  		for (i = 0; i < 200; i++) {
>  			if (tr32(VCPU_STATUS) & VCPU_STATUS_INIT_DONE)
>  				return 0;
> +			if (pci_channel_offline(tp->pdev))
> +				return -ENODEV;
> +
>  			udelay(100);
>  		}
>  		return -ENODEV;
> @@ -1638,6 +1647,15 @@ static int tg3_poll_fw(struct tg3 *tp)
>  		tg3_read_mem(tp, NIC_SRAM_FIRMWARE_MBOX, &val);
>  		if (val == ~NIC_SRAM_FIRMWARE_MBOX_MAGIC1)
>  			break;
> +		if (pci_channel_offline(tp->pdev)) {
> +			if (!tg3_flag(tp, NO_FWARE_REPORTED)) {
> +				tg3_flag_set(tp, NO_FWARE_REPORTED);
> +				netdev_info(tp->dev, "No firmware running\n");
> +			}
> +
> +			break;
> +		}
> +
>  		udelay(10);
>  	}
>  
> @@ -3067,6 +3085,10 @@ static int tg3_halt_cpu(struct tg3 *tp,
>  			tw32(offset + CPU_MODE,  CPU_MODE_HALT);
>  			if (tr32(offset + CPU_MODE) & CPU_MODE_HALT)
>  				break;
> +			if (pci_channel_offline(tp->pdev))
> +				return -EBUSY;
> +			if (pci_channel_offline(tp->pdev))
> +				return -EBUSY;
>  		}

I believe you didn't want to have these two invocations to the
pci_channel_offline() function.  i guess you wanted to have one of
these moved to the other branch of the 'if' statement.

[ btw, I've just replied to an email by David S. Miller about his
  backport to 3.4 (and 3.2) of this commit. ]

Cheers,
-- 
Luis


>  
>  		tw32(offset + CPU_STATE, 0xffffffff); @@ -7569,6
> +7591,14 @@ static int tg3_stop_block(struct tg3 *tp tw32_f(ofs,
> val);
>  
>  	for (i = 0; i < MAX_WAIT_CNT; i++) {
> +		if (pci_channel_offline(tp->pdev)) {
> +			dev_err(&tp->pdev->dev,
> +				"tg3_stop_block device offline, "
> +				"ofs=%lx enable_bit=%x\n",
> +				ofs, enable_bit);
> +			return -ENODEV;
> +		}
> +
>  		udelay(100);
>  		val = tr32(ofs);
>  		if ((val & enable_bit) == 0)
> @@ -7592,6 +7622,13 @@ static int tg3_abort_hw(struct tg3 *tp,
>  
>  	tg3_disable_ints(tp);
>  
> +	if (pci_channel_offline(tp->pdev)) {
> +		tp->rx_mode &= ~(RX_MODE_ENABLE | TX_MODE_ENABLE);
> +		tp->mac_mode &= ~MAC_MODE_TDE_ENABLE;
> +		err = -ENODEV;
> +		goto err_no_dev;
> +	}
> +
>  	tp->rx_mode &= ~RX_MODE_ENABLE;
>  	tw32_f(MAC_RX_MODE, tp->rx_mode);
>  	udelay(10);
> @@ -7640,6 +7677,7 @@ static int tg3_abort_hw(struct tg3 *tp,
>  	err |= tg3_stop_block(tp, BUFMGR_MODE, BUFMGR_MODE_ENABLE, silent);
>  	err |= tg3_stop_block(tp, MEMARB_MODE, MEMARB_MODE_ENABLE, silent);
>  
> +err_no_dev:
>  	for (i = 0; i < tp->irq_cnt; i++) {
>  		struct tg3_napi *tnapi = &tp->napi[i];
>  		if (tnapi->hw_status)
>
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
