Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093AbaELLnn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 07:43:43 -0400
Received: from 1wt.eu ([62.212.114.60]:34880 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428AbaELLnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 07:43:41 -0400
Date: Mon, 12 May 2014 13:43:33 +0200
From: Willy Tarreau <w@1wt.eu>
To: Mathias Krause <minipli@googlemail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
Subject: Re: [ 030/143] proc connector: fix info leaks
Message-ID: <20140512114333.GA19162@1wt.eu>
References: <f07e5fe6d87f172fc73580b9c86ba9a2@local> <20140512003201.879931356@1wt.eu> <CA+rthh91-GB=PPMckeDHEco=vLOimB7fBt0nVX_C+gDz3BRngg@mail.gmail.com> <20140512085704.GA18258@1wt.eu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="NzB8fVQJ5HfG6fxh"
Content-Disposition: inline
In-Reply-To: <20140512085704.GA18258@1wt.eu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 12, 2014 at 10:57:04AM +0200, Willy Tarreau wrote:
> > > diff --git a/drivers/connector/cn_proc.c b/drivers/connector/cn_proc.c
> > > index 6069790..3a2587a 100644
> > > --- a/drivers/connector/cn_proc.c
> > > +++ b/drivers/connector/cn_proc.c
> > > [...]
> > >  module_init(cn_proc_init);
> > > +       memset(&ev->event_data, 0, sizeof(ev->event_data));
> > > +       msg->flags = 0; /* not used */
> > 
> > That last hunk looks bogus. Probably the source of Christoph's compile error.
> 
> Thank you guys, I'll check. I don't know why I didn't see them on an
> allmodconfig build.

I found why: CONFIG_PROC_EVENTS is not enabled when CONNECTOR=m.

Here's a fixed patch. Sorry for the trouble.

Willy


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-proc-connector-fix-info-leaks.patch"

>From 8ab62fb31d8fb0f84686612437cfa69e32cd3626 Mon Sep 17 00:00:00 2001
From: Mathias Krause <minipli@googlemail.com>
Date: Mon, 30 Sep 2013 22:03:06 +0200
Subject: proc connector: fix info leaks

[ Upstream commit e727ca82e0e9616ab4844301e6bae60ca7327682 ]

Initialize event_data for all possible message types to prevent leaking
kernel stack contents to userland (up to 20 bytes). Also set the flags
member of the connector message to 0 to prevent leaking two more stack
bytes this way.

Cc: stable@vger.kernel.org  # v2.6.15+
Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/connector/cn_proc.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/connector/cn_proc.c b/drivers/connector/cn_proc.c
index 6069790..3603599 100644
--- a/drivers/connector/cn_proc.c
+++ b/drivers/connector/cn_proc.c
@@ -59,6 +59,7 @@ void proc_fork_connector(struct task_struct *task)
 
 	msg = (struct cn_msg*)buffer;
 	ev = (struct proc_event*)msg->data;
+	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	get_seq(&msg->seq, &ev->cpu);
 	ktime_get_ts(&ts); /* get high res monotonic timestamp */
 	put_unaligned(timespec_to_ns(&ts), (__u64 *)&ev->timestamp_ns);
@@ -71,6 +72,7 @@ void proc_fork_connector(struct task_struct *task)
 	memcpy(&msg->id, &cn_proc_event_id, sizeof(msg->id));
 	msg->ack = 0; /* not used */
 	msg->len = sizeof(*ev);
+	msg->flags = 0; /* not used */
 	/*  If cn_netlink_send() failed, the data is not sent */
 	cn_netlink_send(msg, CN_IDX_PROC, GFP_KERNEL);
 }
@@ -87,6 +89,7 @@ void proc_exec_connector(struct task_struct *task)
 
 	msg = (struct cn_msg*)buffer;
 	ev = (struct proc_event*)msg->data;
+	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	get_seq(&msg->seq, &ev->cpu);
 	ktime_get_ts(&ts); /* get high res monotonic timestamp */
 	put_unaligned(timespec_to_ns(&ts), (__u64 *)&ev->timestamp_ns);
