Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792AbaLCRxo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 12:53:44 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:33853 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbaLCRxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 12:53:41 -0500
MIME-Version: 1.0
In-Reply-To: <20141203111518.GB1039@katana>
References: <1415261514-4051-1-git-send-email-addy.ke@rock-chips.com>
	<1417574237-4328-1-git-send-email-addy.ke@rock-chips.com>
	<20141203111518.GB1039@katana>
Date: Wed, 3 Dec 2014 09:53:40 -0800
X-Google-Sender-Auth: wf-odrmR2iFLoTWxZA2g2jwAqwU
Message-ID: <CAD=FV=X5inPWZakhgDX0dX=1CWXygEi3_AH9FVFWXYT3LZA5bg@mail.gmail.com>
Subject: Re: [PATCH v2] i2c: rk3x: fix bug that cause measured high_ns doesn't
 meet I2C spec
From: Doug Anderson <dianders@chromium.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Addy Ke <addy.ke@rock-chips.com>, Max Schwarz <max.schwarz@online.de>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Olof Johansson <olof@lixom.net>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Eddie Cai <cf@rock-chips.com>, Jianqun Xu <xjq@rock-chips.com>,
        Tao Huang <huangtao@rock-chips.com>, Chris <zyw@rock-chips.com>,
        =?UTF-8?B?5aea5pm65oOF?= <yzq@rock-chips.com>,
        han jiang <hj@rock-chips.com>, Kever Yang <kever.yang@rock-chips.com>,
        Lin Huang <hl@rock-chips.com>, caesar <caesar.wang@rock-chips.com>,
        Shunqian Zheng <zhengsq@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wolfram,

On Wed, Dec 3, 2014 at 3:15 AM, Wolfram Sang <wsa@the-dreams.de> wrote:
>
>> + - rise-ns : Number of nanoseconds the signal takes to rise (t(r) in i2c spec).
>> +          If not specified this is assumed to be the max the spec allows
>> +          (1000 ns for standard mode, 300 ns for fast mode) which might
>> +          cause slightly slower communication.
>> + - fall-ns : Number of nanoseconds the signal takes to fall (t(f) in the i2c0
>> +          spec).  If not specified this is assumed to be the max the spec
>> +          allows (300 ns) which might cause slightly slower communication.
>
> We already have those bindings from the designware driver:
>
>  - i2c-sda-hold-time-ns : should contain the SDA hold time in nanoseconds.
>  - i2c-scl-falling-time : should contain the SCL falling time in nanoseconds.
>  - i2c-sda-falling-time : should contain the SDA falling time in nanoseconds.
>
> Can you reuse them? Or do you really need a specific rise-time property?
> If so, please matche the style of the bindings above.

Ah, doh!  I should have thought to look for existing bindings.  Sorry
about that.  :(

If you don't read all the below, my belief is that we should simply
rename the strings in Addy's patch.  We should change "rise-ns" to
"i2c-scl-rising-time" and "fall-ns" to "i2c-scl-falling-time".
Wolfram: can you confirm this is OK?  I'm voting to leave the "-ns"
off the end of both to avoid asymmetry.

---

Details:

Hrm, we seem to need different parameters than designware i2c.  The
designware bus is specifying "i2c-sda-hold-time-ns".  On Rockchip i2c
we specify just the number of cycles that the clk line should be high
and the number of cycles that it should be low.  The adapter does the
rest of the work.  As I understand it, the data hold time on Rockchip
i2c is equal to half the low time, for instance.  That was indicated
by Addy who talked to the IC engineer.

Because of the above, I _think_ that means that specifying
"i2c-sda-hold-time-ns" is not appropriate for us, or at least not easy
to convert in a sane way.

We could add a "i2c-scl-hold-time-ns", but if I understand correctly I
think that the "rise-time" describes the hardware in a cleaner way.
If you specify the hold time then (I think) that it requires the user
to tweak it whenever he/she adjusts the bus speed.  In other words if
you have a bus and you decide to move it from running at 400kHz to
running at 300kHz (signal integrity issues?) or 100kHz, you need to
manually modify the hold time.  ...on the other hand the rise time is
a property of the hardware I think (size of resistor, etc).

For the falling times I guess we should use the "i2c-scl-falling-time"
and not list the "i2c-sda-falling-time" for now?  As per above the
controller takes in the high/low period of the clocks and figures out
the rest itself.  Possibly we will need to account for
i2c-sda-falling-time eventually, but maybe that can come later?


-Doug
