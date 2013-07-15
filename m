Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957Ab3GOTIX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 15:08:23 -0400
Received: from toccata.ens-lyon.fr ([140.77.166.68]:51362 "EHLO
	toccata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140Ab3GOTIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 15:08:21 -0400
Date: Mon, 15 Jul 2013 21:08:03 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        Andrew Morton <akpm@linux-foundation.org>, jslaby@suse.cz,
        rpurdie@rpsys.net, linux-kernel <linux-kernel@vger.kernel.org>,
        Evan Broder <evan@ebroder.net>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Matt Sealey <matt@genesi-usa.com>, Rob Clark <robdclark@gmail.com>,
        Niels de Vos <devos@fedoraproject.org>,
        linux-arm-kernel@lists.infradead.org,
        Steev Klimaszewski <steev@genesi-usa.com>
Subject: Re: [PATCH] Route kbd LEDs through the generic LEDs layer
Message-ID: <20130715190803.GG11600@type.youpi.perso.aquilenet.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	David Herrmann <dh.herrmann@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Pavel Machek <pavel@ucw.cz>,
	Andrew Morton <akpm@linux-foundation.org>, jslaby@suse.cz,
	rpurdie@rpsys.net, linux-kernel <linux-kernel@vger.kernel.org>,
	Evan Broder <evan@ebroder.net>,
	Arnaud Patard <arnaud.patard@rtp-net.org>,
	Peter Korsgaard <jacmet@sunsite.dk>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Matt Sealey <matt@genesi-usa.com>, Rob Clark <robdclark@gmail.com>,
	Niels de Vos <devos@fedoraproject.org>,
	linux-arm-kernel@lists.infradead.org,
	Steev Klimaszewski <steev@genesi-usa.com>
References: <201011112205.oABM5KVJ005298@imap1.linux-foundation.org>
 <201011111440.07882.dmitry.torokhov@gmail.com>
 <20110102090935.GV32469@atrey.karlin.mff.cuni.cz>
 <20110102103210.GA25662@core.coreip.homeip.net>
 <20110102225741.GX5480@const.famille.thibault.fr>
 <20110112182702.GA9168@core.coreip.homeip.net>
 <20111114040613.GA4992@type.famille.thibault.fr>
 <20121221003449.GA6999@type.youpi.perso.aquilenet.fr>
 <20130707101028.GD5651@type.youpi.perso.aquilenet.fr>
 <CANq1E4TRAOp+=w4oqPt4sjV7iLyDygxxpwrZy7dSB8UK288aNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANq1E4TRAOp+=w4oqPt4sjV7iLyDygxxpwrZy7dSB8UK288aNA@mail.gmail.com>
User-Agent: Mutt/1.5.21+34 (58baf7c9f32f) (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

David Herrmann, le Mon 15 Jul 2013 17:03:08 +0200, a écrit :
> > @@ -13,6 +13,10 @@
> >         bool "Virtual terminal" if EXPERT
> >         depends on !S390 && !UML
> >         select INPUT
> > +       select NEW_LEDS
> > +       select LEDS_CLASS
> > +       select LEDS_TRIGGERS
> > +       select INPUT_LEDS
> 
> This looks odd. Any dependency changes in the input-layer will break
> this. But I guess that's what we get for a non-recursive "select". Hmm

Yes, that's the issue.

> I also think that the macros don't really simplify this. So:
>   [VC_SHIFTLOCK] = { .name = "shiftlock", .activate =
> kbd_lockstate_trigger_activate },
> isn't much longer than:
>   DEFINE_LOCKSTATE_TRIGGER(VC_SHIFTLOCK,  "shiftlock"),

That makes it more than 80 columns, at least.

> > +       for (i = 0; i < ARRAY_SIZE(ledtrig_ledstate); i++)
> > +               led_trigger_register(&ledtrig_ledstate[i]);
> > +       for (i = 0; i < ARRAY_SIZE(ledtrig_lockstate); i++)
> > +               led_trigger_register(&ledtrig_lockstate[i]);
> > +
> 
> This returns "int", are you sure no error-handling is needed?

ATM only registering the same name several times can happen, and
shouldn't ever happen. But better warn than be sorry, indeed.

> > + * Keyboard LEDs are propagated by default like the following example:
> > + *
> > + * VT keyboard numlock trigger
> > + * -> vt::numl VT LED
> > + * -> vt-numl VT trigger
> 
> Nitpick: What's the reason for the syntax difference? "vt-numl" vs. "vt::numl"

vt::numl is a clear LED classification convention. For triggers, I don't
see a clear convention, but at least I have never seen "::", only "-".
That makes me realize that for keyboard triggers I haven't introduced a
prefix, and only used "scrollock", "numlock", etc. Perhaps
"kbd-scrollock" etc. or (in phase with LEDs), "kbd::scrollock" etc.?

Samuel
