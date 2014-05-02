Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441AbaEBNMV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 09:12:21 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:16875 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752024AbaEBNMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 09:12:19 -0400
Date: Fri, 2 May 2014 09:12:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH RT 2/2] rtmutex: Remove duplicate rt_mutex_init()
Message-ID: <20140502091213.3ed4ba7b@gandalf.local.home>
In-Reply-To: <20140502090831.GB9178@linutronix.de>
References: <20140409024700.702797305@goodmis.org>
	<20140409025232.161960044@goodmis.org>
	<20140502090831.GB9178@linutronix.de>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 May 2014 11:08:31 +0200
Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:

> * Steven Rostedt | 2014-04-08 22:47:02 [-0400]:
> 
> >From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> >
> >The rt_mutex_init() macro is the same whether or not
> >CONFIG_DEBUG_RT_MUTEX is set. Remove the duplicate.
> >
> >Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> This does not apply cleanly on v3.14-rt

That's because I sent this out before 3.14-rt was released :-)

> 
> >--- a/include/linux/rtmutex.h
> >+++ b/include/linux/rtmutex.h
> >@@ -62,25 +62,19 @@ struct hrtimer_sleeper;
> > # define __DEBUG_RT_MUTEX_INITIALIZER(mutexname) \
> > 	, .name = #mutexname, .file = __FILE__, .line = __LINE__
> > 
> >-# define rt_mutex_init(mutex)					\
> >-	do {							\
> >-		raw_spin_lock_init(&(mutex)->wait_lock);	\
> >-		__rt_mutex_init(mutex, #mutex);			\
> >-	} while (0)
> >-
> 
> The macro is the same in CONFIG_DEBUG_RT_MUTEXES and the else path.
> Shouldn't you remove both and define it before the ifdef?

That's exactly what the patch did! Except that it defined it *after* the ifdef.

Here's the patch again (as it was cut in the reply):

--- a/include/linux/rtmutex.h
+++ b/include/linux/rtmutex.h
@@ -62,25 +62,19 @@ struct hrtimer_sleeper;
 # define __DEBUG_RT_MUTEX_INITIALIZER(mutexname) \
 	, .name = #mutexname, .file = __FILE__, .line = __LINE__
 
-# define rt_mutex_init(mutex)					\
-	do {							\
-		raw_spin_lock_init(&(mutex)->wait_lock);	\
-		__rt_mutex_init(mutex, #mutex);			\
-	} while (0)
-
  extern void rt_mutex_debug_task_free(struct task_struct *tsk);
 #else
 # define __DEBUG_RT_MUTEX_INITIALIZER(mutexname)
 
+# define rt_mutex_debug_task_free(t)			do { } while (0)
+#endif
+
 # define rt_mutex_init(mutex)					\
 	do {							\
 		raw_spin_lock_init(&(mutex)->wait_lock);	\
 		__rt_mutex_init(mutex, #mutex);			\
 	} while (0)
 
-# define rt_mutex_debug_task_free(t)			do { } while (0)
-#endif
-
 #define __RT_MUTEX_INITIALIZER_PLAIN(mutexname) \
 	.wait_lock = __RAW_SPIN_LOCK_UNLOCKED(mutexname.wait_lock) \
 	, .wait_list = PLIST_HEAD_INIT(mutexname.wait_list) \

Take special note of the movement of the "#endif".

-- Steve



> There are some
> users of this:
> |drivers/i2c/i2c-core.c: rt_mutex_init(&adap->bus_lock);
> |drivers/media/usb/em28xx/em28xx-cards.c: rt_mutex_init(&dev->i2c_bus_lock);
> 
> Sebastian

