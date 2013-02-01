Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332Ab3BAR4d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 12:56:33 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:63124 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757045Ab3BAR4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 12:56:30 -0500
Date: Fri, 1 Feb 2013 12:56:26 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Cyril Chemparathy <cyril@ti.com>
cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sboyd@codeaurora.org, Will Deacon <will.deacon@arm.com>,
        paulmck@linux.vnet.ibm.com, Catalin Marinas <catalin.marinas@arm.com>,
        marc.zyngier@arm.com, linus.walleij@linaro.org
Subject: Re: [PATCH v4 00/13] ARM LPAE Fixes - Part 1
In-Reply-To: <510BE9BC.9090701@ti.com>
Message-ID: <alpine.LFD.2.02.1302011246080.6300@xanadu.home>
References: <1359669512-31276-1-git-send-email-cyril@ti.com> <alpine.LFD.2.02.1301312252230.6300@xanadu.home> <510BDAED.8060805@ti.com> <20130201151410.GR23505@n2100.arm.linux.org.uk> <510BE9BC.9090701@ti.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Feb 2013, Cyril Chemparathy wrote:

> On 02/01/2013 10:14 AM, Russell King - ARM Linux wrote:
> > On Fri, Feb 01, 2013 at 10:10:37AM -0500, Cyril Chemparathy wrote:
> > > With this, I ran simple network and filesystem performance tests to
> > > compare the code-patching vs. non-code-patching variants.  These tests
> > > didn't yield any significant performance difference between the two on
> > > an ARMv7 (Cortex-A8) platform.
> > 
> > It's not network and fs activity that this kind of stuff is likely to
> > show up in, but more to do with walking pages tables and the like -
> > remember that page tables are stored using physical addresses, and any
> > walks of them have to convert those physical addresses to virtual
> > addresses and back again.
> > 
> > So, things like page scanning for eviction (eg, page aging, page
> > faults even those which just re-use a page from the page cache) have
> > to use the v:p / p:v translation macros.
> > 
> 
> Thanks, Russell.  Any recommendations on how to best benchmark this?

Well, the benchmark issue can be side-stepped altogether.  We know that 
the assembly patching is the best thing that can be done, and we do have 
most of it already.

As previously stated, the p2v patching may remain essentially identical 
to what we have right now.  Since the result is a 32-bit value, the 
current code should just work.

On the v2p side, it's just a matter of adding two instructions around 
the existing one (which should be turned into an adds).  The first is a 
mov to load the high bits of PHYS_OFFSET which are likely to be 
representable with a simple immediate operand, and the third one would 
be a simple adc with #0 which doesn't need any patching.


Nicolas
