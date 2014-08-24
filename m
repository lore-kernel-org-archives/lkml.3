Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbaHXDeK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 23:34:10 -0400
Received: from message.mylangara.bc.ca ([142.35.159.25]:64968 "EHLO
	message.langara.bc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbaHXDeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 23:34:09 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-disposition: inline
Content-type: text/plain; charset=us-ascii
From: Steven Stewart-Gallus <sstewartgallus00@mylangara.bc.ca>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, davidlohr@hp.com, manfred@colorfullife.com,
        bfields@redhat.com, dledford@redhat.com
Message-id: <fb54e896348f.53f95d2f@langara.bc.ca>
Date: Sun, 24 Aug 2014 03:34:07 +0000 (GMT)
X-Mailer: Sun Java(tm) System Messenger Express 6.3-6.03 (built Mar 14 2008;
 32bit)
Content-language: en
Subject: [PATCH] V1 1/2] ipc: let message queues use SIGEV_THREAD_ID with
 mq_notify
X-Accept-Language: en
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Stewart-Gallus <sstewartgallus00@mylangara.bc.ca>

Currently the only thread-safe way of using mq_notify with message
queues is to use the SIGEV_THREAD option. Unfortunately, existing
wrappers around such functionality spawn a thread each time a
notification happens instead of caching threads which is slow and
inconvenient for debugging. This change lets message queues use
SIGEV_THREAD_ID with mq_notify and so target notifications to only one
thread at a time which is thread-safe.

Signed-off-by: Steven Stewart-Gallus <sstewartgallus00@mylangara.bc.ca>
---

Hello! This is a simple patch I made more for the purpose of learning
how the kernel works then for any serious purpose. Currently, in my
own program I now simply use a thread pool and poll for asynchronously
running message sends and receives but a thread-safe mq_notify would
have been useful for me and possibly saved me some effort. So, I won't
be seriously bothered if this patch is rejected but I think other
people might find it useful nonetheless. I also think this behaviour
seems quite natural and appropriate to support.

I am sending this patch for review but I am pretty sure it is mistaken
in some ways. In particular, I believe this patch is wrong because I
don't believe it filters out thread ids that belong to other processes
and I am not sure how to do that.

Thank you,
Steven Stewart-Gallus

diff --git a/man3/mq_notify.3 b/man3/mq_notify.3
index a71aac4..41a1b96 100644
--- a/man3/mq_notify.3
+++ b/man3/mq_notify.3
@@ -95,6 +95,16 @@ as if it were the start function of a new thread.
 See
 .BR sigevent (7)
 for details.
+.TP
+.BR SIGEV_THREAD_ID " (Linux-specific)"
+As for
+.BR SIGEV_SIGNAL ,
+but the signal is targeted at the thread whose ID is given in
+.IR sigev_notify_thread_id ,
+which must be a thread in the same process as the caller.
+See
+.BR sigevent (7)
+for general details.
 .PP
 Only one process can be registered to receive notification
 from a message queue.
diff --git a/man7/sigevent.7 b/man7/sigevent.7
index 9cec77e..15da9fe 100644
--- a/man7/sigevent.7
+++ b/man7/sigevent.7
@@ -125,8 +125,10 @@ structure that defines attributes for the new thread (see
 .TP
 .BR SIGEV_THREAD_ID " (Linux-specific)"
 .\" | SIGEV_SIGNAL vs not?
-Currently used only by POSIX timers; see
-.BR timer_create (2).
+Currently used only by POSIX timers and message queues; see
+.BR timer_create (2)
+and
+.BR mq_notify (2).
 .SH CONFORMING TO
 POSIX.1-2001.
 .SH SEE ALSO

