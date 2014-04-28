Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322AbaD1BbI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:31:08 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42983 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752687AbaD1B3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:22 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jim Somerville" <Jim.Somerville@windriver.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Rusty Russell" <rusty@rustcorp.com.au>,
        "Paul Gortmaker" <paul.gortmaker@windriver.com>
Date: Mon, 28 Apr 2014 02:11:22 +0100
Message-ID: <lsq.1398647482.924871999@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 31/94] hvc: ensure hvc_init is only ever called once
 in hvc_console.c
In-Reply-To: <lsq.1398647481.453080089@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.58-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/tty/hvc/hvc_console.c | 6 +++++-
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

