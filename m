Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966603AbaLLLud (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 06:50:33 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:12367 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965873AbaLLLuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 06:50:32 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 12 Dec 2014 03:46:55 -0800
From: Bill Huang <bilhuang@nvidia.com>
To: <gregkh@linuxfoundation.org>
CC: <vinceh@nvidia.com>, <linux-kernel@vger.kernel.org>,
        Bill Huang <bilhuang@nvidia.com>
Subject: [RFC 1/1] driver core: re-order dpm_list after a succussful probe
Date: Fri, 12 Dec 2014 03:50:15 -0800
Message-ID: <1418385015-26811-1-git-send-email-bilhuang@nvidia.com>
X-Mailer: git-send-email 1.9.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dpm_list was added in the call "device_add" and when we do defer
probe we'll explicitly move the probed device to be the last in the
dpm_list, we should do the same for the normal probe since there are
cases that we won't have chance to do defer probe to change the PM order
as the below example.

If we would like the device driver A to be suspended earlier than the
device driver B, we won't have chance to do defer probe to fix the
suspend dependency since at the time device driver A is probed, device B
was up and running.

Device A was added
Device B was added
Driver for device B was binded
Driver for device A was binded

Signed-off-by: Bill Huang <bilhuang@nvidia.com>
---

It seems to me this is a bug in the core driver, but I'm not sure how should
we fix it.

- Do we have better fix?
- This proposed fix or any other fix might introduces side effect that breaks
  existing working suspend dependencies which happen to work based on the
  existing wrong suspend order.

Any thoughts? Thanks.

 drivers/base/dd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index cdc779c..54886d2 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -308,6 +308,10 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 			goto probe_failed;
 	}
 
+	device_pm_lock();
+	device_pm_move_last(dev);
+	device_pm_unlock();
+
 	driver_bound(dev);
 	ret = 1;
 	pr_debug("bus: '%s': %s: bound device %s to driver %s\n",
-- 
1.9.1

