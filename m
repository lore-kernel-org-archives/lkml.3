Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbaDOST6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 14:19:58 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:33600 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbaDOSTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 14:19:54 -0400
Date: Tue, 15 Apr 2014 20:19:45 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Ralf Baechle <ralf@linux-mips.org>, Josh Triplett <josh@joshtriplett.org>,
        Ingo Molnar <mingo@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        John Crispin <blogic@openwrt.org>
Subject: Re: [GIT] kbuild/lto changes for 3.15-rc1
Message-ID: <20140415181945.GA22608@ravnborg.org>
References: <20140408204906.GA3616@cloud>
 <CA+55aFzhyvZRPjXy7PkUxQO_AMqLSTehh-GNRP+Dx3yKnv-eCA@mail.gmail.com>
 <20140409013557.GA32556@tassilo.jf.intel.com>
 <20140409060133.GA6766@gmail.com>
 <20140409081709.GA283@x4>
 <20140414103205.GA2846@gmail.com>
 <20140415010003.GA2765@jtriplet-mobl1>
 <20140415093622.GB27556@linux-mips.org>
 <20140415111916.GA9390@ravnborg.org>
 <20140415113602.GB283@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140415113602.GB283@x4>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 01:36:02PM +0200, Markus Trippelsdorf wrote:
> On 2014.04.15 at 13:19 +0200, Sam Ravnborg wrote:
> > > 
> > > And while the code size reduction is less for MIPS than what others have
> > > reported for their platforms (I'm still investigating) is still is enough
> > > that embedded developers would commit murder for.
> > 
> > I have experimented a little with a patch that links all of vmlinux in one step.
> > I compared the text size of vmlinux without and with -ffunction-sections.
> > 
> > With a defconfig build on x86 (32 bit) I got following results:
> > 
> >                         size     difference
> > singlelink          10266506
> > function-sections    9487369         779137  7,5%
> > 
> > So this is a reduction of ~800 kb by enabling -ffunction-sections which
> > allows the linker to throw away unused sections.
> > 
> > I have not boot tested the kernel so chances are that too much was thrown out by the linker.
> > But this is an option that has much smaller cost to use than lto.
> > And seems to benefit nicely in size.
> > 
> > I have not tried this wihtout my singlelink patch - but I assume similar results.
> 
> No, it wouldn't work, because you cannot mix -r and --gc-sections (or
> gold's --icf (identical code folding)).
With make allnoconfig I see a 5% decrease in text size by applying -ffunction-sections.
This is with latest mainline and no other than the following applied:

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 602f57e..51bac0a 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -171,6 +171,8 @@ KBUILD_CFLAGS += -fno-asynchronous-unwind-tables
 KBUILD_CFLAGS += $(call cc-option,-mno-sse -mno-mmx -mno-sse2 -mno-3dnow,)
 KBUILD_CFLAGS += $(call cc-option,-mno-avx,)
 
+KBUILD_CFLAGS += -ffunction-sections
+
 KBUILD_CFLAGS += $(mflags-y)
 KBUILD_AFLAGS += $(mflags-y)
 

What can then explain this size difference?

	Sam
