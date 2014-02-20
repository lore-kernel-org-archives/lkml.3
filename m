Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315AbaBTIno (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 03:43:44 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:55027 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264AbaBTInk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 03:43:40 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-72-5305c03b35a0
Message-id: <1392885817.3648.8.camel@AMDC1943>
Subject: Re: [PATCH v3 14/15] charger: max14577: Configure battery-dependent
 settings from DTS
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Jenny Tc <jenny.tc@intel.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Date: Thu, 20 Feb 2014 09:43:37 +0100
In-reply-to: <20140220063031.GC2498@jenny-desktop>
References: <1392627950-26927-1-git-send-email-k.kozlowski@samsung.com>
 <1392627950-26927-15-git-send-email-k.kozlowski@samsung.com>
 <20140220063031.GC2498@jenny-desktop>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrELMWRmVeSWpSXmKPExsVy+t/xy7rWB1iDDY5+57PYOGM9q8XUh0/Y
	LK5/ec5qMenJe2aLiSsnM1us/drDbnG26Q27xf2vRxktNj2+xmpxedccNou1R+6yW9xuXMFm
	cbqb1WL9jNcsDnweO2fdZffYvELLY/Gel0wem1Z1snncubaHzWPeyUCPzUvqPfq2rGL0+LxJ
	LoAzissmJTUnsyy1SN8ugStj+pmdzAXzeCp2L+libWCcx9nFyMkhIWAisfnhHxYIW0ziwr31
	bF2MXBxCAksZJZ4s/cIE4XxmlOjYcgXI4eDgFdCTuLBYGKRBWCBB4s/FX2wgNpuAscTm5UvA
	bBEBRYnvXfvBBjELTGWRWHdnOzNIgkVAVeLT49lgRZwCRhIbL2yHWrCOUWLK5RVgRcwC6hKT
	5i1ihjhJSWJ3eyc7RFxeYvOat2BxXgFBiR+T77FMYBSYhaRlFpKyWUjKFjAyr2IUTS1NLihO
	Ss810itOzC0uzUvXS87P3cQIiaevOxiXHrM6xCjAwajEwxtxnSVYiDWxrLgy9xCjBAezkggv
	TyZrsBBvSmJlVWpRfnxRaU5q8SFGJg5OqQbGpRtshM+mZG0v+RbbPVFecbbY18ehv18eipm8
	/0DLqo377zLZaBit+sf42EbScM9WU6k0+1c64jelnFbNTRVY7XM95e5X2e2Bmz5ccU40PfGh
	dVK+0ht9g7khv/9pGPevkumVjWfOXBxr+oZ7y0UnowhVe6HUA8p/vN4y1xe3ZSqePfdY3P2m
	EktxRqKhFnNRcSIAY1w7roUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-02-20 at 12:00 +0530, Jenny Tc wrote:
> On Mon, Feb 17, 2014 at 10:05:49AM +0100, Krzysztof Kozlowski wrote:
> > +static inline int max14577_init_eoc(struct max14577_charger *chg,
> > +		unsigned int uamp)
> > +{
> > +	unsigned int current_bits = 0xf;
> > +	u8 reg_data;
> > +
> > +	switch (chg->maxim_core->dev_type) {
> > +	case MAXIM_DEVICE_TYPE_MAX77836:
> > +		if (uamp < 5000)
> > +			return -EINVAL; /* Requested current is too low */
> > +
> > +		if (uamp == 7500)
> > +			current_bits = 0x0;
> 
> if (uamp <= 7500) ?

(uamp < 7500) will be mapped to 5000 uA (0x1) so it will be OK. It is
safer to use lower current. The register description looks like:
0000 - 7.5 mA
0001 -  5 mA
0010 - 10 mA
0011 - 15 mA
...
1010 - 50 mA
1011 - 60 mA
1111 - 100 mA

However for value between <7501, 9999> this function will return 0x1
(5000 uA) which is not perfect. Better is to return 0x0 (7500 uA).
I'll fix this in next version of patch.


> 
> > +	/* Initialize Overvoltage-Protection Threshold */
> > +	switch (chg->pdata->ovp_uvolt) {
> > +	case 7500000:
> > +		reg_data = 0x0;
> > +		break;
> > +	case 6000000:
> > +	case 6500000:
> > +	case 7000000:
> > +		reg_data = 0x1 + (chg->pdata->ovp_uvolt - 6000000) / 500000;
> > +		break;
> 
> Is it battery OVP or charger source OVP? If it's battery OVP, then  minimum
> level as 6V seems to be unsafe even for 4.4V batteries.

It is on charger (input). Anyway only these 4 values are supported (6.0,
6.5, 7.0, 7.5 volts).


Best regards,
Krzysztof

