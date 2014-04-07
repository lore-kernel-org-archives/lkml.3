Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083AbaDGI4c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 04:56:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:50053 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755021AbaDGI43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 04:56:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,808,1389772800"; 
   d="scan'208";a="515687181"
Date: Mon, 7 Apr 2014 12:04:03 +0300
From: "Westerberg, Mika" <mika.westerberg@intel.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: "Du, Wenkai" <wenkai.du@intel.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c-designware: Mask interrupts during i2c controller
 enable
Message-ID: <20140407090403.GG19349@intel.com>
References: <7286EAF50D3F4E4AADE7FEECEBF8B5A537A70E1F@ORSMSX109.amr.corp.intel.com>
 <20140404181613.GB19349@intel.com>
 <7286EAF50D3F4E4AADE7FEECEBF8B5A537A70F8B@ORSMSX109.amr.corp.intel.com>
 <20140404184232.GC19349@intel.com>
 <7286EAF50D3F4E4AADE7FEECEBF8B5A537A71351@ORSMSX109.amr.corp.intel.com>
 <20140405061316.GF19349@intel.com>
 <20140406185818.3aaca03d@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140406185818.3aaca03d@alan.etchedpixels.co.uk>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 06, 2014 at 06:58:18PM +0100, One Thousand Gnomes wrote:
> On Sat, 5 Apr 2014 09:13:16 +0300
> "Westerberg, Mika" <mika.westerberg@intel.com> wrote:
> 
> > On Sat, Apr 05, 2014 at 12:54:33AM +0300, Du, Wenkai wrote:
> > > >Interrupt masking is done already after each transaction.
> > > 
> > > At end of transfer, the code uses __i2c_dw_enable(dev, false) to disable
> > > adapter. This function doesn't mask interrupts. There is another function
> > > i2c_dw_disable that masks and clears interrupts. This could be used, but
> > > that means we need to fix in 2 places: 
> > 
> > Please check i2c_dw_isr() and tell me in which code path interrupts are not
> > getting masked. Or am I missing something fundamental here?
> > 
> > In case of abort, we mask interrupts. Also whenever the transaction
> > completes we mask interrupts (in i2c_dw_xfer_msg()).
> 
> Well actually you mask the IRQ at some point after the function returns
> if the bus allows the write to be posted. As i2c_dw_isr can then exit the
> IRQ handler before the write completes I suspect you have a race ?

I had to check BYT specs about that and I couldn't find if it does
posted-writes. For the "hidden" PCI config space it does but that's not
used in the driver anyway.

The thing here is that after suspend/resume cycle, the I2C host controller
gets reset. Once that happens the interrupt mask register is initialized to
0x8ff meaning that for example TX_EMPTY interrupts is unmasked. Nothing
happens though, as the controller is still disabled.

Now when we start the first I2C transaction after resume we call
i2c_dw_xfer_init() that then enables the controller and an interrupt is
immediately triggered even though we didn't finish the initialization. This
makes the controller/driver confused resulting timeout that Wenkai sees.

Actually the following patch should fix the problem as well. Just move the
HW enable to happen last. That way we can make sure that there is a valid
interrupt mask programmed before the controller is enabled.

diff --git a/drivers/i2c/busses/i2c-designware-core.c b/drivers/i2c/busses/i2c-designware-core.c
index 14c4b30d4ccc..35e3371f840c 100644
--- a/drivers/i2c/busses/i2c-designware-core.c
+++ b/drivers/i2c/busses/i2c-designware-core.c
@@ -417,12 +417,12 @@ static void i2c_dw_xfer_init(struct dw_i2c_dev *dev)
 	 */
 	dw_writel(dev, msgs[dev->msg_write_idx].addr | ic_tar, DW_IC_TAR);
 
-	/* Enable the adapter */
-	__i2c_dw_enable(dev, true);
-
-	/* Clear and enable interrupts */
+	/* Clear and unmask interrupts */
 	i2c_dw_clear_int(dev);
 	dw_writel(dev, DW_IC_INTR_DEFAULT_MASK, DW_IC_INTR_MASK);
+
+	/* Enable the adapter (and interrupts) */
+	__i2c_dw_enable(dev, true);
 }
 
 /*
