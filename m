Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab3F0PCV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 11:02:21 -0400
Received: from smtp.citrix.com ([66.165.176.89]:31696 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753453Ab3F0PCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 11:02:18 -0400
X-IronPort-AV: E=Sophos;i="4.87,952,1363132800"; 
   d="scan'208";a="33832733"
From: Ben Guthro <benjamin.guthro@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jan Beulich <jbeulich@suse.com>, "Rafaell J . Wysocki" <rjw@sisk.pl>,
        <linux-kernel@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
        <xen-devel@lists.xen.org>
CC: Ben Guthro <benjamin.guthro@citrix.com>,
        Richard L Maliszewski <richard.l.maliszewski@intel.com>,
        Gang Wei <gang.wei@intel.com>, Shane Wang <shane.wang@intel.com>,
        Bob Moore <robert.moore@intel.com>,
        <tboot-devel@lists.sourceforge.net>
Subject: [PATCH v4 0/5] Xen/ACPI: support sleep state entering on hardware reduced systems
Date: Thu, 27 Jun 2013 11:01:58 -0400
Message-ID: <1372345323-9266-1-git-send-email-benjamin.guthro@citrix.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.204.241.11]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In version 3.4 acpi_os_prepare_sleep() got introduced in parallel with
reduced hardware sleep support, and the two changes didn't get
synchronized: The new code doesn't call the hook function (if so
requested). Fix this, requiring a boolean parameter to be added to the
hook function to distinguish "extended" from "legacy" sleep.

This requires adjusting TXT, but the adjustments only go as far as
failing the extended mode call (since, looking at the TXT interface,
there doesn't even appear to be precautions to deal with that
alternative interface).

The hypervisor change underlying this is commit 62d1a69 ("ACPI: support
v5 (reduced HW) sleep interface") on the master branch of
git://xenbits.xen.org/xen.git.

Signed-off-by: Ben Guthro <benjamin.guthro@citrix.com>
Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Richard L Maliszewski <richard.l.maliszewski@intel.com>
Cc: Gang Wei <gang.wei@intel.com>
Cc: Shane Wang <shane.wang@intel.com>
Cc: Bob Moore <robert.moore@intel.com>
Cc: Rafaell J. Wysocki <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org
Cc: tboot-devel@lists.sourceforge.net 

v2: Extend description to include reference to hypervisor side change
v3: Split into multiple patches, separating subsystems
    Remove bool parameters, in favor of u8
v4: Remove linux/acpi.h dependencies
    Further patch split to break out acpica from OSL
    More bool vs u8 fixes

Ben Guthro (5):
  acpi: Remove need to include linux/acpi.h in common acpica code
  acpi: Call acpi_os_prepare_sleep hook in reduced hardware sleep path
  acpi: Adjust linux acpi OS functions to new extended parameter
  x86/tboot: Fail extended mode reduced hardware sleep
  xen/acpi: notify xen when reduced hardware sleep is available

 arch/x86/kernel/tboot.c          |    6 +++++-
 drivers/acpi/acpica/hwesleep.c   |    7 +++++++
 drivers/acpi/acpica/hwsleep.c    |    3 +--
 drivers/acpi/osl.c               |   16 ++++++++--------
 drivers/xen/acpi.c               |   26 +++++++++++++-------------
 include/acpi/acpiosxf.h          |    6 ++++++
 include/linux/acpi.h             |    9 +++------
 include/xen/acpi.h               |    4 ++--
 include/xen/interface/platform.h |    7 ++++---
 9 files changed, 49 insertions(+), 35 deletions(-)

-- 
1.7.9.5

