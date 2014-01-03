Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505AbaACH4H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 02:56:07 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:36490 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaACH4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 02:56:06 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <CAOesGMhHw-G-T7ZfNsVU92ftOucCNe9shNJtA7SWzqX=dQBQng@mail.gmail.com>
References: <1388264507-5100-1-git-send-email-olof@lixom.net>
	<CAOesGMhHw-G-T7ZfNsVU92ftOucCNe9shNJtA7SWzqX=dQBQng@mail.gmail.com>
Date: Thu, 2 Jan 2014 23:56:04 -0800
Message-ID: <CAOesGMgsY0R6KBXXH_ibTBYb1i_auWESwnoDkvi-esb58Pc+2A@mail.gmail.com>
Subject: Re: [PATCH] powerpc: Fix alignment of secondary cpu spin vars
From: Olof Johansson <olof@lixom.net>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anton Blanchard <anton@samba.org>, Olof Johansson <olof@lixom.net>,
        chzigotzky@xenosoft.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 28, 2013 at 1:05 PM, Olof Johansson <olof@lixom.net> wrote:

> Sigh, it's not this after all. I did a clean build with this applied
> and still see failures. Something else is (also?) going on here.

Ok, so after some more digging I actually think that this isn't about
the new code added as much as it is about having more code in low
memory.

Before, there were only two instuctions in __start:

        b       .__start_initialization_multiplatform
        trap

Now, there's a whole bunch:

c000000000000000 <.__start>:
c000000000000000:       08 00 00 48     tdi     0,r0,72
c000000000000004:       48 00 00 24     b       c000000000000028 <.__start+0x28>
c000000000000008:       05 00 9f 42     .long 0x5009f42
c00000000000000c:       a6 02 48 7d     lhzu    r16,18557(r2)
c000000000000010:       1c 00 4a 39     mulli   r0,r0,19001
c000000000000014:       a6 00 60 7d     lhzu    r16,24701(0)
c000000000000018:       01 00 6b 69     .long 0x1006b69
c00000000000001c:       a6 03 5a 7d     lhzu    r16,23165(r3)
c000000000000020:       a6 03 7b 7d     lhzu    r16,31613(r3)
c000000000000024:       24 00 00 4c     dozi    r0,r0,76
c000000000000028:       48 00 95 84     b       c0000000000095ac
<.__start_initialization_multiplatform>
c00000000000002c:       7f e0 00 08     trap

And indeed, by replacing some of the LE hand-converted code with 0x0,
it seems that what's really making things blow up here is that 0x8-0xc
contain something else than 0x0.

Where/why this comes from I'm less certain of -- and since I seem to
no longer have a usable JTAG setup, I can't break in and see where the
code gets stuck and call paths, etc. So it's pure speculation, but I'm
guessing it's a null pointer dereference somewhere with a chained
pointer as the second member in a struct, i.e. with NULL the stray
null ptr deref does no harm.

Since it doesn't seem to impact pSeries, there's a chance that the bug
is in firmware, not in the kernel, since this seems to happen during
fairly early boot, i.e. possibly while grabbing the DT contents out.

This makes things interesting though. The BE/LE trampoline code
assumes at least 3 consecutive instructions. What was the reasoning
behind entering the kernel LE instead of keeping the old boot protocol
and just switching to LE once kernel is loaded? Is it actually used on
some platforms or is this just a theoretical thing?


-Olof
