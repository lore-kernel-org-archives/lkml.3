Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334Ab3BFSRn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 13:17:43 -0500
Received: from service87.mimecast.com ([91.220.42.44]:51833 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab3BFSRk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 13:17:40 -0500
Message-ID: <1360174657.4045.33.camel@hornet>
Subject: Re: [RFC] perf: need to expose sched_clock to correlate user
 samples with kernel samples
From: Pawel Moll <pawel.moll@arm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Pekka Enberg <penberg@gmail.com>,
        Robert Richter <robert.richter@amd.com>, tglx <tglx@linutronix.de>
Date: Wed, 06 Feb 2013 18:17:37 +0000
In-Reply-To: <1360113595.2621.30.camel@gandalf.local.home>
References: <CABPqkBQALeD=iO9x-N0nw+shhqa1kmUaj=sCvx+MvoAPGQ-y9A@mail.gmail.com>
	 <1350408232.2336.42.camel@laptop> <1359728280.8360.15.camel@hornet>
	 <CABPqkBSVeU_JP2KpVZLepKDJX=-g6A45Y5MoNphd6+DaU2PQzQ@mail.gmail.com>
	 <51118797.9080800@linaro.org> <1360113595.2621.30.camel@gandalf.local.home>
X-Mailer: Evolution 3.6.2-0ubuntu0.1
Mime-Version: 1.0
X-OriginalArrivalTime: 06 Feb 2013 18:17:37.0334 (UTC) FILETIME=[3E12AD60:01CE0496]
X-MC-Unique: 113020618173708001
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-06 at 01:19 +0000, Steven Rostedt wrote:
> If people are worried about adding a bunch of new perf syscalls, maybe
> add a sys_perf_control() system call that works like an ioctl but
> without a file descriptor. Something for things that don't require an
> event attached to it, like to retrieve a time stamp counter that perf
> uses, but done in a way that it could be used for other things perf
> related that does not require an event.

Something along these lines? (completely untested and of course missing
all the #defines __NR_perf_control xxx)

8<-----------------
diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 4f63c05..be7409b 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -322,6 +322,11 @@ enum perf_event_ioc_flags {
 };
 
 /*
+ * Command codes for ioctl-like sys_perf_control interface:
+ */
+#define PERF_CONTROL_GET_TIME		_IOR('$', 0, __u64)
+
+/*
  * Structure of the page that can be mapped via mmap
  */
 struct perf_event_mmap_page {
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 301079d..750404d 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6678,6 +6678,29 @@ err_fd:
 }
 
 /**
+ * sys_perf_control - ioctl-like interface to control system-wide
+ *		      perf behaviour
+ *
+ * @cmd:	one of the PERF_CONTROL_* commands
+ * @arg:	command-specific argument
+ */
+SYSCALL_DEFINE2(perf_control, unsigned int, cmd, unsigned long, arg)
+{
+	switch (cmd) {
+	case PERF_CONTROL_GET_TIME:
+	{
+		u64 time = perf_clock();
+		if (copy_to_user((void __user *)arg, &time, sizeof(time)))
+			return -EFAULT;
+		return 0;
+	}
+
+	default:
+		return -ENOTTY;
+	}
+}
+
+/**
  * perf_event_create_kernel_counter
  *
  * @attr: attributes of the counter to create
8<-----------------

Cheers!

Pawel


