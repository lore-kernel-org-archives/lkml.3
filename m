Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbaB0Wzu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 17:55:50 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:34042 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbaB0Wzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 17:55:48 -0500
Date: Thu, 27 Feb 2014 14:55:45 -0800
From: josh@joshtriplett.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Rashika Kheria <rashika.kheria@gmail.com>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 08/46] kernel: MOve prototype declaration to header
 file include/linux/perf_event.h
Message-ID: <20140227225545.GC30335@cloud>
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
 <137eb91c7ce020384a1fb967c1c8b7eaeded21d8.1393493276.git.rashika.kheria@gmail.com>
 <20140227115414.GD9987@twins.programming.kicks-ass.net>
 <20140227155149.GB26756@thin>
 <20140227192335.GZ27965@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140227192335.GZ27965@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 08:23:35PM +0100, Peter Zijlstra wrote:
> On Thu, Feb 27, 2014 at 07:51:50AM -0800, Josh Triplett wrote:
> > On Thu, Feb 27, 2014 at 12:54:14PM +0100, Peter Zijlstra wrote:
> > > On Thu, Feb 27, 2014 at 05:02:48PM +0530, Rashika Kheria wrote:
> > > > Add prototype declaration of function to header file
> > > > include/linux/perf_event.h because it is used by more than one file.
> > > > 
> > > > This eliminates the following warning in kernel/events/core.c:
> > > > kernel/events/core.c:3743:13: warning: no previous prototype for ‘arch_perf_update_userpage’ [-Wmissing-prototypes]
> > > 
> > > # git grep arch_perf_update_userpage
> > > arch/x86/kernel/cpu/perf_event.c:void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
> > > kernel/events/core.c:void __weak arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
> > > kernel/events/core.c:   arch_perf_update_userpage(userpg, now);
> > > 
> > > 
> > > There's two definitions; one weak, and one usage site.
> > > 
> > > What gives?
> > 
> > There's no prototype for the function anywhere, so -Wmissing-prototypes
> > rightfully complains.  Adding the prototype to a header included in both
> > source files ensures that the function signatures must match, and
> > eliminates the warning.
> 
> Definitions don't require prior declarations. Only usage without prior
> definitions require them.
> 
> I still don't see a problem.

There's value in -Wmissing-prototypes; it's equivalent to the Sparse
check that ensures functions are marked as static when they're not used
outside the file they're defined in (though unlike the Sparse check it
only applies to functions, not data).  The goal isn't "make the warning
go away"; the goal of passing -Wmissing-prototypes is:

- Get rid of unused functions (many of which have been caught by this
  effort).
- Mark functions as static where possible (which enables the above and
  also improves code generation).
- Include headers that declare functions in the source files that define
  them, not just in the source files that use them.  That keeps the
  declaration and definition in sync (which has caught some real bugs as
  part of this effort).
- When no such header exists for a function used across multiple files,
  add the prototype to an appropriate header and use that.  Again, this
  has caught real bugs as part of this effort, when the definition and
  use were out of sync.  (For instance, disagreeing in return type.)
