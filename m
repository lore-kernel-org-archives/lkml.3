Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288Ab3LFIvo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 03:51:44 -0500
Received: from mga09.intel.com ([134.134.136.24]:17728 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756745Ab3LFIvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 03:51:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,839,1378882800"; 
   d="scan'208";a="420360924"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH v3 0/6] ACPI: Cleanup header inclusions.
Date: Fri,  6 Dec 2013 16:51:10 +0800
Message-Id: <cover.1386316208.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1385094640.git.lv.zheng@intel.com>
References: <cover.1385094640.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset includes 2 patches already merged in linux-pm/linux-next
branch.  It is included as the following mailing list thread contains two
patchsets of the ACPICA header cleanups.
1. Cleanup header inclusions.
   http://www.spinics.net/lists/linux-acpi/msg47510.html
2. Cleanup direct ACPICA inclusions.
   http://www.spinics.net/lists/linux-acpi/msg47703.html
It is vague for the thread monitors.
This patchset collects all patches in this thread together to form a single
v3 patchset.

ACPICA header files are lacking in stub protections.  This makes all ACPICA
header files could only be included for CONFIG_ACPI=y environment.  This
infects new ACPI prototypes, if such prototypes referenced ACPICA defined
types, they must be incldued only in the CONFIG_ACPI=y environment.  The
<acpi/acpi_bus.h> and <acpi/acpi_drivers.h> are the monstrosity infants
born under this background, directly including them in the CONFIG_ACPI=n
environment is not safe.  The infection spreads to whole kernel source tree
that we can see "#ifdef CONFIG_ACPI" here and there.

This patchset tries to enforces <linux/acpi.h> inclusions instead of
<acpi/acpi.h>, <acpi/acpi_bus.h> and <acpi/acpi_drivers.h> inclusions.

For <acpi/acpi_bus.h> and <acpi/acpi_drivers.h> inclusion cleanups, as all
users are CONFIG_ACPI dependent, we don't have any issues raised.

For <acpi/acpi.h> inclusion cleanups, we have following 4 cases specially
handled:
1. "ACPI IGD OpRegion" support in i915 DRM driver.  It can be modified to
   be CONFIG_ACPI dependent.
2. "_CRS based MCFG checker" support, original configurability of this
   piece of code relies on link stage optimization.  This patchset
   corrects it by making the configurability to be dependent on compile
   stage references.
3. "iSCSI IBFT finder" support.  IBFT can only appear on ACPI platforms
   while IBFT locating mechanism doesn't rely on ACPI table constructions.
   It is currently not dependent on CONFIG_ACPI.  IMO, this behavior is
   This patchset corrects it by making it dependent on CONFIG_ACPI.  This
   patch need to be discussed, thus marked as RFC.
4. "SFI/ACPI wrapper" support.  This error is not fixed in this patchset.
   Its solution is still under discussion.  It need to be synchronized
   with SFI users.

During the fixes, <linux/acpi_io.h> is also detected as an ACPICA dependent
header, it thus be converted into <acpi/acpi_io.h> and included from
<linux/acpi.h> for CONFIG_ACPI builds.

NOTE that the first 2 commits in this series are already in the
linux-pm/linux-next branch.
 1. Commit: 91be0998578a1001db1382012676ee0a69d5cee3
    Subject: [PATCH] ACPI: Clean up incorrect inclusions of ACPICA headers
 2. Commit: 4e8fb7987f7d0390a2e74622c7c1cbb6760c6516
    Subject: [PATCH] ACPI: Clean up inclusions of ACPI header files
The reset 4 commits are rebased on top of this branch thus can be applied
to the branch directly.

Lv Zheng (6):
  ACPI: Clean up incorrect inclusions of ACPICA headers
  ACPI: Clean up inclusions of ACPI header files
  SFI: Fix warnings reported by W=1 builds.
  ACPI/i915: Fix wrong <acpi/acpi.h> inclusion in i915 opregion module.
  ACPI/SFI: Fix wrong <acpi/acpi.h> inclusion in SFI/ACPI wrapper -
    acpi_disabled linkage.
  ACPI/IBFT: Fix wrong <acpi/acpi.h> inclusion in iSCSI boot firmware
    module.

NOTE that this cover-letter is manually editted,  so file summary is
useless and thus gets deleted.

-- 
1.7.10

