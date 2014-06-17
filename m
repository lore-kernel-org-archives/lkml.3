Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964844AbaFQT4L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 15:56:11 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:34839 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756130AbaFQT4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 15:56:09 -0400
Date: Tue, 17 Jun 2014 14:55:10 -0500
From: Jack Miller <millerjo@us.ibm.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Milton Miller II <miltonm@us.ibm.com>, anton@au1.ibm.com
Subject: Re: [RESEND] shm: shm exit scalability fixes
Message-ID: <20140617195510.GA22266@toadite.austin.ibm.com>
References: <1403026067-14272-1-git-send-email-millerjo@us.ibm.com>
 <1403027312.2464.5.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403027312.2464.5.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061719-6688-0000-0000-000002A103EF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 10:48:32AM -0700, Davidlohr Bueso wrote:
> On Tue, 2014-06-17 at 12:27 -0500, Jack Miller wrote:
> > [ RESEND note: Adding relevant CCs, fixed a couple of typos in commit message,
> > patches unchanged. Original intro follows. ]
> > 
> > All -
> > 
> > This is small set of patches our team has had kicking around for a few versions
> > internally that fixes tasks getting hung on shm_exit when there are many
> > threads hammering it at once.
> > 
> > Anton wrote a simple test to cause the issue:
> > 
> > http://ozlabs.org/~anton/junkcode/bust_shm_exit.c
> 
> I'm actually in the process of adding shm microbenchmarks to perf-bench
> so I might steal this :-)
>

Cool!

> > 
> > Before applying this patchset, this test code will cause either hanging
> > tracebacks or pthread out of memory errors.
> 
> Are you seeing this issue in any real world setups? While the program
> does stress the path you mention quite well, I fear it is very
> unrealistic... how many shared mem segments do real applications
> actually use/create for scaling issues to appear?

We've seen this while running multiple workloads on the same machine. One
workload that used shared memory extensively, and one that created many
shortlived threads. The testcase is just simulating these two workloads
running simultaneously, so I don't think it's too unreasonable to expect it
could happen in the wild.

Even if this is synthetic, the testcase could also be seen as proof of an
unprivileged denial of service as an arbitrary user could run bust_shm_exit
and subsequently start overloading the system.

> 
> I normally wouldn't mind optimizing synthetic cases like this, but a
> quick look at patch 1/3 shows that we're adding an extra overhead (16
> bytes) in the task_struct.

Yeah, that's definitely not to be done lightly, but I think it's worth it to
make the work on exit proportional to the actual task usage instead of the
number of segments in the namespace.

> 
> In any case, I will take a closer look at the set.

Thanks! I'd appreciate any feedback.

- Jack

