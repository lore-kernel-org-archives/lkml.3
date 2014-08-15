Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164AbaHOIjT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 04:39:19 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:34367
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751614AbaHOIjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 04:39:15 -0400
x-originating-ip: 72.167.245.219
From: Dexuan Cui <decui@microsoft.com>
To: gregkh@linuxfoundation.org, dmitry.torokhov@gmail.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, olaf@aepfle.de,
        apw@canonical.com, jasowang@redhat.com
Cc: kys@microsoft.com, haiyangz@microsoft.com
Subject: [PATCH] Input: hyperv-keyboard - implement Type Clipboard Text
Date: Fri, 15 Aug 2014 02:41:59 -0700
Message-Id: <1408095719-19117-1-git-send-email-decui@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the menu of the Hyper-V's Virtual Machine Connection, there is a feature
called "Clipboard | Type clipboard text", which can be used to copy a string
in the host's clipboard into the guest's current input focus(text console or
a GUI window).

Currently the feature doesn't work for Linux VM because the driver
hyperv-keyboard hasn't been enhanced to support it -- this patch is made
to do it.

For each char in the string, the host sends 2 events (key down/up with the
char's UNICODE value) to the guest.
The patch finds each char's scan codes of key down/up, and injects the
scan codes to the serio keyboard module.

Known issues:
1) Only printable ASCII chars are supported, and unsupported chars are
ignored. It seems unlikely to support generic UNICODE chars because there
is not a generic API to inject a UNICODE char to text mode console, KDE,
gnome, etc.

2) When we use the feature, make sure the CapsLock state of the VM's
(virtual) keyboard is OFF because this patch assumes it -- we'll try to
fix this later, probably by tracking the state of virtual CapsLock, because
it looks the keyboard module doesn't supply an API for us to query the state
of the keyboard.

Signed-off-by: Dexuan Cui <decui@microsoft.com>
Cc: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/input/serio/hyperv-keyboard.c | 213 ++++++++++++++++++++++++++++++++--
 1 file changed, 201 insertions(+), 12 deletions(-)

diff --git a/drivers/input/serio/hyperv-keyboard.c b/drivers/input/serio/hyperv-keyboard.c
index e74e5d6..5761869 100644
--- a/drivers/input/serio/hyperv-keyboard.c
+++ b/drivers/input/serio/hyperv-keyboard.c
@@ -18,6 +18,8 @@
 #include <linux/hyperv.h>
 #include <linux/serio.h>
 #include <linux/slab.h>
+#include <linux/kfifo.h>
+#include <linux/delay.h>
 
 /*
  * Current version 1.0
@@ -84,7 +86,15 @@ struct synth_kbd_keystroke {
 #define HK_MAXIMUM_MESSAGE_SIZE 256
 
 #define KBD_VSC_SEND_RING_BUFFER_SIZE		(10 * PAGE_SIZE)
-#define KBD_VSC_RECV_RING_BUFFER_SIZE		(10 * PAGE_SIZE)
+
+/*
+ * For the Type Clipboard Text feature, the host can inject a string of
+ * up to 2047 chars, and each char means 2 events(key down/up) and every
+ * event means a VMBUS packet of 32 Bytes: so the max recv buf's size
+ * should be about 2K * 2 * 32 = 32 pages.
+ * Let's add 8 extra pages for safety.
+ */
+#define KBD_VSC_RECV_RING_BUFFER_SIZE		(40 * PAGE_SIZE)
 
 #define XTKBD_EMUL0     0xe0
 #define XTKBD_EMUL1     0xe1
