Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696Ab3GCRxw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 13:53:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38540 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676Ab3GCRxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 13:53:50 -0400
Date: Wed, 3 Jul 2013 10:53:49 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [ 07/13] net/tg3: Avoid delay during MMIO access
Message-ID: <20130703175349.GA21995@kroah.com>
References: <20130701200523.096669485@linuxfoundation.org>
 <20130701200523.963352818@linuxfoundation.org>
 <87d2r1jpp7.fsf@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d2r1jpp7.fsf@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 02, 2013 at 10:06:44AM +0100, Luis Henriques wrote:
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> 
> > 3.4-stable review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > From: Gavin Shan <shangw@linux.vnet.ibm.com>
> >
> > commit 6d446ec32f169c6a5d9bc90684a8082a6cbe90f6 upstream.
> >
> > When the EEH error is the result of a fenced host bridge, MMIO accesses
> > can be very slow (milliseconds) to timeout and return all 1's,
> > thus causing the driver various timeout loops to take way too long and
> > trigger soft-lockup warnings (in addition to taking minutes to recover).
> >
> > It might be worthwhile to check if for any of these cases, ffffffff is
> > a valid possible value, and if not, bail early since that means the HW
> > is either gone or isolated. In the meantime, checking that the PCI channel
> > is offline would be workaround of the problem.
> >
> > Signed-off-by: Gavin Shan <shangw@linux.vnet.ibm.com>
> > Signed-off-by: David S. Miller <davem@davemloft.net>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >
> > ---
> >  drivers/net/ethernet/broadcom/tg3.c |   36 ++++++++++++++++++++++++++++++++++++
> >  1 file changed, 36 insertions(+)
> >
> > --- a/drivers/net/ethernet/broadcom/tg3.c
> > +++ b/drivers/net/ethernet/broadcom/tg3.c
> > @@ -689,6 +689,9 @@ static int tg3_ape_lock(struct tg3 *tp,
> >  		status = tg3_ape_read32(tp, gnt + off);
> >  		if (status == bit)
> >  			break;
> > +		if (pci_channel_offline(tp->pdev))
> > +			break;
> > +
> >  		udelay(10);
> >  	}
> >  
> > @@ -1466,6 +1469,9 @@ static void tg3_wait_for_event_ack(struc
> >  	for (i = 0; i < delay_cnt; i++) {
> >  		if (!(tr32(GRC_RX_CPU_EVENT) & GRC_RX_CPU_DRIVER_EVENT))
> >  			break;
> > +		if (pci_channel_offline(tp->pdev))
> > +			break;
> > +
> >  		udelay(8);
> >  	}
> >  }
> > @@ -1636,6 +1642,9 @@ static int tg3_poll_fw(struct tg3 *tp)
> >  		for (i = 0; i < 200; i++) {
> >  			if (tr32(VCPU_STATUS) & VCPU_STATUS_INIT_DONE)
> >  				return 0;
> > +			if (pci_channel_offline(tp->pdev))
> > +				return -ENODEV;
> > +
> >  			udelay(100);
> >  		}
> >  		return -ENODEV;
> > @@ -1646,6 +1655,15 @@ static int tg3_poll_fw(struct tg3 *tp)
> >  		tg3_read_mem(tp, NIC_SRAM_FIRMWARE_MBOX, &val);
> >  		if (val == ~NIC_SRAM_FIRMWARE_MBOX_MAGIC1)
> >  			break;
> > +		if (pci_channel_offline(tp->pdev)) {
> > +			if (!tg3_flag(tp, NO_FWARE_REPORTED)) {
> > +				tg3_flag_set(tp, NO_FWARE_REPORTED);
> > +				netdev_info(tp->dev, "No firmware running\n");
> > +			}
> > +
> > +			break;
> > +		}
> > +
> >  		udelay(10);
> >  	}
> >  
> > @@ -3204,6 +3222,8 @@ static int tg3_nvram_write_block_buffere
> >  		ret = tg3_nvram_exec_cmd(tp, nvram_cmd);
> >  		if (ret)
> >  			break;
> > +		if (pci_channel_offline(tp->pdev))
> > +			return -EBUSY;
> >  	}
> >  	return ret;
> >  }
> 
> As I referred in a previous email, I'm not sure about the correctness
> of this backport.  The original commit modifies function tg3_pause_cpu
> (and not tg3_nvram_write_block_buffered).
> 
> My backport to the 3.5 kernel modifies tg3_halt_cpu code which
> contains the code that has been moved into tg3_pause_cpu in mainline
> (by commit 837c45bb4eaf367ac738c8d746990da33b3402ee).

You're right, same thing happens for the 3.9 backport of this patch as
well.

Gavin, if you want this patch to be applied to the stable kernel trees,
please provide a working backported patch to stable@vger.kernel.org so
that I can apply it properly.

I'll go drop this patch from both 3.9 and 3.4-stable.

thanks,

greg k-h
