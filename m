Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778AbaBMUtR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 15:49:17 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:16147 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751277AbaBMUtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 15:49:14 -0500
Date: Thu, 13 Feb 2014 15:45:07 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Rusty Russell <rusty@rustcorp.com.au>,
        David Howells <dhowells@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [RFC PATCH] Fix: module signature vs tracepoints: add new
 TAINT_UNSIGNED_MODULE
Message-ID: <20140213154507.4040fb06@gandalf.local.home>
In-Reply-To: <2127052721.24380.1392306090965.JavaMail.zimbra@efficios.com>
References: <1392074600-21977-1-git-send-email-mathieu.desnoyers@efficios.com>
	<20140211072738.GA24232@gmail.com>
	<20140211234534.6bc34e57@gandalf.local.home>
	<1583293363.24361.1392304214094.JavaMail.zimbra@efficios.com>
	<20140213102817.4bfd5eac@gandalf.local.home>
	<2127052721.24380.1392306090965.JavaMail.zimbra@efficios.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Feb 2014 15:41:30 +0000 (UTC)
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:


> Yes, exactly, presuming that by "supporting" you mean CONFIG_MODULE_SIG=y.
> Loading an unsigned module then taints the kernel, and taints the module
> with TAINT_FORCED_MODULE even though "modprobe --force" was never used.

OK, this IS a major bug and needs to be fixed. This explains a couple
of reports I received about tracepoints not working, and I never
figured out why. Basically, they even did this:


	trace_printk("before tracepoint\n");
	trace_some_trace_point();
	trace_printk("after tracepoint\n");

Enabled the tracepoint (it shows up as enabled and working in the
tools, but not the trace), but in the trace they would get:

	before tracepoint
	after tracepoint

and never get the actual tracepoint. But as they were debugging
something else, it was just thought that this was their bug. But it
baffled me to why that tracepoint wasn't working even though nothing in
the dmesg had any errors about tracepoints.

Well, this now explains it. If you compile a kernel with the following
options:

CONFIG_MODULE_SIG=y
# CONFIG_MODULE_SIG_FORCE is not set
# CONFIG_MODULE_SIG_ALL is not set

You now just disabled (silently) all tracepoints in modules. WITH NO
FREAKING ERROR MESSAGE!!!

The tracepoints will show up in /sys/kernel/debug/tracing/events, they
will show up in perf list, you can enable them in either perf or the
debugfs, but they will never actually be executed. You will just get
silence even though everything appeared to be working just fine.

I tested this out. I was not able to get any tracepoints in modules
working with the above config options.

There's two bugs here. One, the lack of MODULE_SIG_ALL, will
make all modules non signed during the build process. That means that
all modules when loaded will be tainted as FORCED. As Mathieu stated,
you do not need the --force flag here, it just needs to see that the
kernel supports signatures but the module is not signed. In this case,
it just calls add_taint_module(), tainting the module with
FORCED_MODULE. You get a message like this:

 sunrpc: module verification failed: signature and/or required key missing - tainting kernel


Now when this module adds its tracepoint, since it is marked with a
FORCE_MODULE taint flag, the tracepoint code just ignores it and does
not do any processing at all.

Worse yet, the tracepoint code never gives any feedback if a tracepoint
was enabled or not. That is, if a tracepoint was never initialized when
the module was loaded, the tracepoint will still report success at
time of enabling, that it was registered (and tracing) even though it is
not.

At the end of this email, I added a patch that fixes that. But I have to
concur that Mathieu did find a bug. There is no reason to disable
tracepoints in modules if someone simply has the above configs enabled
(and disabled)!

Below is the patch that warns if the tracepoint is not enabled for
whatever reason.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve


diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 29f2654..b85f68f 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -62,6 +62,7 @@ struct tracepoint_entry {
 	struct hlist_node hlist;
 	struct tracepoint_func *funcs;
 	int refcount;	/* Number of times armed. 0 if disarmed. */
+	int enabled;	/* Tracepoint enabled */
 	char name[0];
 };
 
@@ -237,6 +238,7 @@ static struct tracepoint_entry *add_tracepoint(const char *name)
 	memcpy(&e->name[0], name, name_len);
 	e->funcs = NULL;
 	e->refcount = 0;
+	e->enabled = 0;
 	hlist_add_head(&e->hlist, head);
 	return e;
 }
@@ -316,6 +318,7 @@ static void tracepoint_update_probe_range(struct tracepoint * const *begin,
 		if (mark_entry) {
 			set_tracepoint(&mark_entry, *iter,
 					!!mark_entry->refcount);
+			mark_entry->enabled = !!mark_entry->refcount;
 		} else {
 			disable_tracepoint(*iter);
 		}
@@ -380,6 +383,8 @@ tracepoint_add_probe(const char *name, void *probe, void *data)
 int tracepoint_probe_register(const char *name, void *probe, void *data)
 {
 	struct tracepoint_func *old;
+	struct tracepoint_entry *entry;
+	int ret = 0;
 
 	mutex_lock(&tracepoints_mutex);
 	old = tracepoint_add_probe(name, probe, data);
@@ -388,9 +393,15 @@ int tracepoint_probe_register(const char *name, void *probe, void *data)
 		return PTR_ERR(old);
 	}
 	tracepoint_update_probes();		/* may update entry */
+	entry = get_tracepoint(name);
+	/* Make sure the entry was enabled */
+	if (!entry || !entry->enabled) {
+		tracepoint_entry_remove_probe(entry, probe, data);
+		ret = -ENODEV;
+	}
 	mutex_unlock(&tracepoints_mutex);
 	release_probes(old);
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(tracepoint_probe_register);
 
