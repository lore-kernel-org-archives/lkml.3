Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785AbaBYFOY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 00:14:24 -0500
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:55471
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751549AbaBYFOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 00:14:23 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh1155h)
Date: Tue, 25 Feb 2014 12:19:17 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Neil Zhang <zhangwm@marvell.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/6] USB: gadget: mv_udc: workaroud for missing dTD
Message-ID: <20140225041854.GB14793@shlinux1.ap.freescale.net>
References: <1393228996-14787-1-git-send-email-zhangwm@marvell.com>
 <1393228996-14787-6-git-send-email-zhangwm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1393228996-14787-6-git-send-email-zhangwm@marvell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 04:03:15PM +0800, Neil Zhang wrote:
> There is an issue with the add dTD tripwire semaphore (ATDTW bit in
> USBCMD register) that can cause the controller to ignore a dTD that is
> added to a primed endpoint. When this happens, the software can read
> the tripwire bit and the status bit at '1' even though the endpoint
> is unprimed.
> 
> After executing a dTD, the device controller endpoint state machine
> executes a final read of the dTD terminate bit to check if the
> application added a dTD to the linked list at the last moment. This read
> is done in the finpkt_read_latest_next_td (44) state. After the read is
> performed, if the terminate bit is still set, the state machine moves to
> unprime the endpoint. The decision to unprime the endpoint is done in
> the checkqh_decision (59) state, based on the value of the terminate bit.
> 
> Before reaching the checkqh_decision state, the state machine traverses
> the writeqhtd_status (57), writeqh_status (56), and release_prime_mask
> (42) states. As shown in the waveform, the ep_addtd_tripwire_clr signal
> is not set to clear the tripwire bit in these states.
> 
> Signed-off-by: Neil Zhang <zhangwm@marvell.com>
> ---
>  drivers/usb/gadget/mv_udc_core.c |   20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/drivers/usb/gadget/mv_udc_core.c b/drivers/usb/gadget/mv_udc_core.c
> index a620cff..8df8606 100644
> --- a/drivers/usb/gadget/mv_udc_core.c
> +++ b/drivers/usb/gadget/mv_udc_core.c
> @@ -196,7 +196,27 @@ static int process_ep_req(struct mv_udc *udc, int index,
>  			while (readl(&udc->op_regs->epstatus) & bit_pos)
>  				udelay(1);
>  			break;
> +		} else {
> +			if (!(readl(&udc->op_regs->epstatus) & bit_pos)) {
> +				/* The DMA engine thinks there is no more dTD */
> +				curr_dqh->next_dtd_ptr = curr_dtd->dtd_next
> +					& EP_QUEUE_HEAD_NEXT_POINTER_MASK;
> +
> +				/* clear active and halt bit */
> +				curr_dqh->size_ioc_int_sts &=
> +						~(DTD_STATUS_ACTIVE
> +						| DTD_STATUS_HALTED);
> +
> +				/* Do prime again */
> +				wmb();
> +				writel(bit_pos, &udc->op_regs->epprime);
> +				while (readl(&udc->op_regs->epprime) & bit_pos)
> +					cpu_relax();
> +
> +				break;
> +			}
>  		}
> +
>  		udelay(1);
>  	}
>  

Is it a chipidea IP issue? Any errate number for this issue?
Does we need it for chipidea driver?

-- 

Best Regards,
Peter Chen

