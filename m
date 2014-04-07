Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833AbaDGSiK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 14:38:10 -0400
Received: from mga09.intel.com ([134.134.136.24]:63735 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755693AbaDGSiF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 14:38:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,811,1389772800"; 
   d="scan'208";a="516272493"
From: "Du, Wenkai" <wenkai.du@intel.com>
To: "Westerberg, Mika" <mika.westerberg@intel.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] i2c-designware: Mask interrupts during i2c controller
 enable
Thread-Topic: [PATCH] i2c-designware: Mask interrupts during i2c controller
 enable
Thread-Index: Ac9QJwrpXJhe4Vv7Q76dkBKVgbE+4AARZeWAAA7Jh9D//5EOAIAATf0QgABzAACAAldQAIAA/RGAgABeqgCAAAfmAIAAXh4Q
Date: Mon, 7 Apr 2014 16:48:02 +0000
Message-ID: <7286EAF50D3F4E4AADE7FEECEBF8B5A537A72207@ORSMSX109.amr.corp.intel.com>
References: <7286EAF50D3F4E4AADE7FEECEBF8B5A537A70E1F@ORSMSX109.amr.corp.intel.com>
 <20140404181613.GB19349@intel.com>
 <7286EAF50D3F4E4AADE7FEECEBF8B5A537A70F8B@ORSMSX109.amr.corp.intel.com>
 <20140404184232.GC19349@intel.com>
 <7286EAF50D3F4E4AADE7FEECEBF8B5A537A71351@ORSMSX109.amr.corp.intel.com>
 <20140405061316.GF19349@intel.com>
 <20140406185818.3aaca03d@alan.etchedpixels.co.uk>
 <20140407090403.GG19349@intel.com>
 <20140407154252.6b8f0f7e@alan.etchedpixels.co.uk>
 <20140407151107.GL19349@intel.com>
In-Reply-To: <20140407151107.GL19349@intel.com>
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

> -----Original Message-----
> From: Westerberg, Mika
> Sent: Monday, April 07, 2014 8:11 AM
> To: One Thousand Gnomes
> Cc: Du, Wenkai; linux-i2c@vger.kernel.org; Wolfram Sang; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] i2c-designware: Mask interrupts during i2c controller enable
> 
> 
> Do you think we can fix it with adding a dummy read right after write to the mask register, like
> the snippet below?
> 
> diff --git a/drivers/i2c/busses/i2c-designware-core.c b/drivers/i2c/busses/i2c-designware-
> core.c
> index 14c4b30d4ccc..ff9090381d8b 100644
> --- a/drivers/i2c/busses/i2c-designware-core.c
> +++ b/drivers/i2c/busses/i2c-designware-core.c
> @@ -535,6 +535,7 @@ i2c_dw_xfer_msg(struct dw_i2c_dev *dev)
>  		intr_mask = 0;
> 
>  	dw_writel(dev, intr_mask,  DW_IC_INTR_MASK);
> +	dw_readl(dev, DW_IC_INTR_MASK);
>  }
> 

I have tried this read back earlier during debugging, it didn't help. You can confirm yourself as well.

On the ISR code execution path, here is the list to my understanding:

1. TX abort: this path masks all interrupt by writing 0 to interrupt mask register;
2. RX full: this path doesn't do anything on masking interrupts;
3. TX empty: this path only mask TX empty under certain conditions; it doesn't mask other interrupt sources;
4. i2c STOP condition: this path call complete() to finish the transfer; it doesn't do anything on masking interrupts;

The above analysis agrees with the debug logs: most of interrupts are left unmasked in original code when i2c core is being enabled.

I think we want all interrupts masked when enabling HW. This will ensure the required 25us core turn on delay being respected. Also there could be spurious interrupts when HW is being turned on that should be ignored.


