Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348AbaJFTMe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 15:12:34 -0400
Received: from mail.kernel.org ([198.145.19.201]:51839 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753011AbaJFTMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 15:12:33 -0400
Date: Mon, 6 Oct 2014 16:12:27 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Jean Pihet <jean.pihet@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Fu Wei <fu.wei@linaro.org>, Robert Richter <rric@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: perf & rasd integration plan
Message-ID: <20141006191227.GD14113@kernel.org>
References: <CAFrcx1kufO2yj7--UiL841Yp5Es5=WqjL__Yzg=-+nPV5XoohA@mail.gmail.com>
 <20141006150741.GB14113@kernel.org>
 <20141006151605.GE4372@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141006151605.GE4372@pd.tnic>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Oct 06, 2014 at 05:16:06PM +0200, Borislav Petkov escreveu:
> On Mon, Oct 06, 2014 at 12:07:41PM -0300, Arnaldo Carvalho de Melo wrote:
> > So, why have you commented out the perf_missing_features fallbacks? Are
> > they getting in the way somehow, what can we do upstream, i.e. in
> > tools/perf/util/ so that it gets closer to what you want to have?
> > 
> > Ditto for all the other ifdef'ed code, can you elaborate on why each is
> > needed? That will help in moving what is used by rasd from
> > tools/perf/util/ to tools/perf/lib/ so that we can eliminate the
> > duplicity.
> 
> Oh, the reason is very simple: so that it builds. We don't need those
> facilities yet. We will enable them when needed but we wanted to
> concentrate on rasd first and later clean up stuff as we go.

Right, and it is being a great exercise, thanks for the patience so far
;-)

Looking at those ifdefs we see things that are specific to tools/perf/,
like perf_evsel having a struct hists embedded... I.e. that is of no
interest whatsoever (so far) to rasd, and in turn pulls other object
files.

So I think that right now we need to look at those ifdefs and go on
making what is in tools/perf/util/ stop using it somehow, so that what
then gets moved to tools/lib/api/perf/ (I guess this is where it should
be, opinions?) have that sorted out.

I.e. what goes to tools/lib/api/perf/ is what is common to the needs of
tools/perf/ and rasd (wherever it may roam).

Perhaps something like I did for sock/inet_sock/inet_connection_sock
ages ago... I.e. the tools that want a hists will have a 

struct hists_evsel {
	struct perf_evsel evsel;
	struct hists	  hists;
};

etc.

Experimenting with that, as it is the only thing ifdefed out in rasd's
copy of evsel.h...

- Arnaldo
