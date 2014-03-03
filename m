Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151AbaCCJ5B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 04:57:01 -0500
Received: from mga11.intel.com ([192.55.52.93]:63543 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263AbaCCJ46 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 04:56:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,576,1389772800"; 
   d="scan'208";a="491178456"
From: "Du, Yuyang" <yuyang.du@intel.com>
To: Peter Zijlstra <peterz@infradead.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>
CC: Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>
Subject: RE: [RFC] Splitting scheduler into two halves
Thread-Topic: [RFC] Splitting scheduler into two halves
Thread-Index: Ac80Kq2aoa1KkBsvRPK/b91papdg8gAAjwIAAAKik4AAAJY0gACi0ZYw
Date: Mon, 3 Mar 2014 09:56:55 +0000
Message-ID: <0DA73B5D686AEC4AAEF6054BE04DA1CD116CE029@SHSMSX103.ccr.corp.intel.com>
References: <0DA73B5D686AEC4AAEF6054BE04DA1CD116C50EA@SHSMSX102.ccr.corp.intel.com>
 <20140228102932.GI19029@e103034-lin>
 <20140228114459.GM27965@twins.programming.kicks-ass.net>
 <20140228120147.GJ3104@twins.programming.kicks-ass.net>
In-Reply-To: <20140228120147.GJ3104@twins.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, my two cents in response (sorry, I will use a Linux style mail client next time):

1) Top half and bottom half do have interaction with each other. They share information, top half provides some measurement/average to load balance. Good news is they don't interleave operation. Splitting them does not mean they must be self-inclusive to each other.

2) What I have done is a starting point. What really matters is some good design from that starting point. I myself have been working on workload consolidation (or task packing, you name it) for a while. I did have an intent to do a complete bottom half. So, encapsulating the load balance in a class allows it to be replaced easier. But this had already been the last thing I want even if I can do that (before the very first email), because it won't make "a better world".

Lets explore the design space a little bit. For load balance, its function is like:

Tasks -> be balanced -> on CPUs

Be more specific:

[ which_1 ] tasks -> be balanced -> on [ which_2 ] CPUs

Which_1 can be: fair or rt by priority. ARM people may want "small/light" or "big/heavy" by load tracking (fortunately, we don't need that). Maybe others.

Which_2 can be: all, or some.

Which_1 * which_2 have many combinations, each of which has this in common: XX tasks -> be balanced -> on YY CPUs (XX defined by bottom half but got from top half, the other done by bottom half).

So it looks like we need a class, and we need a few implementations (each for a combination) in a *hierarchy* and work together.

I don't have the final answer yet, this is why I said I am continuing to redesign and refactor it. But it really looks that modularity should/can be applied here to help realize so complex a system.

Thanks,
Yuyang
