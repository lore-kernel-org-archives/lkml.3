Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbaI2Qsl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 12:48:41 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:41886 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182AbaI2Qsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 12:48:40 -0400
Date: Mon, 29 Sep 2014 18:48:36 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Tightening up rdpmc permissions?
Message-ID: <20140929164836.GP5430@worktop>
References: <CALCETrU3nNvG6+-7iScYT8LDRFnq8kYnpK0cdW1bgW5O4EGrUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrU3nNvG6+-7iScYT8LDRFnq8kYnpK0cdW1bgW5O4EGrUg@mail.gmail.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 09:39:16AM -0700, Andy Lutomirski wrote:
> I was surprised to notice that, by default, every task has permission
> to use rdpmc. 

Right, we figured the paranoid would poke at
/sys/bus/event_source/devices/cpu/rdpmc.

> seccomp cannot work around this. 

I know nothing much about seccomp.

> This leaks information, although the information leaked is of dubious
> and variable value to an attacker.  It also renders the PR_TSC_SEGV
> mechanism mostly useless.

I'm not seeing how, there's no saying what will run on those counters,
let alone if its correlated to the TSC. But yes I appreciate the
argument.

> Would it make sense to restrict rdpmc to tasks that are in mms that
> have a perf_event mapping? 

We could,

> After all, unless I misunderstand
> something, user code can't reliably use rdpmc unless they've mapped a
> perf_event object to check the rdpmc bit and figure out what ecx value
> to use.

correct,

> I think that this could be implemented with very little overhead,
> especially if combined with the existing CR4_TSD code and if that code
> were taught to avoid reading cr4.

but there's a definite cost to having to write cr4 on every context
switch. It would be better if we could put it under TIF_NOTSC or
something similar and only be effective when something like seccomp or
other thingy is present and enabled. We should definitely avoid a double
cr4 write in case of both rdpmc and tsc switch.
