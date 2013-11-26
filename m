Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758294Ab3KZXUX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 18:20:23 -0500
Received: from mga14.intel.com ([143.182.124.37]:19201 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754404Ab3KZXUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 18:20:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,778,1378882800"; 
   d="scan'208";a="434758866"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Linux PM <linux-pm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Zhang Rui <rui.zhang@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH 0/3] Hook up powerclamp with PM QOS and cpuidle
Date: Tue, 26 Nov 2013 15:20:08 -0800
Message-Id: <1385508011-26914-1-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is intended to address the behavior change and efficiency
loss introduced by using consolidated idle routine in powerclamp driver.

Specifically,
[PATCH 3/8] idle, thermal, acpi: Remove home grown idle implementations

The motivation is that after using common idle routine, powerclamp driver
can no longer pick the deepest idle state needed to conserve power.
Idle state is selected by governors which can be influenced by PM QOS and
other factors. This patchset hooks up powerclamp idle injection with PM
QOS and eventually influce idle governors to pick the power saving target
states.

There are some downside of this approach. Due to overhead, communication
with PM QOS is at enable/disable idle injection time instead of each
injection period. The implication is that if the system natual idle is
more than target injected idle, powerclamp will skip some injection period.
During this period however, deepest idle state may still be chosen
necessarily regardless the latency constraint.


Jacob Pan (3):
  pm/qos: allow state control of qos class
  cpuidle: check for pm qos constraint override
  thermal/powerclamp: communicate with pm qos when injecting idle

 drivers/cpuidle/governors/ladder.c |  4 ++++
 drivers/cpuidle/governors/menu.c   | 13 +++++++++++--
 drivers/thermal/intel_powerclamp.c |  8 ++++++++
 include/linux/pm_qos.h             | 10 +++++++++-
 kernel/power/qos.c                 | 24 ++++++++++++++++++++++++
 5 files changed, 56 insertions(+), 3 deletions(-)

-- 
1.8.1.2

