Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab3HWKHy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 06:07:54 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:52648 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968Ab3HWKHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 06:07:53 -0400
Date: Fri, 23 Aug 2013 12:07:47 +0200
From: Robert Richter <rric@kernel.org>
To: Vince Weaver <vince@deater.net>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org, Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: [PATCH v3 12/12] [RFC] perf, persistent: ioctl functions to
 control persistency
Message-ID: <20130823100747.GC10223@rric.localhost>
References: <1377180807-12758-1-git-send-email-rric@kernel.org>
 <1377180807-12758-13-git-send-email-rric@kernel.org>
 <alpine.DEB.2.02.1308221404090.26486@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1308221404090.26486@pianoman.cluster.toy>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.08.13 14:18:06, Vince Weaver wrote:
> On Thu, 22 Aug 2013, Robert Richter wrote:
> > This is for Linux man-pages:
> 
> Thanks, though you're missing out by not learning all about troff 
> formatting.

Thanks for documenting perf_event_open(), it's a great help. The troff
thing I may learn in case I write a patch for man-pages. ;)

> 
> >     type ...
> > 
> >         PERF_TYPE_PERSISTENT (Since Linux 3.xx)
> > 
> >             This indicates a persistent event. There is a unique
> >             identifier for each persistent event that needs to be
> >             specified in the event's attribute config field.
> >             Persistent events are listed under:
> > 
> >               /sys/bus/event_source/devices/persistent/
> 
> Wait, so the first time you create a persistent event you do *not*
> set type PERF_TYPE_PERSISTENT?  You only do that if you're
> "attaching" to an exisiting event?  You might want to clarify that.

You just *open* an existing persistent event and may access buffers
with mmap(). After opening it you also may attach the event to the
process holding the fd with the ioctl. Then, the event is no longer
persistent and removed after all users finished using the event.
Without doing the attach-ioctl the event stays persistent in the
system.

> >     persistent: (Since Linux 3.xx)
> > 
> >         Put event into persistent state after opening. After closing
> >         the event's fd the event is persistent in the system and
> >         continues to run.
> 
> will there be some sort of tool that will let you kill runaway persistent 
> events?  Or will you have to manually perf_event_open() / iotcl() them
> by hand somehow?

The instance opening the event should also be responsible for removing
it. But there could be a perf tool for controlling persistent events
(create, list, remove, etc).

> >         PERF_EVENT_IOC_DETACH (Since Linux 3.xx)
> > 
> >             Detach the event specified by the file descriptor from the
> >             process and make it persistent in the system. After
> >             closing the fd the event will continue to run. An unique
> >             identifier for the persistent event is returned or an
> >             error otherwise. The following allows to connect to the
> >             event again:
> 
> You might want to re-order things so it's clear you get the unique ID
> at ioctl time and not after the close happens.

Ah, yes, indeed:

            Detach the event specified by the file descriptor from the
            process and make it persistent in the system. An unique
            identifier for the persistent event is returned or an
            error otherwise. After closing the fd the event will
            continue to run. The following allows to connect to the
            event again:


> >         PERF_EVENT_IOC_ATTACH (Since Linux 3.xx)
> > 
> >             Attach the event specified by the file descriptor to the
> >             current process. The event is no longer persistent in the
> >             system and will be removed after all users disconnected
> >             from the event. Thus, if there are no other users the
> >             event will be closed too after closing its file
> >             descriptor, the event then no longer exists.

Thanks for review, Vince.

-Robert
