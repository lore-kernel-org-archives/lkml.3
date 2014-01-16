Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768AbaAPNiw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 08:38:52 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:46977 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbaAPNin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 08:38:43 -0500
Message-ID: <1389879444.2794.44.camel@iivanov-dev.int.mm-sol.com>
Subject: Re: [PATCH v2 2/2] i2c: New bus driver for the QUP I2C controller
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Wolfram Sang <wsa@the-dreams.de>,
        Grant Likely <grant.likely@linaro.org>,
        Jean Delvare <khali@linux-fr.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        James Ralston <james.d.ralston@intel.com>,
        Bill Brown <bill.e.brown@intel.com>,
        Matt Porter <matt.porter@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Date: Thu, 16 Jan 2014 15:37:24 +0200
In-Reply-To: <20140115164604.GI14405@codeaurora.org>
References: <1389659437-16406-1-git-send-email-bjorn.andersson@sonymobile.com>
	 <1389659437-16406-3-git-send-email-bjorn.andersson@sonymobile.com>
	 <20140115164604.GI14405@codeaurora.org>
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Wed, 2014-01-15 at 08:46 -0800, Stephen Boyd wrote: 
> On 01/13, Bjorn Andersson wrote:
> > +/*
> > + * QUP driver for Qualcomm MSM platforms
> > + *
> > + */
> 
> This comment seems redundant, we know what file we're looking at.
> 
> > +
> > +struct qup_i2c_dev {
> > +	struct device		*dev;
> > +	void __iomem		*base;
> > +	struct pinctrl		*pctrl;
> 
> This is unused.
> 
> > +	int			irq;
> > +	struct clk		*clk;
> > +	struct clk		*pclk;
> > +	struct i2c_adapter	adap;
> > +
> > +	int			clk_freq;
> 
> This is only ever used in probe, so why do we need to store it
> away?
> 
> > +	int			clk_ctl;
> > +	int			one_bit_t;
> > +	int			out_fifo_sz;
> > +	int			in_fifo_sz;
> > +	int			out_blk_sz;
> > +	int			in_blk_sz;
> > +	unsigned long		xfer_time;
> > +	unsigned long		wait_idle;
> > +
> > +	struct i2c_msg		*msg;
> > +	/* Current possion in user message buffer */
> 
> s/possion/position/?
> 
> > +	int			pos;
> > +	/* Keep number of bytes left to be transmitted */
> > +	int			cnt;
> > +	/* I2C protocol errors */
> > +	u32			bus_err;
> > +	/* QUP core errors */
> > +	u32			qup_err;
> > +	/*
> > +	 * maximum bytes that could be send (per iterration). could be
> 
> s/iterration/iteration/?
> 
> > +	 * equal of fifo size or block size (in block mode)
> > +	 */
> > +	int			chunk_sz;
> > +	struct completion	xfer;
> > +};
> > +
> > +static irqreturn_t qup_i2c_interrupt(int irq, void *dev)
> > +{
> > +	struct qup_i2c_dev *qup = dev;
> > +	u32 bus_err;
> > +	u32 qup_err;
> > +	u32 opflags;
> > +
> [...]
> > +
> > +	if (opflags & QUP_OUT_SVC_FLAG)
> > +		writel(QUP_OUT_SVC_FLAG, qup->base + QUP_OPERATIONAL);
> > +
> > +	if (!(qup->msg->flags == I2C_M_RD))
> 
> Should this be?
> 
> 	if (!(qup->msg->flags & I2C_M_RD))
> 
> Otherwise it should be
> 
> 	if (qup->msg->flags != I2C_M_RD)
> 

This check is actually broken. Intention was that if this is read
transaction and there is no QUP_MX_INPUT_DONE or QUP_IN_SVC_FLAG
to exit without wakeup transfer thread. As is it now it will never
complete write transactions.

Regards,
Ivan

> > +		return IRQ_HANDLED;
> > +
> > +	if ((opflags & QUP_MX_INPUT_DONE) || (opflags & QUP_IN_SVC_FLAG))
> > +		writel(QUP_IN_SVC_FLAG, qup->base + QUP_OPERATIONAL);
> > +
> > +done:
> > +	qup->qup_err = qup_err;
> > +	qup->bus_err = bus_err;
> > +	complete(&qup->xfer);
> > +	return IRQ_HANDLED;
> > +}
> > +


