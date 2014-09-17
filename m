Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585AbaIQTII (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 15:08:08 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:62506 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756006AbaIQTIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 15:08:05 -0400
Date: Wed, 17 Sep 2014 12:07:53 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: linux-kernel@vger.kernel.org, linux-cris-kernel@axis.com,
        Jesper Nilsson <jespern@axis.com>, Mikael Starvik <starvik@axis.com>,
        Grant Likely <grant.likely@linaro.org>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>
Subject: Re: Status of 'cris' architecture support in Linux kernel
Message-ID: <20140917190753.GA13115@roeck-us.net>
References: <20140831175010.GA15408@roeck-us.net>
 <20140915145203.GK4659@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140915145203.GK4659@axis.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 04:52:03PM +0200, Jesper Nilsson wrote:
> Hi Guenter,
> 
> Sorry for not answering earlier, like some have said in
> the thread followups, I have been on parental leave for quite some time.
> 
> On Sun, Aug 31, 2014 at 10:50:10AM -0700, Guenter Roeck wrote:
> > The idea was to create a crisv32 kernel and initramfs to work with qemu
> > for the ongoing Linux kernel test project.
> 
> A very ambitious goal. :-)
> 
> > After spending a number of days (and nights) on it, the results don't look
> > very encouraging.
> > 
> > My overall conclusion is that 'cris' architecture support in the Linux kernel
> > is in bad shape, does not work anymore, and would require substantial effort
> > to get it into working state.
> 
> Your conclusion is not completely off, but it could be better than it looks. :-)
> 
> I'll try to explain the state of the CRIS port as it currently stands:
> 
> (Background: CRIS port supports 3 different SoC:s, where the CRISv10 is
> older and subsequently less used. The other two are ETRAX FS and ARTPEC-3,
> which in principle share the same CPU-core (CRISv32) but contain some changes to
> the peripheral hardware IPs)
> 
> CRISv10 is only supported by me as a hobby project, AXIS does not have any
> current shipping units with this SoC, thus support for this is waning fast.
> QEMU support is not available for this SoC.
> Additionally, newer gcc assumes TLS support, which CRISv10 does not have,
> and older gcc:s yields an ICE (internal compiler error) on newer kernels.
> 
> Units with ETRAX FS is no longer actively upgraded by AXIS with newer kernels,
> and I have a problem testing anything other than the AXIS 88 developer board
> (Last relase of the SDK was a couple of years ago with the 2.6.32 kernel IIRC)
> which is not up to date, but at least have a lot in common with ARTPEC-3 and
> so is not so hard to support.
> 
> ARTPEC-3 support is not complete as some drivers are not included in upstream
> (ethernet and serial are the most notable ones) but is actually in best shape,
> we have 3.16 booting on real hardware in house.
> 
> I'll add the missing drivers and current patches we have locally to a
> git tree on git-hub, I'll get back to you on that.
> 
> It is also the ARTPEC-3 SoC that is implemented in QEMU unless I'm mistaken.
> 
> > Anyway, below are my individual findings. If there is an ongoing effort to
> > improve cris support in the upstream kernel, specifically support for crisv32,
> > please let me know. I'll be happy to test the resulting kernels.
> 
> Thank you for your work, I'll try to add some more information in the hope
> that this will at least help people google for more information.
> 
> Feel free to send me an email if you want to pick this up again.
> 

Just to give you an update. I "kind of" got an image to run with qemu
after applying the following patches.

8119d33 cris: Add basic qemu_defconfig
40d078b cris: time.c: Add missing include file to fix compile error
a4f2390 cris: Add dummy free_initrd_mem
88585aa cris: Add serial driver for Cris v32
a38d868 cris: Add support for early console

Let me know if you would like a copy of those patches. Out of those, 40d078b,
a4f2390, and a38d868 should be pretty much acceptable for upstream integration.
88585aa would need a lot of work (and probably a rewrite).

Compiler version is 4.7.4; 4.9.1 builds even after applying a number of upstream
patches, but the resulting image hangs. The weekly gcc snapshot fails to build.

The configuration is (I believe) derived from the configuration used for the
image available from the qemu web site. The same is true for the crisv32
serial driver and early console support. time.c needed an additional include
file (<linux/mm.h>). free_initrd_mem is needed to be able to build an image
with initrd support; it currently does nothing.

With this, I am able to get into a shell using a built-in initrd.

/ # uname -a
Linux (none) 3.16.2-00005-g8119d33 #40 Wed Sep 17 11:49:31 PDT 2014 crisv32 GNU/Linux

However, I see the following traceback.

------------[ cut here ]------------
WARNING: CPU: 0 PID: 186 at kernel/softirq.c:146 0xc000fd72()
Modules linked in:
CPU: 0 PID: 186 Comm: init Not tainted 3.16.2-00005-g8119d33 #40

Stack from c1cf9eb0:
       00000000 c02569d0 00000009 c0279f80 c1fda770 c1fa3680 c02574d6 c000cbb8
       00000092 c000fd72 00000200 c02d0d94 00000000 00000000 c000fd72 00000092
       c000cbea 00000000 c000fd72 c1f862d2 c1cdbc20 c01ff768 c1f862d2 c1f862d6
Call Trace: [<c02569d0>] [<c02574d6>] [<c000cbb8>] [<c000fd72>] [<c000fd72>] [<c000cbea>] [<c000fd72>]
       [<c01ff768>] [<c01ff908>] [<c016f83c>] [<c016fb10>] [<c006cfc0>] [<c025855a>] [<c006d0f4>] [<c001f212>]
       [<c0004b80>] [<c00054f0>]
---[ end trace 5bb306335a1f3b62 ]---

Manual symbol decode (this is from a 3.10 traceback, so the addresses
are a bit different):

c0234d8a	printk
c0012b0e	local_bh_enable
c0236004	dump_stack
c000ca4a	warn_slowpath_common
c000ca78	warn_slowpath_null
c0012b0e	local_bh_enable
c01e3c16	unix_release_sock
c01e3dae	unix_release
c015fb9a	sock_release
c015fe68	sock_close
c0067fae	__fput
c0237a20	_cond_resched
c0068168	____fput
c0022062	task_work_run
c0004954	do_notify_resume
c0005324	_work_notifysig

--> Further debugging shows that interrupts are disabled when this happens.

This traceback is seen from 3.10 onwards. 3.4 did not show the traceback; I did
not test any releases in between.

Guenter
