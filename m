Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192AbaBCVT7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 16:19:59 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:42230 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbaBCVT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 16:19:58 -0500
Message-ID: <52F007EE.3090500@linux.vnet.ibm.com>
Date: Mon, 03 Feb 2014 13:19:42 -0800
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Michael Ellerman <mpe@ellerman.id.au>,
        Linux PPC <linuxppc-dev@lists.ozlabs.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 1/8] perf: add PMU_RANGE_ATTR() helper for use by sw-like
 pmus
References: <20140201055805.6FF982C00AF@ozlabs.org>
In-Reply-To: <20140201055805.6FF982C00AF@ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14020321-7164-0000-0000-000005AB065E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2014 09:58 PM, Michael Ellerman wrote:
> On Thu, 2014-16-01 at 23:53:47 UTC, Cody P Schafer wrote:
>> Add PMU_RANGE_ATTR() and PMU_RANGE_RESV() (for reserved areas) which
>> generate functions to extract the relevent bits from
>> event->attr.config{,1,2} for use by sw-like pmus where the
>> 'config{,1,2}' values don't map directly to hardware registers.
>
> This is neat.
>
> The split of the macros is a bit weird, ie. PMU_RANGE_RESV() doesn't really do
> what it's name suggests.
>
> I think you want one macro which creates the accessors, with a name that
> reflects that - yeah I can't think of a good one right now, but "event" should
> probably be in there because that's what it operates on.
>
> Having a macro for the reserved regions is good, but you MUST actually check
> that the reserved regions are zero. Otherwise you are permitting your caller to
> pass junk in there and you then can't unreserved them in a future version of
> the API.
>
> So I think a macro that gives you a special reserved region routine would be
> good, so you can write something like:
>
>    if (event_check_reserved1() || event_check_reserved2())
>    	return -EINVAL;
>

The way it's set up right now, RESV is just a hint to the user of the 
PMU_RANGE_ATTR() and PMU_RANGE_RESV() macros to indicate which to use. 
RESV simply avoids creating an attr format which would go unused only in 
the case where the range is a reserved one (and gcc would complain about 
it).

I don't like the "event_check_foo()" bit because that is actually 
identical to "event_get_foo()", I don't see a point in generating 
differently named functions that do exactly the same thing.

The current user (hv-24x7.c) of PMU_RANGE_RESV() already does the 
appropriate checking:

	if (event_get_reserved1(event) ||
	    event_get_reserved2(event) ||
	    event_get_reserved3(event)) {
		pr_devel("reserved set when forbidden 0x%llx(0x%llx) 0x%llx(0x%llx) 
0x%llx(0x%llx)\n",
				event->attr.config,
				event_get_reserved1(event),
				event->attr.config1,
				event_get_reserved2(event),
				event->attr.config2,
				event_get_reserved3(event));
		return -EINVAL;
	}

