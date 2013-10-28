Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926Ab3J1I5s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 04:57:48 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43607 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750998Ab3J1I5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 04:57:47 -0400
Date: Mon, 28 Oct 2013 08:57:00 +0000
From: Will Deacon <will.deacon@arm.com>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: perf: PERF_EVENT_IOC_PERIOD on ARM vs everywhere else
Message-ID: <20131028085700.GB20218@mudshark.cambridge.arm.com>
References: <alpine.DEB.2.10.1310272233120.12721@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1310272233120.12721@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 02:37:46AM +0000, Vince Weaver wrote:
> Hello

Hi Vince,

> it was pointed out to me that in the 3.7 kernel (more specifically,
> 3581fe0ef37ce12ac7a4f74831168352ae848edc ) a change was made in the
> ARM architecture to change how PERF_EVENT_IOC_PERIOD is handled.
> 
> Unlike other architectures, post-3.7 ARM updates the period right away 
> rather than waiting until the next overflow.
> 
> I can't find any discussion as to why this change was made.

This was in response to complaints from both internal users and people on
public lists:

  http://www.mail-archive.com/perfmon2-devel@lists.sourceforge.net/msg02657.html

I believe the scenario was something like:

 (1) An instruction counter is set up to overflow after 200 instructions,
     with a SIGIO handler to print some information. It is initially
     disabled.

 (2) At some point, the counter is enabled for 1 overflow (IOC_REFRESH)

 (3) The counter eventually overflows and the SIGIO handler is triggered.
     At this pointer the counter is disabled.

 (4) The signal handler changes the period to 200k instructions using
     IOC_PERIOD and enables the counter for a further overflow.

 (5) SIGIO is taken after 200 instructions, rather than 200k.

> Should other architectures be updated to?  I just wanted to find out the 
> rationale for this before I update the manpage to reflect the difference 
> in behaviors between architectures.

I don't want to be the `oddball' architecture (at least, not more than I am
already :), but I do find it tricky to follow the required semantics of perf
as opposed to `it happens to work this way', especially when so much of it
is buried in the various arch backends. So if somebody using the thing on
ARM has (what looks to me like) a valid issue, then I usually try and fix
it.

Cheers,

Will
