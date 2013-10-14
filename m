Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757039Ab3JNQS6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 12:18:58 -0400
Received: from mga14.intel.com ([143.182.124.37]:41861 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018Ab3JNQS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 12:18:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,493,1378882800"; 
   d="scan'208";a="374537588"
Subject: [PATCH 2] libahci: fix turning on LEDs in ahci_start_port()
To: tj@kernel.org
From: Lukasz Dorau <lukasz.dorau@intel.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 14 Oct 2013 18:18:53 +0200
Message-ID: <20131014161853.20775.1487.stgit@gklab-154-244.igk.intel.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If EM Transmit bit is busy during init ata_msleep() is called.
It is wrong - msleep() should be used instead of ata_msleep(),
because if EM Transmit bit is busy for one port, it will be busy
for all other ports too, so using ata_msleep() causes wasting
tries for another ports.

The most common scenario looks like that now
(six ports try to transmit a LED meaasege):
- port #0 tries for the 1st time and succeeds
- ports #1-5 try for the 1st time and sleeps
- port #1 tries for the 2nd time and succeeds
- ports #2-5 try for the 2nd time and sleeps
- port #2 tries for the 3rd time and succeeds
- ports #3-5 try for the 3rd time and sleeps
- port #3 tries for the 4th time and succeeds
- ports #4-5 try for the 4th time and sleeps
- port #4 tries for the 5th time and succeeds
- port #5 tries for the 5th time and sleeps
At this moment port #5 wasted all its five tries and failed to initialize.
Because there are only 5 (EM_MAX_RETRY) tries available usually only five ports
succeed to initialize. The sixth port and next ones usually will fail.

If msleep() is used instead of ata_msleep() the first port succeeds to initialize
in the first try and next ones usually succeed to initialize in the second try.

Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
---
 drivers/ata/libahci.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index acfd0f7..8fb7092 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -779,7 +779,11 @@ static void ahci_start_port(struct ata_port *ap)
 							       emp->led_state,
 							       4);
 				if (rc == -EBUSY)
-					ata_msleep(ap, 1);
+					/* Do not release ownership of @ap's EH,
+					 * because EM Transmit bit is busy for
+					 * all ports sharing the @ap->host.
+					 */
+					msleep(1);
 				else
 					break;
 			}

