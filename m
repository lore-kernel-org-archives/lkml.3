Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761673Ab3EBS3k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 14:29:40 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:62211 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761656Ab3EBS3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 14:29:38 -0400
Date: Thu, 2 May 2013 11:29:33 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: Re: [PATCHSET] blk-throttle: implement proper hierarchy support
Message-ID: <20130502182933.GN19814@mtj.dyndns.org>
References: <1367455189-6957-1-git-send-email-tj@kernel.org>
 <20130502173428.GA4771@redhat.com>
 <20130502175701.GL19814@mtj.dyndns.org>
 <20130502181747.GH30020@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130502181747.GH30020@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Vivek.

On Thu, May 02, 2013 at 02:17:48PM -0400, Vivek Goyal wrote:
> Sorry, did not understand how did you arrive at 15% penalty. I think
> in worst case it will be 50%. Assume size of bio is 1MB. So it will

Oh, that's the number I got by running test.

> wait for 1 second in child group and then it will wait again for
> another second in parent group. Assume next bio gets queued only
> after first bio gets dispatched. 
> 
> That means each 1MB bio will wait for 2 second which will lead to
> effective rate of .5MB/second.

Then the scheduling algorithm is broken in itself regardless of
hierarchy.  That means an issuer which issues at exact the exactly
configured pace gets penalized, right?

> > I don't particularly like doing that as a separate step, maybe we can
> > just push the child's start time to the parent while dispatching?
> > Does that sound doable to you?
> 
> May be. But climbing the ladder has unfairness problems too. We might
> have to rethink about the hierarchical algorithm altogether.

Meh, it's not different from flat case.  It gives workable enough
fairness from the simple fact that the queues at each layer are FIFO.
Beyond that, as long as the limits are honored, it's fine.  If this
thing is going to be used for high-bandwidth applications, it should
probably get reimplemented as per-cpu token distributing hierarchy,
but blk-throttle is not gonna hold back the whole cgroup hierarchy
support.  If you want to reimplement the whole thing, please feel free
to do so afterwards.

Thanks.

-- 
tejun
