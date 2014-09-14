Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbaINPe4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 11:34:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41999 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621AbaINPez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 11:34:55 -0400
Date: Sun, 14 Sep 2014 08:34:07 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, eranian@google.com, Andi Kleen <ak@linux.intel.com>,
        Vince Weaver <vincent.weaver@maine.edu>, jolsa@redhat.com
Subject: Re: [PATCH] Add some documentation on the perf sysfs ABI interface
Message-ID: <20140914153407.GA4064@kroah.com>
References: <1410561259-523-1-git-send-email-andi@firstfloor.org>
 <20140914093033.GR346@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140914093033.GR346@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 14, 2014 at 11:30:33AM +0200, Peter Zijlstra wrote:
> On Fri, Sep 12, 2014 at 03:34:19PM -0700, Andi Kleen wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > Initial attempt of documenting the perf sysfs interface as
> > an ABI. I also added some additional pointers hopefully useful
> > to the users. Comments welcome.
> 
> My only worry is that its a little x86 centric and I'm not sure if that
> is acceptable with the sysfs crowd, Greg?

Does this document what you have today?  If so, that's fine, and good to
do.

Or, is this a proposed interface that is different per architecture in
subtle non-portable ways?  If so, probably not :)

> Other than that it looks like a nice addition and I suppose other
> popular archs can always add to it.
> 
> > Cc: Vince Weaver <vincent.weaver@maine.edu>
> > Cc: jolsa@redhat.com
> > v2: Various fixes. Fix cmask/inv (Stephane) Fixes from Randy Dunlap.
> > Signed-off-by: Andi Kleen <ak@linux.intel.com>
> > ---
> >  Documentation/ABI/stable/sysfs-devices-perf | 98 +++++++++++++++++++++++++++++
> >  1 file changed, 98 insertions(+)
> >  create mode 100644 Documentation/ABI/stable/sysfs-devices-perf
> > 
> > diff --git a/Documentation/ABI/stable/sysfs-devices-perf b/Documentation/ABI/stable/sysfs-devices-perf
> > new file mode 100644
> > index 0000000..3fd9bc6
> > --- /dev/null
> > +++ b/Documentation/ABI/stable/sysfs-devices-perf
> > @@ -0,0 +1,98 @@
> > +Perf events enumeration in sysfs
> > +
> > +The perf events subsystem exports the format of hardware performance
> > +counter events supported by perf events. The events can be accessed
> > +using the perf_event_open() syscall. Each perf directory in devices
> > +represents a distinct PMU (Performance Monitoring Unit), but not all
> > +directories in this file are perf directories.
> > +
> > +What: /sys/devices/*/format/*
> > +Description:
> > +
> > +Each file in format describes how to fill in an event attribute on the
> > +current CPU for the perf_event_open syscall.  Multiple event
> > +attributes may be overlapping and only be valid for some combination
> > +of attributes (for example only for some event/umask combinations).
> > +Most attributes are optional.
> > +
> > +Each field may have the following contents:
> > +
> > +CONFIG:START-END      Field consists of bits START-END in the perf_event_attr
> > +		      CONFIG field
> > +CONFIG:BIT	      Field consists of a single bit with index BIT in
> > +		      CONFIG field
> > +
> > +Valid CONFIG fields are config, config1, config2. These map to the respective
> > +64bit words in struct perf_event_attr.
> > +
> > +Typical attributes on a x86 platform
> > +
> > +event		Set the 8 bit event code (required)
> > +umask		Set the 8 bit umask. Event code and umask together select a
> > +		hardware event.
> > +cmask		Set the 8 bit counter Mask. Only increment counters when at
> > +		least cmask events happen during the same cycle.
> > +inv		(1bit flag) Invert the cmask condition. Only valid with
> > +		cmask>0.
> > +edge		(1bit flag) Only increment the event when the condition
> > +		changes (starts happening)
> > +any		(1bit flag) Count on both threads of a core
> > +pc		(1bit flag) Toggle the PMi pins when the condition happens
> > +
> > +Attributes available on some x86 platforms:
> > +
> > +in_tx		(1bit flag) Only count in a hardware transaction.
> > +in_tx_cp	(1bit flag) Undo counts inside transaction when the
> > +		transaction aborts.
> > +ldlat		Set the load-use latency threshold for sampling loads.
> > +		Note this is a load-use latency so includes pipeline delays.
> > +offcore_rsp     Set an extra mask qualifying the type of offcore access.
> > +		Only with OFFCORE_RESPONSE events. The actual mask is CPU model
> > +		specific.

I don't understand exactly what these files look like, are they just
"one value per file", or do they have to be parsed with multiple values
in the files?

> > +For more details on the x86 attributes on Intel platforms please see
> > +http://www.intel.com/sdm Volume 3, Chapter 18 and 19.  For more
> > +details on the perf_event_attr struct please see the perf_event_open
> > +manpage and include/uapi/linux/perf_event.h.
> > +
> > +What: /sys/devices/*/events/*
> > +Description:
> > +
> > +Describe predefined events available in the CPU. Each file describes an event.
> > +The format is attr=0xHEXNUM{,attr=0xHEXNUM}. Each attr is described in a config
> > +file. Together all the attributes can be used to set up a valid event for the
> > +perf_event_open syscall.

Why would a sysfs file have a "attr=" string in it?  Again, one value per
file is the rule here.

thanks,

greg k-h
