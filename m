Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab3KPVGV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 16:06:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56835 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752648Ab3KPVGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 16:06:18 -0500
Date: Sun, 17 Nov 2013 08:06:03 +1100
From: NeilBrown <neilb@suse.de>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>,
        Marek Belisko <marek@goldelico.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH/RFC] wait_for_completion_timeout() considered harmful.
Message-ID: <20131117080603.2a0d3b6d@notabene.brown>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/tvzOUFjsK_h0ggfB6hAHvdC"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/tvzOUFjsK_h0ggfB6hAHvdC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


It would be reasonable to assume that

      wait_for_completion_timeout(&wm8350->auxadc_done, msecs_to_jiffies(5)=
);

would wait at least 5 msecs for the auxadc_done to complete.  But it does n=
ot.
With a HZ of 200 or less, msecs_to_jiffies(5) has value '1', and so this
will only wait until the next "timer tick", which could happen immediately.

This can lead to incorrect results - and has done so in out-of-tree patches
for drivers/misc/bmp085.c which uses a very similar construct to enable int=
errupt
based result collection.

The documentation for several *_timeout* functions claim they will wait for
"timeout jiffies" to have elapsed where this is not the case.  They will
actually wait for "timeout" jiffies to have started implying an elapsed time
between (timeout-1) and (timeout).

This patch corrects some of this documentation, and adds a collection of
  wait_for_completion*_msecs()
interfaces which wait at least the given number of milliseconds for the
completion (or a signal).

If accepted, we can the see which of the current:
   wait_for_completion_timeout-*(..., msecs_to_jiffies(XXX))
could be converted.

Reported-by: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/include/linux/completion.h b/include/linux/completion.h
index 5d5aaae3af43..efe92eaf1c45 100644
--- a/include/linux/completion.h
+++ b/include/linux/completion.h
@@ -9,6 +9,7 @@
  */
=20
 #include <linux/wait.h>
+#include <linux/jiffies.h>
=20
 /*
  * struct completion - structure used to maintain state for a "completion"
@@ -106,4 +107,33 @@ extern bool completion_done(struct completion *x);
 extern void complete(struct completion *);
 extern void complete_all(struct completion *);
=20
+/* Following wrappers will wait at least 'msecs' milliseconds
+ * unless completion (or signal) happens before then.
+ */
+static inline unsigned long wait_for_completion_msecs(
+	struct completion *x, unsigned long msecs)
+{
+	return wait_for_completion_timeout(x, 1 + msecs_to_jiffies(msecs));
+}
+
+static inline unsigned long wait_for_completion_io_msecs(
+	struct completion *x, unsigned long msecs)
+{
+	return wait_for_completion_io_timeout(x, 1 + msecs_to_jiffies(msecs));
+}
+
+static inline long wait_for_completion_interruptible_msecs(
+	struct completion *x, unsigned long msecs)
+{
+	return wait_for_completion_interruptible_timeout(
+		x, 1 + msecs_to_jiffies(msecs));
+}
+
+static inline long wait_for_completion_killable_msecs(
+	struct completion *x, unsigned long msecs)
+{
+	return wait_for_completion_killable_timeout(
+		x, 1 + msecs_to_jiffies(msecs));
+}
+
 #endif
diff --git a/kernel/sched/completion.c b/kernel/sched/completion.c
index a63f4dc27909..b51902373cc0 100644
--- a/kernel/sched/completion.c
+++ b/kernel/sched/completion.c
@@ -126,12 +126,15 @@ EXPORT_SYMBOL(wait_for_completion);
 /**
  * wait_for_completion_timeout: - waits for completion of a task (w/timeou=
t)
  * @x:  holds the state of this particular completion
- * @timeout:  timeout value in jiffies
+ * @timeout:  timeout value in "jiffie starts"
  *
  * This waits for either a completion of a specific task to be signaled or=
 for a
  * specified timeout to expire. The timeout is in jiffies. It is not
  * interruptible.
  *
+ * The timeout is in "jiffie starts".  It could take between (timeout-1)
+ * and (timeout) jiffies for that many to start.
+ *
  * Return: 0 if timed out, and positive (at least 1, or number of jiffies =
left
  * till timeout) if completed.
  */
