Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758639AbaIOU5M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:57:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54613 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755037AbaIOT1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:27:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Dirk Griesbach <spamthis@freenet.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.16 098/158] ACPI / scan: Allow ACPI drivers to bind to PNP device objects
Date: Mon, 15 Sep 2014 12:25:37 -0700
Message-Id: <20140915192545.828451354@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

commit fc2e0a8326d1b21d11ef8213298e5302867fed2c upstream.

We generally don't allow ACPI drivers to bind to ACPI device objects
that companion "physical" device objects are created for to avoid
situations in which two different drivers may attempt to handle one
device at the same time.  Recent ACPI device enumeration rework
extended that approach to ACPI PNP devices by starting to use a scan
handler for enumerating them.  However, we previously allowed ACPI
drivers to bind to ACPI device objects with existing PNP device
companions and changing that led to functional regressions on some
systems.

For this reason, add a special check for PNP devices in
acpi_device_probe() so that ACPI drivers can bind to ACPI device
objects having existing PNP device companions as before.

Fixes: eec15edbb0e1 (ACPI / PNP: use device ID list for PNPACPI device enumeration)
Link: https://bugzilla.kernel.org/show_bug.cgi?id=81511
Link: https://bugzilla.kernel.org/show_bug.cgi?id=81971
Reported-by: Gabriele Mazzotta <gabriele.mzt@gmail.com>
Reported-by: Dirk Griesbach <spamthis@freenet.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/scan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -978,7 +978,7 @@ static int acpi_device_probe(struct devi
 	struct acpi_driver *acpi_drv = to_acpi_driver(dev->driver);
 	int ret;
 
-	if (acpi_dev->handler)
+	if (acpi_dev->handler && !acpi_is_pnp_device(acpi_dev))
 		return -EINVAL;
 
 	if (!acpi_drv->ops.add)


