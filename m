Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891Ab3FXUID (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 16:08:03 -0400
Received: from mga14.intel.com ([143.182.124.37]:8370 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219Ab3FXUHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 16:07:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,930,1363158000"; 
   d="scan'208";a="259521962"
Subject: [PATCH] pci: Avoid unnecessary calls to work_on_cpu
To: bhelgaas@google.com
From: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 24 Jun 2013 13:05:01 -0700
Message-ID: <20130624195942.40795.27292.stgit@ahduyck-cp1.jf.intel.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is meant to address the fact that we are making unnecessary calls
to work_on_cpu.  To resolve this I have added a check to see if the current
node is the correct node for the device before we decide to assign the probe
task to another CPU.

The advantages to this approach is that we can avoid reentrant calls to
work_on_cpu.  In addition we should not make any calls to setup the work
remotely in the case of a single node system that has NUMA enabled.

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
---

This patch is based off of work I submitted in an earlier patch that I never
heard back on.  The change was originally submitted in:
  pci: Avoid reentrant calls to work_on_cpu

I'm not sure what ever happened with that patch, however after reviewing it
some myself I decided I could do without the change to the comments since they
were unneeded.  As such I am resubmitting this as a much simpler patch that
only adds the line of code needed to avoid calling work_on_cpu for every call
to probe on an NUMA node specific device.

 drivers/pci/pci-driver.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 79277fb..7d81713 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -282,7 +282,7 @@ static int pci_call_probe(struct pci_driver *drv, struct pci_dev *dev,
 	   its local memory on the right node without any need to
 	   change it. */
 	node = dev_to_node(&dev->dev);
-	if (node >= 0) {
+	if ((node >= 0) && (node != numa_node_id())) {
 		int cpu;
 
 		get_online_cpus();

