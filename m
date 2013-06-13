Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305Ab3FMOQh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 10:16:37 -0400
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:51418 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751483Ab3FMOQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 10:16:35 -0400
Message-ID: <51B9D43D.6000008@hurleysoftware.com>
Date: Thu, 13 Jun 2013 10:16:29 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Markus Trippelsdorf <markus@trippelsdorf.de>
CC: Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, David Howells <dhowells@redhat.com>,
        Orion Poplawski <orion@cora.nwra.com>
Subject: Re: Strange intermittent EIO error when writing to stdout since v3.8.0
References: <20130606115417.GA520@x4> <51B09A26.3080603@hurleysoftware.com> <20130606143750.GB520@x4> <51B1FEB1.8040103@hurleysoftware.com> <20914.9444.867518.719403@pilspetsen.it.uu.se> <20130613103950.GB519@x4>
In-Reply-To: <20130613103950.GB519@x4>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2013 06:39 AM, Markus Trippelsdorf wrote:
> On 2013.06.07 at 20:22 +0200, Mikael Pettersson wrote:
>> Peter Hurley writes:
>>   > Based on the other reports from Mikael and David, I suspect this problem
>>   > may have to do with my commit 699390354da6c258b65bf8fa79cfd5feaede50b6:
>>   >
>>   >    pty: Ignore slave pty close() if never successfully opened
>>   >
>>   > This commit poisons the pty under certain error conditions that may
>>   > occur from parallel open()s (or parallel close() with pending write()).
>>   >
>>   > It's unclear to me which error condition is triggered and how user-space
>>   > got an open file descriptor but that seems the most likely. Is the problem
>>   > reproducible enough that a debug patch would likely trigger?
>>
>> In my case the problem occurred frequently enough that I've been forced
>> to change my build procedures to avoid it.  I'd welcome a debug patch.
>
> Since apparently no debugging patch is forthcoming, maybe it's time to
> test the simple revert of commit 699390354da.

I apologize for the delay.

Here's a debug patch which I hope will narrow down the circumstances of
this error condition.

Regards,
Peter Hurley

PS - Don't get excited about EIO from read() which you will see during
boot. That's expected when the slave closes and the master is parked on
a blocking read().

--- >% ---
Subject: [PATCH] tty: Debug EIO from write()


Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
  drivers/tty/pty.c    | 22 +++++++++++++++++++---
  drivers/tty/tty_io.c | 51 ++++++++++++++++++++++++++++++++++++++++++---------
  2 files changed, 61 insertions(+), 12 deletions(-)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index 9c2f1bc..2ce2bb2 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -25,6 +25,16 @@
  #include <linux/slab.h>
  #include <linux/mutex.h>

+#define TTY_DEBUG_EIO 1
+
+#ifdef TTY_DEBUG_EIO
+#define tty_debug_eio(tty, f, args...) ({                       \
+    char __b[64];                                   \
+    printk(KERN_DEBUG "%s: %s: " f, __func__, tty_name(tty, __b), ##args); \
+})
+#else
+#define tty_debug_eio(tty, f, args...)
+#endif

  #ifdef CONFIG_UNIX98_PTYS
  static struct tty_driver *ptm_driver;
@@ -246,12 +256,18 @@ static int pty_open(struct tty_struct *tty, struct file *filp)
      set_bit(TTY_IO_ERROR, &tty->flags);

      retval = -EIO;
-    if (test_bit(TTY_OTHER_CLOSED, &tty->flags))
+    if (test_bit(TTY_OTHER_CLOSED, &tty->flags)) {
+        tty_debug_eio(tty, "other pty closed (%#lx)\n", tty->flags);
          goto out;
-    if (test_bit(TTY_PTY_LOCK, &tty->link->flags))
+    }
+    if (test_bit(TTY_PTY_LOCK, &tty->link->flags)) {
+        tty_debug_eio(tty, "ptm still locked\n");
          goto out;
-    if (tty->driver->subtype == PTY_TYPE_SLAVE && tty->link->count != 1)
+    }
+    if (tty->driver->subtype == PTY_TYPE_SLAVE && tty->link->count != 1) {
+        tty_debug_eio(tty, "ptm open count (%d)\n", tty->link->count);
          goto out;
+    }

      clear_bit(TTY_IO_ERROR, &tty->flags);
      clear_bit(TTY_OTHER_CLOSED, &tty->link->flags);
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 62e942d..e71c61f 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -105,11 +105,21 @@
  #include <linux/kmod.h>
  #include <linux/nsproxy.h>

