Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758904Ab3GRMwY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 08:52:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21583 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758059Ab3GRMwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 08:52:23 -0400
Date: Thu, 18 Jul 2013 14:52:00 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 05/23] perf tests: Add simple session read/write test
Message-ID: <20130718125200.GD1092@krava.brq.redhat.com>
References: <1374083403-14591-1-git-send-email-jolsa@redhat.com>
 <1374083403-14591-6-git-send-email-jolsa@redhat.com>
 <20130717193313.GA5127@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130717193313.GA5127@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 04:33:13PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Wed, Jul 17, 2013 at 07:49:45PM +0200, Jiri Olsa escreveu:
> > +static struct perf_evlist *get_evlist(void)
> > +{
> > +	int err;
> > +	struct perf_evlist *evlist = perf_evlist__new();
> > +	if (evlist == NULL) {
> > +		pr_err("perf_evlist__new failed\n");
> > +		return NULL;
> > +	}
> > +	err = perf_evlist__add_default(evlist);
> > +	if (err < 0) {
> > +		pr_err("Not enough memory to create evsel\n");
> > +		perf_evlist__delete(evlist);
> > +		evlist = NULL;
> > +	}
> > +	return evlist;
> > +}
> 
> I think the above can be such a common idiom that having a new
> constructor for it is doable, i.e.:
> 
> 	evlist = perf_evlist__new_default(void);
> 	if (evlist == NULL)
> 		pr_debug, etc

ook

> 
> > +
> > +static union perf_event *get_event_MMAP(void)
> > +{
> > +	static union perf_event event;
> > +	size_t size;
> > +
> > +	size = snprintf(event.mmap.filename, sizeof(event.mmap.filename),
> > +			"krava") + 1;
> > +	size = PERF_ALIGN(size, sizeof(u64));
> > +
> > +	event.header.type = PERF_RECORD_MMAP;
> > +	event.header.misc = PERF_RECORD_MISC_KERNEL;
> > +	event.header.size = sizeof(event.mmap) -
> > +			    (sizeof(event.mmap.filename) - size);
> > +
> > +	event.mmap.pgoff = 10;
> > +	event.mmap.start = 0;
> > +	event.mmap.len   = 10;
> > +	event.mmap.pid   = 123;
> > +
> > +	return &event;
> > +}
> 
> Don't use statics, here perhaps we can have another general purpose
> helper:
> 
> 	void perf_event__init_mmap(union perf_event *event)
> 
> We then could use it on the synthesizing routines, etc.

ook

> 

SNIP

> > +
> > +static int store_event(int fd, union perf_event *event, size_t *size)
> > +{
> > +	*size += event->header.size;
> > +	return write(fd, event, event->header.size) > 0 ? 0 : -1;
> > +}
> 
> 	I think we need a writen like we have readn and then do it like:
> 
> 	return writen(fd, event, event->header.size) == event->header.size ? 0 : -1;

hum, we could generalize write_output function from builtin-record

> 
> ?
> 

SNIP

> > +
> > +	TEST_ASSERT_VAL("failed to write header",
> > +		!perf_session__write_header(session, evlist, fd, true));
> 
> Humm, can't perf_session__write_header use session->fd? Just like you
> did for some other routines in previous patches in this series?

right, but need to check if the builtin-inject caller uses the same fd

thanks,
jirka
