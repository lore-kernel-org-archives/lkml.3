Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933727AbaJUVkp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 17:40:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12562 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933458AbaJUVkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 17:40:43 -0400
From: Steve Grubb <sgrubb@redhat.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: Eric Paris <eparis@redhat.com>, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org, pmoore@redhat.com
Subject: Re: [RFC][PATCH] audit: log join and part events to the read-only multicast log socket
Date: Tue, 21 Oct 2014 17:40:43 -0400
Message-ID: <4932303.9AV80g4J8S@x2>
Organization: Red Hat
User-Agent: KMail/4.14.2 (Linux/3.16.6-200.fc20.x86_64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <20141021210511.GL15532@madcap2.tricolour.ca>
References: <30ef5c1ba42b52953e5684a0322975c3f0fadc77.1412706089.git.rgb@redhat.com> <2131923.Byl8GhZuQt@x2> <20141021210511.GL15532@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 21, 2014 05:08:22 PM Richard Guy Briggs wrote:
> On 14/10/21, Steve Grubb wrote:
> > > super crazy yuck.  audit_log_task_info() ??
> > 
> > audit_log_task_info logs too much information for typical use. There are
> > times when you might want to know everything about what's connecting. But
> > in this case, we don't need anything about groups, saved uids, fsuid, or
> > ppid.
> > 
> > Its a shame we don't have a audit_log_task_info_light function which only
> > records:
> > 
> > pid= auid= uid= subj= comm= exe=  ses= tty=
> 
> We already have audit_log_task() which gives:
> 	auid=
> 	uid=
> 	gid=
> 	ses=
> 	subj=
> 	pid=
> 	comm=
> 	exe=
> This is missing tty=, but has gid=.  Can we please use that function
> instead and add tty=?

gid is important for things that might allow access by file permissions. But 
the syscall logging is going to have that and much more. In this case, access 
is granted by having a posix capability. So, all we want is what's the 
process, who's the user, which session/tty is this coming from to find all 
events that might be related.


> And while we are at it, refactor audit_log_task_info() to call
> audit_log_task()?

That will cause problems at this point.

> Is this standard set above what should be used for certain classes of
> log messages?

Its hard to say if that is sufficient for all cases. When access is granted by 
posix capability, sure. This is probably good for most kernel originating 
events. But there are times extra info is needed.

> Yes, it will be in a different order because we don't have a canonical
> order yet.  Can we accept two orders of keywords so we can start
> canonicalizing, please?

I don't understand what you are getting at.

-Steve

> > > > +     audit_log_format(ab, " group=%d", group);
> > > 
> > > group seems like too easily confused a name.
> > 
> > nlnk-grp is better if its what I think it is.
> 
> Where did you find that name?  That could work and it is shorter, but it
> seems awkwardly optimized.  "nlnk" doesn't appear once in the kernel.
> "nl" is already recognized for netlink, "mcgrp" is already used for
> "multicast group(s)", so I would suggest "nl-mcgrp".
> 
> > -Steve
> 
> - RGB
> 
> --
> Richard Guy Briggs <rbriggs@redhat.com>
> Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems,
> Red Hat Remote, Ottawa, Canada
> Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545

