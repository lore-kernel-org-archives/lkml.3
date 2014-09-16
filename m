Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbaIPWHN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 18:07:13 -0400
Received: from vidar.hosts.sieglitzhof.net ([62.113.200.140]:60276 "EHLO
	vidar.hosts.sieglitzhof.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753833AbaIPWHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 18:07:09 -0400
From: Maximilian Eschenbacher <maximilian@eschenbacher.email>
To: linux-kernel@vger.kernel.org
Cc: valentina.manea.m@gmail.com, shuah.kh@samsung.com,
        gregkh@linuxfoundation.org,
        Maximilian Eschenbacher <maximilian@eschenbacher.email>,
        Fjodor Schelichow <fjodor.schelichow@hotmail.com>,
        Johannes Stadlinger <johannes.stadlinger@fau.de>,
        Kurt Kanzenbach <ly80toro@cip.cs.fau.de>,
        Dominik Paulus <dominik.paulus@fau.de>,
        Tobias Polzer <tobias.polzer@fau.de>
Date: Tue, 16 Sep 2014 23:38:42 +0000
Message-Id: <1410910735-27929-6-git-send-email-maximilian@eschenbacher.email>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410910735-27929-1-git-send-email-maximilian@eschenbacher.email>
References: <1410910735-27929-1-git-send-email-maximilian@eschenbacher.email>
X-SA-Exim-Connect-IP: 172.16.2.6
X-SA-Exim-Mail-From: maximilian@eschenbacher.email
Subject: [PATCH 05/18] usbip: Add ACL support to usbip bind
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on vidar.hosts.sieglitzhof.net)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the command line argument -a (--allow) to usbip bind to specify
networks allowed to attach to the device and code to store the ACLs in
sysfs.

Signed-off-by: Maximilian Eschenbacher <maximilian@eschenbacher.email>
Signed-off-by: Fjodor Schelichow <fjodor.schelichow@hotmail.com>
Signed-off-by: Johannes Stadlinger <johannes.stadlinger@fau.de>
Signed-off-by: Kurt Kanzenbach <ly80toro@cip.cs.fau.de>
Signed-off-by: Dominik Paulus <dominik.paulus@fau.de>
Signed-off-by: Tobias Polzer <tobias.polzer@fau.de>
---
 tools/usb/usbip/doc/usbip.8      |  8 +++++-
 tools/usb/usbip/src/usbip_bind.c | 62 ++++++++++++++++++++++++++++++++--------
 2 files changed, 57 insertions(+), 13 deletions(-)

diff --git a/tools/usb/usbip/doc/usbip.8 b/tools/usb/usbip/doc/usbip.8
index 847aa40..c7ba36f 100644
--- a/tools/usb/usbip/doc/usbip.8
+++ b/tools/usb/usbip/doc/usbip.8
@@ -60,9 +60,15 @@ Detach an imported USB device.
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
diff --git a/tools/usb/usbip/src/usbip_bind.c b/tools/usb/usbip/src/usbip_bind.c
index fa46141..b888ea3 100644
--- a/tools/usb/usbip/src/usbip_bind.c
+++ b/tools/usb/usbip/src/usbip_bind.c
@@ -38,8 +38,9 @@ enum unbind_status {
 
 static const char usbip_bind_usage_string[] =
 	"usbip bind <args>\n"
-	"    -b, --busid=<busid>    Bind " USBIP_HOST_DRV_NAME ".ko to device "
-	"on <busid>\n";
+	"    -b, --busid=<busid>        Bind " USBIP_HOST_DRV_NAME ".ko to "
+	"device on <busid>\n"
+	"    -a, --allow=<CIDR mask>    Restrict device access to <CIDR mask>\n";
 
 void usbip_bind_usage(void)
 {
@@ -47,10 +48,11 @@ void usbip_bind_usage(void)
 }
 
 /* call at unbound state */
-static int bind_usbip(char *busid)
+static int bind_usbip(char *busid, char *allow)
 {
 	char attr_name[] = "bind";
 	char bind_attr_path[SYSFS_PATH_MAX];
+	char ip_attr_path[SYSFS_PATH_MAX];
 	int rc = -1;
 
 	snprintf(bind_attr_path, sizeof(bind_attr_path), "%s/%s/%s/%s/%s/%s",
@@ -64,6 +66,19 @@ static int bind_usbip(char *busid)
 		return -1;
 	}
 
+	/*
+	 * store allowed IP ranges
+	 * specified by `usbip bind -b <busid> --allow <CIDR mask>`
+	 */
+	snprintf(ip_attr_path, sizeof(ip_attr_path), "%s/%s/%s/%s/%s/%s/%s",
+		 SYSFS_MNT_PATH, SYSFS_BUS_NAME, SYSFS_BUS_TYPE,
+		 SYSFS_DRIVERS_NAME, USBIP_HOST_DRV_NAME, busid, "usbip_acl");
+	rc = write_sysfs_attribute(ip_attr_path, allow, strlen(allow));
+	if (rc < 0) {
+		err("error writing cidr mask %s", allow);
+		return -1;
+	}
+
 	return 0;
 }
 
@@ -139,7 +154,7 @@ out:
 	return status;
 }
 
-static int bind_device(char *busid)
+static int bind_device(char *busid, char *allow)
 {
 	int rc;
 	struct udev *udev;
@@ -170,7 +185,7 @@ static int bind_device(char *busid)
 		return -1;
 	}
 
-	rc = bind_usbip(busid);
+	rc = bind_usbip(busid, allow);
 	if (rc < 0) {
 		err("could not bind device to %s", USBIP_HOST_DRV_NAME);
 		modify_match_busid(busid, 0);
@@ -186,29 +201,52 @@ int usbip_bind(int argc, char *argv[])
 {
 	static const struct option opts[] = {
 		{ "busid", required_argument, NULL, 'b' },
+		{ "allow", optional_argument, NULL, 'a' },
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
2.1.0

