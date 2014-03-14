Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbaCNNlA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 09:41:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26768 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754171AbaCNNk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 09:40:59 -0400
Date: Fri, 14 Mar 2014 09:40:57 -0400
From: Don Zickus <dzickus@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, jmario@redhat.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf: Speed up thread map generation
Message-ID: <20140314134057.GZ25953@redhat.com>
References: <1394745397-96149-1-git-send-email-dzickus@redhat.com>
 <20140314131734.GB5276@krava.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140314131734.GB5276@krava.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 02:17:35PM +0100, Jiri Olsa wrote:
> On Thu, Mar 13, 2014 at 05:16:37PM -0400, Don Zickus wrote:
> 
> SNIP
> 
> > +	event->fork.ptid = tgid;
> > +	event->fork.pid  = tgid;
> > +	event->fork.tid  = pid;
> > +	event->fork.header.type = PERF_RECORD_FORK;
> > +
> > +	event->fork.header.size = (sizeof(event->fork) + machine->id_hdr_size);
> > +
> > +	if (process(tool, event, &synth_sample, machine) != 0)
> > +		return -1;
> > +
> > +	return 0;
> > +}
> > +
> >  int perf_event__synthesize_mmap_events(struct perf_tool *tool,
> >  				       union perf_event *event,
> >  				       pid_t pid, pid_t tgid,
> > @@ -287,6 +309,11 @@ static int __event__synthesize_thread(union perf_event *comm_event,
> >  	DIR *tasks;
> >  	struct dirent dirent, *next;
> >  	pid_t tgid;
> > +	union perf_event *fork_event;
> > +
> > +	fork_event = malloc(sizeof(fork_event->fork) + machine->id_hdr_size);
> > +	if (fork_event == NULL)
> > +		return -1;
> 
> need to be freed

Doh.

> 
> maybe we could move the allocation one level up,
> same as for mmap_event and comm_event

I thought about that too, just seemed silly to pass that through the
function params.  Not sure if there are different mallocs from the callers.

I'll respin the patch with this though.

> 
> otherwise I think the logic with FORK event is correct

Great!

Cheers,
Don
