Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965163AbaLLDbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 22:31:46 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:33193 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383AbaLLDbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 22:31:44 -0500
MIME-Version: 1.0
In-Reply-To: <20141212002410.GB11764@sirena.org.uk>
References: <1418245085-9754-1-git-send-email-dianders@chromium.org>
	<20141210235347.GT11764@sirena.org.uk>
	<CAHNYxRy2t0OVj-+CqQFOfj0zWAGG0j8rmd8SxdNWgBMA2iAfXQ@mail.gmail.com>
	<20141211123106.GU11764@sirena.org.uk>
	<CAD=FV=U4RFYx9NXOACrXJZK2bKkosyYnmTZRHkXuaSz-FS9kNQ@mail.gmail.com>
	<20141211170934.GZ11764@sirena.org.uk>
	<CAD=FV=WBAuF0+BVMG9rp53Zt851Ou0kZ6xgTe9mjmgxyugWteg@mail.gmail.com>
	<20141212002410.GB11764@sirena.org.uk>
Date: Thu, 11 Dec 2014 19:31:43 -0800
X-Google-Sender-Auth: l5aUodO83HNbFYyprNcQQQYJp8c
Message-ID: <CAD=FV=W1r2MXNHXTRiO1pBPWurvgqq+dSoOPgpSJ_zAbpU7T4Q@mail.gmail.com>
Subject: Re: [PATCH 1/4] regulator: core: Support trying to get close to a
 certain voltage
From: Doug Anderson <dianders@chromium.org>
To: Mark Brown <broonie@kernel.org>
Cc: Alexandru Stan <amstan@chromium.org>, Ulf Hansson <ulf.hansson@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        Andrew Bresticker <abrestic@chromium.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark,

On Thu, Dec 11, 2014 at 4:24 PM, Mark Brown <broonie@kernel.org> wrote:
> On Thu, Dec 11, 2014 at 11:55:55AM -0800, Doug Anderson wrote:
>> On Thu, Dec 11, 2014 at 9:09 AM, Mark Brown <broonie@kernel.org> wrote:
>
>> > Please also bear in mind the need to handle shared supplies in your
>> > implementation.
>
>> I'm being dense, can you give more details?  Do you want me to grab
>> the mutex or do something smarter like track the voltage / tolerance
>> requested by multiple clients and resolve them, or ...?
>
> I mean the latter - what happens if more than one consumer is trying to
> use the regulator?  This is IIRC why _set_voltage_tol() uses the cheap
> and nasty implementation it does.

Ah, I see.  I don't think I've ever encountered a case where there
were two consumers for a regulator that actually requested voltages...

...but isn't regulator_set_voltage_tol() broken there?  If you have
two clients, A and B and a regulator that can go 1.0V to 5.0V in .05V
increments:

A requests 1.8V +/- .1V.  We get 1.8V
B requests 1.7V +/- .05V.

The above could be achievable with a voltage of 1.75V but it won't
work with the current regulator_set_voltage_tol() I think.


> There's also the potential
> performance considerations for the DVS type applications now I think
> about it.

Iterating through voltages is really that slow?  If so, perhaps we
could add some caching to keep track of what voltage we actually got
last time...  I could also add an optimization to try the exact
requested voltage right away...

-Doug