@@ -97,6 +100,7 @@ void proc_exec_connector(struct task_struct *task)
 	memcpy(&msg->id, &cn_proc_event_id, sizeof(msg->id));
 	msg->ack = 0; /* not used */
 	msg->len = sizeof(*ev);
+	msg->flags = 0; /* not used */
 	cn_netlink_send(msg, CN_IDX_PROC, GFP_KERNEL);
 }
 
@@ -113,6 +117,7 @@ void proc_id_connector(struct task_struct *task, int which_id)
 
 	msg = (struct cn_msg*)buffer;
 	ev = (struct proc_event*)msg->data;
+	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	ev->what = which_id;
 	ev->event_data.id.process_pid = task->pid;
 	ev->event_data.id.process_tgid = task->tgid;
@@ -136,6 +141,7 @@ void proc_id_connector(struct task_struct *task, int which_id)
 	memcpy(&msg->id, &cn_proc_event_id, sizeof(msg->id));
 	msg->ack = 0; /* not used */
 	msg->len = sizeof(*ev);
+	msg->flags = 0; /* not used */
 	cn_netlink_send(msg, CN_IDX_PROC, GFP_KERNEL);
 }
 
@@ -151,6 +157,7 @@ void proc_sid_connector(struct task_struct *task)
 
 	msg = (struct cn_msg *)buffer;
 	ev = (struct proc_event *)msg->data;
+	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	get_seq(&msg->seq, &ev->cpu);
 	ktime_get_ts(&ts); /* get high res monotonic timestamp */
 	put_unaligned(timespec_to_ns(&ts), (__u64 *)&ev->timestamp_ns);
@@ -161,6 +168,7 @@ void proc_sid_connector(struct task_struct *task)
 	memcpy(&msg->id, &cn_proc_event_id, sizeof(msg->id));
 	msg->ack = 0; /* not used */
 	msg->len = sizeof(*ev);
+	msg->flags = 0; /* not used */
 	cn_netlink_send(msg, CN_IDX_PROC, GFP_KERNEL);
 }
 
@@ -176,8 +184,10 @@ void proc_exit_connector(struct task_struct *task)
 
 	msg = (struct cn_msg*)buffer;
 	ev = (struct proc_event*)msg->data;
+	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	get_seq(&msg->seq, &ev->cpu);
 	ktime_get_ts(&ts); /* get high res monotonic timestamp */
+	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	put_unaligned(timespec_to_ns(&ts), (__u64 *)&ev->timestamp_ns);
 	ev->what = PROC_EVENT_EXIT;
 	ev->event_data.exit.process_pid = task->pid;
@@ -188,6 +198,7 @@ void proc_exit_connector(struct task_struct *task)
 	memcpy(&msg->id, &cn_proc_event_id, sizeof(msg->id));
 	msg->ack = 0; /* not used */
 	msg->len = sizeof(*ev);
+	msg->flags = 0; /* not used */
 	cn_netlink_send(msg, CN_IDX_PROC, GFP_KERNEL);
 }
 
@@ -211,6 +222,7 @@ static void cn_proc_ack(int err, int rcvd_seq, int rcvd_ack)
 
 	msg = (struct cn_msg*)buffer;
 	ev = (struct proc_event*)msg->data;
+	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	msg->seq = rcvd_seq;
 	ktime_get_ts(&ts); /* get high res monotonic timestamp */
 	put_unaligned(timespec_to_ns(&ts), (__u64 *)&ev->timestamp_ns);
@@ -220,6 +232,7 @@ static void cn_proc_ack(int err, int rcvd_seq, int rcvd_ack)
 	memcpy(&msg->id, &cn_proc_event_id, sizeof(msg->id));
 	msg->ack = rcvd_ack + 1;
 	msg->len = sizeof(*ev);
+	msg->flags = 0; /* not used */
 	cn_netlink_send(msg, CN_IDX_PROC, GFP_KERNEL);
 }
 
-- 
1.7.12.1


--NzB8fVQJ5HfG6fxh--
