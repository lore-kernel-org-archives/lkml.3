Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892AbbANCCM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 21:02:12 -0500
Received: from lgeamrelo04.lge.com ([156.147.1.127]:46876 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbbANCCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 21:02:11 -0500
X-Original-SENDERIP: 10.177.220.203
X-Original-MAILFROM: namhyung@kernel.org
Date: Wed, 14 Jan 2015 10:59:39 +0900
From: Namhyung Kim <namhyung@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 3/4] perf probe: Fix probing kretprobes
Message-ID: <20150114015939.GD800@sejong>
References: <1420886028-15135-1-git-send-email-namhyung@kernel.org>
 <1420886028-15135-3-git-send-email-namhyung@kernel.org>
 <54B3BC75.2060500@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <54B3BC75.2060500@hitachi.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 09:22:13PM +0900, Masami Hiramatsu wrote:
> (2015/01/10 19:33), Namhyung Kim wrote:
> > The commit dfef99cd0b2c ("perf probe: Use ref_reloc_sym based address
> > instead of the symbol name") converts kprobes to use ref_reloc_sym
> > (i.e. _stext) and offset instead of using symbol's name directly.  So
> > on my system, adding do_fork ends up with like below:
> > 
> >   $ sudo perf probe -v --add do_fork%return
> >   probe-definition(0): do_fork%return
> >   symbol:do_fork file:(null) line:0 offset:0 return:1 lazy:(null)
> >   0 arguments
> >   Looking at the vmlinux_path (7 entries long)
> >   Using /lib/modules/3.17.6-1-ARCH/build/vmlinux for symbols
> >   Could not open debuginfo. Try to use symbols.
> >   Opening /sys/kernel/debug/tracing/kprobe_events write=1
> >   Added new event:
> >   Writing event: r:probe/do_fork _stext+456136
> >   Failed to write event: Invalid argument
> >   Error: Failed to add events. Reason: Operation not permitted (Code: -1)
> > 
> > As you can see, the do_fork was translated to _stext+456136.  This was
> > because to support (local) symbols that have same name.  But the
> > problem is that kretprobe requires to be inserted at function start
> > point so it simply checks whether it's called with offset 0.  And if
> > not, it'll return with -EINVAL.  You can see it with dmesg.
> > 
> >   $ dmesg | tail -1
> >     [125621.764103] Return probe must be used without offset.
> > 
> > So we need to use the symbol name instead of ref_reloc_sym in case of
> > return probes.
> 
> Thanks, but as I pointed in previous mail, this patch fixes just one
> code path which doesn't use debuginfo. With debuginfo, perf-probe
> executes try_to_find_probe_trace_events() to analyze debuginfo.
> We can just skip calling it for retprobes, but I prefer to keep
> it works. So just skipping conversion in post_process_probe_trace_events()
> is better.

Ah, missed that.  I only tested on my laptop which has no debuginfo.
I will add the check into the post_process_probe_trace_events().

Thanks,
Namhyung
