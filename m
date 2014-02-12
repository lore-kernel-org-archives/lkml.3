Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534AbaBLPRE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 10:17:04 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:37150 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037AbaBLPRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 10:17:01 -0500
Date: Wed, 12 Feb 2014 10:16:57 -0500
From: Tejun Heo <tj@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Prarit Bhargava <prarit@redhat.com>, linux-edac@vger.kernel.org,
        Doug Thompson <dougthompson@xmission.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] edac, poll timeout cannot be zero
Message-ID: <20140212151657.GL24490@htj.dyndns.org>
References: <1391457913-881-1-git-send-email-prarit@redhat.com>
 <20140212150748.GE5121@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140212150748.GE5121@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Feb 12, 2014 at 04:07:48PM +0100, Borislav Petkov wrote:
> While testing, however, I keep seeing the splat below and that's:
> 
>         if (WARN_ON(!list_empty(&work->entry))) {
>                 spin_unlock(&pwq->pool->lock);
>                 return;
>         }
> 
> and there seems to be some interference with edac_mc_workq_setup()
> which does mod_delayed_work() and then the workqueue callback
> edac_mc_workq_function() which does queue_delayed_work().
> 
> What I'm seeing in the splat is that when the timer fires to run the
> delayed work, __queue_work() complains that the work list is not empty
> even though we've done mod_delayed_work() which is supposed to cancel
> any pending work.
> 
> Tejun, any ideas what's happening? Do we need synchronization here or do
> you have a _sync version of mod_delayed_work() which makes sure any work
> is cancelled?

No, you don't need to.  All workqueue operations should be able to
synchronize with each other.

> Or does this mean that once the work is getting queued from the timer
> callback delayed_work_timer_fn, it cannot be cancelled anymore? Or
> something else I'm missing...?

Looking at edac_mc_workq_setup().... it contains INIT_DELAYED_WORK().
Does this race with other workqueue operations on the work item?  If
so, it of course breaks.  It's like doing spin_lock_init() while other
spinlock operations are in progress.

Thanks.

-- 
tejun
