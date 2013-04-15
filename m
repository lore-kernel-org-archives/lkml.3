Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935301Ab3DOIeT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 04:34:19 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:53398 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933813Ab3DOIeR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 04:34:17 -0400
MIME-Version: 1.0
X-Originating-IP: [114.39.99.165]
In-Reply-To: <516BB444.7010508@stericsson.com>
References: <1365424274.21989.2.camel@phoenix>
	<516BB444.7010508@stericsson.com>
Date: Mon, 15 Apr 2013 16:34:13 +0800
Message-ID: <CAFRkauDHn88Y8cAemTNVCXW6WUVqvFfhw1iY174nepNymiU8Nw@mail.gmail.com>
Subject: Re: [PATCH] regulator: ab8500: Fix get_mode for shared mode regulators
From: Axel Lin <axel.lin@ingics.com>
To: =?ISO-8859-1?Q?Bengt_J=F6nsson?= <bengt.g.jonsson@stericsson.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/15 Bengt Jönsson <bengt.g.jonsson@stericsson.com>:
> On 04/08/2013 02:31 PM, Axel Lin wrote:
>>
>> The special handling code for getting shared mode status is wrong
>> because it needs to check info->shared_mode->lp_mode_req for
>> both regulators that shared the same mode register.
>>
>> In set_mode(), current code ensures we won't set mode to
>> REGULATOR_MODE_IDLE
>> if only one of the regulator requests to set idle.
>>
>> In get_mode(), we can just remove the special handling code for shared
>> mode.
>> Read the register value always returns correct status no matter the
>> regulator
>> has shared mode register or not.
>
> I am not convinced about this patch. The purpose of the original code is
> that the regulator framework should be unaware that the mode register is
> shared with another regulator. If we apply this patch, get_mode may return
> different results depending on the other regulators mode settings.

No. Original code is just wrong.

First, take a look at ab8500_regulator_set_mode().
When setting REGULATOR_MODE_IDLE mode, current code will only write
the register to idle mode only when *both* shared regulator have set idle mode.

Which means if only one of the shared mode has set regulator to idle,
both should be still in NORMAL mode.

In ab8500_regulator_get_mode(), the special handling code only check it's own
lp_mode_req flag which is wrong. it needs to check both it's own lp_mode_req
and the other one shared mode regulator.
However, this patch makes things simpler by just remove these check.
Because set_mode ensures the register is set to IDLE only when *both*
shared regulator are in idle.

>
> Let me take an example: The other shared regulator is already set to LP mode
> and the current regulator is requested to low power mode. Then the framework
> first checks current mode and compares to requested mode. If equal, it
> returns. With this patch applied, it will see that the regulator is already
> set to LP mode and return without calling set_mode in the driver. However,
> the state information in the driver will be wrong so when the other
> regulator is requested to HP mode and back to LP mode it will not actually
> set LP mode again to HW.

I'm not sure if I understand this part.
My understanding is for shared mode regulators:
It can be in LP mode only when *BOTH* are in LP mode.
If only one of the regulator in HP mode, then *BOTH* should be in HP mode.
Did I misunderstand something?

Axel
