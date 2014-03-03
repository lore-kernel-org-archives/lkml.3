Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316AbaCCLxs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 06:53:48 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:18734 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109AbaCCLxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 06:53:46 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-b5-53146d478bb5
Message-id: <1393847621.4267.8.camel@AMDC1943>
Subject: Re: [PATCH 3/3] regulator: s2mps11: Copy supported regulators from
 initconst
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mark Brown <broonie@kernel.org>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>
Date: Mon, 03 Mar 2014 12:53:41 +0100
In-reply-to: <20140303020933.GA2411@sirena.org.uk>
References: <1393581710-17754-1-git-send-email-k.kozlowski@samsung.com>
 <1393581710-17754-4-git-send-email-k.kozlowski@samsung.com>
 <20140303020933.GA2411@sirena.org.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsVy+t/xq7ruuSLBBvv38FtsnLGe1WLqwyds
	Fte/PGe1ONv0ht3i25UOJovLu+awWcw4v4/JYu2Ru+wWF1d8YbJYP+M1i8Xc342sFnOmv2Ny
	4PHYOesuu8emVZ1sHn1bVjF6fN4kF8ASxWWTkpqTWZZapG+XwJWx+9tRxoIZvBVXVn5kaWB8
	wtXFyMkhIWAi8eHHAhYIW0ziwr31bF2MXBxCAksZJb41nwRLCAl8ZpT498QfxOYV0JNYd/8z
	O4gtLBAucXD+HSYQm03AWGLz8iVsILaIgLLE1e97WUAGMQucY5Z4MaUbLMEioCrxY+FDoAQH
	B6eAkcS+e5oQy9YySqz7cJkVpIZZQF1i0rxFzBAXKUnsbu9kh4jLS2xe85YZ4ghBiR+T77FM
	YBSYhaRlFpKyWUjKFjAyr2IUTS1NLihOSs810itOzC0uzUvXS87P3cQIiYevOxiXHrM6xCjA
	wajEw2uwVDhYiDWxrLgy9xCjBAezkgivcKxIsBBvSmJlVWpRfnxRaU5q8SFGJg5OqQbGdYZl
	LAI9V/ruN1UsdL/ly+P70Wwtl/GB/C79LzptsY+v9UzXMjv11GeP6z27+kscFp8rtQSqmRw1
	Z27c/bJ3coJJ06vp0lkPTs2r7sve3xR3hLH0rcchq+4H8r8t62PNlV8HzlTeteLZtTSPE7+7
	tyU6aJ09/ez7xWXd7K2ZZvNqE5Rl1YuVWIozEg21mIuKEwEJ4Nz/ZQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2014-03-03 at 10:09 +0800, Mark Brown wrote:
> On Fri, Feb 28, 2014 at 11:01:50AM +0100, Krzysztof Kozlowski wrote:
> > Add __initconst to 'regulator_desc' array with supported regulators.
> > During probe choose how many and which regulators will be supported
> > according to device ID. Then copy the 'regulator_desc' array to
> > allocated memory so the regulator core can use it.
> 
> Applied, thanks.

Thanks! Unfortunately I wonder now whether it was a good idea to mark
the regulator_desc array as __initconst. I've seen the warning from
kbuild test robot:
--------
>> WARNING: vmlinux.o(.text+0xf0faab): Section mismatch in reference
from the function s2mps11_pmic_probe() to the
variable .init.rodata:s2mps11_regulators
   The function s2mps11_pmic_probe() references
   the variable __initconst s2mps11_regulators.
   This is often because s2mps11_pmic_probe lacks a __initconst
   annotation or the annotation of s2mps11_regulators is wrong.
--------

I have two ideas for fixing this:
1. The s2mps11_pmic_probe() could be marked with __init and 
platform_driver_probe() should be used. Unfortunately this does not work
because the driver is registered and probed a little later after
s2mps11_pmic_init() when I2C bus driver is probed. During that time the
drv->probe() is actually NULL.

2. The s2mps11_pmic_probe() won't be marked as __init and could copy the
regulator_desc (__initconst) array to local static variable. This way if
it would be called twice the mentioned array __initconst won't be
dereferenced. Unfortunately this won't remove the warning.

Any ideas for solving this?

Best regards,
Krzysztof





