Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751635AbaDYOwK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 10:52:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:42771 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbaDYOwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 10:52:08 -0400
Date: Fri, 25 Apr 2014 16:52:05 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <rric@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>, Borislav Petkov <bp@alien8.de>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 04/16] perf, mmap: Factor out perf_get_fd()
Message-ID: <20140425145205.GV13658@twins.programming.kicks-ass.net>
References: <1396883078-25320-1-git-send-email-jean.pihet@linaro.org>
 <1396883078-25320-5-git-send-email-jean.pihet@linaro.org>
 <20140422142759.GM11182@twins.programming.kicks-ass.net>
 <20140425135413.GE32718@rric.localhost>
 <20140425144301.GI11096@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140425144301.GI11096@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 04:43:01PM +0200, Peter Zijlstra wrote:
> On Fri, Apr 25, 2014 at 03:54:13PM +0200, Robert Richter wrote:
> > I guess its this patch from Al you referring to:
> > 
> >  ea635c6 Fix racy use of anon_inode_getfd() in perf_event.c
> > 
> > I think we do not introduce it back due to:
> > 
> >  a6fa941 perf_event: Switch to internal refcount, fix race with close()
> > 
> > which removes the user of event_file.
> 
> linux-2.6# git show a6fa941
> error: short SHA1 a6fa941 is ambiguous.
> error: short SHA1 a6fa941 is ambiguous.
> fatal: ambiguous argument 'a6fa941': unknown revision or path not in the working tree.
> 
> Which is I think why Linus makes us use 12 chars instead of the git
> default of 8.
> 
> Of course its also entirely useless of git to not list the full IDs for
> those it did find to be ambiguous.

ok, so its a6fa941d94b4.

But no, I don't think that helps, its still true that the moment you get
a fd another thread can immediately close(). That would drop the last
ref and free it, meanwhile perf_event_open() is happily poking at it.

Now I think you could cure this by adding an extra ref before calling
your perf_get_fd() and dropping that extra ref at the end, where we used
to have fd_install().
