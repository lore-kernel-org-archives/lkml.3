Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751002AbaKXWws (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 17:52:48 -0500
Received: from one.firstfloor.org ([193.170.194.197]:41882 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbaKXWwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 17:52:47 -0500
Date: Mon, 24 Nov 2014 23:52:44 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Brendan Gregg <brendan.d.gregg@gmail.com>
Subject: Re: perf/branch-history branch build broken with NO_DEMANGLE=1
 perf hists browser: Print overhead percent value for first-level callchain
Message-ID: <20141124225244.GS12538@two.firstfloor.org>
References: <20141124145227.GE18625@kernel.org>
 <20141124152312.GA13167@kernel.org>
 <20141124152541.GB13167@kernel.org>
 <20141124153204.GC13167@kernel.org>
 <20141124154841.GD13167@kernel.org>
 <20141124212308.GE13167@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141124212308.GE13167@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> [root@zoo acme]# perf record -a -g -b sleep 2s
> [ perf record: Woken up 7 times to write data ]
> [ perf record: Captured and wrote 3.033 MB perf.data (~132504 samples) ]
> [root@zoo acme]# perf report --stdio --branch-history
> # To display the perf.data header info, please use --header/--header-only options.
> #
> BFD: Dwarf Error: Offset (2585882475) greater than or equal to .debug_str size (44321517).
> BFD: Dwarf Error: Could not find abbrev number 11800.
> <BIG SNIP>
> BFD: Dwarf Error: Offset (83496016) greater than or equal to .debug_str size (44321517).
> BFD: Dwarf Error: Offset (48628447) greater than or equal to .debug_str size (44321517).
> (END)Segmentation fault (core dumped)
> [root@zoo acme]# 
> 
> Will investigate this later today/tomorrow, if nobody finds a fix in the meantime.

I cannot reproduce this.

For me it looks like you have some binary or debuginfo that your libbfd
doesn't like. --branch-history resolves all addresses as srcline, 
so it will actually walk all the line numbers.

Can you please find out which one it is? Probably can be seen
by just going up a few levels in gdb and dumping the event.

If you can find the address that explodes you can also try it directly with
addr2line. If that works it's some problem in the perf implementation.

It is likely that it would need to be fixed in libbfd.

To work around it we could turn off force resolving the srcline,
but that would make the output much less useful too unfortuantely...

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
