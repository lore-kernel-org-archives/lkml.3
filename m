Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534Ab3BMHdX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 02:33:23 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:23840 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab3BMHdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 02:33:21 -0500
X-AuditID: cbfec7f5-b7fd76d000007247-de-511b41bfb07c
Message-id: <511B41B8.3060506@samsung.com>
Date: Wed, 13 Feb 2013 08:33:12 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107
 Thunderbird/17.0.2
MIME-version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Chris Ball <cjb@laptop.org>,
        Kevin Liu <keyuan.liu@gmail.com>
Subject: Re: [PATCH 3/3 RESEND] mmc: sdhci: check voltage range only on
 regulators aware of voltage value
References: <87bobqrcb4.fsf@octavius.laptop.org>
 <1360656096-1671-1-git-send-email-m.szyprowski@samsung.com>
 <Pine.LNX.4.64.1302122309470.14434@axis700.grange>
In-reply-to: <Pine.LNX.4.64.1302122309470.14434@axis700.grange>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMLMWRmVeSWpSXmKPExsVy+t/xa7r7HaUDDU795La4vGsOm8WR//2M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGVMPrSIvaCDv2L7ljXMDYyTeboYOTkkBEwkbp/exAhh
	i0lcuLeerYuRi0NIYCmjxOaD/1ghnGYmiUnXOphAqngFtCQetveygtgsAqoSe7sbWUBsNgFD
	ia63XWwgtqhAqMTafWuYIeoFJX5MvgdWIwJUc2rbBmaQocwCPxklJk56DFYkLJAt8eL2F0aI
	bYsZJfa3rwDbxilgL7Fqbz9YN7OAmcSjlnXMELa8xOY1b5knMArMQrJkFpKyWUjKFjAyr2IU
	TS1NLihOSs810itOzC0uzUvXS87P3cQICcivOxiXHrM6xCjAwajEwzszTCpQiDWxrLgy9xCj
	BAezkgjvBA7pQCHelMTKqtSi/Pii0pzU4kOMTBycUg2Med1NU/0cWmx49vQseRZV65Nd5DMj
	O5JfgnN266crLBf0Dmwy6nT7dkY4m9X/1RqFM4EFLrOacyWct4UHZe1tNtRrqS753Vpa94vt
	wIzHbD/OyQc1s7yr8Yhd953/Po+X9gmNz6sCM13/CX1+d/iHZF6YyZXoHcWVRiuLD56duvEo
	Z8CtvHolluKMREMt5qLiRAB1FaiUJgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2/12/2013 11:10 PM, Guennadi Liakhovetski wrote:
> Hi Marek
>
> On Tue, 12 Feb 2013, Marek Szyprowski wrote:
>
> > Some regulators don't report any voltage values, so checking supported
> > voltage range results in disabling all SDHCI_CAN_VDD_* flags and
> > registration failure. This patch finally provides a correct fix for the
> > registration of SDHCI driver with all possible voltage regulators:
> > dummy, fixed and regulated without using regulator_count_voltages()
> > hacks.
> >
> > Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> > ---
> >  drivers/mmc/host/sdhci.c |    6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
> > index ba586ae..735526b 100644
> > --- a/drivers/mmc/host/sdhci.c
> > +++ b/drivers/mmc/host/sdhci.c
> > @@ -2976,7 +2976,11 @@ int sdhci_add_host(struct sdhci_host *host)
> >  	}
> >
> >  #ifdef CONFIG_REGULATOR
> > -	if (host->vmmc) {
> > +	/*
> > +	 * Voltage range check makes sense only if regulator reports
> > +	 * any voltage value.
> > +	 */
> > +	if (host->vmmc && regulator_get_voltage(host->vmmc) > 0) {
> >  		ret = regulator_is_supported_voltage(host->vmmc, 2700000,
> >  			3600000);
>
> Wouldn't using mmc_regulator_get_ocrmask() be a better option?

The idea behind this patch it to avoid messing ocr mask and voltage
regulators when voltage regulator is a simple on/off switch, which doesn't
report any value. This solves the serious problems with sdhci driver when
dummy regulator is enabled in kconfig, otherwise the sdhci driver
concludes that no supported voltage is available and fails to initialize.
Using mmc_regulator_get_ocrmask() won't solve this problem.

BTW, mmc_regulator_get_ocrmask() won't work with continuous range 
regulators.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center
  


