Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761723Ab3EBTHo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 15:07:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41104 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761688Ab3EBTHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 15:07:43 -0400
Date: Thu, 2 May 2013 15:07:32 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: Re: [PATCHSET] blk-throttle: implement proper hierarchy support
Message-ID: <20130502190732.GK30020@redhat.com>
References: <1367455189-6957-1-git-send-email-tj@kernel.org>
 <20130502173428.GA4771@redhat.com>
 <20130502175701.GL19814@mtj.dyndns.org>
 <20130502181747.GH30020@redhat.com>
 <20130502182933.GN19814@mtj.dyndns.org>
 <20130502184514.GI30020@redhat.com>
 <20130502184953.GP19814@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130502184953.GP19814@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 02, 2013 at 11:49:53AM -0700, Tejun Heo wrote:
> Hello,
> 
> On Thu, May 02, 2013 at 02:45:14PM -0400, Vivek Goyal wrote:
> > I did not understand this point. In flat model, application issuing
> > at configured page will not get penalized.
> > 
> > This penalty is coming from the fact that we are moving bios after the
> > wait and make them wait in another queue.
> > 
> > In flat model there is no such problem. So to me, it is the problem
> > of how hierarchical scheduling is implemented. In flat model, I did
> > not have to deal with it.
> 
> But seen from the parent, the child isn't different from any other
> issuer in flat hierarchy.  It's just being repeated, so if you assume
> a process which behaves in the exact same manner, that process would
> get penalized too.  e.g. imagine an application which throttles itself
> and issues exactly 1MB/s amount of data in direct IO.  It'd get
> penalized the same way, right?

It should not. Why do you think in flat model an application which
throttles itself will be penalized.

So application issue an bio of size 1MB in a group of rate 1MB/s. bio
gets queued and gets dispatched after 1 second. Almost immediately next
bio will come from application (as application also is throttling 
itself at 1MB/s rate). And then this bio waits for a second. So we
almost get steady rate of 1MB/s as configured.

Sorry, I am not able uderstand the problem here.

> 
> > Ok. Not having a perfect algorithm now is fine. We can always redo it
> > later.
> 
> I think we can do source-based RR on bio_lists[] fetching which is
> simple enough and should be able to avoid most of the problems, right?

Yes, maintaining per child/source bio_lists[] in parent and doing round
robin there should mitigate the fairness problem to a great extent.

Thanks
Vivek
