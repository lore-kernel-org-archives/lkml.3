Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021AbaIDPTN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 11:19:13 -0400
Received: from mail.kernel.org ([198.145.19.201]:47987 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803AbaIDPTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 11:19:12 -0400
Date: Thu, 4 Sep 2014 12:19:02 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 04/10] perf record: Filter out POLLHUP'ed file descriptors
Message-ID: <20140904151902.GE2997@kernel.org>
References: <1409781604-16778-1-git-send-email-acme@kernel.org>
 <1409781604-16778-5-git-send-email-acme@kernel.org>
 <54085BC8.40403@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54085BC8.40403@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Sep 04, 2014 at 03:32:08PM +0300, Adrian Hunter escreveu:
> On 09/04/2014 12:59 AM, Arnaldo Carvalho de Melo wrote:
> > So that we don't continue polling on vanished file descriptors, i.e.
> > file descriptors for events monitoring threads that exited.

> > I.e. the following 'perf record' command now exits as expected, instead
> > of staying in an eternal loop:

> >   $ sleep 5s &
> >   $ perf record -p `pidof sleep`

> > Reported-by: Jiri Olsa <jolsa@redhat.com>
<SNIP>
> > +++ b/tools/perf/builtin-record.c
> > @@ -467,6 +467,9 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
> >  			if (err > 0 || (err < 0 && errno == EINTR))
> >  				err = 0;
> >  			waking++;
> > +			if (perf_evlist__filter_pollfd(rec->evlist, POLLERR | POLLHUP) == 0)
> 
> If the poll fds only include the ones mmapped, then mightn't it filter out
> ones still in use? e.g. what if you record two processes and one exits?

Humm, without looking at the code, we would be needlessly looking at the
mmaps for the threads that exited.

I.e. we need to associate at the fdarray level the mmaps for the
descriptors, so that we can, at fdarray__filter() time, munmap the
POLLHUPed descriptors, right?

I'll take a look at the code to see what is needed.

But then this makes the patch set good for a class of problems while
maintaining existing behaviour for the case you outlined, i.e. this is a
partial fix and should go now, with further patches on top of it?

- Arnaldo
