Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab3HVSQs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 14:16:48 -0400
Received: from smtpauth05h.mfg.siteprotect.com ([64.26.60.146]:57668 "EHLO
	smtpauth05.mfg.siteprotect.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753853Ab3HVSQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 14:16:47 -0400
Date: Thu, 22 Aug 2013 14:18:06 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Robert Richter <rric@kernel.org>
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@linaro.org>,
        Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: [PATCH v3 12/12] [RFC] perf, persistent: ioctl functions to
 control persistency
In-Reply-To: <1377180807-12758-13-git-send-email-rric@kernel.org>
Message-ID: <alpine.DEB.2.02.1308221404090.26486@pianoman.cluster.toy>
References: <1377180807-12758-1-git-send-email-rric@kernel.org> <1377180807-12758-13-git-send-email-rric@kernel.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020203.5216558E.025D,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Aug 2013, Robert Richter wrote:

> From: Robert Richter <robert.richter@linaro.org>
> 
> Implementing ioctl functions to control persistent events. There are
> functions to detach or attach an event to or from a process. The
> PERF_EVENT_IOC_DETACH ioctl call makes an event persistent. After
> closing the event's fd it runs then in the background of the system
> without the need of a controlling process. The perf_event_open()
> syscall can be used to reopen the event by any process. The
> PERF_EVENT_IOC_ATTACH ioctl attaches the event again so that it is
> removed after closing the event's fd.


> PERF_EVENT_IOC_ATTACH (Since Linux 3.xx)
> PERF_EVENT_IOC_DETACH (Since Linux 3.xx)

I think these aren't very good names for the ioctls.  Maybe something
like
  PERF_EVENT_IOC_MAKE_PERSISTENT
  PERF_EVENT_IOC_UNPERSIST
I know that last one's not a real word but I can't think of what the 
proper term would be.  Maybe
  PERF_EVENT_IOC_RELEASE_PERSISTENT
  PERF_EVENT_IOC_RECLAIM_PERSISTENT

> This is for Linux man-pages:

Thanks, though you're missing out by not learning all about troff 
formatting.

>     type ...
> 
>         PERF_TYPE_PERSISTENT (Since Linux 3.xx)
> 
>             This indicates a persistent event. There is a unique
>             identifier for each persistent event that needs to be
>             specified in the event's attribute config field.
>             Persistent events are listed under:
> 
>               /sys/bus/event_source/devices/persistent/

Wait, so the first time you create a persistent event you do *not*
set type PERF_TYPE_PERSISTENT?  You only do that if you're
"attaching" to an exisiting event?  You might want to clarify that.

>     persistent: (Since Linux 3.xx)
> 
>         Put event into persistent state after opening. After closing
>         the event's fd the event is persistent in the system and
>         continues to run.

will there be some sort of tool that will let you kill runaway persistent 
events?  Or will you have to manually perf_event_open() / iotcl() them
by hand somehow?

>         PERF_EVENT_IOC_DETACH (Since Linux 3.xx)
> 
>             Detach the event specified by the file descriptor from the
>             process and make it persistent in the system. After
>             closing the fd the event will continue to run. An unique
>             identifier for the persistent event is returned or an
>             error otherwise. The following allows to connect to the
>             event again:

You might want to re-order things so it's clear you get the unique ID
at ioctl time and not after the close happens.

>         PERF_EVENT_IOC_ATTACH (Since Linux 3.xx)
> 
>             Attach the event specified by the file descriptor to the
>             current process. The event is no longer persistent in the
>             system and will be removed after all users disconnected
>             from the event. Thus, if there are no other users the
>             event will be closed too after closing its file
>             descriptor, the event then no longer exists.

Vince
