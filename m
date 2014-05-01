Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682AbaEAAfb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 20:35:31 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56614 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbaEAAfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 20:35:23 -0400
From: Suman Anna <s-anna@ti.com>
To: Ohad Ben-Cohen <ohad@wizery.com>, Mark Rutland <mark.rutland@arm.com>,
        Kumar Gala <galak@codeaurora.org>
CC: Tony Lindgren <tony@atomide.com>, Josh Cartwright <joshc@codeaurora.org>,
        Bjorn Andersson <bjorn@kryo.se>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Suman Anna <s-anna@ti.com>
Subject: [PATCHv5 00/15] hwspinlock/omap dt support
Date: Wed, 30 Apr 2014 19:34:21 -0500
Message-ID: <1398904476-26200-1-git-send-email-s-anna@ti.com>
X-Mailer: git-send-email 1.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

This is a refresh/update of the hwspinlock dt support series. The
series is rebased onto v3.15-rc3, and adds 8 new patches (RFC) to
handle various discussion points arised on v4.

Following are the main changes in v5:
- Base DT patches (Patches 1 to 7, except for 4) are identical to v4.
  Patch4 is updated to remove some traces and fix --strict checkpatch warnings.
- Patch 8 brings back the DT-based hwlock-base-id property, for registration
  purposes. Based on v4 discussion [1].
- Patches 9 through 13 introduce the concept of reserved locks, again based
  on the discussion in v4 [1]. The approach taken here is simplistic, each
  hwlock is assigned a type attribute during registration, with the _request_
  apis honoring the lock type attribute.
- Staged patches 14 & 15 for converting return convention to better
  support deferred probing of client drivers. I do think that it is
  still a good idea to return ERR_PTRs (unconcluded discussion in v4 [2]).
  The main advantage is to support deferred probing for DT boots. The
  original argument/change for returning NULL pointers pre-dates both
  the deferred driver probe mechanism and DT-based boot, so it may be
  moot on the current kernel.

I have marked the new patches as RFC, and should ideally be dealt
with as a separate series. I have added these to this series as
they also add couple of DT-based properties, as well as maintain the
discussion context from the previous series. I am ok for the reserved
lock patches to be left out for 3.16 merge window if these patches still
need some work. I am hoping to have the first 7 or 8 patches (and
finalized return code changes) to make it to 3.16.

The validation logs on all the applicable OMAP SoCs are at:
  OMAP4  - http://slexy.org/view/s2MMyLZTiH 
  OMAP5  - http://slexy.org/view/s20U2ElygK 
  DRA74x - http://slexy.org/view/s20fAoWJ84
  AM33xx - http://slexy.org/view/s2HLj2b406 
  AM43xx - http://slexy.org/view/s2JNrJSWLm 

The above logs are generated with some additional test patches staged
here for reference (not for merging)
https://github.com/sumananna/omap-kernel/commits/hwspinlock/3.15-rc3-v5
https://github.com/sumananna/omap-kernel/commits/hwspinlock/3.15-rc3-v5-test

regards
Suman

[1] http://marc.info/?l=linux-omap&m=139510004009415&w=2
[2] http://marc.info/?l=linux-omap&m=139490475424338&w=2

---
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

Suman Anna (15):
  Documentation: dt: add common bindings for hwspinlock
  Documentation: dt: add the omap hwspinlock bindings document
  hwspinlock/core: maintain a list of registered hwspinlock banks
  hwspinlock/core: add common OF helpers
  hwspinlock/omap: add support for dt nodes
  hwspinlock/omap: enable module before reading SYSSTATUS register
  hwspinlock/omap: enable build for AM33xx, AM43xx & DRA7xx
  hwspinlock/core: add support for base id in DT
  hwspinlock/core: prepare unregister code to support reserved locks
  hwspinlock/core: prepare core to support reserved locks
  hwspinlock/core: add support for reserved locks
  hwspinlock/core: add OF helper to parse reserved locks
  hwspinlock/omap: use OF helper to get reserved locks
  hwspinlock/core: return ERR_PTRs on failure in _request_ api
  hwspinlock/core: change return codes of_hwspin_lock_request_specific

 .../devicetree/bindings/hwlock/hwlock.txt          |  61 +++++
 .../devicetree/bindings/hwlock/omap-hwspinlock.txt |  24 ++
 Documentation/hwspinlock.txt                       |  48 +++-
 MAINTAINERS                                        |   1 -
 arch/arm/mach-omap2/Makefile                       |   3 -
 arch/arm/mach-omap2/hwspinlock.c                   |  60 -----
 drivers/hwspinlock/Kconfig                         |   2 +-
 drivers/hwspinlock/hwspinlock_core.c               | 286 ++++++++++++++++++---
 drivers/hwspinlock/hwspinlock_internal.h           |  11 +
 drivers/hwspinlock/omap_hwspinlock.c               |  49 +++-
 drivers/hwspinlock/u8500_hsem.c                    |   3 +-
 include/linux/hwspinlock.h                         |  34 ++-
 12 files changed, 458 insertions(+), 124 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/hwlock/hwlock.txt
 create mode 100644 Documentation/devicetree/bindings/hwlock/omap-hwspinlock.txt
 delete mode 100644 arch/arm/mach-omap2/hwspinlock.c

-- 
1.9.2

