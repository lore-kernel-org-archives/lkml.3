Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339AbaGOP6L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 11:58:11 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:39958 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154AbaGOP6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 11:58:09 -0400
Date: Tue, 15 Jul 2014 11:58:05 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] workqueue: don't grab PENDING bit on some conditions
Message-ID: <20140715155805.GD19570@htj.dyndns.org>
References: <1405416610-12394-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405416610-12394-1-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lai.

On Tue, Jul 15, 2014 at 05:30:10PM +0800, Lai Jiangshan wrote:
> Thread1 expects that, after flush_delayed_work() returns, the known pending
> work is guaranteed finished. But if Thread2 is scheduled a little later than
> Thread1, the known pending work is dequeued and re-queued, it is considered
> as two different works in the workqueue subsystem and the guarantee expected

They are two separate queueing instances of the same work item.

> by Thread1 is broken.

The guarantee expected by thread 1 is that the most recent queueing
instance of the work item is finished either through completing
execution or being cancelled.  No guarantee is broken.

> The guarantee expected by Thread1/workqueue-user is reasonable for me,
> the workqueue subsystem should provide this guarantee. In another aspect,

You're adding a new component to the existing set of guarantees.  You
can argue for it but it's a new guarantee regardless.

> the flush_delayed_work() is still working when mod_delayed_work_on() returns,
> it is more acceptable that the flush_delayed_work() beats the
> mod_delayed_work_on().
>
> It is achieved by introducing a KEEP_FLUSHED flag for try_to_grab_pending().
> If the work is being flushed and KEEP_FLUSHED flags is set,
> we disallow try_to_grab_pending() to grab the pending of the work.
>
> And there is another condition that the user want to speed up a delayed work.
> 
> When the user use "mod_delayed_work_on(..., 0 /* zero delay */);", his
> attention is to accelerate the work and queue the work immediately.
> 
> But the work does be slowed down when it is already queued on the worklist
> due to the work is dequeued and re-queued. So we also disallow
> try_to_grab_pending() to grab the pending of the work in this condition
> by introducing KEEP_QUEUED flag.

Both are extremely marginal.  Do we have any actual cases any of these
matters?  I can't see what we're gaining with the extra complexity.

> @@ -1212,6 +1220,13 @@ static int try_to_grab_pending(struct work_struct *work, bool is_dwork,
>  	 */
>  	pwq = get_work_pwq(work);
>  	if (pwq && pwq->pool == pool) {
> +		if ((keep_flags | KEEP_QUEUED) ||
> +		    ((keep_flags | KEEP_FLUSHED) &&

This can't be right.

Thanks.

-- 
tejun
