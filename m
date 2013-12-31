Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932363Ab3LaABW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 19:01:22 -0500
Received: from mail-bk0-f50.google.com ([209.85.214.50]:65333 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932246Ab3LaABV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 19:01:21 -0500
Date: Tue, 31 Dec 2013 01:01:15 +0100
From: Julian Andres Klode <jak@jak-linux.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Julian Andres Klode <jak@jak-linux.org>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        "open list:THINKPAD ACPI EXT..." 
	<ibm-acpi-devel@lists.sourceforge.net>,
        "open list:THINKPAD ACPI EXT..." 
	<platform-driver-x86@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] thinkpad_acpi: Add support for controlling charge
 thresholds
Message-ID: <20131231000115.GA28120@jak-x230>
Mail-Followup-To: Julian Andres Klode <jak@jak-linux.org>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
	Matthew Garrett <matthew.garrett@nebula.com>,
	"open list:THINKPAD ACPI EXT..." <ibm-acpi-devel@lists.sourceforge.net>,
	"open list:THINKPAD ACPI EXT..." <platform-driver-x86@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
References: <1384178195-12218-1-git-send-email-jak@jak-linux.org>
 <1384178195-12218-2-git-send-email-jak@jak-linux.org>
 <20131230132915.GB24241@jak-x230>
 <20131230215843.GB4938@khazad-dum.debian.net>
 <20131230224045.GC4938@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131230224045.GC4938@khazad-dum.debian.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 30, 2013 at 08:40:45PM -0200, Henrique de Moraes Holschuh wrote:
> On Mon, 30 Dec 2013, Henrique de Moraes Holschuh wrote:
> > On Mon, 30 Dec 2013, Julian Andres Klode wrote:
> > > On Mon, Nov 11, 2013 at 02:56:30PM +0100, Julian Andres Klode wrote:
> > > > Add support for battery charge thresholds in new Sandy Bridge and Ivy Bridge
> > > > ThinkPads. Based on the unofficial documentation in tpacpi-bat.
> > > > 
> > > > The threshold files support the values '0' for the controller's default,
> > > > and 1-99 as percentages. Values outside of that range are rejected. The
> > > > behaviour of '0' might be confusing, especially for the stop case where
> > > > it basically seems to mean '100'.
> > > 
> > > Thinking more about this, it might make more sense to simply accept a 100
> > > value and not accept a 0 value in the stop case (I tried multiple times to
> > > write 100 to a stop_charge_thresh file, because that feels more natural).
> > > 
> > > Having a 0 mean 100% is just odd. So stop_charge_thresh should simply
> > > accepts integer values in the range [1, 100] (and start_charge_thresh
> > > should continue accept [0, 99], as 0 really means 0 there).
> > 
> > Indeed.  Just return EINVAL for a stop threshold of 0.
> 
> Actually, a stop threshold below the current start threshold is also invalid
> and what happens when you try that is implementation-specific.  And the
> kernel is not the only party who can change the thresholds, so you have to
> read them if you really need to know the current value.

That's true. The problem is that if we forbid such values, the writes
will need to be done in a specific order. Let's say I have a system
with
	start=0		stop=50
and I want to change it to
	start=60	stop=80

If we return -EINVAL on a case stop < start, the only way to do this
is setting stop first and then start, because if we wrote start first,
then we would have: start > stop (because 60 > 50). But the error
message when doing it the wrong way around will not be very helpful
and I think it is confusing.

We might be able to work around this by simple setting stop = start
if a new write causes the stop threshold to be below the start
threshold. But this also seems ugly.


> To correct myself, stop threshold being zero is also implementation-
> specific. on thinkpads it is not valid.

Writing the value 0 effectively means setting the stop threshold to 100%.
The EC itself does not accept the value 100. I don't know why they choose
to implement it this way. So the code should not accept 0 as an input
value and replace an input of 100 with 0.

The exact value returned by the ACPI call is 0x80000000, that is, 
a signed 0 integer with sign bit set to 1. A set sign bit indicates
an error.

> 
> For thinkpads, I believe the EC firmware changes the other threshold so that
> the boundary condition stop > start is always valid.  But I never tried it
> with a direct EC write to validate this.  If it becomes important, I can
> check -- but I'd still prefer to enforce sanity at the driver level just in
> case.  Don't tempt the gremilins, for they live at boundary conditions and
> their sleep is light indeed.

It does not seem to do this here.

-- 
Julian Andres Klode  - Debian Developer, Ubuntu Member

See http://wiki.debian.org/JulianAndresKlode and http://jak-linux.org/.

Please do not top-post if possible.
