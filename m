Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935560AbaICXQp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 19:16:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45858 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757231AbaICWQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:16:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 3.16 026/125] mei: dont schedule suspend in pm idle
Date: Wed,  3 Sep 2014 15:06:23 -0700
Message-Id: <20140903220624.449556001@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220623.649748296@linuxfoundation.org>
References: <20140903220623.649748296@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit d5d83f8abea13d0b50ee762276c6c900d1946264 upstream.

Calling pm_schedule_suspend from the runtime pm idle callback
may reschedule existing timer, thus in case of frequent runtime
rpm idle call the suspend maybe starved.
Instead we call pm_runtime_autosuspend which is checking if the
timer is already charged.

An example is monitoring device pci config space.
Pci config sysfs handlers calls pci_config_pm_runtime_put/get
helpers which in turns calls to device idle callback

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/misc/mei/pci-me.c  |    2 +-
 drivers/misc/mei/pci-txe.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -369,7 +369,7 @@ static int mei_me_pm_runtime_idle(struct
 	if (!dev)
 		return -ENODEV;
 	if (mei_write_is_idle(dev))
-		pm_schedule_suspend(device, MEI_ME_RPM_TIMEOUT * 2);
+		pm_runtime_autosuspend(device);
 
 	return -EBUSY;
 }
--- a/drivers/misc/mei/pci-txe.c
+++ b/drivers/misc/mei/pci-txe.c
@@ -306,7 +306,7 @@ static int mei_txe_pm_runtime_idle(struc
 	if (!dev)
 		return -ENODEV;
 	if (mei_write_is_idle(dev))
-		pm_schedule_suspend(device, MEI_TXI_RPM_TIMEOUT * 2);
+		pm_runtime_autosuspend(device);
 
 	return -EBUSY;
 }


