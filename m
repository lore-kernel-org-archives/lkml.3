Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab3H0BHH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:07:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59407 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252Ab3H0BHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:07:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [ 18/74] tracing/kprobe: Wait for disabling all running kprobe handlers
Date: Mon, 26 Aug 2013 18:08:16 -0700
Message-Id: <20130827010428.268986020@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130827010424.535365435@linuxfoundation.org>
References: <20130827010424.535365435@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

commit a232e270dcb55a70ad3241bc6fc160fd9b5c9e6c upstream.

Wait for disabling all running kprobe handlers when a kprobe
event is disabled, since the caller, trace_remove_event_call()
supposes that a removing event is disabled completely by
disabling the event.
With this change, ftrace can ensure that there is no running
event handlers after disabling it.

Link: http://lkml.kernel.org/r/20130709093526.20138.93100.stgit@mhiramat-M0-7522

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace_kprobe.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -281,6 +281,8 @@ trace_probe_file_index(struct trace_prob
 static int
 disable_trace_probe(struct trace_probe *tp, struct ftrace_event_file *file)
 {
+	struct ftrace_event_file **old = NULL;
+	int wait = 0;
 	int ret = 0;
 
 	mutex_lock(&probe_enable_lock);
@@ -314,10 +316,7 @@ disable_trace_probe(struct trace_probe *
 		}
 
 		rcu_assign_pointer(tp->files, new);
-
-		/* Make sure the probe is done with old files */
-		synchronize_sched();
-		kfree(old);
+		wait = 1;
 	} else
 		tp->flags &= ~TP_FLAG_PROFILE;
 
@@ -326,11 +325,25 @@ disable_trace_probe(struct trace_probe *
 			disable_kretprobe(&tp->rp);
 		else
 			disable_kprobe(&tp->rp.kp);
+		wait = 1;
 	}
 
  out_unlock:
 	mutex_unlock(&probe_enable_lock);
 
+	if (wait) {
+		/*
+		 * Synchronize with kprobe_trace_func/kretprobe_trace_func
+		 * to ensure disabled (all running handlers are finished).
+		 * This is not only for kfree(), but also the caller,
+		 * trace_remove_event_call() supposes it for releasing
+		 * event_call related objects, which will be accessed in
+		 * the kprobe_trace_func/kretprobe_trace_func.
+		 */
+		synchronize_sched();
+		kfree(old);	/* Ignored if link == NULL */
+	}
+
 	return ret;
 }
 