-#undef TTY_DEBUG_HANGUP
+#define TTY_DEBUG_HANGUP 1
+#define TTY_DEBUG_EIO 1

  #define TTY_PARANOIA_CHECK 1
  #define CHECK_TTY_COUNT 1

+#ifdef TTY_DEBUG_EIO
+#define tty_debug_eio(tty, f, args...) ({                       \
+    char __b[64];                                   \
+    printk(KERN_DEBUG "%s: %s: " f, __func__, tty_name(tty, __b), ##args); \
+})
+#else
+#define tty_debug_eio(tty, f, args...)
+#endif
+
  struct ktermios tty_std_termios = {    /* for the benefit of tty drivers  */
      .c_iflag = ICRNL | IXON,
      .c_oflag = OPOST | ONLCR,
@@ -424,6 +434,7 @@ int tty_check_change(struct tty_struct *tty)
      if (is_ignored(SIGTTOU))
          goto out;
      if (is_current_pgrp_orphaned()) {
+        tty_debug_eio(tty, "pgrp orphaned?? (%#lx)\n", tty->flags);
          ret = -EIO;
          goto out;
      }
@@ -448,6 +459,9 @@ static ssize_t hung_up_tty_read(struct file *file, char __user *buf,
  static ssize_t hung_up_tty_write(struct file *file, const char __user *buf,
                   size_t count, loff_t *ppos)
  {
+    struct tty_struct *tty = file_tty(file);
+
+    tty_debug_eio(tty, "%#lx\n", tty ? tty->flags : -1L);
      return -EIO;
  }

@@ -1020,16 +1034,22 @@ static ssize_t tty_read(struct file *file, char __user *buf, size_t count,

      if (tty_paranoia_check(tty, inode, "tty_read"))
          return -EIO;
-    if (!tty || (test_bit(TTY_IO_ERROR, &tty->flags)))
+    if (!tty || (test_bit(TTY_IO_ERROR, &tty->flags))) {
+        tty_debug_eio(tty, "%#lx\n", tty ? tty->flags : -1L);
          return -EIO;
+    }

      /* We want to wait for the line discipline to sort out in this
         situation */
      ld = tty_ldisc_ref_wait(tty);
-    if (ld->ops->read)
+    if (ld->ops->read) {
          i = (ld->ops->read)(tty, file, buf, count);
-    else
+        if (i == -EIO)
+            tty_debug_eio(tty, "ldisc error (%#lx)\n", tty->flags);
+    } else {
+        tty_debug_eio(tty, "no ldisc read method???\n");
          i = -EIO;
+    }
      tty_ldisc_deref(ld);

      if (i > 0)
@@ -1197,18 +1217,31 @@ static ssize_t tty_write(struct file *file, const char __user *buf,

      if (tty_paranoia_check(tty, file_inode(file), "tty_write"))
          return -EIO;
-    if (!tty || !tty->ops->write ||
-        (test_bit(TTY_IO_ERROR, &tty->flags)))
-            return -EIO;
+    if (!tty || !tty->ops->write || (test_bit(TTY_IO_ERROR, &tty->flags))) {
+        if (tty && !tty->ops->write)
+            tty_debug_eio(tty, "no driver write method???\n");
+        else
+            tty_debug_eio(tty, "%#lx\n", tty ? tty->flags : -1L);
+        return -EIO;
+    }
      /* Short term debug to catch buggy drivers */
      if (tty->ops->write_room == NULL)
          printk(KERN_ERR "tty driver %s lacks a write_room method.\n",
              tty->driver->name);
      ld = tty_ldisc_ref_wait(tty);
-    if (!ld->ops->write)
+    if (!ld->ops->write) {
+        tty_debug_eio(tty, "no ldisc write method???\n");
          ret = -EIO;
-    else
+    } else {
          ret = do_tty_write(ld->ops->write, tty, file, buf, count);
+        if (ret == -EIO) {
+            if (tty_hung_up_p(file))
+                tty_debug_eio(tty, "hung up\n");
+            else
+                tty_debug_eio(tty, "ldisc error: flags=%#lx count=%d other=%d\n",
+                          tty->flags, tty->count, tty->link ? tty->link->count : -1);
+        }
+    }
      tty_ldisc_deref(ld);
      return ret;
  }
-- 
1.8.1.2


