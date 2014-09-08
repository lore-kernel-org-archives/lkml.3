Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316AbaIHVTe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 17:19:34 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:47159 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755256AbaIHVTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 17:19:32 -0400
Message-ID: <540E1D75.5000500@gmail.com>
Date: Mon, 08 Sep 2014 14:19:49 -0700
From: Rajat Jain <rajatxjain@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhelgaas@google.com
CC: rajatjain@juniper.net, groeck@juniper.net
Subject: [PATCH] pci/probe: Ignore the device id while handling CRS
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some root ports may return the actual device id returned by the
endpoint, instead of faking up a synthetic id (0xFFFF) as specified
by the PCIe spec (sec 2.3.2). We have seen such broken devices in the
past that match this behaviour:
(Ref: https://lkml.org/lkml/2007/11/1/198)

To take care of the same, CRS was disabled then, however, we want to
enable CRS now (https://lkml.org/lkml/2014/9/2/509), but still do not
want to break such devices. Thus check only against the
(vendor id == 1) and ignore the device id.

Signed-off-by: Rajat Jain <rajatxjain@gmail.com>
Signed-off-by: Rajat Jain <rajatjain@juniper.net>
Signed-off-by: Guenter Roeck <groeck@juniper.net>
---
 drivers/pci/probe.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 3c4c35c..0076a9b 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1305,8 +1305,13 @@ bool pci_bus_read_dev_vendor_id(struct pci_bus *bus, int devfn, u32 *l,
 	    *l == 0x0000ffff || *l == 0xffff0000)
 		return false;
 
-	/* Configuration request Retry Status */
-	while (*l == 0xffff0001) {
+	/*
+	 * Configuration request Retry Status. Note that some root ports
+	 * are broken and may return actual device ID instead of a synthetic ID
+	 * (0xFFFF) to be faked as per the PCIe spec. Hence ignore the device ID
+	 * and only check for (vendor id == 1)
+	 */
+	while (*l & 0xffff == 0x0001) {
 		if (!crs_timeout)
 			return false;
 
-- 
1.7.9.5

