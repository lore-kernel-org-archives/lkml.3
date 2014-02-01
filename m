Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933181AbaBAF6r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 00:58:47 -0500
Received: from ozlabs.org ([203.10.76.45]:41623 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821AbaBAF6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 00:58:07 -0500
In-Reply-To: <1389916434-2288-2-git-send-email-cody@linux.vnet.ibm.com>
To: Cody P Schafer <cody@linux.vnet.ibm.com>,
        Linux PPC <linuxppc-dev@lists.ozlabs.org>
From: Michael Ellerman <mpe@ellerman.id.au>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/8] perf: add PMU_RANGE_ATTR() helper for use by sw-like pmus
Message-Id: <20140201055805.6FF982C00AF@ozlabs.org>
Date: Sat,  1 Feb 2014 16:58:05 +1100 (EST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-16-01 at 23:53:47 UTC, Cody P Schafer wrote:
> Add PMU_RANGE_ATTR() and PMU_RANGE_RESV() (for reserved areas) which
> generate functions to extract the relevent bits from
> event->attr.config{,1,2} for use by sw-like pmus where the
> 'config{,1,2}' values don't map directly to hardware registers.

This is neat.

The split of the macros is a bit weird, ie. PMU_RANGE_RESV() doesn't really do
what it's name suggests.

I think you want one macro which creates the accessors, with a name that
reflects that - yeah I can't think of a good one right now, but "event" should
probably be in there because that's what it operates on.

Having a macro for the reserved regions is good, but you MUST actually check
that the reserved regions are zero. Otherwise you are permitting your caller to
pass junk in there and you then can't unreserved them in a future version of
the API.

So I think a macro that gives you a special reserved region routine would be
good, so you can write something like:

  if (event_check_reserved1() || event_check_reserved2())
  	return -EINVAL;


cheers
