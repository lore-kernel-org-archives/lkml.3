Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025AbaLPVHR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 16:07:17 -0500
Received: from mail.csclub.uwaterloo.ca ([129.97.134.52]:35949 "EHLO
	mail.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbaLPVHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 16:07:16 -0500
From: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Date: Tue, 16 Dec 2014 16:07:14 -0500
To: Len Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH V2 0/2] ARM: omap5/dra7xx counter frequency fixes
Message-ID: <cover.1418762900.git.lsorense@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While trying to deal with errata i856 on the dra7xx I encountered some
obvious typos in the frequencies checked in timer.c, so those are being
fixed in case anyone ever tries to use one of them.

Also implement a fix for errata i856.  Without the fix the time on the
system will get ahead by 43 seconds per day if SYSCLK1 is 20MHz, which it
is on the EVM boards as well as the other boards I am currently aware of.
ntp declares that the system time drifts by over 500ppm (the maximum
ntp will tolerate).

To fix it, check the status register to determine if the 32.768KHz clock
source is real (driven by an external crystal) or emulated (SYSCLK1 /
610), and if it is emulated use the appropriate numerator and divisor
to make the fine master counter match the coarse master counter (which
is driven directly from the 32KHz clock (real or emulated) with a fixed
multiplier of 375 / 2).  Making the fine counter run at a frequency
different from the coarse counter is not an option, as the value in the
fine counter is updated to match the coarse counter if they ever get
out of sync.

With 19.2MHz installed on the board, the clock runs almost 5% slow.

With the change in place, ntp runs with a drift of around 3ppm on all
boards I have tried which is well within the spec of the crystals used
for SYSCLK1.

Even if the errata is fixed in future revisions of the chip, there is
still the option of someone purposely not connecting a 32.768KHz crystal
to save cost or board space, and relying on the emulated clock instead,
in which case this correction will still be necessary.

Len Sorensen (2):
  ARM: omap5/dra7xx: Fix frequency typos.
  ARM: dra7xx: Fix counter frequency drift for AM572x errata i856.

 arch/arm/mach-omap2/control.h |    4 ++++
 arch/arm/mach-omap2/timer.c   |   44 +++++++++++++++++++++++++++++++++++------
 2 files changed, 42 insertions(+), 6 deletions(-)

-- 
1.7.10.4
