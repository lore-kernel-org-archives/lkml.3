Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659Ab3G2Pon (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 11:44:43 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:61546 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab3G2Pol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 11:44:41 -0400
MIME-Version: 1.0
X-Originating-IP: [114.40.27.17]
In-Reply-To: <20130729092809.GA319@Robin-OptiPlex-780>
References: <1375082774.7272.1.camel@phoenix>
	<CAFRkauB35ERLgakua7=Q+xoRx-N83BTD4f_8HyvbGjAxhEZvUg@mail.gmail.com>
	<20130729092809.GA319@Robin-OptiPlex-780>
Date: Mon, 29 Jul 2013 23:44:40 +0800
Message-ID: <CAFRkauCKMjNxZatNmOVc95XUuuDNzW0+7razK4tmHKwf+JyS0A@mail.gmail.com>
Subject: Re: regulator: pfuze100: A few small questions
From: Axel Lin <axel.lin@ingics.com>
To: Robin Gong <b38343@freescale.com>
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Current code adjust min_uV and uV_step when SW2~SW4 high bit is set.
>> I'm wondering if n_voltages is correct or not in this case because
>> the n_voltages is calculated by original equation (max-min/step + 1).
>> What is the max_uV when SW2~SW4 high bit is set?
>>
> If high bit set(bit6, bit0~5:vsel), min_uV/step will change from 0.4V/25mV to
> 0.8V/50mV,but the n_voltages will kept the same.
> For example,SW2 will vary from 0.4V to 1.975V(0x0~0x3f),if bit6 set 0(high bit)
> SW2 will vary from 0.8V to 3.3V(0x40~0x72,0x72~0x7f:reversed).
> Please ignore bit7 or consider it as 0.

Hi Robin,
According to your description:
BIT6 is clear: 0.4V ~ 1.975V , step 25mV (0x0~0x3f)
BIT6 is set:   0.8V ~ 3.3V, step 50mV    (0x40~0x72,0x72~0x7f:reversed)

For SW2/SW3A/SW3B/SW4:
I think current implementation is wrong.
The supported voltage range should cover the whole range: 0.4V ~ 3.3V.

You need to implement set_voltage_sel/get_voltage_sel:
For 0.4V ~ 1.975V, use 25mV step and clear BIT6.
For 2V ~ 3.3V, use 50mV step and set BIT6

And use regulator_list_voltage_linear_range / regulator_map_voltage_linear_range

Below list the register value and voltage mapping:

reg     volt    (reg with BIT6 is set)
================================
0x00    400000
0x01    425000
0x02    450000
0x03    475000
0x04    500000
...     ......
0x0e    750000
0x0f    775000
0x10    800000  (0x40)
0x11    825000
0x12    850000  (0x41)
0x13    875000
0x14    900000  (0x42)
0x15    925000
0x16    950000  (0x43)
0x17    975000
0x18    1000000 (0x44)
0x19    1025000
0x1a    1050000 (0x45)
0x1b    1075000
0x1c    1100000 (0x46)
0x1d    1125000
0x1e    1150000 (0x47)
0x1f    1175000
...     .......
0x3c    1950000 (0x57)
0x3f    1975000
        2000000 (0x58)
        2050000 (0x59)
        2100000 (0x5a)
        .....
        3300000 (0x72)

Regards,
Axel
