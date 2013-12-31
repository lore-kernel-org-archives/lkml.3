Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105Ab3LaMMg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 07:12:36 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:41332 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752796Ab3LaMMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 07:12:34 -0500
X-Sasl-enc: lGUx/9bQkTfX+PkYSHne2S4t0GGjHVbsqOpeLSlPzKWZ 1388491953
Date: Tue, 31 Dec 2013 10:12:31 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Julian Andres Klode <jak@jak-linux.org>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        "open list:THINKPAD ACPI EXT..." 
	<ibm-acpi-devel@lists.sourceforge.net>,
        "open list:THINKPAD ACPI EXT..." 
	<platform-driver-x86@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [ibm-acpi-devel] [PATCH 1/4] thinkpad_acpi: Add support for
 controlling charge thresholds
Message-ID: <20131231121231.GB25729@khazad-dum.debian.net>
References: <1384178195-12218-1-git-send-email-jak@jak-linux.org>
 <1384178195-12218-2-git-send-email-jak@jak-linux.org>
 <20131230132915.GB24241@jak-x230>
 <20131230215843.GB4938@khazad-dum.debian.net>
 <20131230224045.GC4938@khazad-dum.debian.net>
 <20131231000115.GA28120@jak-x230>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131231000115.GA28120@jak-x230>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Dec 2013, Julian Andres Klode wrote:
> We might be able to work around this by simple setting stop = start
> if a new write causes the stop threshold to be below the start
> threshold. But this also seems ugly.

It is the safest way, but the correct pseudo-code would be, assuiming
unsigned:

when someone changes start:

if (start > 99)
	start = 99;
get_current_stop_treshold(&stop);
if (start > stop)
	stop = start + 1;
set_thresholds(start, stop);


when someone changes stop:

if (stop == 0 || stop > 100)
	stop = 100;
get_current_start_threshold(&start);
if (start > stop)
	start = stop - 1;
set_thresholds(start, stop);

And write the stop threshold mod 100 at the low-level "send thresholds to
the firmware" routine.

> Writing the value 0 effectively means setting the stop threshold to 100%.
> The EC itself does not accept the value 100. I don't know why they choose
> to implement it this way. So the code should not accept 0 as an input
> value and replace an input of 100 with 0.

Yes.  This behaviour exists since start/stop thresholds were first exported
outside the EC, in the X30 or thereabouts.

> > For thinkpads, I believe the EC firmware changes the other threshold so that
> > the boundary condition stop > start is always valid.  But I never tried it
> > with a direct EC write to validate this.  If it becomes important, I can
> > check -- but I'd still prefer to enforce sanity at the driver level just in
> > case.  Don't tempt the gremilins, for they live at boundary conditions and
> > their sleep is light indeed.
> 
> It does not seem to do this here.

Then it is best if we enforce it in the driver.  I've crashed thinkpad ECs
before, *don't tempt the gremilins* indeed.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
