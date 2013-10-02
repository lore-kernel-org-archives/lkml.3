Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab3JBGNo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 02:13:44 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:34388 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784Ab3JBGNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 02:13:39 -0400
Date: Wed, 2 Oct 2013 08:13:35 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Waiman Long <Waiman.Long@hp.com>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf: Support for Openembedded/Yocto -dbg packages
Message-ID: <20131002061335.GD31122@gmail.com>
References: <1379493790-9554-1-git-send-email-ricardo.ribalda@gmail.com>
 <20130918092444.GA2778@gmail.com>
 <CAPybu_2GBymhgxHmtJu63pT2t8ge84EA9Ww54r9mGOA5KH7Hww@mail.gmail.com>
 <CAPybu_2Wf_p-jo2X4VzSBXrfy3DnHY4PeOvNVLfeoGRFfbDwRA@mail.gmail.com>
 <20130918101801.GO12926@twins.programming.kicks-ass.net>
 <20130918130735.GC2240@ghostprotocols.net>
 <20130918132903.GA4071@gmail.com>
 <87had0o5kf.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87had0o5kf.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Namhyung Kim <namhyung@kernel.org> wrote:

> Hi Ingo and Arnaldo,
> 
> On Wed, 18 Sep 2013 15:29:03 +0200, Ingo Molnar wrote:
> > * Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:
> >
> >> Em Wed, Sep 18, 2013 at 12:18:01PM +0200, Peter Zijlstra escreveu:
> >> > On Wed, Sep 18, 2013 at 12:02:12PM +0200, Ricardo Ribalda Delgado wrote:
> >> > > Perhaps this is even more clear than v2:
> >> 
> >> > > len = snprintf(file, size, "%s", symbol_conf.symfs);
> >> > > size -= len;
> >> > > file += len;
> >> > > len = snprintf(file, MIN(size,(last_slash - dso->long_name) + 2),
> >> > > "%s",  dso->long_name);
> >> > > size -= len;
> >> > > file += len;
> >> > > len = snprintf(file, size, ".debug%s",  last_slash);
> >> 
> >> > len = 0;
> >> 
> >> > len += snprintf(str + len, size - len, ...);
> >> > len += snprintf(str + len, size - len, ...);
> >> 
> >> And avoid snprintf like the plague, use scnprintf instead...  See
> >> e7f01d1e3d8d501deb8abeaa269d5d48a703b8b0 for details :-)
> >
> > Hm, could we do:
> >
> > 	#define snprintf scnprintf
> >
> > or:
> >
> > 	#define snprintf(x...) BUILD_BUG()
> >
> > ?
> >
> > I don't think there's any valid code, except printf wrappers (which we 
> > don't have in perf), where the semantics of snprintf() would be needed.
> 
> There are some places that use snprintf() to query the actual length:
> 
> tools/perf/util/srcline.c:245:	size = snprintf(NULL, 0, "%s:%u", file, line) + 1;
> tools/perf/util/values.c:147:		width = snprintf(NULL, 0, "%d", values->pid[i]);
> tools/perf/util/values.c:150:		width = snprintf(NULL, 0, "%d", values->tid[i]);
> tools/perf/util/values.c:154:			width = snprintf(NULL, 0, "%" PRIu64, values->value[i][j]);
> tools/perf/util/values.c:189:		width = snprintf(NULL, 0, "%d", values->pid[i]);
> tools/perf/util/values.c:192:		width = snprintf(NULL, 0, "%d", values->tid[i]);
> tools/perf/util/values.c:200:		width = snprintf(NULL, 0, "%" PRIx64, values->counterrawid[j]);
> tools/perf/util/values.c:206:			width = snprintf(NULL, 0, "%" PRIu64, values->value[i][j]);

I think that should be a separate, more obviously named helper inline 
instead, something like:

static inline printf_width(const char *fmt, ...)
{
        va_list args;
        int width;

        va_start(args, fmt);
        width = vsnprintf(NULL, 0, fmt, args);
        va_end(args);

        return width;
}

#define snprintf(fmt...) BUILD_BUG_ON(1, "Use scnprintf() instead of snprintf()")

or so? Then we could use it like this:

> tools/perf/util/values.c:147:		width = printf_width("%d", values->pid[i]);

and naked snprintf use would provoke a build bug.

Various printf wrappers can still use vsnprintf() - it's the routine use 
of snprintf() instead of scnprintf() that should be inhibited.

Thanks,

	Ingo
