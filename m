Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898AbaFYWzR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 18:55:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22974 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756779AbaFYWzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 18:55:13 -0400
Date: Wed, 25 Jun 2014 18:54:52 -0400
From: Rafael Aquini <aquini@redhat.com>
To: Motohiro Kosaki <Motohiro.Kosaki@us.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Motohiro Kosaki JP <kosaki.motohiro@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: export NR_SHMEM via sysinfo(2) / si_meminfo()
 interfaces
Message-ID: <20140625225451.GB1534@t510.redhat.com>
References: <4b46c5b21263c446923caf3da3f0dca6febc7b55.1403709665.git.aquini@redhat.com>
 <6B2BA408B38BA1478B473C31C3D2074E341D585464@SV-EXCHANGE1.Corp.FC.LOCAL>
 <20140625201603.GA1534@t510.redhat.com>
 <6B2BA408B38BA1478B473C31C3D2074E341D585503@SV-EXCHANGE1.Corp.FC.LOCAL>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6B2BA408B38BA1478B473C31C3D2074E341D585503@SV-EXCHANGE1.Corp.FC.LOCAL>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 01:27:53PM -0700, Motohiro Kosaki wrote:
> 
> 
> > -----Original Message-----
> > From: Rafael Aquini [mailto:aquini@redhat.com]
> > Sent: Wednesday, June 25, 2014 4:16 PM
> > To: Motohiro Kosaki
> > Cc: linux-mm@kvack.org; Andrew Morton; Rik van Riel; Mel Gorman; Johannes Weiner; Motohiro Kosaki JP; linux-
> > kernel@vger.kernel.org
> > Subject: Re: [PATCH] mm: export NR_SHMEM via sysinfo(2) / si_meminfo() interfaces
> > 
> > On Wed, Jun 25, 2014 at 12:41:17PM -0700, Motohiro Kosaki wrote:
> > >
> > >
> > > > -----Original Message-----
> > > > From: Rafael Aquini [mailto:aquini@redhat.com]
> > > > Sent: Wednesday, June 25, 2014 2:40 PM
> > > > To: linux-mm@kvack.org
> > > > Cc: Andrew Morton; Rik van Riel; Mel Gorman; Johannes Weiner;
> > > > Motohiro Kosaki JP; linux-kernel@vger.kernel.org
> > > > Subject: [PATCH] mm: export NR_SHMEM via sysinfo(2) / si_meminfo()
> > > > interfaces
> > > >
> > > > This patch leverages the addition of explicit accounting for pages
> > > > used by shmem/tmpfs -- "4b02108 mm: oom analysis: add shmem vmstat"
> > > > -- in order to make the users of sysinfo(2) and si_meminfo*() friends aware of that vmstat entry consistently across the interfaces.
> > >
> > > Why?
> > 
> > Because we do not report consistently across the interfaces we declare exporting that data. Check sysinfo(2) manpage, for instance:
> > [...]
> >            struct sysinfo {
> >                long uptime;             /* Seconds since boot */
> >                unsigned long loads[3];  /* 1, 5, and 15 minute load averages */
> >                unsigned long totalram;  /* Total usable main memory size */
> >                unsigned long freeram;   /* Available memory size */
> >                unsigned long sharedram; /* Amount of shared memory */ <<<<< [...]
> > 
> > userspace tools resorting to sysinfo() syscall will get a hardcoded 0 for shared memory which is reported differently from
> > /proc/meminfo.
> > 
> > Also, si_meminfo() & si_meminfo_node() are utilized within the kernel to gather statistics for /proc/meminfo & friends, and so we
> > can leverage collecting sharedmem from those calls as well, just as we do for totalram, freeram & bufferram.
> 
> But "Amount of shared memory"  didn't mean amout of shmem. It actually meant amout of page of page-count>=2.
> Again, there is a possibility to change the semantics. But I don't have enough userland knowledge to do. Please investigate
> and explain why your change don't break any userland. 

I agree that reporting the amount of shared pages in that historically fashion 
might not be interesting for userspace tools resorting to sysinfo(2),
nowadays.

OTOH, our documentation implies we do return shared memory there, and FWIW,
considering the other places we do export the "shared memory" concept to 
userspace nowadays, we are suggesting it's the amount of tmpfs/shmem, and not the
amount of shared mapped pages it historiacally represented once. What is really
confusing is having a field that supposedely/expectedely would return the amount
of shmem to userspace queries, but instead returns a hard-coded zero (0).

I could easily find out that there were some user complaint/confusion on this 
semantic inconsistency in the past, as in:
https://groups.google.com/forum/#!topic/comp.os.linux.development.system/ogWVn6XdvGA

or in:
http://marc.info/?l=net-snmp-cvs&m=132148788500667

which suggests users seem to always have understood it as being shmem/tmpfs
usage, as the /proc/meminfo field "MemShared" was tied direclty to
sysinfo.sharedram. Historically we reported shared memory that way, and
when it wasn't accurately meaning that anymore a 0 was hardcoded there to
potentially not break compatibility with older tools (older than 2.4).
In 2.6 we got rid of meminfo's "MemShared" until 2009, when you sort of
re-introduced it re-branded as Shmem. IMO, we should leverage what we 
have in kernel now and take this change to make the exposed data consistent 
across the interfaces that export it today -- sysinfo(2) & /proc/meminfo.

This is not a hard requirement, though, but rather a simple maintenance
nitpick from code review. 

Regards,
-- Rafael
