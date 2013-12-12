Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020Ab3LLUt5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 15:49:57 -0500
Received: from relay3.sgi.com ([192.48.152.1]:44659 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751554Ab3LLUty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 15:49:54 -0500
Date: Thu, 12 Dec 2013 14:49:50 -0600
From: Alex Thorlton <athorlton@sgi.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rik van Riel <riel@redhat.com>, Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, Michel Lespinasse <walken@google.com>,
        Benjamin LaHaise <bcrl@kvack.org>, Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        David Rientjes <rientjes@google.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Jiang Liu <jiang.liu@huawei.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Glauber Costa <glommer@parallels.com>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 2/3] Add tunable to control THP behavior
Message-ID: <20131212204950.GA6034@sgi.com>
References: <cover.1386790423.git.athorlton@sgi.com>
 <20131212180050.GC134240@sgi.com>
 <CALCETrWfFRhjuoK8T9G8hecxsRxFPQ+qA0x7azoof1X5tuxruA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWfFRhjuoK8T9G8hecxsRxFPQ+qA0x7azoof1X5tuxruA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Is there a setting that will turn off the must-be-the-same-node
> behavior?  There are workloads where TLB matters more than cross-node
> traffic (or where all the pages are hopelessly shared between nodes,
> but hugepages are still useful).

That's pretty much how THPs already behave in the kernel, so if you want
to allow THPs to be handed out to one node, but referenced from many
others, you'd just set the threshold to 1, and let the existing code
take over.

As for the must-be-the-same-node behavior:  I'd actually say it's more
like a "must have so much on one node" behavior, in that, if you set the
threshold to 16, for example, 16 4K pages must be faulted in on the same
node, in the same contiguous 2M chunk, before a THP will be created.
What happens after that THP is created is out of our control, it could
be referenced from anywhere.

The idea here is that we can tune things so that jobs that behave poorly
with THP on will not be given THPs, but the jobs that like THPs can
still get them.  Granted, there are still issues with this approach, but
I think it's a bit better than just handing out a THP because we touched
one byte in a 2M chunk.

- Alex
