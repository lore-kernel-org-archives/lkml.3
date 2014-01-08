Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269AbaAHS7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 13:59:46 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:38809 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755AbaAHS7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 13:59:42 -0500
Date: Wed, 8 Jan 2014 15:59:34 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: Re: [PATCH 01/28] perf tools: Insert filtered entries to hists also
Message-ID: <20140108185934.GA8365@ghostprotocols.net>
References: <1389170793-21926-1-git-send-email-namhyung@kernel.org>
 <1389170793-21926-2-git-send-email-namhyung@kernel.org>
 <20140108124113.GA15464@ghostprotocols.net>
 <20140108162253.GB21500@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140108162253.GB21500@krava.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jan 08, 2014 at 05:22:53PM +0100, Jiri Olsa escreveu:
> On Wed, Jan 08, 2014 at 09:41:13AM -0300, Arnaldo Carvalho de Melo wrote:
> > Em Wed, Jan 08, 2014 at 05:46:06PM +0900, Namhyung Kim escreveu:
> > > Currently if a sample was filtered by command line option, it just
> > > dropped.  But this affects final output in that the percentage can be
> > > different since the filtered entries were not included to the total.
> > > 
> > > For example, if an original output looked like below:
> > 
> > Humm, if one says that he/she is interested on just samples for a and b,
> > the current behaviour will state how many of the filtered samples are
> > for a and b, which is valid.
> > 
> >  I bet the number of samples will reflect that as well, but you filtered
> > it out, yes, it stays there, so the percentages are relative to the
> > number of samples.
> > 
> > So I think this change in behaviour is wrong, no?
> > 
> hi,
> haven't checked the implementation yet, but it kind of does
> what I'd expect for symbol filtering:
> 
> perf report
> ...
>  22.00%  yes  libc-2.17.so       [.] __strlen_sse2
>  11.79%  yes  libc-2.17.so       [.] fputs_unlocked
>   9.65%  yes  libc-2.17.so       [.] __GI___mempcpy
>   1.91%  yes  yes                [.] fputs_unlocked@plt
> ...
> 
> search (press '/') for fputs_unlocked (with Namhyung's change):
>  11.79%  yes  libc-2.17.so  [.] fputs_unlocked
>   1.91%  yes  yes           [.] fputs_unlocked@plt
> 
> while the current one shows:
>  86.08%  yes  libc-2.17.so  [.] fputs_unlocked
>  13.92%  yes  yes           [.] fputs_unlocked@plt
> 
> which annoys me when searching for 'invisible' symbol
> within tons of others.. I had to do that grep thing
> you showed.
> 
> I'd like to have the Namhyung's change behaviour as default,
> but I'll be happy with some switch as well ;-)

I understand the desire for this different mode, looks indeed useful.

So I think that this is a new feature and as so we should provide it as
an option, that may (or not) become the default.

Some concerns I have are that when we go on filtering we have to have
all the things that are zeroed to then get accrued for each hist entry
that matches the filter being applied and now at least a nr_entries
field got out of the if (al.filtered) block, i.e. in the end we will
have the number of hist entries entries filtered but continue having the
total period for all (filtered or not) hist entries.

Having it as a separate feature would allow to have both views:

1. the percentages relative to the filtered samples
2. the percentages relative to all (filtered or not) samples

Being selectable on the command line and also with a hotkey to provide
two columns: %total, %filtered.

So we would have new field: hists->stats.total_filtered_period, and
hists->stats.nr_filtered_entries, for this, etc.

What do you think?

- Arnaldo