@@ -103,8 +113,173 @@ struct hv_kbd_dev {
 	struct completion wait_event;
 	spinlock_t lock; /* protects 'started' field */
 	bool started;
+
+	DECLARE_KFIFO_PTR(fifo, u8);
+	struct work_struct work;
+};
+
+static const u8 ascii_to_scan_code[128] = {
+	['a'] = 0x1e, ['A'] = 0x1e,
+	['b'] = 0x30, ['B'] = 0x30,
+	['c'] = 0x2e, ['C'] = 0x2e,
+	['d'] = 0x20, ['D'] = 0x20,
+	['e'] = 0x12, ['E'] = 0x12,
+	['f'] = 0x21, ['F'] = 0x21,
+	['g'] = 0x22, ['G'] = 0x22,
+	['h'] = 0x23, ['H'] = 0x23,
+	['i'] = 0x17, ['I'] = 0x17,
+	['j'] = 0x24, ['J'] = 0x24,
+	['k'] = 0x25, ['K'] = 0x25,
+	['l'] = 0x26, ['L'] = 0x26,
+	['m'] = 0x32, ['M'] = 0x32,
+	['n'] = 0x31, ['N'] = 0x31,
+	['o'] = 0x18, ['O'] = 0x18,
+	['p'] = 0x19, ['P'] = 0x19,
+	['q'] = 0x10, ['Q'] = 0x10,
+	['r'] = 0x13, ['R'] = 0x13,
+	['s'] = 0x1f, ['S'] = 0x1f,
+	['t'] = 0x14, ['T'] = 0x14,
+	['u'] = 0x16, ['U'] = 0x16,
+	['v'] = 0x2f, ['V'] = 0x2f,
+	['w'] = 0x11, ['W'] = 0x11,
+	['x'] = 0x2d, ['X'] = 0x2d,
+	['y'] = 0x15, ['Y'] = 0x15,
+	['z'] = 0x2c, ['Z'] = 0x2c,
+	['`'] = 0x29, ['~'] = 0x29,
+	['1'] = 0x02, ['!'] = 0x02,
+	['2'] = 0x03, ['@'] = 0x03,
+	['3'] = 0x04, ['#'] = 0x04,
+	['4'] = 0x05, ['$'] = 0x05,
+	['5'] = 0x06, ['%'] = 0x06,
+	['6'] = 0x07, ['^'] = 0x07,
+	['7'] = 0x08, ['&'] = 0x08,
+	['8'] = 0x09, ['*'] = 0x09,
+	['9'] = 0x0a, ['('] = 0x0a,
+	['0'] = 0x0b, [')'] = 0x0b,
+	['-'] = 0x0c, ['_'] = 0x0c,
+	['='] = 0x0d, ['+'] = 0x0d,
+	['\t'] = 0x0f,
+	['['] = 0x1a, ['{'] = 0x1a,
+	[']'] = 0x1b, ['}'] = 0x1b,
+	['\\'] = 0x2b, ['|'] = 0x2b,
+	[';'] = 0x27, [':'] = 0x27,
+	['\''] = 0x28, ['\"'] = 0x28,
+	['\r'] = 0x1c,
+	['\n'] = 0x1c,
+	[','] = 0x33, ['<'] = 0x33,
+	['.'] = 0x34, ['>'] = 0x34,
+	['/'] = 0x35, ['?'] = 0x35,
+	[' '] = 0x39,
 };
 
