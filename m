Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758904Ab3E1LOx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 07:14:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56259 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265Ab3E1LOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 07:14:51 -0400
Message-ID: <51A491A3.5080702@canonical.com>
Date: Tue, 28 May 2013 19:14:43 +0800
From: Bruce <bruce.ma@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: platform-driver-x86@vger.kernel.org
CC: ibm-acpi-devel@lists.sourceforge.net,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] subsystem:  thinkpad-acpi.c
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

from: Bruce Ma

For some specific model of laptop, don't execute any led functions.

Signed-off-by: Bruce Ma <bruce.ma@canonical.com>
- ---

- --- old/thinkpad_acpi.c    2013-01-29 16:54:34.000000000 +0800
+++ src/thinkpad_acpi.c    2013-01-29 16:52:46.000000000 +0800
@@ -1787,6 +1787,90 @@ static const struct tpacpi_quirk tpacpi_
 #undef TPV_Q_X
 #undef TPV_Q
 +/*
+check tpacpi_check_model()
+
+ * Model Name   , Number Model Name
+ * Lenovo LM490s, 814YG01
+
+ "dmesg | grep thinkpad_acpi" shows:
+ thinkpad_acpi: Lenovo Lenovo LM490s,      model 814YG01
+
+ How to add new model to blacklist:
+ Add these lines like below into lenovo_blacklist[].
+   {
+    .model_s = "Lenovo K490s",
+    .nummodel_s = "814YJ01",
+   },
+ */
+
+unsigned int no_led = 0 ;
+
+struct blacklist {
+  struct list_head blist;
+  char *model_s;
+  char *nummodel_s;
+};
+
+struct blacklist led_blacklist = {
+  .model_s = NULL,
+  .nummodel_s = NULL,
+};
+
+struct blacklist lenovo_blacklist[] = {
+  {
+    .model_s = "Lenovo LM490s",
+    .nummodel_s = "814YG01",
+  },
+  {
+    .model_s = "ThinkPad Edge E430",
+    .nummodel_s = "3254TNU",
+  },
+  {
+    .model_s = "LENOVO",
+    .nummodel_s = "914TK01",
+  },
+  {
+    .model_s = "ThinkPad Twist",
+    .nummodel_s = "334724C",
+  },
+  {
+    .model_s = "Lenovo M490s",
+    .nummodel_s = "914YG01",
+  },
+  {
+    .model_s = "Lenovo K490s",
+    .nummodel_s = "814YJ01",
+  },
+};
+
+static int __init tpacpi_check_model(void)
+{
+  unsigned int i ;
+  struct blacklist *list_p;
+
+  /* If thinkpad_id.nummodel_str is "unkown". */
+  if (!thinkpad_id.nummodel_str) {
+    return 1;
+  }
+
+  INIT_LIST_HEAD(&led_blacklist.blist);
+
+  for(i = 0; i < ARRAY_SIZE(lenovo_blacklist) ; i++) {
+    INIT_LIST_HEAD(&lenovo_blacklist[i].blist);
+    list_add(&lenovo_blacklist[i].blist, &led_blacklist.blist);
+  }
+
+  list_for_each_entry(list_p,&led_blacklist.blist,blist) {
+    if (!strcmp(list_p->model_s,thinkpad_id.model_str)
+                  &&
!strcmp(list_p->nummodel_s,thinkpad_id.nummodel_str)) {
+      no_led = 1;
+      pr_info("Disable led support for this model.\n");
+    }
+  }
+  return 0;
+}
+
 static void __init tpacpi_check_outdated_fw(void)
 {
     unsigned long fwvers;
@@ -5235,6 +5319,10 @@ static enum led_brightness led_sysfs_get
  static void led_exit(void)
 {
+        if (no_led == 1 ) {
+                 return 0;
+  }
+
     unsigned int i;
      for (i = 0; i < TPACPI_LED_NUMLEDS; i++) {
@@ -5349,6 +5437,10 @@ static enum led_access_mode __init led_i
  static int __init led_init(struct ibm_init_struct *iibm)
 {
+        if (no_led == 1 ) {
+           return 0;
+        }
+
     unsigned int i;
     int rc;
     unsigned long useful_leds;
@@ -5397,6 +5489,10 @@ static int __init led_init(struct ibm_in
  static int led_read(struct seq_file *m)
 {
+        if (no_led == 1 ) {
+                return 0;
+        }
+
     if (!led_supported) {
         seq_printf(m, "status:\t\tnot supported\n");
         return 0;
@@ -5423,6 +5519,10 @@ static int led_read(struct seq_file *m)
  static int led_write(char *buf)
 {
+        if (no_led == 1 ) {
+                return 0;
+        }
+
     char *cmd;
     int led, rc;
     enum led_status_t s;
@@ -9031,6 +9131,9 @@ static int __init thinkpad_acpi_module_i
     /* Driver initialization */
      thinkpad_acpi_init_banner();
+
+    tpacpi_check_model();
+
     tpacpi_check_outdated_fw();
      TPACPI_ACPIHANDLE_INIT(ecrd);



- ---
Bruce Ma
May 28,2013


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJRpJGjAAoJEFnPatyLvGg1rnMIAKqffR2XgBQfIaUv+Zqa3OE4
38KGwctvA/qxiFHtxQ7sMJFiiQ01/WskfCVJeWgkh7bDtJt14/Nd5bpCEnjHDBSZ
byqcziONeGt5o1yAXRAP2artuPwpIrdoRK3WYY9ODK+wJBFMb2wEc4EUuyfT5RAM
ASNzal+UjZyqL/UT9vfwtiN4OxuIlJ2BHeTP8jRElYZux2nEUvjtP0Wqwq7Otybc
ud6/p+Ldn1OOEJt+2sBBzdDo75mjOrewJxIsdZyHZoNnXPPZLnftvCM/k/mkEVw4
+ElZEDDVJWKGHqzqiHPKnaJRCqrnEw3t1u1C5hEK7hGn/PVtdYflV78CoimGG5Q=
=nLc0
-----END PGP SIGNATURE-----
