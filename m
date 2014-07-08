Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607AbaGHTe0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:34:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54778 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755856AbaGHTeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:34:19 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Ludovic Drolez" <ldrolez@debian.org>,
        "kbuild test robot" <fengguang.wu@intel.com>,
        "Johan Hovold" <jhovold@gmail.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.881857135@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 039/125] USB: io_ti: fix firmware download on
 big-endian machines (part 2)
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit c03890ff5e24a4bf59059f2d179f427559b7330a upstream.

A recent patch that purported to fix firmware download on big-endian
machines failed to add the corresponding sparse annotation to the
i2c-header. This was reported by the kbuild test robot.

Adding the appropriate annotation revealed another endianess bug related
to the i2c-header Size-field in a code path that is exercised when the
firmware is actually being downloaded (and not just verified and left
untouched unless older than the firmware at hand).

This patch adds the required sparse annotation to the i2c-header and
makes sure that the Size-field is sent in little-endian byte order
during firmware download also on big-endian machines.

Note that this patch is only compile-tested, but that there is no
functional change for little-endian systems.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Cc: Ludovic Drolez <ldrolez@debian.org>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/io_ti.c      | 2 +-
 drivers/usb/serial/io_usbvend.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/serial/io_ti.c
+++ b/drivers/usb/serial/io_ti.c
@@ -923,7 +923,7 @@ static int build_i2c_fw_hdr(__u8 *header
 	firmware_rec =  (struct ti_i2c_firmware_rec*)i2c_header->Data;
 
 	i2c_header->Type	= I2C_DESC_TYPE_FIRMWARE_BLANK;
-	i2c_header->Size	= (__u16)buffer_size;
+	i2c_header->Size	= cpu_to_le16(buffer_size);
 	i2c_header->CheckSum	= cs;
 	firmware_rec->Ver_Major	= OperationalMajorVersion;
 	firmware_rec->Ver_Minor	= OperationalMinorVersion;
--- a/drivers/usb/serial/io_usbvend.h
+++ b/drivers/usb/serial/io_usbvend.h
@@ -594,7 +594,7 @@ struct edge_boot_descriptor {
 
 struct ti_i2c_desc {
 	__u8	Type;			// Type of descriptor
-	__u16	Size;			// Size of data only not including header
+	__le16	Size;			// Size of data only not including header
 	__u8	CheckSum;		// Checksum (8 bit sum of data only)
 	__u8	Data[0];		// Data starts here
 } __attribute__((packed));

