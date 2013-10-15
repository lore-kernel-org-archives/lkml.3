Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab3JOHZp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 03:25:45 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:47232 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab3JOHZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 03:25:44 -0400
Date: Tue, 15 Oct 2013 09:25:40 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>, acme@ghostprotocols.net,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf record: mmap output file - v2
Message-ID: <20131015072540.GE24584@gmail.com>
References: <1381805731-10398-1-git-send-email-dsahern@gmail.com>
 <20131015060200.GA3866@gmail.com>
 <8738o3au2g.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8738o3au2g.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Namhyung Kim <namhyung@kernel.org> wrote:

> > 3)
> >
> > The rec->bytes_at_mmap_start field feels a bit weird. If I read the code 
> > correctly, in every 'perf record' invocation, rec->bytes_written starts at 
> > 0 - i.e. we don't have repeat invocations of cmd_record().
> 
> rec->bytes_written is updated when it writes to the output file for 
> synthesizing COMM/MMAP events (this mmap output is not used at that 
> time).

Btw., while looking into it, I think advance_output() needlessly 
obfuscates as well:

static void advance_output(struct perf_record *rec, size_t size)
{
        rec->bytes_written += size;
}

that code should just be written open coded.

So I think all this needs a few good rounds of cleanups, before we can 
complicate it with a new feature. (the cleanups can be on top of the 
feature, if they go in at the same time.)

> > That means that this:
> >
> > 		rec->bytes_at_mmap_start = st.st_size - rec->bytes_written;
> >
> > is really:
> >
> > 		rec->bytes_at_mmap_start = st.st_size;
> >
> > furthermore, since we don't allow appends anymore, st.st_size ought to be 
> > zero as well.
> >
> > Which means that ->bytes_at_mmap_start is always zero - and could be 
> > eliminated altogether.
> 
> No, st_size is bigger than rec->bytes_written due to the 
> perf_file_header which is written without updating rec->bytes_written.

Since all this is code that executes once during __cmd_record(), is this 
all about the header writeout?

That is what confused me about the stat() call and that's messy really: we 
are the ones who write the file header, we have a very good idea about how 
many bytes we wrote to the file! It should be entirely unnecessary to lose 
that information and then execute a system call to recover that 
information...

Thanks,

	Ingo
