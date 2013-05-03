Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762117Ab3ECMtP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 08:49:15 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:48237 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759816Ab3ECMtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 08:49:13 -0400
X-AuditID: 9c930197-b7c1fae000001854-33-5183b247044b
From: Jongsung Kim <neidhard.kim@lge.com>
Organization: LG Electronics
To: linux@arm.linux.org.uk, gregkh@linuxfoundation.org, jslaby@suse.cz
Subject: [PATCH] ARM: PL011: revise to use amba_rev macro
Date: Fri, 3 May 2013 21:49:10 +0900
User-Agent: KMail/1.12.4 (Linux/2.6.32-358.2.1.el6.x86_64; KDE/4.3.4; x86_64; ; )
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201305032149.10482.neidhard.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces the ugly bit-operations with the convenient
amba_rev macro from the get_fifosize_arm function. The type of
get_fifosize member function is also slightly changed to take
a pointer to the amba_device.

Signed-off-by: Jongsung Kim <neidhard.kim@lge.com>
---
 drivers/tty/serial/amba-pl011.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index b2e9e17..72b57f9 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -79,13 +79,12 @@ struct vendor_data {
 	bool			dma_threshold;
 	bool			cts_event_workaround;
 
-	unsigned int (*get_fifosize)(unsigned int periphid);
+	unsigned int (*get_fifosize)(struct amba_device *dev);
 };
 
-static unsigned int get_fifosize_arm(unsigned int periphid)
+static unsigned int get_fifosize_arm(struct amba_device *dev)
 {
-	unsigned int rev = (periphid >> 20) & 0xf;
-	return rev < 3 ? 16 : 32;
+	return amba_rev(dev) < 3 ? 16 : 32;
 }
 
 static struct vendor_data vendor_arm = {
@@ -98,7 +97,7 @@ static struct vendor_data vendor_arm = {
 	.get_fifosize		= get_fifosize_arm,
 };
 
-static unsigned int get_fifosize_st(unsigned int periphid)
+static unsigned int get_fifosize_st(struct amba_device *dev)
 {
 	return 64;
 }
@@ -2145,7 +2144,7 @@ static int pl011_probe(struct amba_device *dev, const struct amba_id *id)
 	uap->lcrh_rx = vendor->lcrh_rx;
 	uap->lcrh_tx = vendor->lcrh_tx;
 	uap->old_cr = 0;
-	uap->fifosize = vendor->get_fifosize(dev->periphid);
+	uap->fifosize = vendor->get_fifosize(dev);
 	uap->port.dev = &dev->dev;
 	uap->port.mapbase = dev->res.start;
 	uap->port.membase = base;
--
