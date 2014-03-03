Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471AbaCCQVF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 11:21:05 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:43761 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024AbaCCQVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 11:21:02 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-ca-5314abeb2538
Message-id: <1393863657.4267.17.camel@AMDC1943>
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
Date: Mon, 03 Mar 2014 17:20:57 +0100
In-reply-to: <1393847621.4267.8.camel@AMDC1943>
References: <1393581710-17754-1-git-send-email-k.kozlowski@samsung.com>
 <1393581710-17754-4-git-send-email-k.kozlowski@samsung.com>
 <20140303020933.GA2411@sirena.org.uk> <1393847621.4267.8.camel@AMDC1943>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsVy+t/xy7qvV4sEG9y9yW6xccZ6VoupD5+w
	WVz/8pzV4mzTG3aLb1c6mCwu75rDZjHj/D4mi7VH7rJbXFzxhcli/YzXLBZzfzeyWsyZ/o7J
	gcdj56y77B6bVnWyefRtWcXo8XmTXABLFJdNSmpOZllqkb5dAlfG/MNqBaf4K3p2HmBvYDzO
	08XIySEhYCLRNamREcIWk7hwbz1bFyMXh5DAUkaJbxN2sEA4nxklfnw9D1bFK6AvcX7bVBYQ
	W1ggXOLg/DtMIDabgLHE5uVL2EBsEQFliavf94I1MwucY5Z4MaUbLMEioCpxectWsAZOoEGv
	FnQyg9hCAhcYJdZ81AKxmQXUJSbNW8QMcZKSxO72TnaIuLzE5jVvmSGOEJT4MfkeywRGgVlI
	WmYhKZuFpGwBI/MqRtHU0uSC4qT0XCO94sTc4tK8dL3k/NxNjJB4+LqDcekxq0OMAhyMSjy8
	DlNEgoVYE8uKK3MPMUpwMCuJ8EbUAIV4UxIrq1KL8uOLSnNSiw8xMnFwSjUwiqy9wPJjRfyB
	zAk584zjFho+zv1+lu9yjjPr/69lepNy3Q8FXHwpnhVx+tKJkoPWJu5qdW03c26xtes8FDzC
	VFK6buNyzYsX1s5s43IQ/c19e7Yah9e0vCnG/vMecv/9yfGX8fmUrL1nJ+6SfjJ31ZSQOD/p
	99e+lS/cwFovZPB939xYvmvy/UosxRmJhlrMRcWJAMcrgfBlAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> Hi,
> 
> On Mon, 2014-03-03 at 10:09 +0800, Mark Brown wrote:
> > On Fri, Feb 28, 2014 at 11:01:50AM +0100, Krzysztof Kozlowski wrote:
> > > Add __initconst to 'regulator_desc' array with supported regulators.
> > > During probe choose how many and which regulators will be supported
> > > according to device ID. Then copy the 'regulator_desc' array to
> > > allocated memory so the regulator core can use it.
> > 
> > Applied, thanks.
> 
> Thanks! Unfortunately I wonder now whether it was a good idea to mark
> the regulator_desc array as __initconst. I've seen the warning from
> kbuild test robot:
> --------
> >> WARNING: vmlinux.o(.text+0xf0faab): Section mismatch in reference
> from the function s2mps11_pmic_probe() to the
> variable .init.rodata:s2mps11_regulators
>    The function s2mps11_pmic_probe() references
>    the variable __initconst s2mps11_regulators.
>    This is often because s2mps11_pmic_probe lacks a __initconst
>    annotation or the annotation of s2mps11_regulators is wrong.
> --------
> 
> I have two ideas for fixing this:
> 1. The s2mps11_pmic_probe() could be marked with __init and 
> platform_driver_probe() should be used. Unfortunately this does not work
> because the driver is registered and probed a little later after
> s2mps11_pmic_init() when I2C bus driver is probed. During that time the
> drv->probe() is actually NULL.
> 
> 2. The s2mps11_pmic_probe() won't be marked as __init and could copy the
> regulator_desc (__initconst) array to local static variable. This way if
> it would be called twice the mentioned array __initconst won't be
> dereferenced. Unfortunately this won't remove the warning.
> 
> Any ideas for solving this?

I sent a patch removing the __initconst. From my point of view these two
patches can be squashed, so effectively only choosing number of
supported regulators is introduced (as it was in my original patch from
11th of February).


Best regards,
Krzysztof

