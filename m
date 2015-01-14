Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232AbbANU7A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 15:59:00 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:45613 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099AbbANU6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 15:58:55 -0500
From: Suman Anna <s-anna@ti.com>
To: Ohad Ben-Cohen <ohad@wizery.com>, Mark Rutland <mark.rutland@arm.com>,
        Kumar Gala <galak@codeaurora.org>
CC: Bjorn Andersson <bjorn@kryo.se>, Josh Cartwright <joshc@codeaurora.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Suman Anna <s-anna@ti.com>
Subject: [PATCH v7 0/4] hwspinlock core & omap dt support
Date: Wed, 14 Jan 2015 14:58:17 -0600
Message-ID: <1421269101-51105-1-git-send-email-s-anna@ti.com>
X-Mailer: git-send-email 2.2.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

This is an updated version of the hwspinlock dt support series,
rebased onto v3.19-rc3 and mainly addresses the continued discussion
on the need to maintain a list of registered spinlock banks [1].
I have removed this patch as per your wish, and as a result the
burden of the spinlock validation and deferred probing is pushed
onto the hwspinlock clients. Sorry for the delay in refreshing this
series, hopefully this can be the last revision.

Following are the main changes in v7 w.r.t v6:
- Dropped the patch "hwspinlock/core: maintain a list of registered
  hwspinlock banks"
- Updated generic hwspinlock bindings to make hwlock-base-id property
  mandatory.
- Updated the OMAP hwspinlock binding and DT support patches to correct
  for the mandatory hwlock-base-id property.
- Updated the common OF helpers patch to move the of_hwspin_lock_get_base_id()
  and of_hwspin_lock_get_num_locks() functions into the internal header,
  these are no longer exported, but available for platform implementations.
  of_hwspin_lock_get_id() is also simplified now.

The validation logs on all the applicable OMAP SoCs are at:
  OMAP4  - http://slexy.org/view/s21Mh1SqP8
  OMAP5  - http://slexy.org/view/s21TYWxoKu
  DRA74x - http://slexy.org/view/s2dQdghLPr
  DRA72x - http://slexy.org/view/s2QajhhWYu
  AM33xx - http://slexy.org/view/s21DvKQOpa
  AM43xx - http://slexy.org/view/s21L3YB95Q

The above logs are generated with some additional test patches staged
here for reference,
https://github.com/sumananna/omap-kernel/commits/hwspinlock/test/3.19-rc3-dt-v7

The test branch also includes a required patch that adds the hwlock-base-id
to all the OMAP hwspinlock DT nodes (will submit that patch separately for
Tony to pick it up).

Bjorn,
I didn't add your Tested-by: or Reviewed-by as I have modified the
series a bit. Care to give those once again, thanks.

regards
Suman

[1] https://patchwork.kernel.org/patch/4898041/

---
v6:
http://marc.info/?l=linux-omap&m=141055365213895&w=2
- of_hwspin_lock_request_specific() is replaced
  with of_hwspin_lock_get_id(). of_hwspin_lock_simple_xlate() is
  made internal, and of_hwspin_lock_get_base_id() is added.
- Updated the OMAP hwspinlock DT support patch to assign base-id
  from DT if present
- RFC patches adding the concept of reserved locks and return code
  change convention dropped.

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

Suman Anna (4):
  Documentation: dt: add common bindings for hwspinlock
  Documentation: dt: add the omap hwspinlock bindings document
  hwspinlock/core: add common OF helpers
  hwspinlock/omap: add support for dt nodes

 .../devicetree/bindings/hwlock/hwlock.txt          | 55 ++++++++++++++++++
 .../devicetree/bindings/hwlock/omap-hwspinlock.txt | 28 ++++++++++
 Documentation/hwspinlock.txt                       | 25 +++++++++
 MAINTAINERS                                        |  1 -
 arch/arm/mach-omap2/Makefile                       |  3 -
 arch/arm/mach-omap2/hwspinlock.c                   | 60 --------------------
 drivers/hwspinlock/hwspinlock_core.c               | 65 ++++++++++++++++++++++
 drivers/hwspinlock/hwspinlock_internal.h           | 47 ++++++++++++++++
 drivers/hwspinlock/omap_hwspinlock.c               | 22 ++++++--
 include/linux/hwspinlock.h                         |  7 +++
 10 files changed, 244 insertions(+), 69 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/hwlock/hwlock.txt
 create mode 100644 Documentation/devicetree/bindings/hwlock/omap-hwspinlock.txt
 delete mode 100644 arch/arm/mach-omap2/hwspinlock.c

-- 
2.2.1

