Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023AbaFPUSE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 16:18:04 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:49844 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755816AbaFPUSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 16:18:02 -0400
From: Julius Werner <jwerner@chromium.org>
To: Olof Johansson <olofj@chromium.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <stephen.r.warren@gmail.com>,
        Doug Anderson <dianders@chromium.org>,
        Stefan Reinauer <stefan.reinauer@coreboot.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Julius Werner <jwerner@chromium.org>
Subject: [PATCH v2] firmware: Add device tree binding for coreboot
Date: Mon, 16 Jun 2014 13:17:34 -0700
Message-Id: <1402949854-30380-1-git-send-email-jwerner@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
In-Reply-To: <CAODwPW9w0sKme=QSthJN7QACGcwpR6NmxufFtirkm6d3XYZ1_g@mail.gmail.com>
References: <1402689965-19397-1-git-send-email-jwerner@chromium.org> <CAL_JsqL-K4i54ysugCKSw-aO-9pvnYgZfJ=NdBAot=mwffxmyA@mail.gmail.com> <CAODwPW9tRM8kxBVg3apkec2K1rahuENk_b_BD_0jvXON7JzeaA@mail.gmail.com> <CALiw-2GWHKPbXuMFXUHY_pgpUJNdqQbyPEV1UjEep3zD2sSRPQ@mail.gmail.com> <CAODwPW9w0sKme=QSthJN7QACGcwpR6NmxufFtirkm6d3XYZ1_g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds documentation describing a device tree binding for the
coreboot firmware. It is meant to be dynamically added during boot and
contains address definitions for the coreboot table (a list of
variable-sized descriptors providing information about various compile-
and run-time generated firmware parameters) and the CBMEM area (the
structure containing most run-time resident memory regions set up by
coreboot).

These definitions allow kernel drivers to easily access data contained
in and pointed to by these regions (such as coreboot's in-memory log).
(An example implementation can be seen at http://crosreview.com/203371,
which will be submitted at a later point.)

Change-Id: I97609d461d306f85851e5efc26c675ca1e2d7e9d
Signed-off-by: Julius Werner <jwerner@chromium.org>
---
 .../devicetree/bindings/firmware/coreboot.txt      | 32 ++++++++++++++++++++++
 1 file changed, 32 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/firmware/coreboot.txt

diff --git a/Documentation/devicetree/bindings/firmware/coreboot.txt b/Documentation/devicetree/bindings/firmware/coreboot.txt
new file mode 100644
index 0000000..5055f0e
--- /dev/null
+++ b/Documentation/devicetree/bindings/firmware/coreboot.txt
@@ -0,0 +1,32 @@
+COREBOOT firmware information
+
+The device tree node to communicate the location of coreboot's memory-resident
+bookkeeping structures to the kernel. Since coreboot itself cannot boot a
+device-tree-based kernel (yet), this node needs to be inserted by a
+second-stage bootloader (a coreboot "payload").
+
+Required properties:
+ - compatible: Should be "coreboot"
+ - reg: Address and length of the following two memory regions, in order:
+	1.) The coreboot table. This is a list of variable-sized descriptors
+	that contain various compile- and run-time generated firmware
+	parameters. It is identified by the magic string "LBIO" in its first
+	four bytes. See coreboot's src/include/boot/coreboot_tables.h for
+	details.
+	2.) The CBMEM area. This is a downward-growing memory region used by
+	coreboot to dynamically allocate data structures that remain resident.
+	It may or may not include the coreboot table as one of its members. It
+	is identified by a root node descriptor with the magic number
+	0xc0389479 that resides in the topmost 8 bytes of the area. See
+	coreboot's src/lib/dynamic_cbmem.c for details.
+
+Example:
+	firmware {
+		ranges;
+
+		coreboot {
+			compatible = "coreboot";
+			reg = <0xfdfea000 0x264>,
+			      <0xfdfea000 0x16000>;
+		}
+	};
-- 
1.8.3.2

