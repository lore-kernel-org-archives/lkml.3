Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934051AbaLKI0o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 03:26:44 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:60495 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934036AbaLKI0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 03:26:42 -0500
From: Tomasz Figa <tfiga@chromium.org>
To: linux-rockchip@lists.infradead.org
Cc: linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Heiko Stuebner <heiko@sntech.de>, Joerg Roedel <joro@8bytes.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Kevin Hilman <khilman@linaro.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Daniel Kurtz <djkurtz@chromium.org>, Tomasz Figa <tfiga@chromium.org>
Subject: [RFC PATCH 0/2] Fix rockchip IOMMU driver vs PM issues
Date: Thu, 11 Dec 2014 17:26:25 +0900
Message-Id: <1418286387-9663-1-git-send-email-tfiga@chromium.org>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Rockchip SoCs, the IOMMUs are located inside the same power domains as
IP blocks using them. This means that as soon as we runtime suspend such
IP block, causing the power domain to be powered off, the IOMMU would also
be powered off, losing all its state.

This means that whenever the power domain is being powered off, the IOMMU
driver needs to be able to deinitialize the hardware and whenever the domain
is being powered on, it needs to restore all the state, so the consumer
device is able to perform memory transactions.

The solution proposed here revives the idea of PM domain notifiers submitted
originally by Samsung's Sylwester Nawrocki and Marek Szyprowski in [1].
The main benefit of this idea that it is very simple, adding just 84 lines
of code, but effective and also useful for other purposes, what can be seen
in thread [2] and [3]. Moreover, it lets us avoid adding device specific
code (in this case specific to single IOMMU type) to power domain drivers,
which can be used for more devices than just IOMMU and which may vary
between platforms using the same IOMMU driver.

The IOMMU-specific part of the solution simply uses the pre-power-off and
post-power-on notifications to do the necessary setup without the need
of any action from inside drivers of devices behind the IOMMU, so all the
code specific to this particular IOMMU type stays outside other drivers
that should not rely on being run with a particular type of IOMMU (and
often even SoC).

Tested with a custom board based on RK3288 SoC.

[1] http://thread.gmane.org/gmane.linux.kernel.samsung-soc/36079/focus=346956
[2] http://thread.gmane.org/gmane.linux.power-management.general/51993/focus=39158
[3] http://marc.info/?l=linux-pm&m=136448756308203&w=2

Sylwester Nawrocki (1):
  pm: Add PM domain notifications

Tomasz Figa (1):
  iommu: rockchip: Handle system-wide and runtime PM

 Documentation/power/notifiers.txt |  14 +++
 drivers/base/power/domain.c       |  50 +++++++++
 drivers/iommu/rockchip-iommu.c    | 208 +++++++++++++++++++++++++++++++-------
 include/linux/pm_domain.h         |  20 ++++
 4 files changed, 256 insertions(+), 36 deletions(-)

-- 
2.2.0.rc0.207.ga3a616c

