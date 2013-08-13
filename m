Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757790Ab3HMGmz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 02:42:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60728 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757385Ab3HMGeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 02:34:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Curt Brune <curt@cumulusnetworks.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [ 01/12] hwmon: (adt7470) Fix incorrect return code check
Date: Mon, 12 Aug 2013 23:35:36 -0700
Message-Id: <20130813063520.390244478@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130813063520.285638946@linuxfoundation.org>
References: <20130813063520.285638946@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Curt Brune <curt@cumulusnetworks.com>

commit 93d783bcca69bfacc8dc739d8a050498402587b5 upstream.

In adt7470_write_word_data(), which writes two bytes using
i2c_smbus_write_byte_data(), the return codes are incorrectly AND-ed
together when they should be OR-ed together.

The return code of i2c_smbus_write_byte_data() is zero for success.

The upshot is only the first byte was ever written to the hardware.
The 2nd byte was never written out.

I noticed that trying to set the fan speed limits was not working
correctly on my system.  Setting the fan speed limits is the only
code that uses adt7470_write_word_data().  After making the change
the limit settings work and the alarms work also.

Signed-off-by: Curt Brune <curt@cumulusnetworks.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/adt7470.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/adt7470.c
+++ b/drivers/hwmon/adt7470.c
@@ -215,7 +215,7 @@ static inline int adt7470_write_word_dat
 					  u16 value)
 {
 	return i2c_smbus_write_byte_data(client, reg, value & 0xFF)
-	       && i2c_smbus_write_byte_data(client, reg + 1, value >> 8);
+	       || i2c_smbus_write_byte_data(client, reg + 1, value >> 8);
 }
 
 static void adt7470_init_client(struct i2c_client *client)


