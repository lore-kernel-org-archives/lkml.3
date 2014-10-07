Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbaJGNcp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 09:32:45 -0400
Received: from mail.kernel.org ([198.145.19.201]:36971 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753817AbaJGNcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 09:32:43 -0400
Date: Tue, 7 Oct 2014 10:32:36 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: Borislav Petkov <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Fu Wei <fu.wei@linaro.org>, Robert Richter <rric@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 1/1] rasd: Use perf_evlist__open() instead of open coded
Message-ID: <20141007133236.GG14113@kernel.org>
References: <CAFrcx1kufO2yj7--UiL841Yp5Es5=WqjL__Yzg=-+nPV5XoohA@mail.gmail.com>
 <20141006212606.GF14113@kernel.org>
 <CAFrcx1=swP-3E_pxWEcozFJhL+5YaUBPavQX=OfMtc8h4e=bDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFrcx1=swP-3E_pxWEcozFJhL+5YaUBPavQX=OfMtc8h4e=bDg@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Oct 07, 2014 at 10:45:14AM +0200, Jean Pihet escreveu:
> > --- a/src/rasd.c
> > -       evlist__for_each(evlist, c) {
> > -               /* On all online cpus by default, system wide tracing */
> > -               if (perf_evsel__open(c, evlist->cpus, NULL) < 0)
> > -                       err("opening tracepoint, are you root?");
> > -       }
> > -       perf_evlist__set_id_pos(evlist);
> > +       /* On all online cpus by default, system wide tracing */
> > +       if (perf_evlist__open(evlist) < 0)
> > +               err("opening tracepoint, are you root?");
 
> That way the system wide tracing does not work. perf_evlist__open uses
> a non-NULL thread mapping and so it only traces the events generated
> by the daemon itself.
 
> perf top uses a similar approach but uses a lot of code in machine.c
> (machine__synthesize_threads) and util/event.c
> (perf_event__synthesize_threads) to synthesize the threads etc., which
> we want to avoid in the minimalistic approach of rasd.

Humm, I will look into making it support this usecase, the point of
evsel/evlist is to try to abstract away as much as possible, leaving
just a few methods to be used by tools.

I think the default for perf_evlist__open() should be the most useful
for the majority of tools, which I thought would serve rasd well. It is
not the case, so I'll into how the tools that currently use
perf_evlist__open() behave and try to get a sane default in place.

Hopefully we will completely remove the need to set up any thread or cpu
map, as what you want is syswide tracing, right?

- Arnaldo
 
> Maybe I missed something about the system wide tracing, any suggestion
> is welcome.
> 
> Thanks for looking!
> 
> Jean
> 
> >
> >         /* mmap buffers */
> >         if (perf_evlist__mmap(evlist, 4 /* opts->mmap_pages */, false) < 0)
> > --
> > 1.9.3
> >
