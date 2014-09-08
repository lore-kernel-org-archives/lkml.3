Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbaIHPLM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 11:11:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16054 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751781AbaIHPLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 11:11:10 -0400
Date: Mon, 8 Sep 2014 17:10:17 +0200
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
Message-ID: <20140908151016.GH17728@krava.brq.redhat.com>
References: <1409781604-16778-1-git-send-email-acme@kernel.org>
 <1409781604-16778-5-git-send-email-acme@kernel.org>
 <54085BC8.40403@intel.com>
 <20140904151902.GE2997@kernel.org>
 <54097793.4050201@intel.com>
 <20140905140756.GD30520@kernel.org>
 <20140906203915.GA9843@krava.brq.redhat.com>
 <20140908134615.GD2773@kernel.org>
 <20140908140454.GF17728@krava.brq.redhat.com>
 <20140908143317.GE2773@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140908143317.GE2773@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 11:33:17AM -0300, Arnaldo Carvalho de Melo wrote:

SNIP

> 
> So what you're saying is that we should have been polling all the fds
> all the time?
> 
> Because after all we end up trying to consume everything in all the ring
> buffers when just one of them gets a POLLRD anyway...
> 
> > > I'll look at the kernel code for that...
> > >  
> > > > > I.e. when we ask the kernel to point fd B to fd A's mmap (what you
> > > > > called set-output) and fd B inserts an event into fd A's mmap ring
> > > > > buffer, we get fd A poll return as POLLRD, no?
> > > 
> > > > > Have to check... Otherwise we would have to poll all fds all the time,
> > > > > not just the ones mmaping, right?
> > > 
> > > > > > I think Jiri's patchset changed pollfds to include all fds for that reason.
> > > 
> > > > hm, I did not think of that.. ;-) I needed more grained feedback
> > > > for future features like cpu hotplug
> > > 
> > > So this is good for something you didn't tried to fix (and document) but
> > > good for something that may be nice in the future? Grumpf, we have
> > > already way too much stuff that will be eventually used but is not used
> > > right now :-\
>  
> > IMO it's more clear to poll pm all event FDs.. and now with the
> > case Adrian described it seems necessary anyway
> 
> I would have to check why was that we were polling just the one where
> the mmap is done, I don't recall being the one to do it, probably who
> did it thought that since the ring buffer is there, it was enough (and
> possibly scaled better, dunno) to do the polling in just one of them.

for read notification it's ok to poll just for one event, because they
all share same ringbuffer and perf_poll checks if there's ANY new data

for the hup notification I think we need to poll all of them

jirka
