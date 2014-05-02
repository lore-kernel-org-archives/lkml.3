Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbaEBQNr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 12:13:47 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:62321 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722AbaEBQNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 12:13:40 -0400
MIME-Version: 1.0
In-Reply-To: <20140501012825.GI3245@sirena.org.uk>
References: <1398749704-10196-1-git-send-email-inderpal.s@samsung.com>
	<CAD=FV=Vo+GLTt7fh4639XFsJfSUTN0ARBsOy+O24gtB_87MgLw@mail.gmail.com>
	<20140501012825.GI3245@sirena.org.uk>
Date: Fri, 2 May 2014 09:13:39 -0700
X-Google-Sender-Auth: y64JkRA6kxY_XAdI_gBJaSR1PJ8
Message-ID: <CAD=FV=X5vGgZOxbRb808R9CSnGLPD9Tc77VMO5B3f3FS0jwk6Q@mail.gmail.com>
Subject: Re: [RFC PATCH] regulator: virtual: Introduce a new virtual locker
 regulator type
From: Doug Anderson <dianders@chromium.org>
To: Mark Brown <broonie@kernel.org>
Cc: Inderpal Singh <inderpal.s@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-pm@vger.kernel.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Pawel Moll <pawel.moll@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark,

On Wed, Apr 30, 2014 at 6:28 PM, Mark Brown <broonie@kernel.org> wrote:
> On Wed, Apr 30, 2014 at 11:56:08AM -0700, Doug Anderson wrote:
>
>> I cornered Rob and Mark Rutland a little bit about this at ELC today
>> (sorry!).  Neither of them was a huge ran of adding a pseudo device.
>> Rob suggested that Mark Brown might be the best person to give
>> direction here.  Mark Brown: any thoughts?
>
> I glanced at this briefly and couldn't really understand what it was
> supposed to do from a quick glance but I do tend to agree that it's too
> complex and confusing.  Quite what the virtual regulator is supposed to
> represent or how it is used is distinctly non-obvious.

>From my understanding, there are parts internal to the SoC where
something powered by the INT rail looks at an signal based on the ARM
rail, or vice versa.  If the two voltages are too vastly different
then you get into trouble.

To put numbers imagine the ARM rail at 1300 mV and the INT rail at 875
mV.  Something powered by the ARM rail will be looking at a signal,
and perhaps it decides that signals that are >= 1000 mV are high and
signals that are < 1000 mV are low.  If the INT rail is 875 mV then it
will never be able to signal a high.

The ARM and INT rails scale independently of each other.  The ARM rail
increases when the CPU frequency need to be fast.  The INT rail
increases when some internal peripherals on the system need to run
fast.  Imagine you're doing hardware assisted video decoding: you'd
want INT high and ARM low.  Imagine that you're running a
CPU-intensive game: you want INT low and ARM high.

The "solution" to the above (without redoing the SoC) is to make sure
that the INT and ARM rails are always within 300mV of each other.


>> Potentially we could also make this type of thing a core regulator property:
>
> Yes, that seems like the obvious solution if it's in the core.  Someone
> would need to write the code of course.

OK.  Inderpal: is this something you're willing to do?  I'd imagine
that all of the core code should remain the same, it's just a matter
of hooking it up properly.

Mark Brown: did the bindings above seem sane to you?  I can clean them
up a bit and explain more:

  buck2_reg: BUCK2 {
          regulator-name = "vdd_arm";
          regulator-min-microvolt = <800000>;
          regulator-max-microvolt = <1500000>;
          regulator-always-on;
          regulator-boot-on;
          regulator-op-mode = <1>;
          regulator-ramp-delay = <12500>;
          regulator-lock-to = <&buck3_reg>;
          regulator-lock-within-microvolt = <300000>;
 };
  buck3_reg: BUCK3 {
          regulator-name = "vdd_int";
          regulator-min-microvolt = <800000>;
          regulator-max-microvolt = <1400000>;
          regulator-always-on;
          regulator-boot-on;
          regulator-op-mode = <1>;
          regulator-ramp-delay = <12500>;
          regulator-lock-to = <&buck2_reg>, <&buck9_reg>;
          regulator-lock-within-microvolt = <300000>, <200000>;
  };

- regulator-lock-to: A list of regulators to monitor.  If they ever
are greater than our voltage + the corresponding "lock-within" then we
should bump up our voltage.  We'll bump back down if/when the
monitored regulator falls again.

- regulator-lock-within-microvolt: A list of microvolt values that
correspond to a phandle in the "regulator-lock-to" list.

Note that the above specification makes the locking a single
direction.  If it needs to be bidirectional you specify it in both
regulators.


-Doug
