Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab3EIJab (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 05:30:31 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:56982 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956Ab3EIJa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 05:30:29 -0400
Date: Thu, 9 May 2013 11:30:25 +0200
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf: detect loops processing events
Message-ID: <20130509093025.GA21692@gmail.com>
References: <1368026327-4741-1-git-send-email-dsahern@gmail.com>
 <20130509092441.GB21620@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130509092441.GB21620@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> 
> * David Ahern <dsahern@gmail.com> wrote:
> 
> > Recovery algorithm in __perf_session__process_events attempts to remap
> > a perf.data file with a different file_offset and try again at a new head
> > position. Both of these adjustment rely on page_offset. If page_offset is
> > 0 then file_offset and head never change which means the remap attempt is
> > the same and the fetch_mmaped_event is the same and the processing just
> > loops forever.
> > 
> > Detect this condition and warn the user.
> > 
> > Signed-off-by: David Ahern <dsahern@gmail.com>
> > Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> > Cc: Ingo Molnar <mingo@kernel.org>
> > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Jiri Olsa <jolsa@redhat.com>
> > Cc: Namhyung Kim <namhyung@kernel.org>
> > Cc: Stephane Eranian <eranian@google.com>
> > ---
> >  tools/perf/util/session.c |    6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
> > index cf1fe01..1c4dc45 100644
> > --- a/tools/perf/util/session.c
> > +++ b/tools/perf/util/session.c
> > @@ -1235,6 +1235,12 @@ more:
> >  		}
> >  
> >  		page_offset = page_size * (head / page_size);
> > +		/* catch looping where we never make forward progress. */
> > +		if (page_offset == 0) {
> > +			pr_err("Loop detection processing events. Is file corrupted?\n");
> > +			return -1;
> > +		}
> > +
> >  		file_offset += page_offset;
> >  		head -= page_offset;
> >  		goto remap;
> 
> Ah, nice!
> 
> Btw., would it make sense to emit a (once-only) warning and optimistically 
> fix page_offset up to 1 (or 4096) and let things continue with the next 
> set of data - can we recover most of the data in that case?

Basically, what'd like to do with binary data is similar to what we do 
with text data if some trace output is corrupted:

            sshd-15478 [002]  1100.859353:  15478:120:S ==> [002]     0:140:R <idle>
          <idle>-0     [005]  1100.859378:      0:140:R ==> [005] 20169:120:R cat
             cat-20169 [005]  1100.860718:  20169:120:R   + [005] 15521:120:S bash
             ^@¨<81><92>^@^Bª^P^P^D<9c>8@<88>^A^M ;¤0 ^D<90>"ª<81>^B^T)Ò^C$^@^N^@^A
             cat-20169 [005]  1100.860720:  20169:120:R   + [005]   305:115:S kblockd/5
             cat-20169 [005]  1100.860722:  20169:120:? ==> [005]   305:115:R kblockd/5
       kblockd/5-305   [005]  1100.860755:    305:115:S ==> [005] 15521:120:R bash
            bash-15521 [005]  1100.860792:  15521:120:S   + [002] 15478:120:S sshd
          <idle>-0     [002]  1100.860853:      0:140:R ==> [002] 15478:120:R sshd
            sshd-15478 [002]  1100.860895:  15478:120:S ==> [002]     0:140:R <idle>
            bash-15521 [005]  1100.860925:  15521:120:S   + [002] 15478:120:S sshd
            bash-15521 [005]  1100.860999:  15521:120:S ==> [005]     0:140:R <idle>

See that junk in the middle, sign of some sort of file corruption? Instead 
of detecting it and aborting we just try to skip that line and try to find 
the next useful looking line, ignoring the junk and bits around it.

Is there a perf.data equivalent of intelligently trying to skip to the 
next plausible looking event record?

Thanks,

	Ingo
