Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab3IQRwO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 13:52:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28661 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753177Ab3IQRwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 13:52:13 -0400
Date: Tue, 17 Sep 2013 14:52:01 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Tom Zanussi <tzanussi@gmail.com>, Steven Rostedt <srostedt@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Jiri Olsa <jolsa@redhat.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Full syscall argument decode in "perf trace"
Message-ID: <20130917175201.GA3918@infradead.org>
References: <523870FF.3030306@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <523870FF.3030306@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Sep 17, 2013 at 05:10:55PM +0200, Denys Vlasenko escreveu:
> I'm trying to figure out how to extend "perf trace".
 
> Currently, it shows syscall names and arguments, and only them.
> Meaning that syscalls such as open(2) are shown as:
 
>     open(filename: 140736118412184, flags: 0, mode: 140736118403776) = 3
 
> The problem is, of course, that user wants to see the filename
> per se, not the address of its first byte.
 
> To improve that, we need to fetch the pointed-to data.
> There are two approaches to this: extending
> "raw_syscalls:sys_{enter,exit}" tracepoint so that it returns this data,
> or selectively stopping the traced process when it reaches the thacepoint.

We don't want to stop the process at all, this is one of the major
advantages of 'perf trace' over 'strace'.

Look at the tmp.perf/trace2 branch in my git repo, tglx and Ingo added a
tracepoint to vfs_getname to use that.
 
> First solution is attractive performance-wise, but requires a lot
> of new code: *ALL* syscalls will need to know which arguments are pointers,
> how large their pointed-to data structures are, and (remember
> readv and friends!) some of pointed-to structures themselves
> contain pointers which reference even more data.

Well, we can look at DWARF to get the function signatures, types,
librarize 'perf probe' and insert probes in the syscalls we want
decoding.

That for the cases where we don't have a tracepoint or when adding a new
tracepoint is not an option.

And this all with what we have in the kernel right now.

Also for 'perf trace' look at my perf/core branch, where we have more
syscall arg beautifiers and the machinery that is getting in place to
allow that.

Longer term we could have something like dtrace's CTF to have a more
compact type only ELF section that always go with the kernel, like we
have CFI in binaries these days.
 
- Arnaldo
