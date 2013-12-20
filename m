Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904Ab3LTKqY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 05:46:24 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:62856 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756066Ab3LTKqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 05:46:19 -0500
Date: Fri, 20 Dec 2013 11:46:15 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, linux-arch@vger.kernel.org,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        systemtap@sourceware.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH -tip v6 00/22] kprobes: introduce NOKPROBE_SYMBOL(),
 cleanup and fixes crash bugs
Message-ID: <20131220104615.GA22609@gmail.com>
References: <20131219090353.14309.15496.stgit@kbuild-fedora.novalocal>
 <y0m38loefhx.fsf@fche.csb>
 <52B3C5E6.2040802@hitachi.com>
 <20131220082056.GA15934@gmail.com>
 <52B40E79.8040701@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52B40E79.8040701@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> (2013/12/20 17:20), Ingo Molnar wrote:
> > 
> > * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> > 
> >>>  But a closer look indicates that the insertion of kprobes is 
> >>> taking about three (!!) orders of magnitude longer than before, as 
> >>> judged by the rate of increase of 'wc -l 
> >>> /sys/kernel/debug/kprobes/list'.
> >>
> >> Right, because kprobes are not designed for thousands of probes.
> > 
> > Then this needs to be fixed, because right now this bug is making it 
> > near impossible to properly test kprobes robustness.
> > 
> > For example a hash table (hashed by probe address) could be used in 
> > addition to the list, to speed up basic operations.
> 
> kprobe itself is already using hlist (6bits hash table).
> Maybe we'd better expand the table bits. However, the iteration
> of the list on debugfs is just doing seq_printf()s. I'm not exactly
> sure what Frank complaints about...

Well, Frank reported that the test he performed takes hours to finish, 
and he mentioned a specific script line he used to produce that:

  # stap -te "probe kprobe.function("*") {}"

I suspect an equivalent perf probe sequence would be something like:

  # for FUNC in $(grep -iw t /proc/kallsyms | cut -d' ' -f3); do date; perf probe -a $FUNC; done

(totally untested.)

Can you reproduce that slowdown, using his method?

I can reproduce one weirdness, with just 13 probes added, 'perf probe 
-l' [which should really be 'perf probe list'!] executes very slowly:

 # perf stat --null --repeat 3 perf probe -l

 Performance counter stats for 'perf probe -l' (3 runs):

       0.763640098 seconds time elapsed                                          ( +-  1.61% )

0.7 seconds is ridiculously long.

Also, here's another bugreport as well: while playing around with 
'perf probe' I found that its usability is still very poor. For 
example I mis-remembered the syntax and typed the obvious way to :

 # perf probe add __schedule
 Failed to find path of kernel module.
 Failed to open debuginfo file.
   Error: Failed to add events. (-2)

why the heck does a simple and obvious 'perf probe add' not work, why 
is the strange syntax of 'perf probe -a' forced? Every other perf 
subcommand uses clean command spaces - see for example 'perf bench'.

Also, the error message is totally misleading and uninformative to the 
level of being passive-aggressive. An error message should directly 
relate to the mistake performed and should give a good way out of the 
situation. Who the heck cares that there was no debuginfo file to 
open? Who cares that the 'path of kernel module' was not found? It has 
no relation to the bug.

An informative error message would be:

 # perf probe add __schedule
 Error: Could not find symbol 'add'.

and that's it. No 'failed to add events' message - obviously the event 
is not enabled if we cannot find the symbol name.

Thanks,

	Ingo
