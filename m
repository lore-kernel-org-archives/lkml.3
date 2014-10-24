Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbaJXGWn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 02:22:43 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:62361 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbaJXGWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 02:22:41 -0400
MIME-Version: 1.0
In-Reply-To: <CA+Bv8XbpqJZiKFA2PsY7DFMcGxzG=bfZv5oR45k2gx7rQivLGA@mail.gmail.com>
References: <5448F83A.7010903@marcansoft.com> <CA+Bv8XbpqJZiKFA2PsY7DFMcGxzG=bfZv5oR45k2gx7rQivLGA@mail.gmail.com>
From: Perry Hung <iperry@gmail.com>
Date: Fri, 24 Oct 2014 14:22:18 +0800
Message-ID: <CAPUYfSfvQTBzLBZg1+_sO-Q7=7NOyQtEA_Hk5oi+sdNOvdS5Pg@mail.gmail.com>
Subject: Re: [PATCH] usb: serial: Perform verification for FTDI FT232R devices
To: Russ Dill <russ.dill@gmail.com>
Cc: Hector Martin <hector@marcansoft.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good Russ, just a minor fix:

-       /* Attempt to set Vendor ID to 0 */
-       eeprom_data[1] = 0;
-
-       /* Calculate new checksum to avoid bricking devices */
-       checksum = ftdi_checksum(eeprom_data, eeprom_size);
-
-       /* Verify EEPROM programming behavior/nonbehavior */
-       write_eeprom(port, 1, 0);
-       write_eeprom(port, eeprom_size - 1, checksum);
+    /* Attempt to set Product ID */
+    switch (priv->chip_type) {
+    case FT232BM:
+    case FT232RL:
+    case FT232H:
+        if (eeprom_data[2] == 0) {
+            eeprom_data[2] = FTDI_232RL_PID;
+            /* Calculate new checksum to avoid bricking devices */
+            checksum = ftdi_checksum(eeprom_data, eeprom_size);
+
+            /* Verify EEPROM programming behavior/nonbehavior */
+            write_eeprom(port, 2, eeprom_data[2]);
+            write_eeprom(port, 3, eeprom_data[3]);
+            write_eeprom(port, eeprom_size - 2, eeprom_data[eeprom_size - 2]);
+            write_eeprom(port, eeprom_size - 1, checksum);
+        }
+        break;
+    default:
+        break;
+    }

 end_verify:

On Thu, Oct 23, 2014 at 10:14 PM, Russ Dill <russ.dill@gmail.com> wrote:
> On Thu, Oct 23, 2014 at 5:44 AM, Hector Martin <hector@marcansoft.com> wrote:
>> NAK. This patch neither accomplishes what FTDI intended, nor what the
>> author humorously intended.
>>
>>> +     /* Attempt to set Vendor ID to 0 */
>>> +     eeprom_data[1] = 0;
>>> +
>>> +     /* Calculate new checksum to avoid bricking devices */
>>> +     checksum = ftdi_checksum(eeprom_data, eeprom_size);
>>> +
>>> +     /* Verify EEPROM programming behavior/nonbehavior */
>>> +     write_eeprom(port, 1, 0);
>>> +     write_eeprom(port, eeprom_size - 1, checksum);
>>
>> FTDI's verification routine sets the Product ID (at address 2) to 0 and
>> a dummy word (at address 0x3e) to a correctly crafted value that makes
>> the existing checksum pass. This bricks clone devices (setting PID to
>> 0), while original FT232RL devices are not affected as they only commit
>> writes when they receive a write command to an odd EEPROM address,
>> combining it with the most recently issued write to an even address and
>> writing 32 bits at a time.
>>
>> This patch instead writes the Vendor ID (at address 1) and the real
>> checksum (at address 0x3f). As amusing as bricking all devices would be,
>> unfortunately, a real FT232RL would just write garbage at addresses 0
>> and 0x3e too (as writes are still 32 bits, and no prior even-addressed
>> writes have occurred, so the holding register on the chip contains
>> garbage). Therefore, the real effect of this patch is to brick clone
>> devices (in a different way from the official driver, killing the VID
>> instead of the PID), while merely resetting original FT232RL devices to
>> defaults, due to the inadvertently corrupted even words now causing a
>> checksum mismatch.
>>
>> Props on the humor, try again with better code next time ;-). I suggest
>> the following:
>>
>> +       write_eeprom(port, 0, eeprom_data[0]);
>> +       write_eeprom(port, 1, 0);
>> +       write_eeprom(port, eeprom_size - 2, eeprom_data[eeprom_size - 2]);
>> +       write_eeprom(port, eeprom_size - 1, checksum);
>
> Damned off by one errors. Yes, it should be the product ID, not the
> vendor ID. These write u16's though, writing to wIndex 2 writes to
> bytes 4 and 5. the correct code is:
>
> write_eeprom(port, 2, 0);
> write_eeprom(port, eeprom_size - 2, checksum);
>
> And yes, the checksum code needs to be modified to create a specially
> crafted value that allows the existing checksum to pass.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
