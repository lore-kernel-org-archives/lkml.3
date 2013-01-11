Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781Ab3AKCrs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 21:47:48 -0500
Received: from mail-ye0-f201.google.com ([209.85.213.201]:40965 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775Ab3AKCrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 21:47:47 -0500
X-Greylist: delayed 3968 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Jan 2013 21:47:46 EST
From: Simon Glass <sjg@chromium.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Simon Glass <sjg@chromium.org>, linux-input@vger.kernel.org,
        Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org, Roland Stigge <stigge@antcom.de>,
        linux-doc@vger.kernel.org, Vincent Palatin <vpalatin@chromium.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Felipe Balbi <balbi@ti.com>, Sourav Poddar <sourav.poddar@ti.com>,
        Luigi Semenzato <semenzato@chromium.org>,
        Olof Johansson <olof@lixom.net>, Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@nvidia.com>,
        Alban Bedel <alban.bedel@avionic-design.de>
Subject: [PATCH v2] input: Extend matrix-keypad device tree binding
Date: Thu, 10 Jan 2013 17:41:32 -0800
Message-Id: <1357868492-16023-1-git-send-email-sjg@chromium.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some matrix keypad drivers can support different numbers of rows and
columns. Add a generic binding for these.

Implementation note:

In order to implement this binding in the kernel, we will need to modify
matrix_keypad_() to look up the number of rows and cols in
the keymap. Perhaps this could be done by passing 0 for these parameters?
Many of the parameters can already be set to NULL. Ick.

Signed-off-by: Simon Glass <sjg@chromium.org>
---
Changes in v2:
- Remove repeat rate parameters
- Update TI OMAP, tca8418 and lpc32xx bindings to use this one

 .../devicetree/bindings/input/lpc32xx-key.txt      |    9 ++++++---
 .../devicetree/bindings/input/matrix-keymap.txt    |    8 ++++++++
 .../devicetree/bindings/input/omap-keypad.txt      |   13 +++++--------
 .../devicetree/bindings/input/tca8418_keypad.txt   |    6 ++++--
 4 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/Documentation/devicetree/bindings/input/lpc32xx-key.txt b/Documentation/devicetree/bindings/input/lpc32xx-key.txt
index 31afd50..bcf62f8 100644
--- a/Documentation/devicetree/bindings/input/lpc32xx-key.txt
+++ b/Documentation/devicetree/bindings/input/lpc32xx-key.txt
@@ -1,19 +1,22 @@
 NXP LPC32xx Key Scan Interface
 
+This binding is based on the matrix-keymap binding with the following
+changes:
+
 Required Properties:
 - compatible: Should be "nxp,lpc3220-key"
 - reg: Physical base address of the controller and length of memory mapped
   region.
 - interrupts: The interrupt number to the cpu.
-- keypad,num-rows: Number of rows and columns, e.g. 1: 1x1, 6: 6x6
-- keypad,num-columns: Must be equal to keypad,num-rows since LPC32xx only
-  supports square matrices
 - nxp,debounce-delay-ms: Debounce delay in ms
 - nxp,scan-delay-ms: Repeated scan period in ms
 - linux,keymap: the key-code to be reported when the key is pressed
   and released, see also
   Documentation/devicetree/bindings/input/matrix-keymap.txt
 
+Note: keypad,num-rows and keypad,num-columns are required, and must be equal
+since LPC32xx only supports square matrices
+
 Example:
 
 	key@40050000 {
diff --git a/Documentation/devicetree/bindings/input/matrix-keymap.txt b/Documentation/devicetree/bindings/input/matrix-keymap.txt
index 3cd8b98..c54919f 100644
--- a/Documentation/devicetree/bindings/input/matrix-keymap.txt
+++ b/Documentation/devicetree/bindings/input/matrix-keymap.txt
@@ -9,6 +9,12 @@ Required properties:
 	row << 24 | column << 16 | key-code
 
 Optional properties:
+Properties for the number of rows and columns are optional because some
+drivers will use fixed values for these.
+- keypad,num-rows: Number of row lines connected to the keypad controller.
+- keypad,num-columns: Number of column lines connected to the keypad
+  controller.
+
 Some users of this binding might choose to specify secondary keymaps for
 cases where there is a modifier key such as a Fn key. Proposed names
 for said properties are "linux,fn-keymap" or with another descriptive
@@ -17,3 +23,5 @@ word for the modifier other from "Fn".
 Example:
 	linux,keymap = < 0x00030012
 			 0x0102003a >;
+	keypad,num-rows = <2>;
+	keypad,num-columns = <8>;
diff --git a/Documentation/devicetree/bindings/input/omap-keypad.txt b/Documentation/devicetree/bindings/input/omap-keypad.txt
index f2fa5e1..34ed1c6 100644
--- a/Documentation/devicetree/bindings/input/omap-keypad.txt
+++ b/Documentation/devicetree/bindings/input/omap-keypad.txt
@@ -6,19 +6,16 @@ A key can be placed at each intersection of a unique row and a unique column.
 The keypad controller can sense a key-press and key-release and report the
 event using a interrupt to the cpu.
 
+This binding is based on the matrix-keymap binding with the following
+changes:
+
+keypad,num-rows and keypad,num-columns are required.
+
 Required SoC Specific Properties:
 - compatible: should be one of the following
    - "ti,omap4-keypad": For controllers compatible with omap4 keypad
       controller.
 
-Required Board Specific Properties, in addition to those specified by
-the shared matrix-keyboard bindings:
-- keypad,num-rows: Number of row lines connected to the keypad
-  controller.
-
-- keypad,num-columns: Number of column lines connected to the
-  keypad controller.
-
 Optional Properties specific to linux:
 - linux,keypad-no-autorepeat: do no enable autorepeat feature.
 
diff --git a/Documentation/devicetree/bindings/input/tca8418_keypad.txt b/Documentation/devicetree/bindings/input/tca8418_keypad.txt
index 2a1538f..2551850 100644
--- a/Documentation/devicetree/bindings/input/tca8418_keypad.txt
+++ b/Documentation/devicetree/bindings/input/tca8418_keypad.txt
@@ -1,8 +1,10 @@
+This binding is based on the matrix-keymap binding with the following
+changes:
+
+keypad,num-rows and keypad,num-columns are required.
 
 Required properties:
 - compatible: "ti,tca8418"
 - reg: the I2C address
 - interrupts: IRQ line number, should trigger on falling edge
-- keypad,num-rows: The number of rows
-- keypad,num-columns: The number of columns
 - linux,keymap: Keys definitions, see keypad-matrix.
-- 
1.7.7.3

