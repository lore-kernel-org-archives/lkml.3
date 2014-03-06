Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbaCFOmb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 09:42:31 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:52030 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936AbaCFOm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 09:42:27 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-8a-531889505af4
Message-id: <1394116942.25853.14.camel@AMDC1943>
Subject: Re: [PATCH 2/3] regulator: s2mps11: Add set_suspend_disable for S2MPS14
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mark Brown <broonie@kernel.org>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>
Date: Thu, 06 Mar 2014 15:42:22 +0100
In-reply-to: <20140306093826.GO13126@sirena.org.uk>
References: <1394011373-4057-1-git-send-email-k.kozlowski@samsung.com>
 <1394011373-4057-3-git-send-email-k.kozlowski@samsung.com>
 <20140306093826.GO13126@sirena.org.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPLMWRmVeSWpSXmKPExsVy+t/xK7oBnRLBBiue6llsnLGe1WLqwyds
	Fmeb3rBb3P96lNHi25UOJovLu+awWcw4v4/JYu2Ru+wWJ//0Mlqc7ma1uLjiC5PF+hmvWSzm
	TH/H5MDrsXPWXXaPTas62TzuXNvD5jHvZKBH35ZVjB6fN8kFsEVx2aSk5mSWpRbp2yVwZRza
	t5Cx4LpAxYHtm1kbGFfwdjFyckgImEgsbtrKCmGLSVy4t56ti5GLQ0hgKaPErY5ZLBDOZ0aJ
	3k8LgDIcHLwCBhKv1sSDNAgLBEisX/OJGcRmEzCW2Lx8CRuILSKgLHH1+16wXmaBV8wSD3ZP
	AkuwCKhKnNtzjBFkDidQw4SVkhDz1zBKHO04AzaIWUBdYtK8RcwQFylJ7G7vZIeIy0tsXvMW
	LM4rICjxY/I9lgmMArOQtMxCUjYLSdkCRuZVjKKppckFxUnpuYZ6xYm5xaV56XrJ+bmbGCGR
	8mUH4+JjVocYBTgYlXh4N/iJBwuxJpYVV+YeYpTgYFYS4ZWtlggW4k1JrKxKLcqPLyrNSS0+
	xMjEwSnVwMhbE1p54dj5JZdsJ4WJNJY3rrrnnjLFLamiylxhTsWcfcu6Ox3LbrnXvrjGyRam
	Eq5zcfE0idBlwYJL9qz8svS4x2/WbzqhXTw8QobbC6cY+ObYblBbd/i86F3tnQYKy56c7A28
	/e+kbruE+ZK1oRMW3xDYNCt1/1Y+Zi1GM4YnD5dH2593Wq3EUpyRaKjFXFScCACool26cgIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-03-06 at 17:38 +0800, Mark Brown wrote:
> On Wed, Mar 05, 2014 at 10:22:52AM +0100, Krzysztof Kozlowski wrote:
> 
> > +	ret = regmap_read(rdev->regmap, rdev->desc->enable_reg, &data);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	/*
> > +	 * Don't enable suspend mode if regulator is already disabled because
> > +	 * this would effectively for a short time turn on the regulator after
> > +	 * resuming.
> > +	 */
> > +	if (!(data & rdev->desc->enable_mask))
> > +		return 0;
> > +
> > +	return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
> > +			rdev->desc->enable_mask, S2MPS14_ENABLE_SUSPEND);
> > +}
> 
> What happens if the regulator gets enabled between this being called
> and the device suspending?  I'd expect this to be storing the state and
> then changing what gets written during enable and disable operations (if
> the hardware does what I think it does).

It seems that none of the regulators implementing set_suspend_disable()
work that way. They just write the suspend value to device. Of course
this is not an issue - the S2MPS14 may be the first :).

However in that case the driver won't be able later to change that value
back to "normal enable" (enable_mask). Consider such flow:
1. System is going to suspend.
2. Some regulator has "rstate->disabled" so set_suspend_disable() is
called on it.
3. The "suspend" value is written to the device for given regulator and
it is stored as "enable" value.
4. If regulator is enabled during here then the same "suspend" value
will be written.
5. System is suspended.
6. After resuming regulator_suspend_finish() calls
_regulator_do_enable() on the regulator... which will write the
"suspend" value because the driver cannot differentiate between this
enable and previous.

I assume that this may not be a problem because:
1. Regulator will be still turned on (the "suspend" value tells PMIC to
enable the regulator when SoC enables power).
2. The first disable of regulator may bring back "enable" value back to
normal mode.

Am I thinking here correctly? 


Best regards,
Krzysztof


