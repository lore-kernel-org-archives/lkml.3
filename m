Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032Ab3FCIAw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 04:00:52 -0400
Received: from mail.abilis.ch ([195.70.19.74]:26983 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903Ab3FCIAn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 04:00:43 -0400
Date: Mon, 3 Jun 2013 10:00:04 +0200
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Thomas Gleixner <tglx@linutronix.de>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>
Subject: Re: [PATCH V3] irqchip: Add TB10x interrupt controller driver (2)
Message-ID: <20130603080001.GA31808@ab42.lan>
References: <20130530211944.05F4D3E0A90@localhost>
 <1370014348-21121-1-git-send-email-christian.ruppert@abilis.com>
 <alpine.LFD.2.02.1305311835040.2905@ionos>
 <20130531221814.534DF3E08FE@localhost>
 <20130601110133.GA4051@ab42.lan>
 <51AC2A99.30709@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <51AC2A99.30709@synopsys.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 11:03:13AM +0530, Vineet Gupta wrote:
> On 06/01/2013 04:31 PM, Christian Ruppert wrote:
> > On Fri, May 31, 2013 at 11:18:14PM +0100, Grant Likely wrote:
> >> On Fri, 31 May 2013 19:32:34 +0200 (CEST), Thomas Gleixner <tglx@linutronix.de> wrote:
> >>> On Fri, 31 May 2013, Christian Ruppert wrote:
> [...]
> >> The loop above is mapping each of the
> >> interrupt inputs on the parent controller so that each child controller
> >> can be chained to it as an input. I can't think of how else it could be
> >> set up with the current code if the drivers were kept separate.
> > This is exactly the intention. I haven't found an easier way to do this
> > either but I'm open to suggestions.
> 
> But the child intc must only uplink to one parent intc IRQ line. In that
> case why do we need to enumerate the rest of them in code. Is that a
> limitation of framework or the parent intc (with it's legacy domain
> instantiation) is not doing something correct.

You are right, it would have been possible to "merge" several interrupt
sources onto the same ARC input. This is done (where required) further
down the interrupt controller hierarchy, however, and the way our
hardware is designed is that every input line of the tb10x-ictl controls
a separate output line. Every one of these output lines is connected to
a different ARC interrupt input. tb10x-ictl does not "merge" several
interrupts:

                      ...
                   |
               3 --+ 3
                   |
               4 --+ 4
       +-----+     |
   5 --+.....+-----+ 5
       |tb10x|     |     ARC770
   6 --+.....+-----+ 6
       |-ictl|     |
   7 --+.....+-----+ 7
       |     |     |
   8 --+.....+-----+ 8
       |     |     |
         ...          ...

> [...]
> >> If I were working on this system I'd drop the
> >> snps,arc700-intc node entirely and have a single abilis,tb10x-intc that
> >> encapsulated the properties of both (you would of course want to share
> >> handler functions for the 'normal' inputs without the custom features).
> >> That would eliminate the goofyness of listing 27 separate interrupts in
> >> the abilis,tb10x-ictl interrupts property.
> > To complicate things even further, some ARC CPU built-in peripherals
> > (e.g. timers) generate interrupts directly to the ARC built-in interrupt
> > controller (without going through the TB10x front-end), hence the
> > "goofy" list of interrupts in the TB10x DT node.
> 
> But I presume that this is common-place for cascaded intc setups - some
> peripherals hooking up directly to topmost intc would be normal. But it
> seems I'm not as educated in area as I really should be.

Yep, that's completely normal. But it forces us to tell the driver which
ones of the interrupts it must manage and which ones it should ignore.

Greetings,
  Christian

-- 
  Christian Ruppert              ,          <christian.ruppert@abilis.com>
                                /|
  Tel: +41/(0)22 816 19-42     //|                 3, Chemin du Pré-Fleuri
                             _// | bilis Systems   CH-1228 Plan-les-Ouates
