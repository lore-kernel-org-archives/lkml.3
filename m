Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679Ab3ANCoV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 21:44:21 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:53924 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754012Ab3ANCoU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 21:44:20 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Axel Lin <axel.lin@ingics.com>, "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/3] regulator-core: update all enable GPIO state in
	_enable/disable
Thread-Topic: [PATCH 2/3] regulator-core: update all enable GPIO state in
	_enable/disable
Thread-Index: AQHN8fhzdUVzsipdnka7A7zmYXiw6phIDtuA
Date: Mon, 14 Jan 2013 02:44:08 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E12A43@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F69E122AA@DQHE02.ent.ti.com>
 <20130113224220.GE5041@opensource.wolfsonmicro.com>
 <A874F61F95741C4A9BA573A70FE3998F69E12A0D@DQHE02.ent.ti.com>
 <20130114014239.GA29909@opensource.wolfsonmicro.com>
In-Reply-To: <20130114014239.GA29909@opensource.wolfsonmicro.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.87.185.78]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
> 
> So, clearly that's going to be the behaviour at the system level but
> the
> consumers aren't going to know that.  If the consumer supports some of
> the supplies being enabled and disabled separately then it will rely on
> the regulator core reference counting to keep the supply enabled if
> there are other reasons to do so.  This is how things would work if
> both
> supplies came from the same regulator so I'd expect us to preserve the
> same behaviour.

OK, the consumer just cares about the regulator(s) which is(are) obtained.
However it doesn't show exact state of regulator in case that enable GPIOs are
shared.
For example, LDO1 and LDO3 can be enabled by same GPIO pin.
But there are two separate regulator consumers, CA and CB.

(1) CA gets LDO1 regulator.
(2) CB gets LDO3 regulator.
(3) CA enables LDO1 (the GPIO goes to HIGH state)
    : Both LDO1 and LDO3 are enabled physically.
(4) CB also enables LDO3
    : But no GPIO state is changed because GPIO is already HIGH state.
(5) CA disables LDO1. LDO3 also is turned off eventually.
(6) CB tries to get the state of LDO3 before disabling it,
regulator_is_enabled() returns 1, but real state is 0.

	if(!regulator_is_enabled(rdev))
		regulator_disable(rdev);

	Therefore CB never disables LDO3, use_count is always 1.

This patch solves this unmatched situation.

But based on regulator behavior, I don't need to care this situation either.
A regulator consumer handles their *own* regulator(s).
Regulator APIs may show unmatched value, but it can be handled in each consumer 
driver *separately*.
Therefore, we should not update 'ena_gpio_state' of other regulators.
This patch should be ignored.
Is that correct?

Best Regards,
Milo



