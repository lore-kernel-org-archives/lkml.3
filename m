Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821AbaIFUj5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 16:39:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5495 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826AbaIFUj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 16:39:56 -0400
Date: Sat, 6 Sep 2014 22:39:15 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 04/10] perf record: Filter out POLLHUP'ed file descriptors
Message-ID: <20140906203915.GA9843@krava.brq.redhat.com>
References: <1409781604-16778-1-git-send-email-acme@kernel.org>
 <1409781604-16778-5-git-send-email-acme@kernel.org>
 <54085BC8.40403@intel.com>
 <20140904151902.GE2997@kernel.org>
 <54097793.4050201@intel.com>
 <20140905140756.GD30520@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140905140756.GD30520@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 11:07:56AM -0300, Arnaldo Carvalho de Melo wrote:
> Em Fri, Sep 05, 2014 at 11:42:59AM +0300, Adrian Hunter escreveu:
> > On 09/04/2014 06:19 PM, Arnaldo Carvalho de Melo wrote:
> > > Em Thu, Sep 04, 2014 at 03:32:08PM +0300, Adrian Hunter escreveu:
> > No I was meaning something different. For example, 'perf record' opens an
> > event for 2 processes per-cpu and gets 4 file descriptors:
>  
> > 	task1	task2
> > cpu0	fd0	fd1
> > cpu1	fd2	fd3
>  
> > Now, perf record will mmap fd0 and fd2 and set-output fd1->fd0
> > and fd3->fd2.
>  
> > pollfds includes only fd0 and fd2.
>  
> > But if task2 exits, the POLLHUP will appear on fd1 and fd3.
> 
> So? We are not interested in fd1 and fd3, since all our reading is done
> on fd0 and fd2 mmaps, no?

hm, what if task1 (fd0, fd2) exits first.. perf record will exit,
but it still has to read task2..?

> 
> I.e. when we ask the kernel to point fd B to fd A's mmap (what you
> called set-output) and fd B inserts an event into fd A's mmap ring
> buffer, we get fd A poll return as POLLRD, no?
> 
> Have to check... Otherwise we would have to poll all fds all the time,
> not just the ones mmaping, right?
> 
> > I think Jiri's patchset changed pollfds to include all fds for that reason.

hm, I did not think of that.. ;-) I needed more grained feedback
for future features like cpu hotplug

> 
> It did? I have to look again, probably went together with other changes,
> has it?

it was done by replacing 'int' with 'struct poll_item' for evsel::fd xyarray

jirka
