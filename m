Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495AbaLRRqE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 12:46:04 -0500
Received: from mail-vc0-f170.google.com ([209.85.220.170]:40602 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbaLRRqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 12:46:02 -0500
MIME-Version: 1.0
In-Reply-To: <1418325511-16648-1-git-send-email-dianders@chromium.org>
References: <1418325511-16648-1-git-send-email-dianders@chromium.org>
Date: Thu, 18 Dec 2014 09:46:00 -0800
X-Google-Sender-Auth: YpSW7wgnQtsHpfARXww39tM9zsc
Message-ID: <CAD=FV=Vt3q_7g=SmnV5ZCd-Evr_17BTMR9LWsFax8qOwtkSw6Q@mail.gmail.com>
Subject: Re: [PATCH] i2c: rk3x: Account for repeated start time requirement
From: Doug Anderson <dianders@chromium.org>
To: Wolfram Sang <wsa@the-dreams.de>, Max Schwarz <max.schwarz@online.de>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Addy Ke <addy.ke@rock-chips.com>, Lin Huang <hl@rock-chips.com>,
        yiwei cai <cyw@rock-chips.com>, Doug Anderson <dianders@chromium.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Dec 11, 2014 at 11:18 AM, Doug Anderson <dianders@chromium.org> wrote:
> On Rockchip I2C the controller drops SDA low in the repeated start
> condition at half the SCL high time.
>
> If we want to meet timing requirements, that means we need to hold SCL
> high for (4.7us * 2) when we're sending a repeated start (.6us * 2 for
> Fast-mode).  That lets us achieve minimum tSU;STA.  However, we don't
> want to always hold SCL high for that long because we'd never be able
> to make 100kHz or 400kHz speeds.
>
> Let's fix this by doing our clock calculations twice: once taking the
> above into account and once running at normal speeds.  We'll use the
> slower speed when sending the start bit and the normal speed
> otherwise.
>
> Note: we really only need the conservative timing when sending
> _repeated_ starts, not when sending the first start.  We don't account
> for this so technically the first start bit will be longer too.
> ...well, except in the case when we use the combined write/read
> optimization which doesn't use the same code.
>
> As part of this change we needed to account for the SDA falling time.
> The specification indicates that this should be the same, but we'll
> follow Designware and add a binding.  Note that we deviate from
> Designware and assign the default SDA falling time to be the same as
> the SCL falling time, which is incredibly likely.
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
> Note: This is based on Addy's patch (i2c: rk3x: fix bug that cause
> measured high_ns doesn't meet I2C specification) that can be found at
> <https://patchwork.kernel.org/patch/5475331/>.
>
>  Documentation/devicetree/bindings/i2c/i2c-rk3x.txt |  7 +-
>  drivers/i2c/busses/i2c-rk3x.c                      | 90 +++++++++++++++++-----
>  2 files changed, 74 insertions(+), 23 deletions(-)

So apparently the person who tested this for me got mixed up and told
me it was good, but it wasn't.  :(

I've sent up a new version.  I've tested it myself this time but
certainly would appreciate any extra testing folks can do on it...
See <https://patchwork.kernel.org/patch/5515551/>

-Doug
