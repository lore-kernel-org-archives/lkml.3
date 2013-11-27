Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059Ab3K0L54 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 06:57:56 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:53961 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291Ab3K0L5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 06:57:50 -0500
Date: Wed, 27 Nov 2013 12:57:46 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH] tools/perf/util: Document and clean up readn() a bit
Message-ID: <20131127115746.GB10528@gmail.com>
References: <1385130268-10664-1-git-send-email-jolsa@redhat.com>
 <1385130268-10664-2-git-send-email-jolsa@redhat.com>
 <20131125192909.GA27323@ghostprotocols.net>
 <20131126175335.GA9300@gmail.com>
 <5295AFA3.6060007@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5295AFA3.6060007@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Adrian Hunter <adrian.hunter@intel.com> wrote:

> On 26/11/13 19:53, Ingo Molnar wrote:
> > 
> > * Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:
> > 
> >> Em Fri, Nov 22, 2013 at 03:24:26PM +0100, Jiri Olsa escreveu:
> >>>  }
> >>> +
> >>> +ssize_t perf_data_file__write(struct perf_data_file *file,
> >>> +			      void *buf, size_t size)
> >>> +{
> >>> +	ssize_t total = size;
> >>> +
> >>> +	while (size) {
> >>> +		ssize_t ret = write(file->fd, buf, size);
> >>> +
> >>> +		if (ret < 0) {
> >>> +			pr_err("failed to write perf data, error: %m\n");
> >>> +			return -1;
> >>> +		}
> >>> +
> >>> +		size -= ret;
> >>> +		buf  += ret;
> >>> +	}
> >>> +
> >>> +	return total;
> >>
> >> So this is the functional equivalent of "readn", so please move it to
> >> just after "readn" and make this just a simple wrapper.
> > 
> > Btw., would be nice to add a small comment to readn() that describes 
> > its semantics, it looks like a useful helper.
> > 
> > I also added a check for the input parameter 'n', plus I added a 
> > 'left' variable to make the flow clearer, and added a debug check for 
> > the return value - I think returning 'n' is more obvious.
> 
> It would be nicer to match what 'read' does.
> 
> > 
> > Totally untested though.
> > 
> > Thanks,
> > 
> > 	Ingo
> > 
> > Signed-off-by: Ingo Molnar <mingo@kernel.org>
> > 
> > diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
> > index 28a0a89..4789081 100644
> > --- a/tools/perf/util/util.c
> > +++ b/tools/perf/util/util.c
> > @@ -6,6 +6,7 @@
> >  #endif
> >  #include <stdio.h>
> >  #include <stdlib.h>
> > +#include <linux/kernel.h>
> >  
> >  /*
> >   * XXX We need to find a better place for these things...
> > @@ -151,21 +152,29 @@ unsigned long convert_unit(unsigned long value, char *unit)
> >  	return value;
> >  }
> >  
> > -int readn(int fd, void *buf, size_t n)
> > +/*
> > + * Read exactly 'n' bytes or return an error:
> > + */
> > +int readn(int fd, void *buf, ssize_t n)
> 
> Should really be the same prototype as 'read' i.e.
> 
> 	ssize_t readn(int fd, void *buf, size_t n)
> 
> Need to change callers that are using 'int' too.
> 
> >  {
> >  	void *buf_start = buf;
> > +	size_t left = n;
> > +
> > +	BUG_ON(n <= 0);
> 
> 	BUG_ON(n == 0 || n > SSIZE_MAX);
> 
> >  
> > -	while (n) {
> > -		int ret = read(fd, buf, n);
> > +	while (left) {
> > +		int ret = read(fd, buf, left);
> 
> Should use the correct return type:
> 
> 		ssize_t ret = read(fd, buf, left);
> 
> >  
> >  		if (ret <= 0)
> >  			return ret;
> 
> Don't return 0 if not all the bytes were read:
> 
> 		if (ret < 0)
> 			return ret;
> 		if (!ret)
> 			break;

Okay, I thought this was an intentional 'all or nothing' interface - 
but looking at the readn() users they can tolerate partial results 
just fine.

> 
> >  
> > -		n -= ret;
> > +		left -= ret;
> >  		buf += ret;
> >  	}
> >  
> > -	return buf - buf_start;
> > +	BUG_ON(buf-buf_start != n);
> > +
> > +	return n;
> 
> Should return the same value as 'read' i.e the original
> 
> 	return buf - buf_start;

It does, in the original version I patched buf-buf_start == n, see the 
assert that checks for that.

If partial reads are returned then this bit has to change too, yes.

Thanks,

	Ingo
