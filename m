Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769Ab3DXBWB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 21:22:01 -0400
Received: from wdmail02.wdc.com ([129.253.55.42]:33132 "EHLO wdmail02.wdc.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755108Ab3DXBWA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 21:22:00 -0400
X-Greylist: delayed 566 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Apr 2013 21:22:00 EDT
X-IronPort-AV: E=Sophos;i="4.87,538,1363158000"; 
   d="scan'208";a="24965554"
From: Daniel Taylor <Daniel.Taylor@wdc.com>
To: Kenny MacDermid <kenny.macdermid@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: WD My Passport SCSI commands, kernel driver?
Thread-Topic: WD My Passport SCSI commands, kernel driver?
Thread-Index: AQHOQG6h2kU3K6Kyd0KMxLjTFGjB1Jjkju1g
Date: Wed, 24 Apr 2013 01:12:30 +0000
Message-ID: <5A9BC72FD5CEC94EA024CED8E31D701A82065948@wdscexmb03.sc.wdc.com>
References: <20130423215413.GB14277@rm-rf.ca>
In-Reply-To: <20130423215413.GB14277@rm-rf.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.4.44.9]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Kenny MacDermid
> Sent: Tuesday, April 23, 2013 2:54 PM
> To: linux-kernel@vger.kernel.org
> Subject: WD My Passport SCSI commands, kernel driver?
> 
> WD My Passport harddrives contain hardware encryption. An unlock utility
> is provided for other OSes, but not for Linux.
> I'd like to know if the kernel is the correct place for code to unlock this
> device, and any tips on how it should be implemented. I've reverse
> engineered the vendor specific commands needed to unlock the device.
> 
> When connecting a locked drive the following is shown:
> 
> [] usb 1-1: new full-speed USB device number 2 using ohci_hcd [] usb 1-1:
> New USB device found, idVendor=1058, idProduct=0748 [] usb 1-1: New USB
> device strings: Mfr=1, Product=2, SerialNumber=5 [] usb 1-1: Product: My
> Passport 0748 [] usb 1-1: Manufacturer: Western Digital [] usb 1-1:
> SerialNumber: ________________________ [] Initializing USB Mass Storage
> driver...
> [] scsi3 : usb-storage 1-1:1.0
> [] usbcore: registered new interface driver usb-storage [] USB Mass Storage
> support registered.
> [] scsi 3:0:0:0: Direct-Access     WD       My Passport 0748 1019 PQ: 0 ANSI: 6
> [] scsi 3:0:0:1: CD-ROM            WD       Virtual CD 0748  1019 PQ: 0 ANSI: 6
> [] scsi 3:0:0:2: Enclosure         WD       SES Device       1019 PQ: 0 ANSI: 6
> [] sd 3:0:0:0: Attached scsi generic sg3 type 0 [] sr2: scsi3-mmc drive: 51x/51x
> caddy [] sr 3:0:0:1: Attached scsi CD-ROM sr2 [] sr 3:0:0:1: Attached scsi
> generic sg4 type 5 [] scsi 3:0:0:2: Attached scsi generic sg5 type 13 [] sd
> 3:0:0:0: [sdb] Unit Not Ready [] sd 3:0:0:0: [sdb]  Sense Key : Data Protect
> [current] [] sd 3:0:0:0: [sdb]  Add. Sense: Logical unit access not authorized []
> sd 3:0:0:0: [sdb] 3906963456 512-byte logical blocks: (2.00 TB/1.81 TiB) [] sd
> 3:0:0:0: [sdb] Write Protect is off [] sd 3:0:0:0: [sdb] Mode Sense: 47 00 10 08
> [] sd 3:0:0:0: [sdb] No Caching mode page present [] sd 3:0:0:0: [sdb]
> Assuming drive cache: write through [] sd 3:0:0:0: [sdb] Unit Not Ready [] sd
> 3:0:0:0: [sdb]  Sense Key : Data Protect [current] [] sd 3:0:0:0: [sdb]  Add.
> Sense: Logical unit access not authorized [] sd 3:0:0:0: [sdb] No Caching
> mode page present [] sd 3:0:0:0: [sdb] Assuming drive cache: write through
> 
> Followed by 160 read errors:
> 
> [] sd 3:0:0:0: [sdb] Unhandled sense code [] sd 3:0:0:0: [sdb]  Result:
> hostbyte=invalid driverbyte=DRIVER_SENSE [] sd 3:0:0:0: [sdb]  Sense Key :
> Data Protect [current] [] sd 3:0:0:0: [sdb]  Add. Sense: Logical unit access not
> authorized [] sd 3:0:0:0: [sdb] CDB: Read(10): 28 00 00 00 00 00 00 00 08 00 []
> end_request: critical target error, dev sdb, sector 0 [] Buffer I/O error on
> device sdb, logical block 0
> 
> After sending the correct command to the device using sg_raw, including a
> hash of the password, the device will unlock and sdb will be readable.
> 
> Is this something suited to the kernel, or better as a standalone utility? And
> if it's suited for the kernel are there any examples of other drives requiring
> unlock commands?
> 
> Thank you,
> 
> Kenny

The #1 issue that USB drives are all marked as SCSI-2, which prevents the use of the needed
commands   (the old LUN field interferes with newer command descriptors).  I have fixed
that in WD code  for our consumer NAS by changing the scsi_level /sys entry from ro to rw. 
I'd like to see this change in the kernel, but have not had any positive feedback.  Here's a 3.2
kernel patch example  for scsi_sysfs.c:

diff -Naur scsi_level.old//drivers/scsi/scsi_sysfs.c scsi_level.new//drivers/scsi/scsi_sysfs.c
--- scsi_level.old//drivers/scsi/scsi_sysfs.c   2013-04-23 18:03:26.089614702 -0700
+++ scsi_level.new//drivers/scsi/scsi_sysfs.c   2013-04-23 18:03:19.433429766 -0700
@@ -469,8 +469,8 @@
  * sdev_rw_attr: create a function and attribute variable for a
  * read/write field.
  */
-#define sdev_rw_attr(field, format_string)                             \
-       sdev_show_function(field, format_string)                                \
+#define sdev_rw_attr(field, r_format_string, w_format_string)          \
+       sdev_show_function(field, r_format_string)                              \
                                                                        \
 static ssize_t                                                         \
 sdev_store_##field (struct device *dev, struct device_attribute *attr, \
@@ -478,7 +478,7 @@
 {                                                                      \
        struct scsi_device *sdev;                                       \
        sdev = to_scsi_device(dev);                                     \
-       sscanf (buf, format_string, &sdev->field);                      \
+       snscanf (buf, 20, w_format_string, &sdev->field);                       \
        return count;                                                   \
 }                                                                      \
 static DEVICE_ATTR(field, S_IRUGO | S_IWUSR, sdev_show_##field, sdev_store_##field);
@@ -532,7 +532,7 @@
 sdev_rd_attr (device_blocked, "%d\n");
 sdev_rd_attr (queue_depth, "%d\n");
 sdev_rd_attr (type, "%d\n");
-sdev_rd_attr (scsi_level, "%d\n");
+sdev_rw_attr (scsi_level, "%d\n", "%hhd\n");
 sdev_rd_attr (vendor, "%.8s\n");
 sdev_rd_attr (model, "%.16s\n");
 sdev_rd_attr (rev, "%.4s\n");

There are good reasons for the default scsi_level, but allowing user space to change the
level for "known good" drives fixes not only the WD unlock, but also standard commands
such as send diagnostic, which puts a self-test code where the LUN field is for older
commands.

In our NAS, we then use user-space to perform the unlock.

Dan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
