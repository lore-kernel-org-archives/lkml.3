Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936869Ab3DJJBL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 05:01:11 -0400
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:41162 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752709Ab3DJJBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 05:01:08 -0400
Message-ID: <51652A41.4080502@stericsson.com>
Date: Wed, 10 Apr 2013 11:00:49 +0200
From: =?UTF-8?B?QmVuZ3QgSsO2bnNzb24=?= <bengt.g.jonsson@stericsson.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: regulator: ab8500-ext: Strange set_mode behavior when info->cfg->hwreq
 is set
References: <1365519681.3946.4.camel@phoenix>
In-Reply-To: <1365519681.3946.4.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2013 05:01 PM, Axel Lin wrote:
> Hi,
>
> I see below code && comments in enable() function:
>
>          /*
>           * To satisfy both HW high power request and SW request, the regulator
>           * must be on in high power.
>           */
>          if (info->cfg && info->cfg->hwreq)
>                  *regval = info->update_val_hp;
>
>
> I'm not very clear about the comment and the code.
>
> 1) Does that mean the device does not allow set REGULATOR_MODE_IDLE when
> info->cfg->hwreq is set?
Yes.
> current code looks strange because when info->cfg->hwreq is set:
> set_mode() allows set REGULATOR_MODE_IDLE and get_mode() returns the status
> is REGULATOR_MODE_IDLE. However, current code actually write info->update_val_hp
> to the register (which means it is in REGULATOR_MODE_NORMAL mode).
>
> If the device does not allow set REGULATOR_MODE_IDLE when info->cfg->hwreq is
> set, we probably needs to return error in set REGULATOR_MODE_IDLE case.
I understand that this requires some explanation.

The ab8500 hardware supports a special hardwarerequest mode where the 
regulator can be automatically activated in HP mode by a HW signal. The 
same two register bits are used for setting this mode or to control the 
regulator between off/LP mode/HP mode:
- 0b00 = off,
- 0b01 = HP (high power) mode,
- 0b10 = HW request,
- 0b11 = LP (low power) mode.

So these external regulators are designed to be controlled by either HW 
request OR control from software. In practice, we had a case where we 
wanted to combine SW and HW requests and fall-back to HW request when 
there is no SW request dynamically. This is what the code aims to do: if 
the regulator is configured to support HW request, it may be set to HP 
at any time by HW signals. If a SW request is put on the regulator from 
the regulator framework, it must go to HP mode to satisfy requests from 
both HW and SW, LP mode is not sufficient.

I designed the code so that the regulator framework does not know about 
the HW request mode, as if this was handled by the hardware itself. In 
some cases, when the regulator framework requests LP mode and there is 
no HW request, we will set HP mode anyway. There is no way to avoid 
itfor the external regulators.
>
> Or 2) Does above comment mean the device needs set to REGULATOR_MODE_NORMAL
> when the regulator is switching from off to on? Which means it allows setting
> the regulator to REGULATOR_MODE_IDLE if the regulator is already on.
>
> If this is the case, we cannot call enable() in set_mode() because current code
> in set_mode() will write to register only when the regulator is already on.
> Calling enable() always write info->update_val_hp to the register.
> Thus it should just call abx500_mask_and_set_register_interruptible() directly
> to update the register.
I am not sure what you mean here. Maybe above comments answer your question.
>
> comments?
>
> Regards,
> Axel
>
I hope this clarifies. Regards,

Bengt
