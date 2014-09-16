Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519AbaIPVqu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 17:46:50 -0400
Received: from vidar.hosts.sieglitzhof.net ([62.113.200.140]:60158 "EHLO
	vidar.hosts.sieglitzhof.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751955AbaIPVqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 17:46:49 -0400
X-Greylist: delayed 416 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Sep 2014 17:46:48 EDT
From: Maximilian Eschenbacher <maximilian@eschenbacher.email>
To: linux-kernel@vger.kernel.org
Cc: valentina.manea.m@gmail.com, shuah.kh@samsung.com,
        gregkh@linuxfoundation.org, Tobias Polzer <tobias.polzer@fau.de>,
        Maximilian Eschenbacher <maximilian@eschenbacher.email>,
        Fjodor Schelichow <fjodor.schelichow@hotmail.com>,
        Johannes Stadlinger <johannes.stadlinger@fau.de>,
        Dominik Paulus <dominik.paulus@fau.de>
Date: Tue, 16 Sep 2014 23:38:53 +0000
Message-Id: <1410910735-27929-17-git-send-email-maximilian@eschenbacher.email>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410910735-27929-1-git-send-email-maximilian@eschenbacher.email>
References: <1410910735-27929-1-git-send-email-maximilian@eschenbacher.email>
X-SA-Exim-Connect-IP: 172.16.2.6
X-SA-Exim-Mail-From: maximilian@eschenbacher.email
Subject: [PATCH 16/18] usbip: Update documentation
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on vidar.hosts.sieglitzhof.net)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tobias Polzer <tobias.polzer@fau.de>

README was updated and cleaned. It now contains just one example, which
was updated to use encryption. Also, the new crypto behaviour is
documented. The usbip "port" command has been removed from the README,
as it isn't supported by newer userland versions. One dead link was
removed from the checklist section.

Signed-off-by: Maximilian Eschenbacher <maximilian@eschenbacher.email>
Signed-off-by: Fjodor Schelichow <fjodor.schelichow@hotmail.com>
Signed-off-by: Johannes Stadlinger <johannes.stadlinger@fau.de>
Signed-off-by: Tobias Polzer <tobias.polzer@fau.de>
Signed-off-by: Dominik Paulus <dominik.paulus@fau.de>
---
 tools/usb/usbip/README       | 72 +++++++++++++++++---------------------------
 tools/usb/usbip/doc/usbip.8  |  2 ++
 tools/usb/usbip/doc/usbipd.8 |  4 ++-
 3 files changed, 33 insertions(+), 45 deletions(-)

diff --git a/tools/usb/usbip/README b/tools/usb/usbip/README
index 831f49f..ebb194b 100644
--- a/tools/usb/usbip/README
+++ b/tools/usb/usbip/README
@@ -12,13 +12,15 @@
     - libudev >= 2.0
 	libudev library
 
-    - libwrap0-dev
+    - libwrap0-dev (optional)
 	tcp wrapper library
 
     - gcc >= 4.0
 
     - libtool, automake >= 1.9, autoconf >= 2.5.0, pkg-config
 
+    - libgnutls-dev >= 3.0 (libgnutls28-dev on debian) (optional)
+
 [Optional]
     - hwdata
         Contains USB device identification data.
@@ -29,43 +31,38 @@
 	$ ./autogen.sh
 
     1. Compile & install the userspace utilities.
-	$ ./configure [--with-tcp-wrappers=no] [--with-usbids-dir=<dir>]
+	$ ./configure [--with-tcp-wrappers=no] [--with-usbids-dir=<dir>] [--with-gnutls]
 	$ make install
 
     2. Compile & install USB/IP drivers.
 
 
 [Usage]
-    server:# (Physically attach your USB device.)
-
-    server:# insmod usbip-core.ko
-    server:# insmod usbip-host.ko
-
-    server:# usbipd -D
-	- Start usbip daemon.
-
-    server:# usbip list -l
-	- List driver assignments for USB devices.
 
