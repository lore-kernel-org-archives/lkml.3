Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508AbaKYMK1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 07:10:27 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:59682 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbaKYMKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 07:10:25 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kevin Hilman <khilman@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robh+dt@kernel.org>, ssantosh@kernel.org
Subject: Re: [PATCH v4 1/2] ARM: keystone: pm: switch to use generic pm domains
Date: Tue, 25 Nov 2014 13:09:40 +0100
Message-ID: <2301239.aDOlWg3gEs@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <54746349.3000306@ti.com>
References: <1415631557-22897-1-git-send-email-grygorii.strashko@ti.com> <15074721.IbfeeI3ajE@wuerfel> <54746349.3000306@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:e84/LnWJzahYYauiz92jt35cN9fAyABksixmKFpKilh
 h2vb8Y6I2rjD4xxDOrcMOms6Ln2tRZbo2QziYq0S6zygBoVS/P
 ioLwNBqoGwoJnbKHUvwK3H4SX7FdhpJsq1g6klsZ3VsO5mC0hS
 NHESCzBnXnTMOyhL2hasJiAR0SJ1lNlsIDyJ2J1dsF2XT7Q8bv
 IECuAeV7F/2I0VkhHjnDjE8h3EeiuRapZUbgEFb47Zm/Tu12y1
 +/JmGaSj/iw8Zkf3rRaSDvp89+S87BWE0Bhoz00gly5vAnEyPD
 CVtDAOhoMtgoIL7U5vfcnDv0qYbiVA1IjlhVpx0qEjhWP5mtRg
 Twn6IaHpEbuZjwQIECGg=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 November 2014 13:08:57 Grygorii Strashko wrote:
> On 11/25/2014 12:33 PM, Arnd Bergmann wrote:
> > On Monday 24 November 2014 22:44:06 Mike Turquette wrote:
> >> Quoting Arnd Bergmann (2014-11-24 02:50:28)
> >>>
> > 
> > I'm not sure I even understand what you intended the example to look
> > like, it does't parse 
> > 
> > My point above was completely different, the suggestion I made was
> > to not classify the clocks in DT at all, but to leave it all in
> > the client driver.
> 
> I slept with this idea  From one side it sounds good. Pls, Correct me if I'm wrong:
> - there still will be "simple-pmdomain" and all devices will be attached to it by
>    default (or as specified in DT power-domains = <&simple_pmdomain>;);

I would assume only devices that set "power-domains = <&simple_pmdomain>"

> - drivers will use smth. like pm_clk_remove() to remove optional clocks from pm_clk;

Right. Regarding the naming of the function, I would pick something other
than remove, since the main purpose is not to have that clock abandoned
by the pm-domain code (this is still a side-effect), but to have the
clock put under control of the driver itself.

It might be possible to do this implicitly if the driver calls clk_get(),
basically doing clk_get() (or another call if necessary) would prevent the
simple pmdomain from turning it off during suspend.

> From another side:
> - drivers will get dependency from pm_clk;

There are three cases here:

- A device that is always used with a pm-domain, the driver doesn't
  have to worry about it but do need the dependency on having the
  simple-pmdomain code enabled.

- A device that may or may not have clocks, but if it has them, they
  are managed through a pm-domain. In this case, it's platform dependent
  whether we have the dependency. We may want to prevent the device from
  being probed if a power-domain property is present but no driver
  for the domain.

- A device that uses the pm-domain on some machines but not on others:
  this is a bit tricky, because the driver will still have to know
  about all the clocks, although we could choose not to turn off the
  clocks during suspend if the power-domain is not set.

> - HW limitations can't be taken into account - it's possible that some clocks should
>   not be enabled until it's allowed. And only driver know when it's allowed.
>   Otherwise, HW state may become unspecified or wrong output can be generated.

Correct: if you have a device that you don't want to be handled by a simple
pm-domain, then you have to connect it to a different pm-domain, e.g. one that
manages a fixed set of clocks itself.

	Arnd