+static const bool ascii_needs_shift[128] = {
+	['A'] = 1,
+	['B'] = 1,
+	['C'] = 1,
+	['D'] = 1,
+	['E'] = 1,
+	['F'] = 1,
+	['G'] = 1,
+	['H'] = 1,
+	['I'] = 1,
+	['J'] = 1,
+	['K'] = 1,
+	['L'] = 1,
+	['M'] = 1,
+	['N'] = 1,
+	['O'] = 1,
+	['P'] = 1,
+	['Q'] = 1,
+	['R'] = 1,
+	['S'] = 1,
+	['T'] = 1,
+	['U'] = 1,
+	['V'] = 1,
+	['W'] = 1,
+	['X'] = 1,
+	['Y'] = 1,
+	['Z'] = 1,
+	['~'] = 1,
+	['!'] = 1,
+	['@'] = 1,
+	['#'] = 1,
+	['$'] = 1,
+	['%'] = 1,
+	['^'] = 1,
+	['&'] = 1,
+	['*'] = 1,
+	['('] = 1,
+	[')'] = 1,
+	['_'] = 1,
+	['+'] = 1,
+	['{'] = 1,
+	['}'] = 1,
+	['|'] = 1,
+	[':'] = 1,
+	['\"'] = 1,
+	['<'] = 1,
+	['>'] = 1,
+	['?'] = 1,
+};
+static void handle_scancode(struct work_struct *work)
+{
+	unsigned long flags;
+	struct hv_kbd_dev *kbd_dev =
+		container_of(work, struct hv_kbd_dev, work);
+
+	u8 scan_code = -1;
+	unsigned int ret;
+
+	/*
+	 * Inject the information through the serio interrupt.
+	 */
+	do {
+		spin_lock_irqsave(&kbd_dev->lock, flags);
+
+		ret = kfifo_get(&kbd_dev->fifo, &scan_code);
+		if (ret != 0)
+			serio_interrupt(kbd_dev->hv_serio, scan_code, 0);
+
+		spin_unlock_irqrestore(&kbd_dev->lock, flags);
+
+		/*
+		 * We can't inject the scan codes too fast, otherwise, some
+		 * of the keys can be found lost in a X11 window. Tests show
+		 * 10ms is a safe empirical value.
+		 */
+		if (ret != 0)
+			msleep(10);
+	} while (ret);
+}
+
+static void handle_unicode(struct hv_kbd_dev *kbd_dev, u32 c, u32 info)
+{
+	u8 scan_code;
+	bool break_code = false;
+
+	/* We don't support generic UNICODE chars. */
+	if (c >= 0x80)
+		return;
+
+	/* We only support printable ASCII chars */
+	scan_code = ascii_to_scan_code[c];
+	if (!scan_code)
+		return;
+
+	if (info & IS_BREAK) {
+		scan_code |= XTKBD_RELEASE;
+		break_code = true;
+	}
+
+	if (ascii_needs_shift[c] && !break_code)
+		kfifo_put(&kbd_dev->fifo, 0x2a); /* L-Shift Down */
+
+	kfifo_put(&kbd_dev->fifo, scan_code);
+
+	if (ascii_needs_shift[c] && break_code)
+		kfifo_put(&kbd_dev->fifo, 0x2a | XTKBD_RELEASE); /* L-Shift Up */
+}
+
 static void hv_kbd_on_receive(struct hv_device *hv_dev,
 			      struct synth_kbd_msg *msg, u32 msg_length)
 {
@@ -152,22 +327,28 @@ static void hv_kbd_on_receive(struct hv_device *hv_dev,
 		ks_msg = (struct synth_kbd_keystroke *)msg;
 		info = __le32_to_cpu(ks_msg->info);
 
-		/*
-		 * Inject the information through the serio interrupt.
-		 */
+		/* Put the scan codes into a fifo and handle it in a work */
 		spin_lock_irqsave(&kbd_dev->lock, flags);
 		if (kbd_dev->started) {
 			if (info & IS_E0)
-				serio_interrupt(kbd_dev->hv_serio,
-						XTKBD_EMUL0, 0);
+				kfifo_put(&kbd_dev->fifo, XTKBD_EMUL0);
 			if (info & IS_E1)
-				serio_interrupt(kbd_dev->hv_serio,
-						XTKBD_EMUL1, 0);
+				kfifo_put(&kbd_dev->fifo, XTKBD_EMUL1);
+
 			scan_code = __le16_to_cpu(ks_msg->make_code);
-			if (info & IS_BREAK)
-				scan_code |= XTKBD_RELEASE;
 
-			serio_interrupt(kbd_dev->hv_serio, scan_code, 0);
+			if (!(info & IS_UNICODE)) {
+				if (info & IS_BREAK)
+					scan_code |= XTKBD_RELEASE;
+
+				kfifo_put(&kbd_dev->fifo, scan_code);
+			} else {
+				/* the scan_code is actually a UNICODE char */
+				handle_unicode(kbd_dev, scan_code, info);
+			}
+
+			schedule_work(&kbd_dev->work);
+
 		}
 		spin_unlock_irqrestore(&kbd_dev->lock, flags);
 
@@ -354,6 +535,11 @@ static int hv_kbd_probe(struct hv_device *hv_dev,
 		goto err_free_mem;
 	}
 
+	error = kfifo_alloc(&kbd_dev->fifo, PAGE_SIZE*4, GFP_KERNEL);
+	if (error)
+		goto err_free_mem;
+	INIT_WORK(&kbd_dev->work, handle_scancode);
+
 	kbd_dev->hv_dev = hv_dev;
 	kbd_dev->hv_serio = hv_serio;
 	spin_lock_init(&kbd_dev->lock);
@@ -378,7 +564,7 @@ static int hv_kbd_probe(struct hv_device *hv_dev,
 			   hv_kbd_on_channel_callback,
 			   hv_dev);
 	if (error)
-		goto err_free_mem;
+		goto err_free_fifo;
 
 	error = hv_kbd_connect_to_vsp(hv_dev);
 	if (error)
@@ -392,6 +578,8 @@ static int hv_kbd_probe(struct hv_device *hv_dev,
 
 err_close_vmbus:
 	vmbus_close(hv_dev->channel);
+err_free_fifo:
+	kfifo_free(&kbd_dev->fifo);
 err_free_mem:
 	kfree(hv_serio);
 	kfree(kbd_dev);
@@ -405,6 +593,7 @@ static int hv_kbd_remove(struct hv_device *hv_dev)
 	device_init_wakeup(&hv_dev->device, false);
 	serio_unregister_port(kbd_dev->hv_serio);
 	vmbus_close(hv_dev->channel);
+	kfifo_free(&kbd_dev->fifo);
 	kfree(kbd_dev);
 
 	hv_set_drvdata(hv_dev, NULL);
-- 
1.9.1

