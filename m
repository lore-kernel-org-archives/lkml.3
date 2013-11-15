Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757135Ab3KOEsV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 23:48:21 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:11835 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755545Ab3KOEsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 23:48:14 -0500
Date: Thu, 14 Nov 2013 23:48:12 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Terje Bergstrom <tbergstrom@nvidia.com>,
        Arto Merilainen <amerilainen@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Erik Faye-Lund <kusmabite@gmail.com>
Subject: Why have another variable deciding a tracepoint?
Message-ID: <20131114234812.3bf7bce9@gandalf.local.home>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been reviewing different users of tracepoints and I stumbled
across this:

drivers/gpu/host1x/cdma.c: host1x_cdma_push()

	if (host1x_debug_trace_cmdbuf)
		trace_host1x_cdma_push(dev_name(cdma_to_channel(cdma)->dev),
				       op1, op2);

That host1x_debug_trace_cmdbuf is a variable that gets set by another
debugfs file "trace_cmdbuf" that is custom to this driver.

Why?

The tracepoint host1x_cdma_push is already controlled by either ftrace
or perf. If it gets enabled by perf or ftrace, it still wont be traced
unless we also enable this trace_cmdbuf. Is there some reason for this?
I can't figure it out from the change log: 6236451d83a720 ("gpu:
host1x: Add debug support").

As tracepoints uses jump labels, there is no branch cost associated
with them. That is, they are either a direct jump, or a nop (in most
cases a nop). But here you added the overhead of a conditional branch
depending on this variable.

If this is truly needed, then use TRACE_EVENT_CONDITION() for that
tracepoint.


/me is baffled

-- Steve


