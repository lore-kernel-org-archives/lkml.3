Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbaIHPiu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 11:38:50 -0400
Received: from mail.kernel.org ([198.145.19.201]:52119 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753421AbaIHPir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 11:38:47 -0400
Date: Mon, 8 Sep 2014 12:38:24 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 04/10] perf record: Filter out POLLHUP'ed file descriptors
Message-ID: <20140908153824.GG2773@kernel.org>
References: <1409781604-16778-5-git-send-email-acme@kernel.org>
 <54085BC8.40403@intel.com>
 <20140904151902.GE2997@kernel.org>
 <54097793.4050201@intel.com>
 <20140905140756.GD30520@kernel.org>
 <20140906203915.GA9843@krava.brq.redhat.com>
 <20140908134615.GD2773@kernel.org>
 <20140908140454.GF17728@krava.brq.redhat.com>
 <20140908143317.GE2773@kernel.org>
 <20140908151016.GH17728@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140908151016.GH17728@krava.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Sep 08, 2014 at 05:10:17PM +0200, Jiri Olsa escreveu:
> On Mon, Sep 08, 2014 at 11:33:17AM -0300, Arnaldo Carvalho de Melo wrote:
> > > IMO it's more clear to poll pm all event FDs.. and now with the
> > > case Adrian described it seems necessary anyway

> > I would have to check why was that we were polling just the one where
> > the mmap is done, I don't recall being the one to do it, probably who
> > did it thought that since the ring buffer is there, it was enough (and
> > possibly scaled better, dunno) to do the polling in just one of them.
 
> for read notification it's ok to poll just for one event, because they
> all share same ringbuffer and perf_poll checks if there's ANY new data
 
> for the hup notification I think we need to poll all of them

Yeah, I'm convinced of this, I'm working on a patch to make it look at
all file descriptors at poll time.

I'm doing it on top of a patch that will close the mmap when it gets a
POLLHUP, as discussed recently on this thread, in a response I gave to
Adrian.

But since multiple fds share an mmap, we can only close that mmap when
all fds are HUPed, i.e. we need to reference count struct perf_mmap,
which is what I am doing.

I.e. the fist mmaps and sets perf_mmap.nfds to 1, the next one, just
after doing that PERF_EVENT_IOC_SET_OUTPUT will bump perf_mmap.nfds,
unmap gets replaced by mmap_put, that decs and calls munmap when it
hits zero, yadda, yadda.

- Arnaldo
