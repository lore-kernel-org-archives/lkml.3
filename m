Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210AbaEDPnX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 11:43:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36946 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755171AbaEDPnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:43:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        Jim Somerville <Jim.Somerville@windriver.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 3.4 34/43] hvc: ensure hvc_init is only ever called once in hvc_console.c
Date: Sun,  4 May 2014 11:42:28 -0400
Message-Id: <20140504154228.906653088@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154224.211508175@linuxfoundation.org>
References: <20140504154224.211508175@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Gortmaker <paul.gortmaker@windriver.com>

commit f76a1cbed18c86e2d192455f0daebb48458965f3 upstream.

Commit 3e6c6f630a5282df8f3393a59f10eb9c56536d23 ("Delay creation of
khcvd thread") moved the call of hvc_init from being a device_initcall
into hvc_alloc, and used a non-null hvc_driver as indication of whether
hvc_init had already been called.

The problem with this is that hvc_driver is only assigned a value
at the bottom of hvc_init, and so there is a window where multiple
hvc_alloc calls can be in progress at the same time and hence try
and call hvc_init multiple times.  Previously the use of device_init
guaranteed that hvc_init was only called once.

This manifests itself as sporadic instances of two hvc_init calls
racing each other, and with the loser of the race getting -EBUSY
from tty_register_driver() and hence that virtual console fails:

    Couldn't register hvc console driver
    virtio-ports vport0p1: error -16 allocating hvc for port

Here we add an atomic_t to guarantee we'll never run hvc_init twice.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Fixes: 3e6c6f630a52 ("Delay creation of khcvd thread")
Reported-by: Jim Somerville <Jim.Somerville@windriver.com>
Tested-by: Jim Somerville <Jim.Somerville@windriver.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/hvc/hvc_console.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/tty/hvc/hvc_console.c
+++ b/drivers/tty/hvc/hvc_console.c
@@ -31,6 +31,7 @@
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/major.h>
+#include <linux/atomic.h>
 #include <linux/sysrq.h>
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
@@ -70,6 +71,9 @@ static struct task_struct *hvc_task;
 /* Picks up late kicks after list walk but before schedule() */
 static int hvc_kicked;
 
+/* hvc_init is triggered from hvc_alloc, i.e. only when actually used */
+static atomic_t hvc_needs_init __read_mostly = ATOMIC_INIT(-1);
+
 static int hvc_init(void);
 
 #ifdef CONFIG_MAGIC_SYSRQ
@@ -825,7 +829,7 @@ struct hvc_struct *hvc_alloc(uint32_t vt
 	int i;
 
 	/* We wait until a driver actually comes along */
-	if (!hvc_driver) {
+	if (atomic_inc_not_zero(&hvc_needs_init)) {
 		int err = hvc_init();
 		if (err)
 			return ERR_PTR(err);


