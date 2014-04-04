Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbaDDQct (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 12:32:49 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:46715
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753963AbaDDQcq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 12:32:46 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dIc89bh936eI1432I4015Izz1f42h2148h1ee6h1de0h1fdah2149h2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzz1de098h8275bh1de097hz2fh95h839h93fhc61hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h2336h2438h2461h2487h24d7h2516h2545h255eh25f6h2605h268bh26d3h906i2673i1155h)
Date: Fri, 4 Apr 2014 09:32:32 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Wolfram Sang <wsa@the-dreams.de>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Mike Looijmans <mike.looijmans@topic.nl>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Harini Katakam <harinik@xilinx.com>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-i2c@vger.kernel.org>
Subject: Re: [PATCH v4 2/3] i2c: Add driver for Cadence I2C controller
References: <1396547967-19260-1-git-send-email-soren.brinkmann@xilinx.com>
 <1396547967-19260-2-git-send-email-soren.brinkmann@xilinx.com>
 <20140404143847.GA5529@katana>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20140404143847.GA5529@katana>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <53e29fb2-2a42-4cbf-9c15-490d81ee0de4@CH1EHSMHS005.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-04-04 at 04:38PM +0200, Wolfram Sang wrote:
> On Thu, Apr 03, 2014 at 10:59:26AM -0700, Soren Brinkmann wrote:
> > Add a driver for the Cadence I2C controller. This controller is for
> > example found in Xilinx Zynq.
> > 
> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > Tested-by: Michal Simek <michal.simek@xilinx.com>
> > Reviewed-by: Harini Katakam <harinik@xilinx.com>
> 
> Only minor stuff, but since you resend anyhow because of 400kHz issue...
> 
> > +static void cdns_i2c_mrecv(struct cdns_i2c *id)
> > +{
> > +	unsigned int ctrl_reg;
> > +	unsigned int isr_status;
> > +
> > +	id->p_recv_buf = id->p_msg->buf;
> > +	id->recv_count = id->p_msg->len;
> > +
> > +	/* Put the controller in master receive mode and clear the FIFO */
> > +	ctrl_reg = cdns_i2c_readreg(CDNS_I2C_CR_OFFSET);
> > +	ctrl_reg |= CDNS_I2C_CR_RW | CDNS_I2C_CR_CLR_FIFO;
> > +
> > +	if ((id->p_msg->flags & I2C_M_RECV_LEN) == I2C_M_RECV_LEN)
> 
> 'if (id->p_msg->flags & I2C_M_RECV_LEN)' is enough.
> 
> > +		/* Report the other error interrupts to application as EIO */
> > +		if (id->err_status & (CDNS_I2C_IXR_RX_UNF |
> > +				      CDNS_I2C_IXR_TX_OVF |
> > +				      CDNS_I2C_IXR_RX_OVF |
> > +				      CDNS_I2C_IXR_NACK)) {
> > +			cdns_i2c_master_reset(adap);
> > +			return -EIO;
> > +		}
> 
> NACK is returned as -ENXIO. Check 'Documentation/i2c/fault-codes' for
> standard patterns. I'd think the rest is EIO, though.

Okay, I'll put this into the next version:
diff --git a/drivers/i2c/busses/i2c-cadence.c b/drivers/i2c/busses/i2c-cadence.c
index 43af8c351c8b..63f3f03ecc9b 100644
--- a/drivers/i2c/busses/i2c-cadence.c
+++ b/drivers/i2c/busses/i2c-cadence.c
@@ -311,7 +311,7 @@ static void cdns_i2c_mrecv(struct cdns_i2c *id)
        ctrl_reg = cdns_i2c_readreg(CDNS_I2C_CR_OFFSET);
        ctrl_reg |= CDNS_I2C_CR_RW | CDNS_I2C_CR_CLR_FIFO;
 
-       if ((id->p_msg->flags & I2C_M_RECV_LEN) == I2C_M_RECV_LEN)
+       if (id->p_msg->flags & I2C_M_RECV_LEN)
                id->recv_count = I2C_SMBUS_BLOCK_MAX + 1;
 
        /*
@@ -531,12 +531,13 @@ static int cdns_i2c_master_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs,
                if (ret)
                        return ret;
 
-               /* Report the other error interrupts to application as EIO */
-               if (id->err_status & (CDNS_I2C_IXR_RX_UNF |
-                                     CDNS_I2C_IXR_TX_OVF |
-                                     CDNS_I2C_IXR_RX_OVF |
-                                     CDNS_I2C_IXR_NACK)) {
+               /* Report the other error interrupts to application */
+               if (id->err_status) {
                        cdns_i2c_master_reset(adap);
+
+                       if (id->err_status & CDNS_I2C_IXR_NACK)
+                               return -ENXIO;
+
                        return -EIO;
                }
        }

	Thanks,
	Sören


