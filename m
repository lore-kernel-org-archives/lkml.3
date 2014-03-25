Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798AbaCYUKg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 16:10:36 -0400
Received: from siggy.segv.de ([78.46.139.7]:40578 "EHLO siggy.segv.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752825AbaCYUKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 16:10:34 -0400
X-Greylist: delayed 2552 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Mar 2014 16:10:34 EDT
Date: Tue, 25 Mar 2014 20:27:59 +0100
From: Alexander Elbs <alex@segv.de>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        bonbons@linux-vserver.org
Subject: Re: mvsdio: unhandled interrupt, mmc writes queuing up
Message-ID: <20140325192759.GJ29769@segv.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.11.1403191221310.1291@knanqh.ubzr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Nicolas,

> On Wed, 19 Mar 2014, Bruno Prémont wrote:
> > Hi,
> > 
> > Since upgrading my Sheevaplug from 3.7.2 to 3.13.6 (FDT) I'm seeing
> >   mvsdio f1090000.mvsdio: unhandled interrupt status=0x8810 en=0x0000 pio=0
> > at varied timings.
>

I have the same problem on my sheevaplug.

> It has been many years since I've looked at the code for this driver.  
> I'm therefore including Thomas Petazzoni to the CC list as he appears to 
> have been the most active since then.
>
> The reported status seems to indicate missing data in the context of a 
> transfer with CMD12, and a CRC error ensued of course.
>
> At this point I'd suggest testing intermediate kernels between 3.7 and 
> 3.13, and try bisection until you find the offending commit.
>
> [...]
> > I get same results with 3.14-rc7.
>
> Excellent, that reduces the search space significantly.  You can do a 
> git bisect directly.

I did a git bisect.
  good: no message "unhandled interrupt"
  bad: message above appears
  skipped: unbootable kernel, usually stuck after the line "Uncompressing Linux". 

So far I am down to a few commits after 3.11.

$ git bisect view --oneline
2326f04 (refs/bisect/bad) ARM: kirkwood: convert to DT irqchip and clocksource
f07d73e ARM: dove: convert to DT irqchip and clocksource
cabbd6b (refs/bisect/skip-cabbd6bd15723ffa60f954f3a6c76dc45062289b) ARM: orion5x: update intc device tree node to new reg layout
15f1859 (refs/bisect/skip-15f18591d63fa78da87121ba0687fe1f4bcc5468) ARM: kirkwood: move device tree nodes to DT irqchip and clocksource
953b710 (HEAD) ARM: dove: move device tree nodes to DT irqchip and clocksource
497d3d0 (refs/bisect/skip-497d3d0f1899eeabdfe9c6e0095c162e72b6a6a6) ARM: orion5x: remove legacy mv643xx_eth board setup
c0f27f6 (refs/bisect/skip-c0f27f63db4a969dfdb2f135df1134da992c39fb) ARM: kirkwood: remove legacy clk alias for mv643xx_eth
a977e18 (refs/bisect/skip-a977e18e4cfc2ed73cc5bf05642f21323d9ec517) ARM: kirkwood: remove redundant DT board files
b4715df ARM: dove: remove legacy mv643xx_eth setup
99d6455 (refs/bisect/skip-99d6455b8ecbc7d29e279f66cde564998718e0ee) ARM: orion5x: add gigabit ethernet and mvmdio device tree nodes
876e233 ARM: kirkwood: add gigabit ethernet and mvmdio device tree nodes
4c3f6b8 ARM: dove: add gigabit ethernet and mvmdio device tree nodes

I hope this helps.



Full bisect log:
# bad: [5e01dc7b26d9f24f39abace5da98ccbd6a5ceb52] Linux 3.12
# good: [6e4664525b1db28f8c4e1130957f70a94c19213e] Linux 3.11
git bisect start 'v3.12' 'v3.11'
# good: [cc998ff8811530be521f6b316f37ab7676a07938] Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next
git bisect good cc998ff8811530be521f6b316f37ab7676a07938
# bad: [81a6fcae3ff3f6af1c9d7e31499e68fda2b3f58d] mm, hugetlb: clean-up alloc_huge_page()
git bisect bad 81a6fcae3ff3f6af1c9d7e31499e68fda2b3f58d
# bad: [c7c4591db64dbd1e504bc4e2806d7ef290a3c81b] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace
git bisect bad c7c4591db64dbd1e504bc4e2806d7ef290a3c81b
# skip: [8e73e367f7dc50f1d1bc22a63e5764bb4eea9b48] Merge tag 'cleanup-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc
git bisect skip 8e73e367f7dc50f1d1bc22a63e5764bb4eea9b48
# skip: [8dd21c93197cc465ae87e142435b3f7f262eade9] ARM: DRA7: Add the build support in omap2plus
git bisect skip 8dd21c93197cc465ae87e142435b3f7f262eade9
# good: [202127031a14f244c15ae4434993d36bd10a439c] powerpc/eeh: powerpc/eeh: Fix undefined variable
git bisect good 202127031a14f244c15ae4434993d36bd10a439c
# good: [f0d8e3f186a55ee2296f15e0e6c515beb8cefacf] ARM: dts: imx27-phytec-phycore-som: Using labels for reusing UART, I2C and FEC
git bisect good f0d8e3f186a55ee2296f15e0e6c515beb8cefacf
# good: [f2acf003cd399994172a5ec342b47741841746f1] ARM: debug: move keystone debug to generic 8250 code
git bisect good f2acf003cd399994172a5ec342b47741841746f1
# good: [2ce05a14bb379bd81ba3ad12cc08b2c4bda83480] ARM: ux500: fix devicetree builds
git bisect good 2ce05a14bb379bd81ba3ad12cc08b2c4bda83480
# good: [051168df528fe4456d63f5f65b041c147c26fe97] tile: don't assume user privilege is zero
git bisect good 051168df528fe4456d63f5f65b041c147c26fe97
# good: [8157107b13099d6eb2e8ccd00b9aba009c698c38] tilegx: support KGDB
git bisect good 8157107b13099d6eb2e8ccd00b9aba009c698c38
# good: [ebea60bee85fc043b02fd3438c381c28085eed69] ARM: msm: Move mach/board.h contents to common.h
git bisect good ebea60bee85fc043b02fd3438c381c28085eed69
# good: [9854a6f929956c9099dcc837157fd344f6f1c227] HID: hid-holtekff: don't push static constants on stack for %*ph
git bisect good 9854a6f929956c9099dcc837157fd344f6f1c227
# good: [dccfd1e439c11422d7aca0d834b0430d24650e85] Merge tag 'dt-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc
git bisect good dccfd1e439c11422d7aca0d834b0430d24650e85
# good: [b4b50fd78b1e31989940dfc647e64453d0f7176a] Merge tag 'soc-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc
git bisect good b4b50fd78b1e31989940dfc647e64453d0f7176a
# bad: [27c7651a6a5f143eccd66db38c7a3035e1f8bcfb] Merge tag 'gpio-v3.12-1' of git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio
git bisect bad 27c7651a6a5f143eccd66db38c7a3035e1f8bcfb
# bad: [293d0e3bf0818f3f7307a56d3ac31f41b5078aa1] Merge branch 'armsoc/for-3.12/soc' of git://github.com/broadcom/bcm11351 into next/boards
git bisect bad 293d0e3bf0818f3f7307a56d3ac31f41b5078aa1
# bad: [6b08e4370c0ffa57acfdb593d69306bbd6ca8b03] Merge tag 'renesas-defconfig-for-v3.12' of git://git.kernel.org/pub/scm/linux/kernel/git/horms/renesas into next/boards
git bisect bad 6b08e4370c0ffa57acfdb593d69306bbd6ca8b03
# bad: [4ddbed9618724d52a7a79c1e10ef5adb46fcccf7] Merge tag 'boards-3.12' of git://git.infradead.org/linux-mvebu into next/boards
git bisect bad 4ddbed9618724d52a7a79c1e10ef5adb46fcccf7
# bad: [2326f04321a9aec591c1d159b3a9d12c2bf89438] ARM: kirkwood: convert to DT irqchip and clocksource
git bisect bad 2326f04321a9aec591c1d159b3a9d12c2bf89438
# skip: [c0f27f63db4a969dfdb2f135df1134da992c39fb] ARM: kirkwood: remove legacy clk alias for mv643xx_eth
git bisect skip c0f27f63db4a969dfdb2f135df1134da992c39fb
# skip: [99d6455b8ecbc7d29e279f66cde564998718e0ee] ARM: orion5x: add gigabit ethernet and mvmdio device tree nodes
git bisect skip 99d6455b8ecbc7d29e279f66cde564998718e0ee
# skip: [497d3d0f1899eeabdfe9c6e0095c162e72b6a6a6] ARM: orion5x: remove legacy mv643xx_eth board setup
git bisect skip 497d3d0f1899eeabdfe9c6e0095c162e72b6a6a6
# skip: [15f18591d63fa78da87121ba0687fe1f4bcc5468] ARM: kirkwood: move device tree nodes to DT irqchip and clocksource
git bisect skip 15f18591d63fa78da87121ba0687fe1f4bcc5468
# skip: [a977e18e4cfc2ed73cc5bf05642f21323d9ec517] ARM: kirkwood: remove redundant DT board files
git bisect skip a977e18e4cfc2ed73cc5bf05642f21323d9ec517
# skip: [cabbd6bd15723ffa60f954f3a6c76dc45062289b] ARM: orion5x: update intc device tree node to new reg layout
git bisect skip cabbd6bd15723ffa60f954f3a6c76dc45062289b

Regards,
Alexander Elbs
