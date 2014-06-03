Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933157AbaFCQ2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 12:28:50 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:35517 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932469AbaFCQ2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 12:28:48 -0400
Date: Tue, 3 Jun 2014 12:28:44 -0400
From: Tejun Heo <tj@kernel.org>
To: Paolo Valente <paolo.valente@unimore.it>
Cc: Jens Axboe <axboe@kernel.dk>, Li Zefan <lizefan@huawei.com>,
        Fabio Checconi <fchecconi@gmail.com>,
        Arianna Avanzini <avanzini.arianna@gmail.com>,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org,
        Mauro Andreolini <mauro.andreolini@unimore.it>
Subject: Re: [PATCH RFC - TAKE TWO - 10/12] block, bfq: add Early Queue Merge
 (EQM)
Message-ID: <20140603162844.GD26210@htj.dyndns.org>
References: <20140528221929.GG1419@htj.dyndns.org>
 <1401354343-5527-1-git-send-email-paolo.valente@unimore.it>
 <1401354343-5527-11-git-send-email-paolo.valente@unimore.it>
 <20140601000331.GA29085@htj.dyndns.org>
 <3B7B1A46-46EB-4C52-A52C-4F79C71D14C2@unimore.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3B7B1A46-46EB-4C52-A52C-4F79C71D14C2@unimore.it>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Jun 02, 2014 at 11:46:45AM +0200, Paolo Valente wrote:
> > I don't really follow the last part.  So, the difference is that
> > cooperating queue setup also takes place during bio merge too, right?
> 
> Not only, in bfq an actual queue merge is performed in the bio-merge hook.

I think I'm a bit confused because it's named "early" queue merge
while it actually moves queue merging later than cfq - set_request()
happens before bio/rq merging.  So, what it tries to do is
compensating for the lack of cfq_rq_close() preemption at request
issue time, right?

> > cfq does it once when allocating the request.  That seems a lot more
> > reasonable to me.  It's doing that once for one start sector.  I mean,
> > plugging is usually extremely short compared to actual IO service
> > time.  It's there to mask the latencies between bio issues that the
> > same CPU is doing.  I can't see how this earliness can be actually
> > useful.  Do you have results to back this one up?  Or is this just
> > born out of thin air?
> 
> Arianna added the early-queue-merge part in the allow_merge_fn hook
> about one year ago, as a a consequence of a throughput loss of about
> 30% with KVM/QEMU workloads. In particular, we ran most of the tests
> on a WDC WD60000HLHX-0 Velociraptor. That HDD might not be available
> for testing any more, but we can reproduce our results for you on
> other HDDs, with and without early queue merge. And, maybe through
> traces, we can show you that the reason for the throughput loss is
> exactly that described (in a wordy way) in this patch. Of course
> unless we have missed something.

Oh, as long as it makes measureable difference, I have no objection;
however, I do think more explanation and comments would be nice.  I
still can't quite understand why retrying on each merge attempt would
make so much difference.  Maybe I just failed to understand what you
wrote in the commit message.  Is it because the cooperating tasks
issue IOs which grow large and close enough after merges but not on
the first bio issuance?  If so, why isn't doing it on rq merge time
enough?  Is the timing sensitive enough for certain workloads that
waiting till unplug time misses the opportunity?  But plugging should
be relatively short compared to the time actual IOs take, so why would
it be that sensitive?  What am I missing here?

Thanks.

-- 
tejun
