Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109Ab3IMJze (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 05:55:34 -0400
Received: from mx-rz-1.rrze.uni-erlangen.de ([131.188.11.20]:54182 "EHLO
	mx-rz-1.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754899Ab3IMJyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 05:54:09 -0400
X-RRZE-Submit-IP: 131.188.42.159
From: Dominik Paulus <dominik.paulus@fau.de>
To: linux-kernel@vger.kernel.org
Cc: Dominik Paulus <dominik.paulus@fau.de>,
        Kurt Kanzenbach <ly80toro@cip.cs.fau.de>,
        Tobias Polzer <tobias.polzer@fau.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ilija Hadzic <ihadzic@research.bell-labs.com>,
        Anthony Foiani <anthony.foiani@gmail.com>,
        Masanari Iida <standby24x7@gmail.com>, linux-kernel@i4.cs.fau.de,
        devel@driverdev.osuosl.org
Subject: [PATCHv2 05/11] staging: usbip: Add ACL support to usbip bind
Date: Fri, 13 Sep 2013 11:55:55 +0200
Message-Id: <1379066161-8278-6-git-send-email-dominik.paulus@fau.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1379066161-8278-1-git-send-email-dominik.paulus@fau.de>
References: <1379066161-8278-1-git-send-email-dominik.paulus@fau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the command line argument -a (--allow) to usbip bind to specify
networks allowed to attach to the device and code to store the ACLs in
sysfs.

Signed-off-by: Kurt Kanzenbach <ly80toro@cip.cs.fau.de>
Signed-off-by: Dominik Paulus <dominik.paulus@fau.de>
Signed-off-by: Tobias Polzer <tobias.polzer@fau.de>
---
 drivers/staging/usbip/userspace/doc/usbip.8      |  8 ++-
 drivers/staging/usbip/userspace/src/usbip_bind.c | 74 ++++++++++++++++++++----
 2 files changed, 69 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/usbip/userspace/doc/usbip.8 b/drivers/staging/usbip/userspace/doc/usbip.8
index b5050ed..b818bde 100644
--- a/drivers/staging/usbip/userspace/doc/usbip.8
+++ b/drivers/staging/usbip/userspace/doc/usbip.8
@@ -62,9 +62,15 @@ Detach an imported USB device.
 .PP
 
 .HP
-\fBbind\fR \-\-busid=<\fIbusid\fR>
+\fBbind\fR \-\-busid=<\fIbusid\fR> [\-\-allow=<\fICIDR mask\fR>...]
 .IP
 Make a device exportable.
+.br
+\-\-allow accepts CIDR masks like 127.0.0.0/8 or fd00::/64
+.br
+Only hosts in (at least) one of the allowed ranges are accepted. If
+\-\-allow is omitted, 0.0.0.0/0 and ::/0 are added to the list. The list can
+be read/written from corresponding \fBusbip_acl\fR file in sysfs after bind.
 .PP
 
 .HP
diff --git a/drivers/staging/usbip/userspace/src/usbip_bind.c b/drivers/staging/usbip/userspace/src/usbip_bind.c
index 9ecaf6e..d2739fc 100644
--- a/drivers/staging/usbip/userspace/src/usbip_bind.c
+++ b/drivers/staging/usbip/userspace/src/usbip_bind.c
@@ -37,8 +37,9 @@ enum unbind_status {
 
 static const char usbip_bind_usage_string[] =
 	"usbip bind <args>\n"
-	"    -b, --busid=<busid>    Bind " USBIP_HOST_DRV_NAME ".ko to device "
-	"on <busid>\n";
+	"    -b, --busid=<busid>        Bind " USBIP_HOST_DRV_NAME ".ko to "
+	"device on <busid>\n"
+	"    -a, --allow=<CIDR mask>    Restrict device access to <CIDR mask>\n";
 
 void usbip_bind_usage(void)
 {
@@ -46,17 +47,19 @@ void usbip_bind_usage(void)
 }
 
 /* call at unbound state */
-static int bind_usbip(char *busid)
+static int bind_usbip(char *busid, char *allow)
 {
 	char bus_type[] = "usb";
 	char attr_name[] = "bind";
 	char sysfs_mntpath[SYSFS_PATH_MAX];
 	char bind_attr_path[SYSFS_PATH_MAX];
 	char intf_busid[SYSFS_BUS_ID_SIZE];
+	char ip_attr_path[SYSFS_PATH_MAX];
 	struct sysfs_device *busid_dev;
 	struct sysfs_attribute *bind_attr;
 	struct sysfs_attribute *bConfValue;
 	struct sysfs_attribute *bNumIntfs;
+	struct sysfs_attribute *usbip_ip;
 	int i, failed = 0;
 	int rc, ret = -1;
 
@@ -101,8 +104,32 @@ static int bind_usbip(char *busid)
 			dbg("bind driver at %s failed", intf_busid);
 			failed = 1;
 		}
+
+	}
+
+	/*
+	 * store allowed IP ranges
+	 * specified by `usbip bind -b <busid> --allow <CIDR mask>`
+	 */
+	snprintf(ip_attr_path, sizeof(ip_attr_path),
+			"%s/%s/%s/%s/%s/%s:%.1s.%d/%s",
+			sysfs_mntpath, SYSFS_BUS_NAME, bus_type,
+			SYSFS_DRIVERS_NAME, USBIP_HOST_DRV_NAME, busid,
+			bConfValue->value, 0, "usbip_acl");
+
+	usbip_ip = sysfs_open_attribute(ip_attr_path);
+	if (!usbip_ip) {
+		err("sysfs_open_attribute failed: path=%s",
+				ip_attr_path);
+		goto err_close_busid_dev;
 	}
 
+	rc = sysfs_write_attribute(usbip_ip, allow, strlen(allow));
+	if (rc)
+		err("sysfs_write_attribute failed");
+
+	sysfs_close_attribute(usbip_ip);
+
 	if (!failed)
 		ret = 0;
 
@@ -213,7 +240,7 @@ out:
 	return status;
 }
 
-static int bind_device(char *busid)
+static int bind_device(char *busid, char *allow)
 {
 	int rc;
 
@@ -233,7 +260,7 @@ static int bind_device(char *busid)
 		return -1;
 	}
 
-	rc = bind_usbip(busid);
+	rc = bind_usbip(busid, allow);
 	if (rc < 0) {
 		err("could not bind device to %s", USBIP_HOST_DRV_NAME);
 		modify_match_busid(busid, 0);
@@ -249,29 +276,52 @@ int usbip_bind(int argc, char *argv[])
 {
 	static const struct option opts[] = {
 		{ "busid", required_argument, NULL, 'b' },
+		{ "allow", required_argument, NULL, 'a' },
 		{ NULL,    0,                 NULL,  0  }
 	};
 
-	int opt;
-	int ret = -1;
+	int opt, rc;
+	char allow[4096];
+	char *device = NULL;
+	struct subnet subnet;
+
+	allow[0] = 0;
 
 	for (;;) {
-		opt = getopt_long(argc, argv, "b:", opts, NULL);
+		opt = getopt_long(argc, argv, "a:b:", opts, NULL);
 
 		if (opt == -1)
 			break;
 
 		switch (opt) {
+		case 'a':
+			rc = parse_cidr(optarg, &subnet);
+			if (rc < 0) {
+				err("Invalid subnet specified: %s", optarg);
+				goto err_out;
+			}
+
+			if (strlen(allow) < sizeof(allow) - strlen(optarg) - 2)
+				sprintf(allow + strlen(allow), "%s\n", optarg);
+			else
+				err("ACL length too long.");
+			break;
 		case 'b':
-			ret = bind_device(optarg);
-			goto out;
+			device = optarg;
+			break;
 		default:
 			goto err_out;
 		}
 	}
 
+	/* By default, allow access from all IPs */
+	if (!allow[0])
+		strcpy(allow, "::/0\n0.0.0.0/0\n");
+
+	if (device)
+		return bind_device(device, allow);
+
 err_out:
 	usbip_bind_usage();
-out:
-	return ret;
+	return -1;
 }
-- 
1.8.4

