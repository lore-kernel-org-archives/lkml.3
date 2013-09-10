Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751324Ab3IJJPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 05:15:31 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41416 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab3IJJP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 05:15:29 -0400
Date: Tue, 10 Sep 2013 11:15:10 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCHv2 00/25] perf tool: Add support for multiple data file
 storage
Message-ID: <20130910091510.GO26785@twins.programming.kicks-ass.net>
References: <1378031796-17892-1-git-send-email-jolsa@redhat.com>
 <20130909111749.GP31370@twins.programming.kicks-ass.net>
 <522EC22E.8080805@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <522EC22E.8080805@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 09:54:38AM +0300, Adrian Hunter wrote:
> On 09/09/13 14:17, Peter Zijlstra wrote:

> > The only reason I wanted this is so that each thread can write its own
> > data. The current one file thing is an immense bottle-neck for big
> > machines.
> 
> Do you need multiple files for that?  Why not just feed writes to a pool of
> threads?

Not sure I understand what you mean there. Since we have a (or multiple)
event per cpu it doesn't make sense to read that data from another cpu
and have that write it to disk. That completely destroys the locality.

Instead the suggestion was to have a thread per cpu (bound) to empty out
the per cpu mmap buffer(s) and write them to disk.

Now the only way to coherently do that into a single file is to do some
streams implementation, which I suppose is possible. Pre-allocate
large-ish sections per thread and mark them as such, then let the thread
spool data into it, when full allocate a new section.

However this would result in allocation-block-size*nr_cpus minimal file
sizes, which wouldn't be a problem per-se since they can be sparse.

It will however pretty much mess up Jolsa's max-MBs per file thing and
it is of course slightly more complex than having a file per cpu/thread.
And is more likely to create kernel lock contention; the pagecache locks
are typically per inode, bouncing those around the machine isn't nice
either.