@@ -159,10 +162,11 @@ EXPORT_SYMBOL(wait_for_completion_io);
 /**
  * wait_for_completion_io_timeout: - waits for completion of a task (w/tim=
eout)
  * @x:  holds the state of this particular completion
- * @timeout:  timeout value in jiffies
+ * @timeout:  timeout value in "jiffie starts"
  *
  * This waits for either a completion of a specific task to be signaled or=
 for a
- * specified timeout to expire. The timeout is in jiffies. It is not
+ * specified timeout to expire. The timeout is in "jiffie starts" which im=
plies
+ * a duration between (timeout-1) and (timeout) jiffies. It is not
  * interruptible. The caller is accounted as waiting for IO.
  *
  * Return: 0 if timed out, and positive (at least 1, or number of jiffies =
left
@@ -196,10 +200,12 @@ EXPORT_SYMBOL(wait_for_completion_interruptible);
 /**
  * wait_for_completion_interruptible_timeout: - waits for completion (w/(t=
o,intr))
  * @x:  holds the state of this particular completion
- * @timeout:  timeout value in jiffies
+ * @timeout:  timeout value in "jiffie starts"
  *
  * This waits for either a completion of a specific task to be signaled or=
 for a
- * specified timeout to expire. It is interruptible. The timeout is in jif=
fies.
+ * specified timeout to expire. It is interruptible. The timeout is in
+ * "jiffie starts" which implies a duration between (timeout-1) and
+ * (timeout) jiffies.
  *
  * Return: -ERESTARTSYS if interrupted, 0 if timed out, positive (at least=
 1,
  * or number of jiffies left till timeout) if completed.
@@ -233,11 +239,12 @@ EXPORT_SYMBOL(wait_for_completion_killable);
 /**
  * wait_for_completion_killable_timeout: - waits for completion of a task =
(w/(to,killable))
  * @x:  holds the state of this particular completion
- * @timeout:  timeout value in jiffies
+ * @timeout:  timeout value in "jiffie starts"
  *
  * This waits for either a completion of a specific task to be
  * signaled or for a specified timeout to expire. It can be
- * interrupted by a kill signal. The timeout is in jiffies.
+ * interrupted by a kill signal. The timeout is in "jiffie starts"
+ * which implies a duration between (timeout-1) and (timeout) jiffies.
  *
  * Return: -ERESTARTSYS if interrupted, 0 if timed out, positive (at least=
 1,
  * or number of jiffies left till timeout) if completed.
diff --git a/kernel/timer.c b/kernel/timer.c
index 6582b82fa966..bf8ed6adb140 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1405,16 +1405,17 @@ static void process_timeout(unsigned long __data)
=20
 /**
  * schedule_timeout - sleep until timeout
- * @timeout: timeout value in jiffies
+ * @timeout: timeout value in "jiffie starts"
  *
- * Make the current task sleep until @timeout jiffies have
- * elapsed. The routine will return immediately unless
+ * Make the current task sleep until the start of the "timeout"
+ * jiffie from now.  This can take between (timeout-1) and (timeout)
+ * jiffies to occur. The routine will return immediately unless
  * the current task state has been set (see set_current_state()).
  *
  * You can set the task state as follows -
  *
  * %TASK_UNINTERRUPTIBLE - at least @timeout jiffies are guaranteed to
- * pass before the routine returns. The routine will return 0
+ * have started before the routine returns. The routine will return 0
  *
  * %TASK_INTERRUPTIBLE - the routine may return early if a signal is
  * delivered to the current task. In this case the remaining time

--Sig_/tvzOUFjsK_h0ggfB6hAHvdC
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUofeOznsnt1WYoG5AQLyfA/+Olrhc1kDMUoYboTPtJTx4HwHkhipOS4t
z2jQVat/5+HdCz2Y+Wnr4Uskfa1tR1gA2jGsLyBIS84NIgRofnd8R6aMuscuG/yg
MJMqV7yNLEzdpjp2pT3bPXtF8Fiudx56twYJflTOCP25ljr1S9xGg68NU5HcTZsv
sgU/I9sYrSAcyxRcfiaDsXcOcpx9yb68/rSb7AXt47laes7DB5+SQFdthSUfmc2a
vKvhVWzn4GOYZrWP41nyykAZ2Tc8YCbapbLMvfy/WB5MPtocv/1HwJNSFnKG12s5
QfoWZ3SS+j0Kfvsi4FtYBuOt7oWlPgsHAusuh4gH28oL8/9ED/9kAyQiIwyXBP2h
WPaWOiUNW93uhT4HtQPEYhRMC6FBmYc40eR6Tp2+scUOYlty1u+WpHlwlmlf4fMd
3fFIZWv8qK62BKHrgMT4icTv5t8B/Kk0K17vArcmPNI827g19bjW3yWGQmmXgSum
6mrYZeZ6icTlD9VfMJryjdXXjpeoODFLk8rSHyzVawVllrBrWDIvgRicSA9n035d
RlSa2mDop2NFl5KK7IEboAxTMjFfOBUV3WxLjOwo4FwMixWRe1wO6Hlg3eSFP+S8
Sa3KOUA5OH9I11OmSpOtkSePRxxO1k9kkC1mIWY73v/VHU1RYoHJuPvCUsstTeme
/rKwhssKDrc=
=5dA8
-----END PGP SIGNATURE-----

--Sig_/tvzOUFjsK_h0ggfB6hAHvdC--
