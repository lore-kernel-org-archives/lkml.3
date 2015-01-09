Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932985AbbAIQBJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 11:01:09 -0500
Received: from casper.infradead.org ([85.118.1.10]:53854 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbbAIQBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 11:01:07 -0500
Date: Fri, 9 Jan 2015 17:00:51 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: perf: PERF_FLAG_FD_OUTPUT has been broken since 2.6.35
Message-ID: <20150109160051.GK29390@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.11.1501081014460.24664@vincent-weaver-1.umelst.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1501081014460.24664@vincent-weaver-1.umelst.maine.edu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2015 at 10:22:37AM -0500, Vince Weaver wrote:
> Hello,
> 
> I was working on improving the manpage by working out how the 
> perf_event_open() PERF_FLAG_FD_OUTPUT flag works.
> 
> It turns out it doesn't.
> 
> In kernel/events/core.c when opening a file this is done:
> 
>         if (output_event) {
>            err = perf_event_set_output(event, output_event);
>            if (err)
>               goto err_context;
>         }
> 
> 	and perf_event_set_output() does:
> 
>                 if (output_event->cpu == -1 && output_event->ctx != event->ctx) {
>                    goto out;
>                 }
> 
> 	But event->ctx is always NULL; it does not get set to ctx until
> 	after the call to perf_event_set_output().
> 
> 	It looks like this was broken back in 2.6.35 days with the change:
> 
> 		commit ac9721f3f54b27a16c7e1afb2481e7ee95a70318
> 		Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 		Date:   Thu May 27 12:54:41 2010 +0200
> 
> 		perf_events: Fix races and clean up perf_event and perf_mmap_data interaction
> 
> So is this worth fixing seeing as apparently no one uses this feature?

I think there's a fair argument for removing it, Ingo, Acme?

> As an aside, added error reporting is *really* needed as I had to sprinkle
> all of events/core.c with printk() calls to even begin to understand why
> I was getting the EINVAL result.

Yes, let me see if I can find someone to work on that :/
