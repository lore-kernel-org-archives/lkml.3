Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063AbaDDSUn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 14:20:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:63363 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753722AbaDDSUl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 14:20:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,796,1389772800"; 
   d="scan'208";a="507148323"
From: "Du, Wenkai" <wenkai.du@intel.com>
To: "Westerberg, Mika" <mika.westerberg@intel.com>
CC: "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] i2c-designware: Mask interrupts during i2c controller
 enable
Thread-Topic: [PATCH] i2c-designware: Mask interrupts during i2c controller
 enable
Thread-Index: Ac9QJwrpXJhe4Vv7Q76dkBKVgbE+4AARZeWAAA7Jh9A=
Date: Fri, 4 Apr 2014 18:20:39 +0000
Message-ID: <7286EAF50D3F4E4AADE7FEECEBF8B5A537A70F8B@ORSMSX109.amr.corp.intel.com>
References: <7286EAF50D3F4E4AADE7FEECEBF8B5A537A70E1F@ORSMSX109.amr.corp.intel.com>
 <20140404181613.GB19349@intel.com>
In-Reply-To: <20140404181613.GB19349@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mika,

In current driver implementation, I2c controller is enabled, then disabled every time inside i2c_dw_xfer. So I think the interrupt masking should be done inside i2c_dw_xfer_init, where the controller is enabled.

i2c_dw_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
{
...
	/* start the transfers */
	i2c_dw_xfer_init(dev);
...
	/*
	 * We must disable the adapter before unlocking the &dev->lock mutex
	 * below. Otherwise the hardware might continue generating interrupts
	 * which in turn causes a race condition with the following transfer.
	 * Needs some more investigation if the additional interrupts are
	 * a hardware bug or this driver doesn't handle them correctly yet.
	 */
	__i2c_dw_enable(dev, false);
...
}


Thanks,
Wenkai



-----Original Message-----
From: Westerberg, Mika 
Sent: Friday, April 04, 2014 11:16 AM
To: Du, Wenkai
Cc: linux-i2c@vger.kernel.org; Wolfram Sang; linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c-designware: Mask interrupts during i2c controller enable

On Fri, Apr 04, 2014 at 08:05:23PM +0300, Du, Wenkai wrote:
> diff --git a/drivers/i2c/busses/i2c-designware-core.c 
> b/drivers/i2c/busses/i2c-designware-core.c
> index 14c4b30..71a3fa9 100644
> --- a/drivers/i2c/busses/i2c-designware-core.c
> +++ b/drivers/i2c/busses/i2c-designware-core.c
> @@ -417,6 +417,9 @@ static void i2c_dw_xfer_init(struct dw_i2c_dev *dev)
>  	 */
>  	dw_writel(dev, msgs[dev->msg_write_idx].addr | ic_tar, DW_IC_TAR);
>  
> +	/* disable interrupts */
> +	i2c_dw_disable_int(dev);
> +

Please move this to i2c_dw_init() as I previously commented. This can only happen once the controller comes out of reset (either boot, or resume from system sleep).

>  	/* Enable the adapter */
>  	__i2c_dw_enable(dev, true);
>  
> --
> 1.7.9.5
