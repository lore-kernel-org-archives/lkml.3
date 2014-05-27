Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690AbaE0Hhx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 03:37:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35434 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949AbaE0Hhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 03:37:52 -0400
Date: Tue, 27 May 2014 09:37:38 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 06/14] perf tools: Cache dso data file descriptor
Message-ID: <20140527073738.GA12920@krava.brq.redhat.com>
References: <1400174615-2121-1-git-send-email-jolsa@kernel.org>
 <1400174615-2121-7-git-send-email-jolsa@kernel.org>
 <87tx8chvzb.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tx8chvzb.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 10:05:28AM +0900, Namhyung Kim wrote:
> Hi Jiri,
> 
> On Thu, 15 May 2014 19:23:27 +0200, Jiri Olsa wrote:
> 
> [SNIP]
> > +static void data_close(void)
> > +{
> > +	bool cache_fd = may_cache_fd();
> > +
> > +	if (!cache_fd)
> > +		close_first_dso();
> > +}
> 
> Why do you do this at close()?  As long as there's no attempt to open a
> new file, we can keep existing fd, no?

so the way it works now is:

 - we keep up to the 'RLIMIT_NOFILE / 2' of open dso objects
 - if we try to open dso and it fails, because we are out of
   file descriptors, we close dso objects and try to reopen
   (check do_open function)
 - when we close the dso object we check if number of opened
   dso objects is below 'RLIMIT_NOFILE / 2'.. if it is, we keep
   the dso opened, if not we close first dso in the list

util/dso.h tries to describe that

> 
> > +
> > +void dso__data_close(struct dso *dso)
> > +{
> > +	if (dso->data.fd >= 0)
> > +		data_close();
> > +}
> 
> Hmm.. it's confusing dso__data_close(dso) closes an other dso rather
> than the given dso.  And this dso__data_close() is not paired with any
> _open() also these close calls make me confusing which one to use. ;-p

thats due to the caching.. as explained above

About the pairing.. originally the interface was only dso__data_fd
that opened and returned fd, which the caller needed to close.

I added dso__data_close so we could keep track of file descriptors.

I could add dso__data_open I guess, but it is dso__data_fd which is
needed for elf interface anyway.

thanks,
jirka
