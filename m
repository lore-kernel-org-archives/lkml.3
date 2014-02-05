Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761AbaBENiu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 08:38:50 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:21619 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbaBENis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 08:38:48 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-3f-52f23ee6a449
Message-id: <1391607524.3726.23.camel@AMDC1943>
Subject: Re: [PATCH 10/18] mfd: max14577: Add detection of device type
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Date: Wed, 05 Feb 2014 14:38:44 +0100
In-reply-to: <20140203095541.GK13529@lee--X1>
References: <1390911522-28209-1-git-send-email-k.kozlowski@samsung.com>
 <1390911522-28209-11-git-send-email-k.kozlowski@samsung.com>
 <20140203095541.GK13529@lee--X1>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCLMWRmVeSWpSXmKPExsVy+t/xK7rP7D4FGbR9ZbeY+vAJm8X1L89Z
	Lc42vWG3uP/1KKPFtysdTBabHl9jtbi8aw6bxdojd9ktbjeuYLM43c3qwOWxc9Zddo9NqzrZ
	PO5c28PmMe9koMfmJfUefVtWMXp83iQXwB7FZZOSmpNZllqkb5fAlfHry0WmgrWCFfvXH2Fu
	YDzJ28XIySEhYCLxoe0fE4QtJnHh3nq2LkYuDiGBpYwSy3tfsUM4nxkleubOB6ri4OAV0Jd4
	ua8EpEFYwE1iwZoLzCA2m4CxxOblS9hASkQEVCTOvTEHaWUWeMwkseT2B7AFLAKqEns27Qar
	5xTQlVi7eRHUspWMEn83XwdLMAuoS0yat4gZ4iIlid3tnewQcXmJzWvegsV5BQQlfky+xzKB
	UWAWkpZZSMpmISlbwMi8ilE0tTS5oDgpPddQrzgxt7g0L10vOT93EyMkJr7sYFx8zOoQowAH
	oxIPb4foxyAh1sSy4srcQ4wSHMxKIrx2Bp+ChHhTEiurUovy44tKc1KLDzEycXBKNTBm/lSc
	8yTnNv/UfQfb19z9fnbdtsw1bMX1RqGT1qhMtkm9FVy6Z0Lftc8Gmt4XKz7sssp/NOvcij+m
	ljuetH4xWbN+iuW5Q8U2Ow4srnhtcP/xBTXWzRsnZc5Yllni9KdJ9OrBzculM9wetFyrnKOz
	NKX1PtPPyVfleSZUhJ+7sydwa/TxX6Ut85RYijMSDbWYi4oTAehM6mFnAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-03 at 09:55 +0000, Lee Jones wrote:
> > This patch continues the preparation for adding support for max77836
> > device to existing max14577 driver.
> > 
> > Add enum for types of devices supported by this driver. The device type
> > will be detected by matching of_device_id, or i2c_device_id as a
> > fallback.
> > 
> > The patch also moves to separate function the code related to displaying
> > DeviceID register values.
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > Cc: Kyungmin Park <kyungmin.park@samsung.com>
> > Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> > ---
> >  drivers/mfd/max14577.c               |   61 +++++++++++++++++++++++-----------
> >  include/linux/mfd/max14577-private.h |   12 ++++---
> >  2 files changed, 50 insertions(+), 23 deletions(-)
> > 
> > diff --git a/drivers/mfd/max14577.c b/drivers/mfd/max14577.c
> > index 1d8104213b3e..224aba8c5b3f 100644
> > --- a/drivers/mfd/max14577.c
> > +++ b/drivers/mfd/max14577.c
> > @@ -20,6 +20,7 @@
> 
> <snip>
> 
> > +static void max14577_print_dev_type(struct maxim_core *maxim_core)
> > +{
> > +	u8 reg_data, vendor_id, device_id;
> > +	int ret = max14577_read_reg(maxim_core->regmap_muic,
> > +			MAXIM_MUIC_REG_DEVICEID, &reg_data);
> 
> I'm not a big fan of declaring variables whilst feeding them with
> function return values. Can you separate the two please?

Sure.

> 
> > +	if (ret) {
> > +		dev_err(maxim_core->dev, "Failed to read DEVICEID
> > register: %d\n",
> 
> I think this is too many chars.

OK.

> 
> > +				ret);
> > +		return;
> > +	}
> > +
> 
> <snip>
> 
> > -	ret = max14577_read_reg(maxim_core->regmap_muic,
> > -			MAXIM_MUIC_REG_DEVICEID, &reg_data);
> > -	if (ret) {
> > -		dev_err(maxim_core->dev, "Device not found on this channel: %d\n",
> > -				ret);
> > -		return ret;
> > +	if (np) {
> > +		const struct of_device_id *of_id =
> > +			of_match_device(max14577_dt_match, &i2c->dev);
> 
> Again this is a bit messy. Bring it down onto a separate line.

OK.

I'll send fixed version after grabbing more ACK-s for previous
rename-patches (this patch depends on them).

Best regards,
Krzysztof

