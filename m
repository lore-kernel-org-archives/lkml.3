Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643Ab3BEXIV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 18:08:21 -0500
Received: from gate.crashing.org ([63.228.1.57]:33782 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755962Ab3BEXIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 18:08:20 -0500
Message-ID: <1360105635.2707.7.camel@pasglop>
Subject: Re: [PATCH] drivers/block/xsysace - replace
 in(out)_8/in(out)_be16/in(out)_le16 with generic iowrite(read)8/16(be)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
Cc: Michal Simek <monstr@monstr.eu>, Arnd Bergmann <arnd@arndb.de>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        alan@lxorguk.ukuu.org.uk, geert@linux-m68k.org,
        dahinds@users.sourceforge.net
Date: Wed, 06 Feb 2013 10:07:15 +1100
In-Reply-To: <511178AC.7080304@synopsys.com>
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com>
	 <1781360.cmQWHCW5SC@wuerfel>
	 <CAHTX3dJpuTRa4Ff29k95quPMVDO2mBiayPoocnw5R15=5ovOHQ@mail.gmail.com>
	 <201302041724.47331.arnd@arndb.de> <1360031367.14701.47.camel@pasglop>
	 <CAHTX3dL4dScmzgGyqbvPH-7UQvFrjQhHu2zh0iZyzWB=spZS+Q@mail.gmail.com>
	 <1360066756.4529.6.camel@pasglop>
	 <CAHTX3dLJy314mv39hprkmZ5XdzYiYGz1ngTERp7w6aAYud+Riw@mail.gmail.com>
	 <51111133.7000105@synopsys.com> <1360098004.4529.13.camel@pasglop>
	 <511178AC.7080304@synopsys.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-06 at 01:25 +0400, Alexey Brodkin wrote:
> Sounds good but how should one tell which approach is correct? For 
> example here - is the one implemented by Xilinx is golden reference or
> not?

So I'm reading that PDF you pointed to. So far what I can see is:

 - In 8-bit mode you only do 8-bit accesses, so endianness should be
totally irrelevant (at least the pdf says so)

 - In 16-bit mode, that's where things become interesting... the doc
says:

  PLB Data Bus 		| System ACE Data Bus
  ----------------------+--------------------
  PLB_DBus[8 : 15]	| SysACE_MPD[15 : 8]
  PLB_DBus[0 : 7] 	| SysACE_MPD[7 : 0]

Now, I'm not 100% of the bit numbering used by Xilinx here but it smells
like PLB used ppc numbering and SystemACE use the classic numbering, in
which case the above would mean that the MSB of the PLB is connected to
the LSB of the SystemACE and vice-versa.

If that is the case then this is the *correct* wiring and means that the
data port (if any) doesn't need any byteswapping. It also means that the
registers need byteswap on BE, as expected for a LE device. IE. Just
always use ioread32 (or _rep variants for the data port if there's such
a thing on it).

So that looks good... unless I misunderstood the Xilinx spec, this looks
like the right way to do and the only one we should support.

The various other mentions in the text of "bit swapping" vs "byte swapping"
and reference to SW swapping are all just very confused which makes me
think that while the wiring up ended up being correct, this is in part
by accident (or whoever wrote the doc didn't understand what this is
all about).

So is there a known implementation that gets it backward ? Unless it's
a very popular and very useful one to support I would advocate just
not doing so.

Cheers,
Ben.


