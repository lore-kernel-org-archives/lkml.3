Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120AbaHTPbT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 11:31:19 -0400
Received: from mail-bl2lp0205.outbound.protection.outlook.com ([207.46.163.205]:24907
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750819AbaHTPbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 11:31:18 -0400
Date: Wed, 20 Aug 2014 10:25:40 -0500
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@atx-linux-37
To: Romain Baeriswyl <Romain.Baeriswyl@abilis.com>
CC: Wolfram Sang <wsa@the-dreams.de>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Christian Ruppert <christian.ruppert@abilis.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, <baruch@tkos.co.il>,
        <grant.likely@linaro.org>, <robh+dt@kernel.org>, <skuribay@pobox.com>,
        <alan@linux.intel.com>, <devicetree@vger.kernel.org>,
        <delicious.quinoa@gmail.com>, <dinguyen@opensource.altera.com>,
        <yvanderv@opensource.altera.com>,
        Romain Baeriswyl <romainba@abilis.com>
Subject: Re: [PATCH] i2c designware add support of I2C standard mode
In-Reply-To: <alpine.DEB.2.02.1408200928130.11079@atx-linux-37>
Message-ID: <alpine.DEB.2.02.1408201021440.11079@atx-linux-37>
References: <20140820124231.GD21734@leverpostej> <1408544948-22339-1-git-send-email-romainba@abilis.com> <alpine.DEB.2.02.1408200928130.11079@atx-linux-37>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: DM2PR04CA053.namprd04.prod.outlook.com (10.141.154.171) To
 BL2PR03MB305.namprd03.prod.outlook.com (10.141.68.13)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03094A4065
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(6009001)(189002)(199003)(51704005)(24454002)(42186005)(53416004)(74502001)(74662001)(31966008)(102836001)(107046002)(77096002)(46406003)(79102001)(101416001)(76482001)(110136001)(77982001)(46102001)(50986999)(54356999)(76176999)(85306004)(81542001)(33716001)(86362001)(86152002)(83072002)(92566001)(92726001)(23726002)(83506001)(21056001)(85852003)(64706001)(80022001)(19580405001)(50466002)(69596002)(106356001)(66066001)(20776003)(87976001)(47776003)(4396001)(95666004)(99396002)(81342001)(81156004)(83322001)(105586002)(19580395003);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB305;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Aug 2014, atull wrote:

> 
> 
> On Wed, 20 Aug 2014, Romain Baeriswyl wrote:
> 
> > From: Romain Baeriswyl <Romain.Baeriswyl@abilis.com>
> > 
> > Some legacy devices support ony I2C standard mode at 100kHz.
> > This patch allows to select the standard mode through the DTS
> > with the use of the existing clock-frequency parameter.
> > 
> > When clock-frequency parameter is not set, the fast mode is selected.
> > Only when the parameter is set at 100000, the standard mode is selected.
> > 
> > Signed-off-by: Romain Baeriswyl <romainba@abilis.com>
> > Reviewed-by: Christian Ruppert <christian.ruppert@abilis.com>
> > ---
> >  drivers/i2c/busses/i2c-designware-platdrv.c |   23 +++++++++++++++++++++--
> >  1 files changed, 21 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
> > index 402ec39..b543fe1 100644
> > --- a/drivers/i2c/busses/i2c-designware-platdrv.c
> > +++ b/drivers/i2c/busses/i2c-designware-platdrv.c
> > @@ -122,6 +122,7 @@ static int dw_i2c_probe(struct platform_device *pdev)
> >  	struct i2c_adapter *adap;
> >  	struct resource *mem;
> >  	int irq, r;
> > +	u32 clk_freq;
> >  
> >  	irq = platform_get_irq(pdev, 0);
> >  	if (irq < 0) {
> > @@ -151,6 +152,9 @@ static int dw_i2c_probe(struct platform_device *pdev)
> >  		return PTR_ERR(dev->clk);
> >  	clk_prepare_enable(dev->clk);
> >  
> > +	/* fast mode by default because of legacy reasons */
> > +	clk_freq = 400000;
> > +
> >  	if (pdev->dev.of_node) {
> >  		u32 ht = 0;
> >  		u32 ic_clk = dev->get_clk_rate_khz(dev);
> > @@ -166,6 +170,17 @@ static int dw_i2c_probe(struct platform_device *pdev)
> >  		of_property_read_u32(pdev->dev.of_node,
> >  				     "i2c-scl-falling-time-ns",
> >  				     &dev->scl_falling_time);
> > +
> > +		of_property_read_u32(pdev->dev.of_node, "clock-frequency",
> > +				     &clk_freq);
> > +
> > +		/* Only standard mode at 100kHz and fast mode at 400kHz
> > +		 * are supported.
> > +		 */
> > +		if (clk_freq != 100000 && clk_freq != 400000) {
> > +			dev_err(&pdev->dev, "Only 100kHz and 400kHz supported");
> > +			return -EINVAL;
> > +		}
> 
> Hi Romain,
> 
> It is common to operate i2c at <100KHz on boards that have i2c 
> issues.  I am using this driver at 50KHz because I have a LCD module 
> that just doesn't work at a full 100KHz.  Please remove the check for 
> these two frequency points.
> 
> >  	}
> >  
> >  	dev->functionality =
> > @@ -175,8 +190,12 @@ static int dw_i2c_probe(struct platform_device *pdev)
> >  		I2C_FUNC_SMBUS_BYTE_DATA |
> >  		I2C_FUNC_SMBUS_WORD_DATA |
> >  		I2C_FUNC_SMBUS_I2C_BLOCK;
> > -	dev->master_cfg =  DW_IC_CON_MASTER | DW_IC_CON_SLAVE_DISABLE |
> > -		DW_IC_CON_RESTART_EN | DW_IC_CON_SPEED_FAST;
> > +	if (clk_freq == 100000)
> 
> Please change to <=
> 

Hi Romain,

This looks fine to me, my "<= issues" are not important as this isn't 
really setting a frequency, but just setting a bit that controls speed.

Acked-by: Alan Tull <atull@opensource.altera.com>


> > +		dev->master_cfg =  DW_IC_CON_MASTER | DW_IC_CON_SLAVE_DISABLE |
> > +			DW_IC_CON_RESTART_EN | DW_IC_CON_SPEED_STD;
> > +	else
> > +		dev->master_cfg =  DW_IC_CON_MASTER | DW_IC_CON_SLAVE_DISABLE |
> > +			DW_IC_CON_RESTART_EN | DW_IC_CON_SPEED_FAST;
> >  
> >  	/* Try first if we can configure the device from ACPI */
> >  	r = dw_i2c_acpi_configure(pdev);
> > -- 
> > 1.7.1
> > 
> > 
> 
