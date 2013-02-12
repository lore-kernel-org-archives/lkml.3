Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761049Ab3BLAaN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 19:30:13 -0500
Received: from gate.crashing.org ([63.228.1.57]:52540 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760770Ab3BLAaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 19:30:11 -0500
Message-ID: <1360628974.17442.23.camel@pasglop>
Subject: Re: [PATCH] drivers/block/xsysace - replace
 in(out)_8/in(out)_be16/in(out)_le16 with generic iowrite(read)8/16(be)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Michal Simek <monstr@monstr.eu>, Geert Uytterhoeven <geert@linux-m68k.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, dahinds@users.sourceforge.net
Date: Tue, 12 Feb 2013 11:29:34 +1100
In-Reply-To: <201302111608.29304.arnd@arndb.de>
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com>
	 <201302111543.46196.arnd@arndb.de>
	 <CAHTX3dJ6pZWyGB=6T22wA_wR-Tqty+4Nywm84g_n4djTv-cT=g@mail.gmail.com>
	 <201302111608.29304.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-02-11 at 16:08 +0000, Arnd Bergmann wrote:
> I tend to disagree. You should never assume that a device is the same
> endianess as the the CPU, and you should try not to use the __raw_*
> accessors in device drivers either.
> 
> In particular, ARM can run both big- and little-endian even though
> big-endian is rarely used, so you need to know the endianess for
> the device you are talking to rather than assume that it knows
> what the CPU does at the time.

Part of the problem he might be having is that the way a device is wired
to the bus may be different depending on whether the CPU is running LE
or BE ... or rather should be (in order to preserve byte addresses).

However, not all logic out there might do it right, which means that you
may end up with the wrong wiring if you switch the core around in SW.

It depends how the ARM core operates vs. IO when switched between BE and
LE, does it keep the same lines doing byte 0 or does it keep the MSB/LSB
in the same place (and thus changes which lanes contain byte 0) ?

Depending on how the core does the mode change it may require a wiring
change of IO devices as well... If it changes where byte 0 is, then data
cycles must have the lanes reversed. If it changes where the MSB is,
then address cycles must have the lanes reversed.

I wouldn't be surprised if most SOC bus logic out there gets it wired up
for one and only one case.

Cheers,
Ben.


