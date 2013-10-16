Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759977Ab3JPHLZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 03:11:25 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:51142 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753597Ab3JPHLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 03:11:24 -0400
Date: Wed, 16 Oct 2013 09:11:19 +0200
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 3/3] perf record: mmap output file
Message-ID: <20131016071119.GE22509@gmail.com>
References: <1381289214-24885-1-git-send-email-dsahern@gmail.com>
 <1381289214-24885-4-git-send-email-dsahern@gmail.com>
 <20131009055957.GA7664@gmail.com>
 <525D4B5F.4090005@gmail.com>
 <20131015143245.GB9828@ghostprotocols.net>
 <20131015143819.GM10651@twins.programming.kicks-ass.net>
 <20131015152747.GA15979@gmail.com>
 <525D5FA1.7060404@gmail.com>
 <20131015160646.GC16003@gmail.com>
 <525D6A6C.3090208@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <525D6A6C.3090208@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> On 10/15/13 10:06 AM, Ingo Molnar wrote:

> > splice() is very fast and should be able to process a lot of pages in 
> > one go, so the feedback loop should be pretty weak. mmap() triggers 
> > kernel code as well, every time we run out of the 64 MB window we got 
> > to remap it, right?
> 
> 
> Yes, 1 mmap, 1 munmap for every 64MB. Compare to the write() case which 
> calls write() for each mmap each time through the mmap_read loop.
> 
> I am conjecturing that splice would follow the write model in the sense 
> of a ring buffer has N bytes, call splice to copy the data from the ring 
> buffer to the file. So, splice saves on the memcpy, but not the 
> syscalls.

Well, splice can be 64 MB granular as well - but it depends on how 
buffered the pipes are (splice always uses pipes to shuffle around pages).

It's possible to have pipes with larger buffering - see F_SETPIPE_SZ. The 
current limit (for unprivileged users?) is:

  fs/pipe.c:unsigned int pipe_max_size = 1048576;

[But I haven't actually used this to increase splice() size yet.]

Thanks,

	Ingo
