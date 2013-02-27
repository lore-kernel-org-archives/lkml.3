Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374Ab3B0NPY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 08:15:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52979 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759904Ab3B0NPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 08:15:23 -0500
Date: Wed, 27 Feb 2013 14:14:56 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] perf: Fix vmalloc ring buffer free function
Message-ID: <20130227131456.GD1054@krava.brq.redhat.com>
References: <1361892861-11070-1-git-send-email-jolsa@redhat.com>
 <CAFTL4hzPdQAmpGX7pod1qabJ85VC64ta2fVDBLiRqghfQWjeMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hzPdQAmpGX7pod1qabJ85VC64ta2fVDBLiRqghfQWjeMA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 02:02:39PM +0100, Frederic Weisbecker wrote:
> 2013/2/26 Jiri Olsa <jolsa@redhat.com>:
> > If we allocate perf ring buffer with the size of single page,
> > we will get memory corruption when releasing it. It's caused
> > by rb_free_work function (the CONFIG_PERF_USE_VMALLOC option
> > variant).
> >
> > For single page sized ring buffer the page_order is -1 (because
> > nr_pages is 0). This needs to be recognized in the rb_free_work
> > function and set 'nr' to 0 in this case, so only the user page
> > gets freed.
> >
> > Reported-by: Jan Stancek <jstancek@redhat.com>
> > Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> > Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Namhyung Kim <namhyung@kernel.org>
> > Cc: Paul Mackerras <paulus@samba.org>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> > ---
> >  kernel/events/ring_buffer.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
> > index 23cb34f..21159fb 100644
> > --- a/kernel/events/ring_buffer.c
> > +++ b/kernel/events/ring_buffer.c
> > @@ -336,7 +336,8 @@ static void rb_free_work(struct work_struct *work)
> >         int i, nr;
> >
> >         rb = container_of(work, struct ring_buffer, work);
> > -       nr = 1 << page_order(rb);
> > +       /* -1 if there's only user page */
> > +       nr = page_order(rb) == -1 ? 0 : 1 << page_order(rb);
> 
> So we allow for 0 sized ring buffer? I'm not entirely convinced this
> is a good idea. Besides this above case, perf_output_begin() looks

We actually have test perf case 'tools/perf/tests/rdpmc.c' using
just the user page for counter id and other stuff..

> dangerous in the case of CONFIG_PERF_USE_VMALLOC due to page_order()
> being -1. At least rb->nr_pages sould be zero in that case.

right, seems to suffer the same way as rb_free_work.. will check 

thanks,
jirka
