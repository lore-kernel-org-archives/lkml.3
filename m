Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934908Ab3GRXtP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 19:49:15 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:62202 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933467Ab3GRXtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 19:49:12 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Julia Lawall <julia.lawall@lip6.fr>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>, Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH] backports: backport drvdata = NULL core driver fixes
Date: Thu, 18 Jul 2013 16:48:59 -0700
Message-Id: <1374191339-10124-1-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

The Linux kernel had tons of code which at times cleared the
drvdata upon probe failure or release. There are however a bunch
of drivers that didn't clear this.

Commit 0998d063 implmented clearing this upon device_release_driver()
and dealt with probe failure on driver_probe_device(). After this the
kernel was cleaned up separately with *tons* of patches to remove all
these driver specific settings given that the clearing is now done
internally by the device core.

Instead of ifdef'ing code back in for older code where it was properly
in place backport this by piggy backing the new required code upon the
calls used in place. There is a small race here upon device_release_driver()
but we can live with that theoretical race.

Due to the way we hack this backport we can't use a separate namespace
as we have with other symbols.

mcgrof@frijol ~/linux-stable (git::master)$ git describe --contains \
	0998d0631001288a5974afc0b2a5f568bcdecb4d
v3.6-rc1~99^2~14^2~17

commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
Author: Hans de Goede <hdegoede@redhat.com>
Date:   Wed May 23 00:09:34 2012 +0200

    device-core: Ensure drvdata = NULL when no driver is bound

    1) drvdata is for a driver to store a pointer to driver specific data
    2) If no driver is bound, there is no driver specific data associated with
       the device
    3) Thus logically drvdata should be NULL if no driver is bound.

    But many drivers don't clear drvdata on device_release, or set drvdata
    early on in probe and leave it set on probe error. Both of which results
    in a dangling pointer in drvdata.

    This patch enforce for drvdata to be NULL after device_release or on probe
    failure.

    Signed-off-by: Hans de Goede <hdegoede@redhat.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Tested with ckmake against next-20130618:

1   2.6.24              [  OK  ]
2   2.6.25              [  OK  ]
3   2.6.26              [  OK  ]
4   2.6.27              [  OK  ]
5   2.6.28              [  OK  ]
6   2.6.29              [  OK  ]
7   2.6.30              [  OK  ]
8   2.6.31              [  OK  ]
9   2.6.32              [  OK  ]
10  2.6.33              [  OK  ]
11  2.6.34              [  OK  ]
12  2.6.35              [  OK  ]
13  2.6.36              [  OK  ]
14  2.6.37              [  OK  ]
15  2.6.38              [  OK  ]
16  2.6.39              [  OK  ]
17  3.0.79              [  OK  ]
18  3.1.10              [  OK  ]
19  3.10-rc1            [  OK  ]
20  3.2.45              [  OK  ]
21  3.3.8               [  OK  ]
22  3.4.46              [  OK  ]
23  3.5.7               [  OK  ]
24  3.6.11              [  OK  ]
25  3.7.10              [  OK  ]
26  3.8.13              [  OK  ]
27  3.9.3               [  OK  ]

real    32m2.332s
user    860m23.688s
sys     121m20.840s

Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>
Cc: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 backport/backport-include/linux/device.h |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/backport/backport-include/linux/device.h b/backport/backport-include/linux/device.h
index c2f80e2..ba55d0e 100644
--- a/backport/backport-include/linux/device.h
+++ b/backport/backport-include/linux/device.h
@@ -176,4 +176,23 @@ extern int dev_set_name(struct device *dev, const char *name, ...)
 			__attribute__((format(printf, 2, 3)));
 #endif
 
+#if LINUX_VERSION_CODE <= KERNEL_VERSION(3,6,0)
+#define driver_probe_device(__drv, __dev)		\
+({							\
+ 	int ret;					\
+ 	ret = (driver_probe_device)(__drv, __dev);	\
+ 	if (ret)					\
+		dev_set_drvdata(__dev, NULL);		\
+ 	return ret;					\
+})
+
+#define device_release_driver(__dev)			\
+({							\
+ 	(device_release_driver)(__dev);			\
+ 	device_lock(__dev);				\
+ 	dev_set_drvdata(__dev, NULL);			\
+ 	device_unlock(__dev);				\
+})
+#endif /* LINUX_VERSION_CODE <= KERNEL_VERSION(3,6,0) */
+
 #endif /* __BACKPORT_DEVICE_H */
-- 
1.7.10.4

