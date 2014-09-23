Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033AbaIWCkk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 22:40:40 -0400
Received: from mail.kernel.org ([198.145.19.201]:38484 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754956AbaIWCkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 22:40:35 -0400
From: Zefan Li <lizf@kernel.org>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 34/45] USB: serial: fix potential heap buffer overflow
Date: Tue, 23 Sep 2014 10:31:36 +0800
Message-Id: <1411439507-30391-34-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411439259-30224-1-git-send-email-lizf@kernel.org>
References: <1411439259-30224-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

3.4.104-rc1 review patch.  If anyone has any objections, please let me know.

------------------

commit 5654699fb38512bdbfc0f892ce54fce75bdc2bab upstream.

Make sure to verify the number of ports requested by subdriver to avoid
writing beyond the end of fixed-size array in interface data.

The current usb-serial implementation is limited to eight ports per
interface but failed to verify that the number of ports requested by a
subdriver (which could have been determined from device descriptors) did
not exceed this limit.

Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[lizf: Backported to 3.4: s/ddev/\&interface->dev/]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/usb/serial/usb-serial.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 815d86d..a08230e 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -889,6 +889,11 @@ int usb_serial_probe(struct usb_interface *interface,
 			num_ports = type->num_ports;
 	}
 
+	if (num_ports > MAX_NUM_PORTS) {
+		dev_warn(&interface->dev, "too many ports requested: %d\n", num_ports);
+		num_ports = MAX_NUM_PORTS;
+	}
+
 	serial->num_ports = num_ports;
 	serial->num_bulk_in = num_bulk_in;
 	serial->num_bulk_out = num_bulk_out;
-- 
1.7.9.5

