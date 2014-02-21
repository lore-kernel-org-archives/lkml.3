Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581AbaBUNGb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:06:31 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:43181 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754655AbaBUNG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 08:06:26 -0500
Date: Fri, 21 Feb 2014 08:06:14 -0500
From: Tejun Heo <tj@kernel.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net, Chris Boot <bootc@bootc.net>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH 4/9] firewire: don't use PREPARE_DELAYED_WORK
Message-ID: <20140221130614.GH6897@htj.dyndns.org>
References: <1392929071-16555-1-git-send-email-tj@kernel.org>
 <1392929071-16555-5-git-send-email-tj@kernel.org>
 <5306AF8E.3080006@hurleysoftware.com>
 <20140221015935.GF6897@htj.dyndns.org>
 <5306B4DF.4000901@hurleysoftware.com>
 <20140221021341.GG6897@htj.dyndns.org>
 <5306E06C.5020805@hurleysoftware.com>
 <20140221100301.GA14653@mtj.dyndns.org>
 <53074BE4.1020307@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53074BE4.1020307@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Feb 21, 2014 at 07:51:48AM -0500, Peter Hurley wrote:
> I think the vast majority of kernel code which uses the workqueue
> assumes there is a memory ordering guarantee.

Not really.  Workqueues haven't even guaranteed non-reentrancy until
recently, forcing everybody to lock explicitly in the work function.
I don't think there'd be many, if any, use cases which depend on
ordering guarantee on duplicate queueing.

> Another way to look at this problem is that process_one_work()
> doesn't become the existing instance _until_ PENDING is cleared.

Sure, having that guarantee definitely is nicer and all we need seems
to be mb_after_unlock in the execution path.  Please feel free to
submit a patch.

> >add such guarantee, not sure how much it'd matter but it's not like
> >it's gonna cost a lot either.
> >
> >This doesn't have much to do with the current series tho.  In fact,
> >PREPARE_WORK can't ever be made to give such guarantee.
> 
> Yes, I agree that PREPARE_DELAYED_WORK was also broken usage with the
> same problem. [And there are other bugs in that firewire device work
> code which I'm working on.]
> 
> >The function pointer has to fetched before clearing of PENDING.
> 
> Why?
> 
> As long as the load takes place within the pool->lock, I don't think
> it matters (especially now PREPARE_WORK is removed).

Hmmm... I was talking about PREPARE_WORK().  Clearing PENDING means
that the work item is released from the worker context and may be
freed or reused at any time (hmm... this may not be true anymore as
non-syncing variants of cancel_work are gone), so clearing PENDING
should be the last access to the work item and thus we can't use that
as the barrier event for fetching its work function.

Thanks.

-- 
tejun