-    server:# usbip bind --busid 1-2
-	- Bind usbip-host.ko to the device with busid 1-2.
-	- The USB device 1-2 is now exportable to other hosts!
-	- Use `usbip unbind --busid 1-2' to stop exporting the device.
+See usbip(8) and usbipd(8).
 
-    client:# insmod usbip-core.ko
-    client:# insmod vhci-hcd.ko
+[Security considerations]
+By default, all of the usbip network traffic is unencrypted and
+unauthenticated. As it is mostly parsed in staging quality kernel code, you
+should use usbip in this mode only in absolutely trusted environments.
 
-    client:# usbip list --remote <host>
-	- List exported USB devices on the <host>.
+In addition to the usual methods for secure network tunneling - SSH tunnels,
+IPsec, etc. -, usbip version 1.2.1 supports out-of-the-box crypto for all of
+the network traffic. This requires usbip to be compiled with GnuTLS enabled
+(configure switch: --with-gnutls). Crypto support can be enabled by using
+password authentication. If the --auth flag is set, usbip will not only
+authenticate client and server using the shared passphrase, but also encrypt
+and authenticate all of the following traffic. For the userspace traffic,
+GnuTLS is used, the kernel traffic is encrypted and authenticated using AES-GCM
+with 128bit keys. The session keys are randomly generated and exchanged for
+in userspace for each connection.
 
-    client:# usbip attach --remote <host> --busid 1-2
-	- Connect the remote USB device.
-
-    client:# usbip port
-	- Show virtual port status.
-
-    client:# usbip detach --port <port>
-	- Detach the USB device.
+The encryption support has been designed to offer perfect forward secrecy and
+decent security even if using rather weak passwords. Strong passwords are
+mainly needed to provide proper authorization (this is still important, see
+above!) and to secure against man-in-the-middle attacks.
+However, the crypto code still lacks complete review and code auditing. Do not
+rely on it for strong security.
 
 
 [Example]
@@ -76,7 +73,7 @@ Physically attach your USB devices to this host.
 
     trois:# insmod path/to/usbip-core.ko
     trois:# insmod path/to/usbip-host.ko
-    trois:# usbipd -D
+    trois:# usbipd -sVerySecret -D
 
 In another terminal, let's look up what USB devices are physically
 attached to this host.
@@ -139,7 +136,7 @@ exportable on the host.
     deux:# insmod path/to/usbip-core.ko
     deux:# insmod path/to/vhci-hcd.ko
 
-    deux:# usbip list --remote 10.0.0.3
+    deux:# usbip --auth VerySecret list --remote 10.0.0.3
     Exportable USB devices
     ======================
      - 10.0.0.3
@@ -167,20 +164,9 @@ exportable on the host.
 
 Attach a remote USB device:
 
-    deux:# usbip attach --remote 10.0.0.3 --busid 1-1
+    deux:# usbip --auth VerySecret attach --remote 10.0.0.3 --busid 1-1
     port 0 attached
 
-Show the devices attached to this client:
-
-    deux:# usbip port
-    Port 00: <Port in Use> at Full Speed(12Mbps)
-	   Prolific Technology, Inc. : unknown product (067b:3507)
-	   6-1 -> usbip://10.0.0.3:3240/1-1  (remote bus/dev 001/004)
-	   6-1:1.0 used by usb-storage
-			  /sys/class/scsi_device/0:0:0:0/device
-			  /sys/class/scsi_host/host0/device
-			  /sys/block/sda/device
-
 Detach the imported device:
 
     deux:# usbip detach --port 0
@@ -188,8 +174,6 @@ Detach the imported device:
 
 
 [Checklist]
-    - See 'Debug Tips' on the project wiki.
-	- http://usbip.wiki.sourceforge.net/how-to-debug-usbip
     - usbip-host.ko must be bound to the target device.
 	- See /proc/bus/usb/devices and find "Driver=..." lines of the device.
     - Shutdown firewall.
diff --git a/tools/usb/usbip/doc/usbip.8 b/tools/usb/usbip/doc/usbip.8
index c7ba36f..b818bde 100644
--- a/tools/usb/usbip/doc/usbip.8
+++ b/tools/usb/usbip/doc/usbip.8
@@ -27,7 +27,9 @@ Log to syslog.
 \fB\-\-tcp-port PORT\fR
 .IP
 Connect to PORT on remote host (used for attach and list --remote).
+.PP
 
+.HP
 \fB\-\-auth\fR
 .IP
 Set the password to be used for client authentication. See usbipd(8) for more information.
diff --git a/tools/usb/usbip/doc/usbipd.8 b/tools/usb/usbip/doc/usbipd.8
index 8beb95a..3fcd9ed 100644
--- a/tools/usb/usbip/doc/usbipd.8
+++ b/tools/usb/usbip/doc/usbipd.8
@@ -56,7 +56,9 @@ Listen on TCP/IP port PORT.
 .HP
 \fB\-s\fR, \fB\-\-auth\fR
 .IP
-Sets the password to be used for client authentication. If -a is used, the server will only accept connections from authenticated clients. Note: USB traffic will still be unencrypted, this currently only serves for authentication.
+Sets the password to be used for client authentication. If -a is used, the
+server will only accept connections from authenticated clients. This will also
+encrypt the whole usbip traffic, including kernel traffic, using 128bit AES.
 .PP
 
 \fB\-h\fR, \fB\-\-help\fR
-- 
2.1.0

