Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933312Ab3FRQeh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 12:34:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49378 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933061Ab3FRQRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 12:17:39 -0400
From: Greg Kroah-Hartman <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Aaron Lu <aaron.lu@intel.com>
Subject: [ 03/48] ACPI / video: Do not bind to device objects with a scan handler
Date: Tue, 18 Jun 2013 09:17:29 -0700
Message-Id: <20130618161726.411508930@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130618161725.912524266@linuxfoundation.org>
References: <20130618161725.912524266@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

commit 8c9b7a7b2fc2750af418ddc28e707c42e78aa0bf upstream.

With the introduction of ACPI scan handlers, ACPI device objects
with an ACPI scan handler attached to them must not be bound to
by ACPI drivers any more.  Unfortunately, however, the ACPI video
driver attempts to do just that if there is a _ROM ACPI control
method defined under a device object with an ACPI scan handler.

Prevent that from happening by making the video driver's "add"
routine check if the device object already has an ACPI scan handler
attached to it and return an error code in that case.

That is not sufficient, though, because acpi_bus_driver_init() would
then clear the device object's driver_data that may be set by its
scan handler, so for the fix to work acpi_bus_driver_init() has to be
modified to leave driver_data as is on errors.

References: https://bugzilla.kernel.org/show_bug.cgi?id=58091
Bisected-and-tested-by: Dmitry S. Demin <dmitryy.demin@gmail.com>
Reported-and-tested-by: Jason Cassell <bluesloth600@gmail.com>
Tracked-down-by: Aaron Lu <aaron.lu@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Aaron Lu <aaron.lu@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/scan.c  |    5 +----
 drivers/acpi/video.c |    3 +++
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -830,11 +830,8 @@ acpi_bus_driver_init(struct acpi_device
 		return -ENOSYS;
 
 	result = driver->ops.add(device);
-	if (result) {
-		device->driver = NULL;
-		device->driver_data = NULL;
+	if (result)
 		return result;
-	}
 
 	device->driver = driver;
 
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -1646,6 +1646,9 @@ static int acpi_video_bus_add(struct acp
 	int error;
 	acpi_status status;
 
+	if (device->handler)
+		return -EINVAL;
+
 	status = acpi_walk_namespace(ACPI_TYPE_DEVICE,
 				device->parent->handle, 1,
 				acpi_video_bus_match, NULL,


