Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbaJQPPF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 11:15:05 -0400
Received: from mail-qg0-f48.google.com ([209.85.192.48]:55250 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbaJQPPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 11:15:03 -0400
From: Vince Weaver <vincent.weaver@maine.edu>
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Fri, 17 Oct 2014 11:21:41 -0400 (EDT)
To: Vince Weaver <vincent.weaver@maine.edu>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: perf: 3.17 another perf_fuzzer lockup
In-Reply-To: <alpine.DEB.2.11.1410171015540.15673@vincent-weaver-1.umelst.maine.edu>
Message-ID: <alpine.DEB.2.11.1410171118090.15673@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.11.1410061130100.11293@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.11.1410061151400.12313@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.11.1410151418570.3151@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.11.1410161723220.9124@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.11.1410171015540.15673@vincent-weaver-1.umelst.maine.edu>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Oct 2014, Vince Weaver wrote:

> Now to find out why this could happen.  Probably something to do with 
> crazy RCU magic :(

it looks like there's an unbalanced get_ctx() / put_ctx() here, as the
software event context on the main process should not get decremented
to 0 unless that process is exiting, yet it happens.

Maybe this is bisectable.  Hmmm.

[  106.781177] VMW: using pid 2941
[  127.216558] ------------[ cut here ]------------

And here's where ctx->refcount gets decremented to 0.

[  127.221237] WARNING: CPU: 0 PID: 2941 at kernel/events/core.c:905 put_ctx+0x57/0x8e()
[  127.256799] CPU: 0 PID: 2941 Comm: perf_fuzzer Not tainted 3.17.0+ #97
[  127.263372] Hardware name: AOpen   DE7000/nMCP7ALPx-DE R1.06 Oct.19.2012, BIOS 080015  10/19/2012
[  127.272289]  0000000000000009 ffff8800cb107d98 ffffffff81530f3c 000000000000249e
[  127.279954]  0000000000000000 ffff8800cb107dd8 ffffffff8104005d ffff8800cae4b750
[  127.287621]  ffffffff810cf819 ffff8800cbb26400 ffff8800cae4b000 ffff8800cbb26410
[  127.295285] Call Trace:
[  127.297789]  [<ffffffff81530f3c>] dump_stack+0x46/0x58
[  127.302980]  [<ffffffff8104005d>] warn_slowpath_common+0x81/0x9b
[  127.309036]  [<ffffffff810cf819>] ? put_ctx+0x57/0x8e
[  127.314134]  [<ffffffff8104011a>] warn_slowpath_null+0x1a/0x1c
[  127.320022]  [<ffffffff810cf819>] put_ctx+0x57/0x8e
[  127.324957]  [<ffffffff810cf898>] __free_event+0x48/0x71
[  127.330326]  [<ffffffff8112bb01>] ? __d_free_external+0x29/0x4f
[  127.336298]  [<ffffffff810d1311>] _free_event+0xd6/0xdb
[  127.341585]  [<ffffffff810d13ee>] put_event+0xd8/0xe1
[  127.346693]  [<ffffffff810d141e>] perf_release+0x15/0x19
[  127.352062]  [<ffffffff8111cd7d>] __fput+0xf1/0x1a6
[  127.356994]  [<ffffffff8111ce6a>] ____fput+0xe/0x10
[  127.361931]  [<ffffffff81055402>] task_work_run+0x83/0x9a
[  127.367389]  [<ffffffff810029ca>] do_notify_resume+0x5a/0x61
[  127.373106]  [<ffffffff81536720>] int_signal+0x12/0x17
[  127.378300] ---[ end trace 8508b4f6a48d2f87 ]---

and here a little later is when we try to add a new software event
but it gets infinitely stuck.

[  127.385717] VMW: task->perf_event_ctxp[1]=ffff8800cbb26400, EAGAIN, ref=1
[  127.392566] VMW: pmu->type=1 type=1 config=8 pid=2941


Vince

