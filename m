Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932251Ab3GQPOP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 11:14:15 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:33642 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746Ab3GQPON convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 11:14:13 -0400
MIME-Version: 1.0
In-Reply-To: <20130715190803.GG11600@type.youpi.perso.aquilenet.fr>
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
	<20130715190803.GG11600@type.youpi.perso.aquilenet.fr>
Date: Wed, 17 Jul 2013 17:14:13 +0200
Message-ID: <CANq1E4QicuuD6iSkR-TUp99QTaxq_FZGwing2w30=nN0cw5hpw@mail.gmail.com>
Subject: Re: [PATCH] Route kbd LEDs through the generic LEDs layer
From: David Herrmann <dh.herrmann@gmail.com>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        David Herrmann <dh.herrmann@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@linux-foundation.org>,
        jslaby@suse.cz, rpurdie@rpsys.net,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Evan Broder <evan@ebroder.net>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Matt Sealey <matt@genesi-usa.com>, Rob Clark <robdclark@gmail.com>,
        Niels de Vos <devos@fedoraproject.org>,
        linux-arm-kernel@lists.infradead.org,
        Steev Klimaszewski <steev@genesi-usa.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Mon, Jul 15, 2013 at 9:08 PM, Samuel Thibault
<samuel.thibault@ens-lyon.org> wrote:
> Hello,
>
> David Herrmann, le Mon 15 Jul 2013 17:03:08 +0200, a écrit :
>> > @@ -13,6 +13,10 @@
>> >         bool "Virtual terminal" if EXPERT
>> >         depends on !S390 && !UML
>> >         select INPUT
>> > +       select NEW_LEDS
>> > +       select LEDS_CLASS
>> > +       select LEDS_TRIGGERS
>> > +       select INPUT_LEDS
>>
>> This looks odd. Any dependency changes in the input-layer will break
>> this. But I guess that's what we get for a non-recursive "select". Hmm
>
> Yes, that's the issue.
>
>> I also think that the macros don't really simplify this. So:
>>   [VC_SHIFTLOCK] = { .name = "shiftlock", .activate =
>> kbd_lockstate_trigger_activate },
>> isn't much longer than:
>>   DEFINE_LOCKSTATE_TRIGGER(VC_SHIFTLOCK,  "shiftlock"),
>
> That makes it more than 80 columns, at least.

Indeed, I missed that.

>> > +       for (i = 0; i < ARRAY_SIZE(ledtrig_ledstate); i++)
>> > +               led_trigger_register(&ledtrig_ledstate[i]);
>> > +       for (i = 0; i < ARRAY_SIZE(ledtrig_lockstate); i++)
>> > +               led_trigger_register(&ledtrig_lockstate[i]);
>> > +
>>
>> This returns "int", are you sure no error-handling is needed?
>
> ATM only registering the same name several times can happen, and
> shouldn't ever happen. But better warn than be sorry, indeed.

Yepp, it also avoids ignoring any future errors that we might
introduce in led_trigger_register().

>> > + * Keyboard LEDs are propagated by default like the following example:
>> > + *
>> > + * VT keyboard numlock trigger
>> > + * -> vt::numl VT LED
>> > + * -> vt-numl VT trigger
>>
>> Nitpick: What's the reason for the syntax difference? "vt-numl" vs. "vt::numl"
>
> vt::numl is a clear LED classification convention. For triggers, I don't
> see a clear convention, but at least I have never seen "::", only "-".
> That makes me realize that for keyboard triggers I haven't introduced a
> prefix, and only used "scrollock", "numlock", etc. Perhaps
> "kbd-scrollock" etc. or (in phase with LEDs), "kbd::scrollock" etc.?

I understand. Due to lack of insight, I cannot really comment on that,
sorry. Just wanted to go sure you're aware of that. So feel free to
pick any of them.

Thanks
David
