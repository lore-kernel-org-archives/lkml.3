Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751142AbaLOWLH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 17:11:07 -0500
Received: from mail-vc0-f173.google.com ([209.85.220.173]:51097 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbaLOWLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 17:11:04 -0500
MIME-Version: 1.0
In-Reply-To: <20141212125951.GE11764@sirena.org.uk>
References: <1418245085-9754-1-git-send-email-dianders@chromium.org>
	<20141210235347.GT11764@sirena.org.uk>
	<CAHNYxRy2t0OVj-+CqQFOfj0zWAGG0j8rmd8SxdNWgBMA2iAfXQ@mail.gmail.com>
	<20141211123106.GU11764@sirena.org.uk>
	<CAD=FV=U4RFYx9NXOACrXJZK2bKkosyYnmTZRHkXuaSz-FS9kNQ@mail.gmail.com>
	<20141211170934.GZ11764@sirena.org.uk>
	<CAD=FV=WBAuF0+BVMG9rp53Zt851Ou0kZ6xgTe9mjmgxyugWteg@mail.gmail.com>
	<20141212002410.GB11764@sirena.org.uk>
	<CAD=FV=W1r2MXNHXTRiO1pBPWurvgqq+dSoOPgpSJ_zAbpU7T4Q@mail.gmail.com>
	<20141212125951.GE11764@sirena.org.uk>
Date: Mon, 15 Dec 2014 14:11:02 -0800
X-Google-Sender-Auth: 9pAPJ4rpvHi48f_jmeMDMXcl0xE
Message-ID: <CAD=FV=UfKAduhzs5-EJFZDgv-kv=rzMzuzT5N97ogdno66PqYw@mail.gmail.com>
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

On Fri, Dec 12, 2014 at 4:59 AM, Mark Brown <broonie@kernel.org> wrote:
>> > There's also the potential
>> > performance considerations for the DVS type applications now I think
>> > about it.
>
>> Iterating through voltages is really that slow?  If so, perhaps we
>> could add some caching to keep track of what voltage we actually got
>> last time...  I could also add an optimization to try the exact
>> requested voltage right away...
>
> Applications like DVS get pretty performance sensitive and for a
> regulator with high resolution if you're trying to hit a voltage at the
> top of the range you could be iterating over a hundred or more values.

OK, you've convinced me.  :)


> Perhaps doing something based on the various factorings out of the
> voltage mapping would do the trick, add a new op for getting to the
> closest voltage?

I'd really rather add a new op because I think it would mean that all
the old regulators that don't implement the op would be slow all of a
sudden.  :(


I looked at trying to refactor everything, but I think the answer is
that I should drop my patch and consider the existing
regulator_set_voltage_tol() experience good enough.  While I could go
through and try to make regulator_set_voltage_tol() better:

1. It fixes no issues that I know of.  On all boards that I've worked
with it is possible to make VMMC and VQMMC exactly equal.

2. As you said, regulator_set_voltage_tol() is on the critical path
for CPUfreq and the existing code is heavily optimized to work fast on
a large number of different types of regulators.  Trying to replicate
that without huge code duplication and without any bugs would be
difficult.


I'll spin my MMC patch to use regulator_set_voltage_tol().  If Ulf
responds and says that he'd like to more accurately specify the
min/max voltage then I'll post up a new function using a scheme like
regulator_set_voltage_tol() but asymmetric.


As always, thanks for your great feedback!

-Doug
