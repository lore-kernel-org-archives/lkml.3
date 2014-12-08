Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772AbaLHVCJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 16:02:09 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:59005 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbaLHVCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 16:02:07 -0500
From: Jakub Sitnicki <jsitnicki@gmail.com>
To: rafael.j.wysocki@intel.com
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Sitnicki <jsitnicki@gmail.com>
Subject: [PATCH] PNP: Switch from __check_region() to __request_region()
Date: Mon,  8 Dec 2014 22:01:57 +0100
Message-Id: <1418072517-5413-1-git-send-email-jsitnicki@gmail.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PNP core is the last user of the __check_region() which has been
deprecated for almost 12 years (since v2.5.54). Replace it with a combo
of __request_region() followed by __release_region().

pnp_check_port() and pnp_check_mem() remain racy after this change.

Signed-off-by: Jakub Sitnicki <jsitnicki@gmail.com>
---

There was a previous attempt at making this change 3 years ago but the
author has never addressed the review comments:

  https://lkml.org/lkml/2011/8/12/216

The end goal here is to get rid of __check_region() which lands in
every kernel image because of the PNP core.

It has been previously pointed out that replacing __check_region()
with request_region() obscures the fact that pnp_check_port() is racy:

  https://lkml.org/lkml/2011/8/11/466

Because of that I've also considered just moving __check_region() to
PNP core. However, that would require making free_resource() an
exported symbol in kernel/resource.c.

On the other hand, a switch to request/release_region() makes
pnp_check_port() and pnp_check_mem() follow the same pattern as found
in pnp_check_irq() and pnp_check_dma():

	if (!dev->active) {
		if (request_<resource type>(...))
			return 0;
		free_<resource type>(...);
	}
  
Admittedly, I was not able to exercise the touched code paths on a
commodity x86_64 laptop or under QEMU / VirtualBox (which lack ISA PnP
support, AFAIK).

To my understanding, the correct way to test pnp_check_port() or
pnp_check_mem() would be by issuing either:

  $ echo fill >/sys/bus/pnp/devices/XX:YY/resources
or
  $ echo auto >/sys/bus/pnp/devices/XX:YY/resources

... but only if the device is not attached or active, which is not the
case for ACPI PnP devices on my machines. If anyone can provide hints
on steps to test this, I will be glad to do so.

 drivers/pnp/resource.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/pnp/resource.c b/drivers/pnp/resource.c
index 782e822..f980ff7 100644
--- a/drivers/pnp/resource.c
+++ b/drivers/pnp/resource.c
@@ -179,8 +179,9 @@ int pnp_check_port(struct pnp_dev *dev, struct resource *res)
 	/* check if the resource is already in use, skip if the
 	 * device is active because it itself may be in use */
 	if (!dev->active) {
-		if (__check_region(&ioport_resource, *port, length(port, end)))
+		if (!request_region(*port, length(port, end), "pnp"))
 			return 0;
+		release_region(*port, length(port, end));
 	}
 
 	/* check if the resource is reserved */
@@ -241,8 +242,9 @@ int pnp_check_mem(struct pnp_dev *dev, struct resource *res)
 	/* check if the resource is already in use, skip if the
 	 * device is active because it itself may be in use */
 	if (!dev->active) {
-		if (check_mem_region(*addr, length(addr, end)))
+		if (!request_mem_region(*addr, length(addr, end), "pnp"))
 			return 0;
+		release_mem_region(*addr, length(addr, end));
 	}
 
 	/* check if the resource is reserved */
-- 
1.9.3

