Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774AbaIHRHq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 13:07:46 -0400
Received: from mail.kernel.org ([198.145.19.201]:56923 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753826AbaIHRHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 13:07:45 -0400
Date: Mon, 8 Sep 2014 14:07:38 -0300
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
Message-ID: <20140908170738.GH2773@kernel.org>
References: <54085BC8.40403@intel.com>
 <20140904151902.GE2997@kernel.org>
 <54097793.4050201@intel.com>
 <20140905140756.GD30520@kernel.org>
 <20140906203915.GA9843@krava.brq.redhat.com>
 <20140908134615.GD2773@kernel.org>
 <20140908140454.GF17728@krava.brq.redhat.com>
 <20140908143317.GE2773@kernel.org>
 <20140908151016.GH17728@krava.brq.redhat.com>
 <20140908153824.GG2773@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140908153824.GG2773@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Sep 08, 2014 at 12:38:24PM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Mon, Sep 08, 2014 at 05:10:17PM +0200, Jiri Olsa escreveu:
> > On Mon, Sep 08, 2014 at 11:33:17AM -0300, Arnaldo Carvalho de Melo wrote:
> > > > IMO it's more clear to poll pm all event FDs.. and now with the
> > > > case Adrian described it seems necessary anyway
> 
> > > I would have to check why was that we were polling just the one where
> > > the mmap is done, I don't recall being the one to do it, probably who
> > > did it thought that since the ring buffer is there, it was enough (and
> > > possibly scaled better, dunno) to do the polling in just one of them.
>  
> > for read notification it's ok to poll just for one event, because they
> > all share same ringbuffer and perf_poll checks if there's ANY new data
>  
> > for the hup notification I think we need to poll all of them
> 
> Yeah, I'm convinced of this, I'm working on a patch to make it look at
> all file descriptors at poll time.

Done, its at:

https://git.kernel.org/cgit/linux/kernel/git/acme/linux.git/commit/?h=perf/fdarray.v2&id=46eb798f12d41093deb743b9df10fec23ffae719

this is in a refreshed branch so that it gets in the right time in the
patch kit

Comment:

-----
  perf evlist: We need to poll all event file descriptors
    
  Because we want to notice when they get POLLHUP'ed, so that we can
  figure out when all threads exited in a workload being monitored.
    
  We can't just monitor the fds that were mmaped, we need to notice when
  all the fds that were PERF_EVENT_IOC_SET_OUTPUT'ed too, because the mmap
  stays even after the fd that originally was used to do the mmap call
  went away, its only when all the set-output fds for a mmap are gone that
  the mmap is.
-----

Full branch is available at:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git perf/fdarray.v2

Web interface:

https://git.kernel.org/cgit/linux/kernel/git/acme/linux.git/log/?h=perf/fdarray.v2
 
> I'm doing it on top of a patch that will close the mmap when it gets a
> POLLHUP, as discussed recently on this thread, in a response I gave to
> Adrian.

> But since multiple fds share an mmap, we can only close that mmap when
> all fds are HUPed, i.e. we need to reference count struct perf_mmap,
> which is what I am doing.
 
> I.e. the fist mmaps and sets perf_mmap.nfds to 1, the next one, just
> after doing that PERF_EVENT_IOC_SET_OUTPUT will bump perf_mmap.nfds,
> unmap gets replaced by mmap_put, that decs and calls munmap when it
> hits zero, yadda, yadda.

Should be ok, now, with the above patch (kinda one liner, just moving
the add_pollfd call) + the patches at the top of the branch that
introduce the mmap refcounting and the fdarray facility to store some
info (what I think you called poll_item in your patchset) associated to
each entry in the file descriptor array).

Please let me know if you can take a look at the branch via the web
interface to see if that solves the problems you reported before I
repost them or if you prefer that I repost so that you can check via
e-mail.

I will repost it one final time, after lunch ;-)

- Arnaldo
