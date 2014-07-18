Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935073AbaGRODx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 10:03:53 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:34580 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933454AbaGRODw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 10:03:52 -0400
Date: Fri, 18 Jul 2014 16:03:43 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        "Sahasrabudhe, Sheetal" <sheetals@quicinc.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        jolsa@redhat.com
Subject: Re: perf: child events not killed on release paths, survive
 indefinitely
Message-ID: <20140718140343.GC20603@laptop.programming.kicks-ass.net>
References: <20140718123238.GF25180@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20140718123238.GF25180@leverpostej>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 01:32:39PM +0100, Mark Rutland wrote:
> Hi all,
> 
> Sheetal reported a weird issue on arm where events which have been
> closed seem to stay around and compete for HW counters if an application
> has forked between the events being opened and them being closed.
> 
> I've reproduced this in mainline and linux-next and this seems to be a
> generic issue; the below test case fires on my x86-64 workstation as
> well as on arm and arm64.
> 
> The problem is the way we (don't) handle child events when releasing a
> parent in perf_release and perf_event_release_kernel. We call put_event
> on the parent when it is released, but this will exit early having done
> nothing because each child will have incremented the parent refcount
> when initialised from perf_event_init_task. We don't seem to do anything
> about the children in this case.
> 
> Thus the parent event can't be killed until all the children have first
> been killed. As the only places references to them exist are the
> parent's child_list and their respective tasks' hardware
> perf_event_context, they'll only get killed when their respective tasks
> exit (I confirmed this with some printks in hw_perf_event_destroy and
> put_event). Until that happens they remain in their respective contexts
> and continue to compete for HW counters, adversely affecting events
> opened later.
> 
> I'm not sure what the best way of handling this is. We need to clean up
> the children when the last possible user of the event is gone, but it
> looks to me like we'd need to have a separate child_refcount or
> reader_refcount to be able to tell when the events are still useful and
> when the only references which remain are internal.
> 
> Any ideas?

Jiri was recently poking at that:

lkml.kernel.org/r/1405079782-8139-3-git-send-email-jolsa@kernel.org

