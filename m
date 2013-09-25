Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab3IYMvY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 08:51:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56224 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755522Ab3IYMvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 08:51:17 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 06/21] perf: Add event toggle ioctl interface
Date: Wed, 25 Sep 2013 14:50:32 +0200
Message-Id: <1380113447-17144-7-git-send-email-jolsa@redhat.com>
In-Reply-To: <1380113447-17144-1-git-send-email-jolsa@redhat.com>
References: <1380113447-17144-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding new ioctl PERF_EVENT_IOC_SET_TOGGLE to interface
the toggle settings for event.

This ioctl has 2 goals:
  - allowing the toggle event being part of the group
  - allowing to define toggle setting after event
    is created

The ioctl interface is:

  u64 args[2] = { toggled_fd, flag };
  err = ioctl(fd, PERF_EVENT_IOC_SET_TOGGLE, args);

Where:
  toggled_fd - is file description of the event we want to toggle
  flag       - is one of PERF_FLAG_TOGGLE_ON|PERF_FLAG_TOGGLE_OFF
  err        -  0 when successful
               -1 otherwise with errno:
                  EBUSY  - event has already toggled event defined
                  EFAULT - could not copy user data
                  EINVAL - wrong data

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 include/uapi/linux/perf_event.h |  1 +
 kernel/events/core.c            | 40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index ecb0474..b941c21 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -325,6 +325,7 @@ struct perf_event_attr {
 #define PERF_EVENT_IOC_SET_OUTPUT	_IO ('$', 5)
 #define PERF_EVENT_IOC_SET_FILTER	_IOW('$', 6, char *)
 #define PERF_EVENT_IOC_ID		_IOR('$', 7, u64 *)
+#define PERF_EVENT_IOC_SET_TOGGLE	_IOW('$', 8, u64 *)
 
 enum perf_event_ioc_flags {
 	PERF_IOC_FLAG_GROUP		= 1U << 0,
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 40c792d..b41a0d8 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3575,6 +3575,7 @@ static inline int perf_fget_light(int fd, struct fd *p)
 static int perf_event_set_output(struct perf_event *event,
 				 struct perf_event *output_event);
 static int perf_event_set_filter(struct perf_event *event, void __user *arg);
+static int perf_event_set_toggle_fd(struct perf_event *event, u64 __user *arg);
 
 static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
@@ -3629,6 +3630,9 @@ static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case PERF_EVENT_IOC_SET_FILTER:
 		return perf_event_set_filter(event, (void __user *)arg);
 
+	case PERF_EVENT_IOC_SET_TOGGLE:
+		return perf_event_set_toggle_fd(event, (u64 __user *)arg);
+
 	default:
 		return -ENOTTY;
 	}
@@ -7017,6 +7021,42 @@ perf_event_set_toggle(struct perf_event *event,
 	return 0;
 }
 
+static int perf_event_set_toggle_fd(struct perf_event *event, u64 __user *arg)
+{
+	struct perf_event *toggled_event;
+	struct fd toggled_fd = { NULL, 0 };
+	u64 fd, flag;
+	int err;
+
+	if (event->toggled_event)
+		return -EBUSY;
+
+	if (copy_from_user(&fd, arg, sizeof(fd)))
+		return -EFAULT;
+
+	if (copy_from_user(&flag, arg + 1, sizeof(flag)))
+		return -EFAULT;
+
+	err = perf_fget_light((int) fd, &toggled_fd);
+	if (err)
+		return -EINVAL;
+
+	toggled_event = toggled_fd.file->private_data;
+
+	if (!atomic_long_inc_not_zero(&toggled_event->refcount)) {
+	        fdput(toggled_fd);
+		return -EINVAL;
+	}
+
+	err = perf_event_set_toggle(event, toggled_event, event->ctx, flag);
+	if (err)
+		put_event(toggled_event);
+
+	fdput(toggled_fd);
+	return err;
+}
+
+
 /**
  * sys_perf_event_open - open a performance event, associate it to a task/cpu
  *
-- 
1.7.11.7

