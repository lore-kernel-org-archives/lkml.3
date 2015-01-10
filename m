Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547AbbAJJwG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 04:52:06 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:62879 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbbAJJwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 04:52:03 -0500
Date: Sat, 10 Jan 2015 18:51:53 +0900
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] perf probe can't insert return kprobe
Message-ID: <20150110095153.GB29697@danjae>
References: <20150109145539.GC14750@krava.brq.redhat.com>
 <20150109152113.GA29697@danjae>
 <20150109153056.GB4136@krava.brq.redhat.com>
 <20150109154421.GA7849@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20150109154421.GA7849@krava.brq.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Fri, Jan 09, 2015 at 04:44:21PM +0100, Jiri Olsa wrote:
> On Fri, Jan 09, 2015 at 04:30:56PM +0100, Jiri Olsa wrote:
> > On Sat, Jan 10, 2015 at 12:21:13AM +0900, Namhyung Kim wrote:
> > > On Fri, Jan 09, 2015 at 03:55:39PM +0100, Jiri Olsa wrote:
> > > > hi,
> > > > I couldn't use following perf command to insert return probe:
> > > > 
> > > >   # perf probe -a fork_exit=do_fork%return
> > > >   Added new event:
> > > >   Failed to write event: Invalid argument
> > > >     Error: Failed to add events.
> > > > 
> > > > 
> > > > I'm pretty sure I used this command before, so seems like
> > > > it's broken. I can still use debugfs tracing interface to
> > > > do that:
> > > >   # echo 'r:do_fork_entry do_fork' > kprobe_events
> > > > 
> > > > I used Arnaldo's latest perf/core and FC20 kernel:
> > > > 
> > > >   # uname -a
> > > >   Linux krava 3.17.7-200.fc20.x86_64 #1 SMP Wed Dec 17 03:35:33 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux
> > > >   # ./perf version
> > > >   perf version 3.18.g6a7d78
> > > > 
> > > 
> > > Is it just return probe?  Did it work for normal kprobes?
> > 
> > yep, works for normal probes
> > 
> > > Maybe it's related to the below:
> > > 
> > > https://lkml.org/lkml/2014/12/31/15
> > > 
> > > Have you check the acme/perf/urgent too?
> > 
> > hum.. can't access lkml, I'll check, also with perf/urgent
> 
> neither helped..

I think I've found the reason.

The commit dfef99cd0b2c ("perf probe: Use ref_reloc_sym based address
instead of the symbol name") converts kprobes to use ref_reloc_sym
(i.e. _stext) and offset instead of using symbol's name directly.  So
on my system, adding do_fork ends up with like below:

  $ sudo perf probe -v --add do_fork%return
  probe-definition(0): do_fork%return
  symbol:do_fork file:(null) line:0 offset:0 return:1 lazy:(null)
  0 arguments
  Looking at the vmlinux_path (7 entries long)
  Using /lib/modules/3.17.6-1-ARCH/build/vmlinux for symbols
  Could not open debuginfo. Try to use symbols.
  Opening /sys/kernel/debug/tracing/kprobe_events write=1
  Added new event:
  Writing event: r:probe/do_fork _stext+456136
  Failed to write event: Invalid argument
    Error: Failed to add events. Reason: Operation not permitted (Code: -1)
  

As you can see, the do_fork was translated to _stext+456136.  This was
because to support (local) symbols that have same name.  But the
problem is that kretprobe requires to be inserted at function start
point so it simply checks whether it's called with offset 0.  And if
not, it'll return with -EINVAL.  You can see it with dmesg.

  $ dmesg | tail -1
  [125621.764103] Return probe must be used without offset.

So we need to use the symbol name instead of ref_reloc_sym in case of
return probes.  During the tracking down, I found a couple of problems
in the code.  I'll send fixes soon.

Thanks,
Namhyung
