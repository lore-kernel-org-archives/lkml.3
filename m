Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282AbaKRR77 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 12:59:59 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:56647 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865AbaKRR75 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 12:59:57 -0500
MIME-Version: 1.0
In-Reply-To: <20141117211410.25314.99324@quantum>
References: <1415884826-7877-1-git-send-email-kever.yang@rock-chips.com>
	<CAD=FV=WSDtxjtGD3c22OqXsSqaphKcmup9rAfonbeC-bUWHmSQ@mail.gmail.com>
	<20141114014102.25314.77218@quantum>
	<6053586.L6Ix8HgKpA@diego>
	<20141117211410.25314.99324@quantum>
Date: Tue, 18 Nov 2014 09:59:56 -0800
X-Google-Sender-Auth: R9gQkxZCERyt4f7rsj6hOc-pgPI
Message-ID: <CAD=FV=VZ+qPRdeTaAXxBU0aSObBRdY5TDmREYviuh8h3dUs5fQ@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] clk: add property for force to update clock setting
From: Doug Anderson <dianders@chromium.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Kever Yang <kever.yang@rock-chips.com>,
        Sonny Rao <sonnyrao@chromium.org>, Addy Ke <addy.ke@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Nov 17, 2014 at 1:14 PM, Mike Turquette <mturquette@linaro.org> wrote:
> Quoting Heiko Stübner (2014-11-14 10:06:47)
>> Hi Mike,
>>
>> Am Donnerstag, 13. November 2014, 17:41:02 schrieb Mike Turquette:
>> > Quoting Doug Anderson (2014-11-13 15:27:32)
>>
>> [...]
>>
>> > All of the above is to say that perhaps the solution to this problem
>> > belongs in the driver. In the end we're talking about details for
>> > correctly programming hardware, which sounds an awful lot like what
>> > drivers are supposed to do.
>> >
>> > Let me know if the ->init() callback holds any promise for you. If not
>> > we can figure something out.
>>
>> From my theoretical musings, ->init() sounds like a nice idea - but of
>> course it comes with a "but".
>>
>> I guess the general idea would be to have the pll clk-type simply reset
>> to the same rate but forcing it to use the parameters from its parameter
>> table - when the rate params differ [0].
>>
>> The only problem would be the apll supplying the cpu cores. After all clocks
>> are registered, our armclk makes sure that the core clock gets reparented
>> before changing the underlying apll [dpll is safe, as it is read-only currently].

DPLL probably won't be read only forever...


>> At the moment the order would be
>> clk_register(apll)
>> apll->init()
>> clk_register(armclk);
>
> Sorry, but I don't understand the problem. The at registration-time,
> apll is re-programmed to a correct value for its current rate. Then
> armclk is registered which might change apll's rate. Any change to the
> apll which is issued from armclk should insure that apll is programmed
> correctly.

I think Heiko is worried that until the "armclk" is registered that
nobody is there to reparent the ARM core to GPLL while APLL changes
(that's armclk's job).  This is potentially unsafe.

NOTE: it actually might not be unsafe, just slow.  I think we'll
actually swap the PLL into "slow" mode before changing it (24MHz) so
we won't die we'll just run at 24MHz at boot time while we wait for
APLL to re-lock.


One option would be to just add yet another per-pll parameter.  We'll
only cleanup CPLL, GPLL, and NPLL.  If APLL (ARM clock) and DPLL
(memory clock) are set differently by firmware then we're just SOL.
Of course if firmware boots us on GPLL then I guess we're back to
square one (would firmware really be that malicious?)

-Doug
