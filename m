Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023Ab3FYQ4q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 12:56:46 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:49006 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060Ab3FYQ4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 12:56:45 -0400
Date: Tue, 25 Jun 2013 18:56:39 +0200
From: Robert Richter <rric@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/14] perf, persistent: Kernel updates for perf tool
 integration
Message-ID: <20130625165639.GH21579@rric.localhost>
References: <1370968960-22527-1-git-send-email-rric@kernel.org>
 <20130624102200.GR28407@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130624102200.GR28407@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.06.13 12:22:00, Peter Zijlstra wrote:
> On Tue, Jun 11, 2013 at 06:42:26PM +0200, Robert Richter wrote:
> > Note that perf tools need to support the 'attr<num>' syntax that is
> > added in a separate patch set. With it we are able to run perf tool
> > commands to read persistent events, e.g.:
> 
> where is this patch? I can't find it.

I posted it with that subject:

 [PATCH 0/4] perf tools: Persistent events, changes for perf tool integration

> I also find attr<num>:<bit> a bit weird. So far we've used
> <perf_event_attr::fieldname>:<bits>, so while initializing anonymous
> unions is a bit difficult with 'older' GCCs and we cannot actually do:
> 
> struct perf_event_attr {
> 	...
> 	union {
> 		u64 flags;
> 		u64 disabled : 1,
> 		    ...
> 		    __reserved_1 : X;
> 	}
> 	...
> };
> 
> We could fake it in userspace by allowing things like: flags:23. It
> would not be a much worse hack than attr<num>:<bit> I suppose.

A goal is to be able to entirely describe the complete attr structure
with sysfs. perf tools should work out-of-the-box for every kind of
event. For this particular case a 'flags' syntax would be ok, but not
if you like to fill in other attr members.

With attr<num>:<bit> you are flexible to put in *everything* into
attr. And for better readability there are abstractions as formats
like:

 /sys/bus/event_source/devices/persistent/format/persistent:attr5:23

Not sure if the event parser handles recursion already, but we could
also support the 'flag' format you describe that way:

 /sys/bus/event_source/devices/persistent/format/flags:attr5:0-63
 /sys/bus/event_source/devices/persistent/format/persistent:flags:23

We could even list events for other pmus with small changes in the
kernel, e.g:

 /sys/bus/event_source/devices/persistent/format/type:attr0:0-31
 /sys/bus/event_source/devices/persistent/events/some_tracepoint:type=2,config=<tp_id>

The example is a bit weird. But in general we can translate struct
perf_event_attr to a string and vice versa. And perf tools understand
how to set up every bit of the event attr structure.

-Robert
