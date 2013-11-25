Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420Ab3KYRU7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 12:20:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2874 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754456Ab3KYRU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 12:20:57 -0500
Date: Mon, 25 Nov 2013 18:22:06 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH 3/3] tracing: Teach FETCH_MTD_{symbol,deref} to handle
	per-cpu data
Message-ID: <20131125172206.GD14516@redhat.com>
References: <20131123201543.GA22148@redhat.com> <20131125172106.GA14516@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131125172106.GA14516@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

@symbol can't be used to dump the per-cpu variables. The same is
true for +offset(something) if "something" results in __percpu
pointer.

With this patch parse_probe_offset() treats "~" before the numeric
offset as "per cpu" mark and stores it in the lowest bit,
calc_probe_offset() simply adds per_cpu_offset(smp_processor_id())
if this bit is set.

We could turn {dprm,sc}->offset into the "struct probe_offset" which
holds offset + is_percpu, but this hack looks simple enough and I hope
that LONG_MAX/2 is enough for the numeric offset.

Test-case: 2088 == offsetof(struct rq, curr)

  # perf probe 'do_exit curr=%%current rq_curr=@runqueues+~2088:u64'
  # perf record -e probe:do_exit true
  # perf --no-pager script | tail -1
	true   537 [000]   521.282640: probe:do_exit: (ffffffff8103dd60) \
	curr=ffff88001da8c900 rq_curr=ffff88001da8c900

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace_probe.c |   35 ++++++++++++++++++++++++++++++++---
 1 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index 723e6e9..bcf6827 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -593,15 +593,44 @@ static int pseudo_reg_query_offset(const char *name)
 
 static long calc_probe_offset(unsigned long offset)
 {
-	return offset;
+	long off = offset >> 1;
+
+	if (offset & 1)
+		off += per_cpu_offset(raw_smp_processor_id());
+
+	return off;
 }
 
 static int parse_probe_offset(const char *name, unsigned long *offset)
 {
-	if (name[0] == '+')	/* kstrtol() rejects '+' */
+	bool negative = false;
+	long percpu_bit = 0;
+	long off = 0;
+
+	switch (name[0]) {
+	case '-':
+		negative = true;
+	case '+':
 		name++;
+	}
 
-	return kstrtol(name, 0, offset);
+	if (name[0] == '~') {
+		percpu_bit = 1;
+		name++;
+	}
+
+	if (name[0]) {
+		int err = kstrtoul(name, 0, &off);
+
+		if (err || off >= LONG_MAX/2)
+			return -EINVAL;
+
+		if (negative)
+			off = -off;
+	}
+
+	*offset = (off << 1) | percpu_bit;
+	return 0;
 }
 
 /* Recursive argument parser */
-- 
1.5.5.1


