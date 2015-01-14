Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394AbbANQ0p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 11:26:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48327 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752506AbbANQ0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 11:26:43 -0500
Date: Wed, 14 Jan 2015 17:26:27 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH v2 4/4] perf probe: Fix probing kretprobes
Message-ID: <20150114162627.GH6369@krava.redhat.com>
References: <1421234288-22758-1-git-send-email-namhyung@kernel.org>
 <1421234288-22758-4-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421234288-22758-4-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 08:18:08PM +0900, Namhyung Kim wrote:
> The commit dfef99cd0b2c ("perf probe: Use ref_reloc_sym based address
> instead of the symbol name") converts kprobes to use ref_reloc_sym
> (i.e. _stext) and offset instead of using symbol's name directly.  So
> on my system, adding do_fork ends up with like below:
> 
>   $ sudo perf probe -v --add do_fork%return
>   probe-definition(0): do_fork%return
>   symbol:do_fork file:(null) line:0 offset:0 return:1 lazy:(null)
>   0 arguments
>   Looking at the vmlinux_path (7 entries long)
>   Using /lib/modules/3.17.6-1-ARCH/build/vmlinux for symbols
>   Could not open debuginfo. Try to use symbols.
>   Opening /sys/kernel/debug/tracing/kprobe_events write=1
>   Added new event:
>   Writing event: r:probe/do_fork _stext+456136
>   Failed to write event: Invalid argument
>   Error: Failed to add events. Reason: Operation not permitted (Code: -1)
> 
> As you can see, the do_fork was translated to _stext+456136.  This was
> because to support (local) symbols that have same name.  But the
> problem is that kretprobe requires to be inserted at function start
> point so it simply checks whether it's called with offset 0.  And if
> not, it'll return with -EINVAL.  You can see it with dmesg.
> 
>   $ dmesg | tail -1
>     [125621.764103] Return probe must be used without offset.
> 
> So we need to use the symbol name instead of ref_reloc_sym in case of
> return probes.
> 
> Reported-by: Jiri Olsa <jolsa@redhat.com>

'perf probe --add do_fork%return' inserts the probe correctly now

Tested-by: Jiri Olsa <jolsa@redhat.com>

thanks,
jirka
