Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751296Ab3DOLeX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 07:34:23 -0400
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:48144 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751018Ab3DOLeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 07:34:21 -0400
Message-ID: <516BE5AE.3020703@stericsson.com>
Date: Mon, 15 Apr 2013 13:34:06 +0200
From: =?ISO-8859-1?Q?Bengt_J=F6nsson?= <bengt.g.jonsson@stericsson.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: ab8500: Fix get_mode for shared mode regulators
References: <1365424274.21989.2.camel@phoenix> <516BB444.7010508@stericsson.com> <CAFRkauDHn88Y8cAemTNVCXW6WUVqvFfhw1iY174nepNymiU8Nw@mail.gmail.com> <CAFRkauDhqwcHtJU_uBf8wMmKr8DohHZnU6DNPBnzZhTp9-eBfg@mail.gmail.com>
In-Reply-To: <CAFRkauDhqwcHtJU_uBf8wMmKr8DohHZnU6DNPBnzZhTp9-eBfg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2013 10:50 AM, Axel Lin wrote:
>> My understanding is for shared mode regulators:
>> It can be in LP mode only when *BOTH* are in LP mode.
>> If only one of the regulator in HP mode, then *BOTH* should be in HP mode.
>> Did I misunderstand something?
Your understanding is correct.
> Let me put this issue this way:
>
> Current code behavior:
> get_mode() returns IDLE if only one lp_mode_req flag is true, but mode
> register value is HP.
>
> AB8540_LDO_ANAMIC1      AB8540_LDO_ANAMIC2      mode register
> get_mode() returns
> lp_mode_req=true        lp_mode_req=true        HP
> REGULATOR_MODE_NORMAL
> lp_mode_req=true        lp_mode_req=false       HP
> REGULATOR_MODE_IDLE
> lp_mode_req=false       lp_mode_req=true        HP
> REGULATOR_MODE_IDLE
> lp_mode_req=false       lp_mode_req=false       LP
> REGULATOR_MODE_IDLE
I think it looks like this:

AB8540_LDO_ANAMIC1      AB8540_LDO_ANAMIC2      mode register
get_mode() returns
lp_mode_req=true        lp_mode_req=true        LP
REGULATOR_MODE_IDLE     REGULATOR_MODE_IDLE
lp_mode_req=true        lp_mode_req=false       HP
REGULATOR_MODE_IDLE     REGULATOR_MODE_NORMAL
lp_mode_req=false       lp_mode_req=true        HP
REGULATOR_MODE_NORMAL   REGULATOR_MODE_IDLE
lp_mode_req=false       lp_mode_req=false       HP
REGULATOR_MODE_NORMAL   REGULATOR_MODE_NORMAL

> with this path:
> mode register value is consistent with get_mode().
>
> AB8540_LDO_ANAMIC1      AB8540_LDO_ANAMIC2      mode register
> get_mode() returns
> lp_mode_req=true        lp_mode_req=true        HP
> REGULATOR_MODE_NORMAL
> lp_mode_req=true        lp_mode_req=false       HP
> REGULATOR_MODE_NORMAL
> lp_mode_req=false       lp_mode_req=true        HP
> REGULATOR_MODE_NORMAL
> lp_mode_req=false       lp_mode_req=false       LP
> REGULATOR_MODE_IDLE

And like this:

AB8540_LDO_ANAMIC1      AB8540_LDO_ANAMIC2      mode register
get_mode() returns
lp_mode_req=true        lp_mode_req=true        LP
REGULATOR_MODE_IDLE     REGULATOR_MODE_IDLE
lp_mode_req=true        lp_mode_req=false       HP
REGULATOR_MODE_NORMAL   REGULATOR_MODE_NORMAL
lp_mode_req=false       lp_mode_req=true        HP
REGULATOR_MODE_NORMAL   REGULATOR_MODE_NORMAL
lp_mode_req=false       lp_mode_req=false       HP
REGULATOR_MODE_NORMAL   REGULATOR_MODE_NORMAL


I guess what you don't like with the current approach is that the driver returns REGULATOR_MODE_IDLE in some cases where the mode register is set to LP. But I think, with patch applied, the control may be wrong in some cases because the regulator framework will call get_mode and see that the mode is already correct and not call set_mode so lp_mode_req will not get updated. I realised my previous example was incorrect so here I describe another example:

0. Start condition:
ANAMIC1 is requested in LP mode (lp_mode_req=true) and ANAMIC2 is requested in HP mode (lp_mode_req=false).
So the mode register is set to HP.

1. Now ANAMIC1 is requested to HP mode from consumer side. The regulator framework checks the current mode with get_mode which returns HP. So the regulator framework returns without calling set_mode because the mode is already correct.
For ANAMIC1 lp_mode_req=true and for ANAMIC2 lp_mode_req=false (still).
The mode register will be correct at HP.

2. If ANAMIC2 is now requested to LP mode from consumer side, the regulator framework calls get_mode which returns HP, so the framework calls set_mode.
In set_mode, the function checks the other regulator's status which is lp_mode_req=true. So the function will continue and set the regulator in LP mode even if it should not be.

Bengt

