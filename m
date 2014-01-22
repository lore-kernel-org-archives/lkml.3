Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701AbaAVTTx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 14:19:53 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:48150 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbaAVTTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 14:19:51 -0500
X-Auth-Info: PMZ3B1MRCNWJuJQLYHDoC+lMoAgVl3/0ct7/UR/AfoQ=
Date: Wed, 22 Jan 2014 20:19:47 +0100
From: Gerhard Sittig <gsi@denx.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: Re: [PATCH 4/5] spi: Check that Quad/Dual is half duplex
Message-ID: <20140122191947.GQ20094@book.gsilab.sittig.org>
References: <1390317009-8292-1-git-send-email-geert@linux-m68k.org>
 <1390317009-8292-4-git-send-email-geert@linux-m68k.org>
 <20140121182130.GM17314@sirena.org.uk>
 <CAMuHMdWW1EsHe0u0o8XZuG4AzPKRqKL7ET5Ac2NkbeLRfW_foQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdWW1EsHe0u0o8XZuG4AzPKRqKL7ET5Ac2NkbeLRfW_foQ@mail.gmail.com>
Organization: DENX Software Engineering GmbH
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 21:06 +0100, Geert Uytterhoeven wrote:
> 
> On Tue, Jan 21, 2014 at 7:21 PM, Mark Brown <broonie@kernel.org> wrote:
> > On Tue, Jan 21, 2014 at 04:10:08PM +0100, Geert Uytterhoeven wrote:
> >> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
> >> Quad and Dual SPI Transfers use all available data lines
> >> (incl. MOSI/MISO), hence they must be half duplex. Add a
> >> check that verify that.
> >
> > This is surprising to me - I had expected that there would be
> > extra signals that would be used for these modes, not that
> > the opposite direction data line would be one of the ones
> > being reused.  On the other hand if this is what all the
> > flash chips do then it would seem reasonable that controllers
> > do the same.  Can you clarify please?
> 
> Dual SPI works by aggregating the MOSI and MISO lines for 2-bit
> unidirectional transfers.
> Quad SPI aggregates MOSI, MISO, and 2 additional lines for 4-bit
> unidirectional transfers.

Does it help to only use the MOSI/MISO names for single data line
transfers, and to explicitly mention the fact that multi data
line transfers change the signals' meaning to "IO0 .. IO3", and
that these "IOn" lines are used in half duplex ways?

> Hence Dual SPI uses the traditional 4-wire wiring, while Quad
> SPI uses 6-wire.

Be careful!  Just because the number of wires is identical, I
would not want to refer to it as "the traditional 4-wire wiring"
in the dual data line case.  Strictly speaking it's not that you
connect MISO+MOSI with MISO+MOSI, insted you connect IO0+IO1 with
IO0+IO1.  It just happens that the same pins are re-used, while
the signals do change their meaning.

Now add unidirectional transmitters (amplifiers and/or level
shifters) to the picture instead of mere wires, and you cannot
run all modes across these connections any longer as you may
assume at the moment.

IO2 and IO3 in quad data line mode do change the meaning of the
pins which they re-purpose, too (that's write protect and hold
usually).  Which is why the features of the SPI controller and
the flash chip alone may not be sufficient to determine which
modes are available, as the board may add constraints as well.

> SPI FLASH chips handle it this way, and the Renesas QSPI
> controller in the r8a7790/7791 SoCs, too.
> 
> Typically the first transfer in a message is a Single Transfer
> (e.g. read data command), while subsequent transfers can be
> Dual or Quad Transfers (e.g.  the actual data read from the
> FLASH).

Please note that subsequent transfers may be single data line
transfers as well. :)


BTW am I trying to be strict about the above implicit assumption
of "dual/quad" meaning the number of data lines.  To not confuse
them with dual data rate transfers, which are orthogonal to the
number of data lines in use, and are available in chips as well
(see the S25FL256S data sheet that was referenced in the Quad-SPI
discussion earlier).

Let's be clear from the beginning, to not have to cleanup or
guess afterwards.


virtually yours
Gerhard Sittig
-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr. 5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de
