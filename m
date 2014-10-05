Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108AbaJEWGI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 18:06:08 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:49229 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751798AbaJEWGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 18:06:06 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mark Rutland <mark.rutland@arm.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Aaron Lu <aaron.lu@intel.com>, Darren Hart <dvhart@linux.intel.com>
Subject: Re: [PATCH v3 04/15] ACPI: Document ACPI device specific properties
Date: Mon, 06 Oct 2014 00:26:08 +0200
Message-ID: <1562586.DiDBZ0QE8j@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <8634377.yRllsv0gms@wuerfel>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com> <6568619.UkU5qISONv@vostro.rjw.lan> <8634377.yRllsv0gms@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, October 04, 2014 12:59:59 PM Arnd Bergmann wrote:
> On Saturday 04 October 2014 02:13:23 Rafael J. Wysocki wrote:
> > > Because people get the format wrong regardless of documentation. The
> > > format:
> > > 
> > > Package () {
> > >       Package () { ^ref1, data, data },
> > >       Package () { ^ref2, data },
> > >       Package () { ^ref3, data, data, data },
> > > }
> > > 
> > > Is superior to the format:
> > > 
> > > Package () { ^ref1, data, data, ^ref2, data, ^ref3, data, data, data }
> > > 
> > > Because in the former you have delimiters that can be used to verify
> > > each tuple. Imagine someone misses a data element for one of these
> > > tuples. In the former layout you can detect this easily while in the
> > > latter you cannot.
> > 
> > I agree with this particular thing (although other people seem to have
> > problems with too many package nesting levels) but I'm not sure what that
> > has to do with the example given above (let me quote again):
> > 
> > > Putting everything to a single package results this:
> > > 
> > >       Package () { "pwms", Package () {"led-red", ^PWM0, 0, 10, "led-green", ^PWM0, 1, 10 }}
> > > 
> > > But I think the below looks better:
> > > 
> > >       Package () { "pwms", Package () {^PWM0, 0, 10, ^PWM0, 1, 10 }}
> > >       Package () { "pwm-names", Package () {"led-red", "led-green"}}
> > > 
> > > and it is trivial to match with the corresponding DT fragment.
> > 
> > that I was commenting.  Both cases contains the
> > 
> >         Package () { ^ref1, data, data, ^ref2, data, ^ref3, data, data, data }
> > 
> > format that you don't like, don't they?
> > 
> 
> There are two independent issues:
> 
> a) avoiding the need for "pwm-names" by embedding the name in the
>    "pwms" property
> 
> b) avoiding the need for "#pwm-cells" by having explicit separators between
>    entries in a "pwms" property.
> 
> It would be possible to do one but not the other.

OK

So aside from theorethical considerations it's good to look at what the
current code is doing in my opinion.

In the current patchset, acpi_dev_get_property_reference() is only used
in one place, which is acpi_get_gpiod_by_index().  That, in turn, is only
used by acpi_find_gpio() and by dev_get_named_gpiod_from_child() (and its
devm variant).  acpi_find_gpio() passes 0 as index (which means it only
cares about the first reference in the list) and the _get_named_gpiod_from_child()
thigs are used by leds-gpio and gpio-keys-polled.  Each of them also uses
0 as the index (so they only care about the first reference in the list as well).

Thus, arguably, acpi_dev_get_property_reference() in its current form is
sufficient for what we need at the moment.  There simply is no need to make
it more complicated right now and we can extend it in the future if need be.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
