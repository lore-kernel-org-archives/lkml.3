Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034AbaILU1Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 16:27:16 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:51437 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbaILUZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 16:25:37 -0400
From: Suman Anna <s-anna@ti.com>
To: Ohad Ben-Cohen <ohad@wizery.com>, Mark Rutland <mark.rutland@arm.com>,
        Kumar Gala <galak@codeaurora.org>
CC: Tony Lindgren <tony@atomide.com>, Josh Cartwright <joshc@codeaurora.org>,
        Bjorn Andersson <bjorn@kryo.se>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Suman Anna <s-anna@ti.com>
Subject: [PATCHv6 0/5] hwspinlock core/omap dt support
Date: Fri, 12 Sep 2014 15:24:54 -0500
Message-ID: <1410553499-55951-1-git-send-email-s-anna@ti.com>
X-Mailer: git-send-email 2.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

This is an update to the hwspinlock dt support series. The series
is rebased onto v3.17-rc3, and addresses the review comments on the
previous v5 series. I have also split and left out the RFC patches
about the support for reserved locks (will post these as a separate
series) and return code convention changes in the hwspinlock core
(will not be needed anymore). The support for deferred probing of
clients is supported in the new of_hwspin_lock_get_id() function
itself.

Following are the main changes in v6 w.r.t v5:
- [Patch 1] Updated generic hwspinlock bindings after folding back
  the hwlock-base-id property from v5 Patch 8 [1]. [Patch 1]
- [Patch 4] Updated the common OF helpers patch based on review
  comments on v5. of_hwspin_lock_request_specific() is replaced
  with of_hwspin_lock_get_id(). of_hwspin_lock_simple_xlate() is
  made internal, and of_hwspin_lock_get_base_id() is added.
- [Patch 5] Updated the OMAP hwspinlock DT support patch to address
  review comments about hard-coded base-id, it is parsed from DT
  if present.
- Patches 2 and 3 are unchanged from previous version.
- Support patches for AM335x and AM437x SoCs (v5 patches 6 and 7)
  have been dropped as they are merged in separately for 3.17
- RFC patches (v5 patches 9 through 15) adding the concept of
  reserved locks and return code change convention dropped.

I had looked into dropping the patch to maintain the list of registered
spinlocks, but had to retain the patch as it was needed to perform the
validity of the args-specifier value in of_hwspin_lock_get_id().

The validation logs on all the applicable OMAP SoCs are at:
  OMAP4  - http://pastebin.ubuntu.com/8329228
  OMAP5  - http://pastebin.ubuntu.com/8329301
  DRA74x - http://pastebin.ubuntu.com/8329261
  AM33xx - http://pastebin.ubuntu.com/8329199
  AM43xx - http://pastebin.ubuntu.com/8329273

The above logs are generated with some additional test patches staged
here for reference:
https://github.com/sumananna/omap-kernel/commits/hwspinlock/test/3.17-rc3-dt-v6
https://github.com/sumananna/omap-kernel/commits/hwspinlock/submit/3.17-rc3-dt-v6

regards
Suman

[1] https://patchwork.kernel.org/patch/4096741/

---
v5:
http://marc.info/?l=linux-omap&m=139890478402807&w=2
- Rebased v4 patches plus additional RFC patches.
- Added back the patch to support DT-based hwlock-base-id property,
  for registration purposes.
- RFC patches introducing the concept of reserved locks.
- Staged patches for converting return convention to better support
  deferred probing of client drivers.

v4:
- The DT bindings are split into separate patches, and updated to
  add comments about #hwlock-cells
- Fixed a registration issue with repeated module installation and
  removal.
- Added a new OF helper to support #hwlock-cells in addition to the
  previous OF functions. The OMAP adaptation patch is updated to use
  the default translate function
- Updated hwspinlock documentation to adjust for the structure
  changes and the new api additions.
- Added build support for AM335x, AM43xx and DRA7xx
http://marc.info/?l=linux-omap&m=138965904015225&w=2

v3:
- Removed the DT property hwlock-base-id and associated OF helper
- Added changes in core to support requesting a specific hwlock using
  phandle + args approach
- Revised both the common and OMAP DT bindings document
http://marc.info/?l=linux-omap&m=138143992932197&w=2

v2:
- Added a new common DT binding documentation and OF helpers.
- Revised OMAP DT parse support to use the new OF helper (Patch2)
- OMAP5 hwspinlock support including the hwmod entry and DT node
- Add AM335x support to OMAP hwspinlock driver, including a fix
  needed in driver given that AM335 spinlock module requires s/w wakeup
- AM335 DT node for spinlock, and a hwmod change to enable smart-idle
  for AM335.
- OMAP4 DT node patch is unchanged
http://marc.info/?l=linux-omap&m=137944644112727&w=2

v1:
- Add DT parse support to OMAP hwspinlock driver
- Add OMAP4 DT node and bindings information
http://marc.info/?l=linux-omap&m=137823082308009&w=2

---

Suman Anna (5):
  Documentation: dt: add common bindings for hwspinlock
  Documentation: dt: add the omap hwspinlock bindings document
  hwspinlock/core: maintain a list of registered hwspinlock banks
  hwspinlock/core: add common OF helpers
  hwspinlock/omap: add support for dt nodes

 .../devicetree/bindings/hwlock/hwlock.txt          |  55 +++++++
 .../devicetree/bindings/hwlock/omap-hwspinlock.txt |  24 +++
 Documentation/hwspinlock.txt                       |  28 ++++
 MAINTAINERS                                        |   1 -
 arch/arm/mach-omap2/Makefile                       |   3 -
 arch/arm/mach-omap2/hwspinlock.c                   |  60 -------
 drivers/hwspinlock/hwspinlock_core.c               | 173 +++++++++++++++++++++
 drivers/hwspinlock/hwspinlock_internal.h           |   2 +
 drivers/hwspinlock/omap_hwspinlock.c               |  23 ++-
 include/linux/hwspinlock.h                         |  15 +-
 10 files changed, 312 insertions(+), 72 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/hwlock/hwlock.txt
 create mode 100644 Documentation/devicetree/bindings/hwlock/omap-hwspinlock.txt
 delete mode 100644 arch/arm/mach-omap2/hwspinlock.c

-- 
2.0.4

