Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933773Ab3E1JXJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 05:23:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55454 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933724Ab3E1JXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 05:23:07 -0400
Message-ID: <51A47773.4080701@canonical.com>
Date: Tue, 28 May 2013 17:22:59 +0800
From: Bruce <bruce.ma@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: platform-driver-x86@vger.kernel.org
CC: ibm-acpi-devel@lists.sourceforge.net,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        linux-kernel@vger.kernel.org
Subject: Patch for thinkpad-acpi.c
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi, all:

We are testing Ubuntu 12.04 on some laptops , and find out there are
some error messages in dmesg after run S3 or S4. Like:
[10512.177806] ACPI Warning: For \_SB_.PCI0.LPCB.H_EC.LED_: Excess
arguments - needs 1, found 2 (20110623/nspredef-326)
[11728.328110] ACPI Warning: For \_SB_.PCI0.LPCB.H_EC.LED_: Excess
arguments - needs 1, found 2 (20110623/nspredef-326)

The root cause is thinkpad-acpi.c, the LED function will trigger this
message.
Because theses laptops don't have any led light, so we don't need any
action for leds.

Then I make a patch for this issue:
1. Add a blacklist which include some model name and model number.
2. Add a function which name tpacpi_check_model()  in
thinkpad_acpi_module_i() . It will check the model name and model number
    during init step. If this model name is in blacklist, then set value
no_led to 1.
3. Add a condition in led_exit(),led_init(),led_read() and led_write(),
if no_led is 1, then just return.


patch file no-led.patch:

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

# End of patch



==============
Bruce Ma
May 28,2013


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJRpHdvAAoJEFnPatyLvGg17w0H/i2r/ZFbnHD2KRf5tgCWGol+
ihha9IqNXUGMMoltcWh2NrJybKZcc4QspGHAhr3sqX7id825tPYvWEtSPOMXs373
ytHFAVc5SEf40I6Zmwhb6YDgwJsh2SS02wkQeKbfTyi5aj2XSOvK0ap4IDFeFJgd
+Ewe7A7ZGwkR5ybBgHSqgw+IUv0H0Gj0PnJooLqLVXbt7gJ9583yP/SLZyADkgJv
KCRjbId/I8OI58/Wil8u3rkzTKO1RU0UUItxiJrDuinod4heKnQ0MyPgbDzVlUU1
3KE08jsITFEckI4QDwQpPcHbWLh3+C5hrsCwBhKDZDZEorzAxXxEDo1idz/g3Io=
=DuJ/
-----END PGP SIGNATURE-----

