Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936AbaA2Cdv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 21:33:51 -0500
Received: from ozlabs.org ([203.10.76.45]:50124 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751669AbaA2Cdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 21:33:50 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tom Gundersen <teg@jklm.no>, linux-kernel@vger.kernel.org
Cc: linux-input@vger.kernel.org, kay@vrfy.org, Tom Gundersen <teg@jklm.no>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH] module: allow multiple calls to MODULE_DEVICE_TABLE() per module
In-Reply-To: <1390916546-27155-1-git-send-email-teg@jklm.no>
References: <87k3dkzy4t.fsf@rustcorp.com.au> <1390916546-27155-1-git-send-email-teg@jklm.no>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Wed, 29 Jan 2014 12:05:50 +1030
Message-ID: <87bnyvzi15.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tom Gundersen <teg@jklm.no> writes:
> Commit 78551277e4df5: "Input: i8042 - add PNP modaliases" had a bug, where the
> second call to MODULE_DEVICE_TABLE() overrode the first resulting in not all
> the modaliases being exposed.
>
> This fixes the problem by including the name of the device_id table in the
> __mod_*_device_table alias, allowing us to export several device_id tables
> per module.

Thanks, applied.

I also put this on top:

module: remove MODULE_GENERIC_TABLE

MODULE_DEVICE_TABLE() calles MODULE_GENERIC_TABLE(); make it do the
work directly.  This also removes a wart introduced in the last patch,
where the alias is defined to be an unknown struct type "struct
type##__##name##_device_id" instead of "struct type##_device_id" (it's
an extern so GCC doesn't care, but it's wrong).

The other user of MODULE_GENERIC_TABLE (ISAPNP_CARD_TABLE) is unused,
so delete it.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/include/linux/isapnp.h b/include/linux/isapnp.h
index e2d28b026a8c..3c77bf9b1efd 100644
--- a/include/linux/isapnp.h
+++ b/include/linux/isapnp.h
@@ -56,10 +56,6 @@
 #define ISAPNP_DEVICE_ID(_va, _vb, _vc, _function) \
 		{ .vendor = ISAPNP_VENDOR(_va, _vb, _vc), .function = ISAPNP_FUNCTION(_function) }
 
-/* export used IDs outside module */
-#define ISAPNP_CARD_TABLE(name) \
-		MODULE_GENERIC_TABLE(isapnp_card, name)
-
 struct isapnp_card_id {
 	unsigned long driver_data;	/* data private to the driver */
 	unsigned short card_vendor, card_device;
diff --git a/include/linux/module.h b/include/linux/module.h
index ad18f6006f86..5686b37e11d6 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -82,15 +82,6 @@ void sort_extable(struct exception_table_entry *start,
 void sort_main_extable(void);
 void trim_init_extable(struct module *m);
 
-#ifdef MODULE
-#define MODULE_GENERIC_TABLE(gtype, name)			\
-extern const struct gtype##_id __mod_##gtype##_table		\
-  __attribute__ ((unused, alias(__stringify(name))))
-
-#else  /* !MODULE */
-#define MODULE_GENERIC_TABLE(gtype, name)
-#endif
-
 /* Generic info of form tag = "info" */
 #define MODULE_INFO(tag, info) __MODULE_INFO(tag, tag, info)
 
@@ -141,8 +132,14 @@ extern const struct gtype##_id __mod_##gtype##_table		\
 /* What your module does. */
 #define MODULE_DESCRIPTION(_description) MODULE_INFO(description, _description)
 
-#define MODULE_DEVICE_TABLE(type, name)		\
-  MODULE_GENERIC_TABLE(type##__##name##_device, name)
+#ifdef MODULE
+/* Creates an alias so file2alias.c can find device table. */
+#define MODULE_DEVICE_TABLE(type, name)					\
+  extern const struct type##_device_id __mod_##type##__##name##_device_table \
+  __attribute__ ((unused, alias(__stringify(name))))
+#else  /* !MODULE */
+#define MODULE_DEVICE_TABLE(type, name)
+#endif
 
 /* Version of form [<epoch>:]<version>[-<extra-version>].
  * Or for CVS/RCS ID version, everything but the number is stripped.
