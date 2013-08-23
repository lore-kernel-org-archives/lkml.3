Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab3HWJhU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 05:37:20 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:42747 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880Ab3HWJhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 05:37:17 -0400
Date: Fri, 23 Aug 2013 11:37:08 +0200
From: Robert Richter <rric@kernel.org>
To: Vince Weaver <vince@deater.net>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH v3 08/12] perf, persistent: Exposing persistent events
 using sysfs
Message-ID: <20130823093708.GA10223@rric.localhost>
References: <1377180807-12758-1-git-send-email-rric@kernel.org>
 <1377180807-12758-9-git-send-email-rric@kernel.org>
 <alpine.DEB.2.02.1308221344500.26486@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1308221344500.26486@pianoman.cluster.toy>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.08.13 14:00:51, Vince Weaver wrote:
> On Thu, 22 Aug 2013, Robert Richter wrote:

> > +		attr<index>:<bits>	Set any field of the event
> > +					attribute. The index is a
> > +					decimal number that specifies
> > +					the u64 value to be set within
> > +					struct perf_event_attr.
> 
> Ugh this is ugly.

It's not intended to be used by humans. ;) It is more for format
definitions that are provided by the kernel and that are parsed by
(perf) tools. Of course, a human could dig into it to figure out
that's going on.

> You might also want to specify that the "index"
> value starts at 0 which threw me for a bit when I was trying to figure
> out what was going on.  You might also want to clarify the previous
> part of the document which uses "attr" to mean something else.

I thought it would be clear enough to refer to struct perf_event_attr.
Since the index usually starts with 0 as in the config fields, I
assumed this was clear in this case too. Though this can be documented
better.

> Is this endian clean?  Will attr5:23 point to the same bit on a big-endian 
> machine as on little-endian?

It is the endianness used in the syscall. Handled in the same way as
for the config fields. I don't see where this could be an issue.

> If we're going to have to have an ugly interface like this we might
> as well do something more human readable, since anything that parses this 
> is going to have to rebuild the struct perf_event_attr by hand anyway
> (unless you propose people blindly set bits at offsets using pointer math
> which just sounds like a bad idea).

The format directories in /sys/bus/event_source/devices/*/format/ are
already there to make it human readable. A user never has to deal
directly with syntax provided there and may use already the
abstractions for the event syntax.

> For example, just give up and let someone specify the actual field name
> like "persistent" and have the tools handle that. 
> 
> /sys/bus/event_source/devices/persistent/events/mce_record
>    persistent,config=106
> 
> /sys/bus/event_source/devices/persistent/format/persistent
>     attr_persistent
> 
> That way you could also add things like
> /sys/bus/event_source/devices/persistent/format/precise_ip
>     attr_precise_ip:0-1

The problem with this is that you have to implement this in the event
parser of perf tools. Thus, you need to update the parser for any
other syntax you want to use. This is not necessary with my
implementation. It already provides the above. The pmu driver just
need to add the sysfs entry.

 .../format/precise_ip = attr5:15-16

Then, -e cycles,precise_ip=1 is the same as -e cycles:p. Looks very
human readable?

All this without updating perf tools.

Simply test this as follows:

 # cp -rp /sys/devices/cpu/format/ /dev/shm/
 # echo attr5:15-16 > /dev/shm/format/precise_ip
 # mount --bind /dev/shm/format/ /sys/devices/cpu/format/
 # find /sys/devices/cpu/format/
 /sys/devices/cpu/format/
 /sys/devices/cpu/format/precise_ip
 /sys/devices/cpu/format/umask
 /sys/devices/cpu/format/event
 /sys/devices/cpu/format/cmask
 /sys/devices/cpu/format/edge
 /sys/devices/cpu/format/inv
 # perf record -e cycles,precise_ip=1 sleep 1

Works out-of-the-box...

It's the whole intention of the new syntax that the event parser never
needs to be modified again for new attribute flags or any other
settings of the attributes. Now the syntax is also capable to describe
any event setup. Also consider that different architectures may
provide different syntax. In this case there is no need for
arch-specific code in the tools implementation, all is just brought by
sysfs.

> Although I still think exposing the full huge attr stuct via sysfs is just 
> silly.  Isn't there some better way?  I'm not aware of any other syscall
> that exports things like this.

That's a different story. Guess there is no way back anymore now.
Though we are in a state all this is handable and covered by perf
tools.

-Robert
