Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075AbaFBWo7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 18:44:59 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:54131 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981AbaFBWo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 18:44:56 -0400
From: Alex Elder <elder@linaro.org>
To: mturquette@linaro.org, mporter@linaro.org, bcm@fixthebug.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 0/7] clk: bcm: prerequisite and bus clock support
Date: Mon,  2 Jun 2014 17:44:51 -0500
Message-Id: <1401749098-10185-1-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently only peripheral clocks are supported for Broadcom platforms
that use Kona style CCUs for clocking.  This series adds support for
bus clocks as well.

One motivation for doing this is that there exist peripheral clocks
that cannot be configured without having first enabled a related bus
clock.  Adding bus clock support allows such peripheral clocks to be
usable.

This also imposes a new requirement, however--that the bus clock be
enabled *before* operating on the clock that depends on it.  For
this, we define the notion of a "prerequisite" clock.  If a clock
has a prerequisite specified, that prequisite clock will be prepared
and enabled at the beginning  of the dependent clock's ->prepare
method.  The prerequisite clock is similarly disabled and unprepared
at the end of the dependent clock's ->unprepare method.

These patches are based on Mike Turquette's current "clk-next"
branch.
    9ec2749 clk: qcom: Return error pointers for unimplemented clocks

They are available here:
    http://git.linaro.org/landing-teams/working/broadcom/kernel.git
    Branch review/bcm-bus-clk-v5

					-Alex

Version history:
v5  - All clocks get initialized the first time they are prepared.
    - A per-clock flag now avoids doing initialization more than once.
    - Prerequisite clocks get prepared and enabled in a dependent
      clock's prepare routine, *before* preparing the dependent.
    - No longer require nestable CCU write enable requests.
    - Dropped requirement that clock and prerequisite share CCU.
v4  - Remove boot-time initialization of clocks, opting instead to
      do this work when needed, via clock ->prepare method.
    - Prerequisite clocks are now prepared and enabled in a
      dependent clock's ->prepare method.
    - Use __clk_lookup() to get the prerequisite clock pointer.
    - ccu_write_enable() calls can now be nested
v3: - Deleted clk_lookup field from struct kona_clk.
    - Now use term "initialized" rather than "enabled".
v2: - Added field "p" to the previously unnamed prereq union.

Alex Elder (7):
  clk: kona: move some code
  clk: kona: don't init clocks at startup time
  clk: bcm281xx: add an initialized flag
  clk: bcm281xx: implement prerequisite clocks
  clk: bcm281xx: add bus clock support
  clk: bcm281xx: define a bus clock
  ARM: dts: add bus clock bsc3_apb for bcm281xx

 arch/arm/boot/dts/bcm11351.dtsi      |   3 +-
 drivers/clk/bcm/clk-bcm281xx.c       |  13 +-
 drivers/clk/bcm/clk-kona-setup.c     |  99 ++++++++++-
 drivers/clk/bcm/clk-kona.c           | 310 +++++++++++++++++++++++++----------
 drivers/clk/bcm/clk-kona.h           |  36 +++-
 include/dt-bindings/clock/bcm281xx.h |   3 +-
 6 files changed, 364 insertions(+), 100 deletions(-)

-- 
1.9.1

