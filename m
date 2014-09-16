Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbaIPQeF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 12:34:05 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:33268 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096AbaIPQeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 12:34:02 -0400
Message-ID: <1410885227.12376.20.camel@hornet>
Subject: Re: [RFC 2/2] perf: Marker software event and ioctl
From: Pawel Moll <pawel.moll@arm.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Christopher Covington <cov@codeaurora.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>,
        John Stultz <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Date: Tue, 16 Sep 2014 17:33:47 +0100
In-Reply-To: <20140915183101.GE11199@kernel.org>
References: <1410522513-1045-1-git-send-email-pawel.moll@arm.com>
	 <1410522513-1045-3-git-send-email-pawel.moll@arm.com>
	 <5412EA7A.9020807@codeaurora.org> <1410526672.16936.52.camel@hornet>
	 <20140912134910.GG1801@kernel.org> <1410530335.16936.60.camel@hornet>
	 <20140912161934.GJ1801@kernel.org> <1410802034.3817.21.camel@hornet>
	 <20140915183101.GE11199@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-09-15 at 19:31 +0100, Arnaldo Carvalho de Melo wrote:
> Em Mon, Sep 15, 2014 at 06:27:14PM +0100, Pawel Moll escreveu:
> > On Fri, 2014-09-12 at 17:19 +0100, Arnaldo Carvalho de Melo wrote:
> > > Em Fri, Sep 12, 2014 at 02:58:55PM +0100, Pawel Moll escreveu:
> > > > On Fri, 2014-09-12 at 14:49 +0100, Arnaldo Carvalho de Melo wrote:
> > > > > Perhaps both? I.e. an u64 followed from a string, if the u64 is zero,
> > > > > then there is a string right after it?
> > >  
> > > > How would this look like in userspace? Something like this?
> > >  
> > > > 8<----
> > > > struct perf_event_marker {
> > > > 	uint64_t value;
> > > > 	char *string;
> > > > } arg;
> > >  
> > > > arg.value = 0x1234;
> > >  
> > > > /* or */
> > >  
> > > > arg.value = 0;
> > > > arg.string = "abcd";
> > >  
> > > > ioctl(fd, PERF_EVENT_IOC_MARKER, &arg)
> > > > 8<----
> > >  
> > > > If so, maybe it would simpler just to go for classic size/data
> > > > structure?
> > >  
> > > > 8<-----
> > > > struct perf_event_marker {
> > > > 	uint32_t size;
> > > > 	void *data;
> > > > }
> > > > 8<-----
> > >  
> > > > This would directly map into struct perf_raw_record...
> > > 
> > > I can see the usefulness of having it all, i.e. if we do just:
> > > 
> > > perf trace --pid `pidof some-tool-in-debug-mode-using-this-interface`
> > 
> > Hm. I haven't thought about a situation when 3rd party wants to inject
> > something into "my" data stream... I guess it could be implemented (a
> 
> I was thinking about intercepting calls that pass some logging data, as
> strings, and 'tee' them to the 'perf trace' 'data stream'.

Right, ok, like LD_PRELOADing printf (a stupid example of course) and
piping it inside perf... So if I'm getting it right, it's the perf
process that would eventually do the ioctl(PERF_EVENT_IOC_MARKER), not
the traced process, correct? This makes sense. Another use case for
ioctl justification, thanks :-)

> > "myself"?), but will definitely complicate the patch. Should I have a
> > look at it now or maybe leave it till we get a general agreement about
> > the marker ioctl existence?
> > 
> > > Then 'perf trace' doesn't know about any binary format a tool may have,
> > > getting strings there (hey, LD_PRELOADing some logging library to hook
> > > into this comes to mind) and having it merged with other events
> > > (syscalls, pagefaults, etc) looks useful.
> > 
> > But do you still mean a "magic" u64 before the rest? Injecting a string
> > would just mean:
> > 
> > 	marker.size = strlen(s) + 1;
> > 	marker.data = s;
> > 
> > > As well as some specialized version of 'perf trace' that knows about
> > > some binary protocol that would get app specific stats or lock status,
> > > etc, perhaps even plugins for 'perf trace' that would be selected by
> > > that first u64? Also seems useful.
> > > 	  
> > > I.e. having a way to provide just strings and another that would allow
> > > passing perf_raw_record.
> > 
> > Sounds interesting. But then maybe this stuff shouldn't go into "raw"
> > then? It could be something like this in the sample:
> > 
> > 	{ u64 type; /* 0 means zero-terminated string in data */
> > 	  u32 size;
> > 	  char data[size]; } && PERF_SAMPLE_MARKER
> 
> Yes, this is how I think it should be.

Seems that Ingo had exactly the same thing on mind. I'll get a patch
done.

Paweł

