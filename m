Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596AbaBXKdv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 05:33:51 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48672 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbaBXKdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 05:33:50 -0500
Message-ID: <1393237988.3091.14.camel@pizza.hi.pengutronix.de>
Subject: Re: [PATCH v2 0/6] ARM: STi reset controller support
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Maxime Coquelin <maxime.coquelin@st.com>
Cc: srinivas kandagatla <srinivas.kandagatla@st.com>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, kernel@stlinux.com,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Olof Johansson <olof@lixom.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, stephen.gallimore@st.com,
        Rob Herring <robh+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Rob Landley <rob@landley.net>, Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Date: Mon, 24 Feb 2014 11:33:08 +0100
In-Reply-To: <5304B849.2080806@st.com>
References: <1389696613-19683-1-git-send-email-srinivas.kandagatla@st.com>
			<1391437665-11913-1-git-send-email-srinivas.kandagatla@st.com>
		<1391592486.11239.4.camel@pizza.hi.pengutronix.de>
	 <52F4D76F.8070301@st.com> <5304B849.2080806@st.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:ca9c:dcff:febd:f1b5
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxime,

Am Mittwoch, den 19.02.2014, 14:57 +0100 schrieb Maxime Coquelin:
> Hi Philipp,
> 
> On 02/07/2014 01:54 PM, srinivas kandagatla wrote:
> > Hi Philipp,
> > Thankyou for looking at the patches.
> >
> >
> > On 05/02/14 09:28, Philipp Zabel wrote:
> >> Hi Srinivas,
> >>
> > ...
> >>
> >> the patchset looks good to me for the soft resets. But for the powerdown
> >> bits I am wondering whether the reset controller API is the right
> >> abstraction. Depending on whether those bits really just put the IPs
> >> into reset or there is some power gating / sequencing involved,
> >> shouldn't this rather be handled as a set of pm domains?
> >
> > The hardware name of these control signals into the devices is
> > slightly unfortunate and a bit misleading. We do not generally
> > have separate power domains for peripheral devices in our
> > current STB SoCs, in the sense that the voltage cannot actually be
> > removed from individual devices. In the USB case we believe the
> > powerdown signals internally gate off two of the three
> > incoming clocks to most of the USB controller's logic blocks,
> > essentially holding the device in a disabled (enable/disable
> > might have been a better name for the signal) state.
> >
> > The primary requirement to manipulate these signals is to bring
> > the device out of its cold boot default powerdown/disabled/reset
> > (whatever you want to call it) state when the device is probed or
> > after a SoC wide power loss when resuming from PM_SUSPEND_MEM.
> >
> >
> >> I see that for example on STiH415 there are both soft resets and
> >> powerdown bits for USB[012].
> >
> > Our IPs typically have two or sometimes three signals going into
> > them, controlled from outside of the IP block itself (typically using
> > SoC global system configuration registers) that you could view
> > as "reset-a-like"; that is toggling each of the signals puts the IP
> > into a state where it is in some way unusable and then back to
> > being useable again. The reset controller API appeared to be the
> > natural abstraction for the drivers to be given access to such control
> > signals, regardless of the precise effect the signals have on the
> > device's internal state.
> >
> > With regards to sequencing between these signals; it is the case that
> > there is a likely sequencing because at least in the USB case it is
> > thought that the "powerdown" stops the clock going to the reset chain
> > logic. But we did not see that as an issue as the reset controller
> > framework allows for multiple named "reset" lines being defined for
> > a device through its DT attributes. The driver knows which signal
> > is which and what each does, because it asks for them by name;
> > therefore, it knows how to impose any required ordering when changing
> > the state of those signals.
> >
> 
> Did Srini's explanations convinced you?
> 
> If so, could you queue the series for v3.15?

to be honest, I'm not comfortable with this explanation. If the
"powerdown" bits only gate the clocks to those modules, calling it a
reset control is clearly the wrong abstraction. If that is the case,
couldn't you handle those bits via the clock framework?
If on the other hand these powerdown bits also trigger reset machinery,
such that asserting and deasserting that bit will change the module's
internal state, I could be convinced to queue them like this.

regards
Philipp

