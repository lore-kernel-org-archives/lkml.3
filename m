Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295Ab3J1RFp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 13:05:45 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:34671 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757240Ab3J1RFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 13:05:42 -0400
From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
To: <linux-kernel@vger.kernel.org>
CC: Wolfram Sang <w.sang@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 1/2] misc/at24: avoid infinite loop on write()
Date: Mon, 28 Oct 2013 19:05:15 +0200
Message-ID: <1382979916-3494-2-git-send-email-vladimir_zapolskiy@mentor.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1382979916-3494-1-git-send-email-vladimir_zapolskiy@mentor.com>
References: <1382979916-3494-1-git-send-email-vladimir_zapolskiy@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [137.202.0.76]
X-OriginalArrivalTime: 28 Oct 2013 17:05:40.0419 (UTC) FILETIME=[EE0BB930:01CED3FF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change fixes a problem of infinite zero byte write() without
an error status, if there is an attempt to write a file bigger than
EEPROM size over sysfs interface.

Signed-off-by: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/eeprom/at24.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/misc/eeprom/at24.c b/drivers/misc/eeprom/at24.c
index 5d4fd69..94b8a33 100644
--- a/drivers/misc/eeprom/at24.c
+++ b/drivers/misc/eeprom/at24.c
@@ -428,6 +428,9 @@ static ssize_t at24_bin_write(struct file *filp, struct kobject *kobj,
 {
 	struct at24_data *at24;
 
+	if (unlikely(off >= attr->size))
+		return -EFBIG;
+
 	at24 = dev_get_drvdata(container_of(kobj, struct device, kobj));
 	return at24_write(at24, buf, off, count);
 }
-- 
1.7.10.4

