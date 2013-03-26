Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933794Ab3CZAp6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 20:45:58 -0400
Received: from mail-ye0-f202.google.com ([209.85.213.202]:52968 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933748Ab3CZAp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 20:45:57 -0400
From: Greg Thelen <gthelen@google.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfs: dcache: cond_resched in shrink_dentry_list
References: <1364232151-23242-1-git-send-email-gthelen@google.com>
	<20130325235614.GI6369@dastard>
Date: Mon, 25 Mar 2013 17:39:13 -0700
In-Reply-To: <20130325235614.GI6369@dastard> (Dave Chinner's message of "Tue,
	26 Mar 2013 10:56:14 +1100")
Message-ID: <xr93fvzjgfke.fsf@gthelen.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 25 2013, Dave Chinner wrote:

> On Mon, Mar 25, 2013 at 10:22:31AM -0700, Greg Thelen wrote:
>> Call cond_resched() from shrink_dentry_list() to preserve
>> shrink_dcache_parent() interactivity.
>> 
>> void shrink_dcache_parent(struct dentry * parent)
>> {
>> 	while ((found = select_parent(parent, &dispose)) != 0)
>> 		shrink_dentry_list(&dispose);
>> }
>> 
>> select_parent() populates the dispose list with dentries which
>> shrink_dentry_list() then deletes.  select_parent() carefully uses
>> need_resched() to avoid doing too much work at once.  But neither
>> shrink_dcache_parent() nor its called functions call cond_resched().
>> So once need_resched() is set select_parent() will return single
>> dentry dispose list which is then deleted by shrink_dentry_list().
>> This is inefficient when there are a lot of dentry to process.  This
>> can cause softlockup and hurts interactivity on non preemptable
>> kernels.
>
> Hi Greg,
>
> I can see how this coul dcause problems, but isn't the problem then
> that shrink_dcache_parent()/select_parent() itself is mishandling
> the need for rescheduling rather than being a problem with
> the shrink_dentry_list() implementation?  i.e. select_parent() is
> aborting batching based on a need for rescheduling, but then not
> doing that itself and assuming that someone else will do the
> reschedule for it?
>
> Perhaps this is a better approach:
>
> -	while ((found = select_parent(parent, &dispose)) != 0)
> +	while ((found = select_parent(parent, &dispose)) != 0) {
>                 shrink_dentry_list(&dispose);
> +		cond_resched();
> +	}
>
> With this, select_parent() stops batching when a resched is needed,
> we dispose of the list as a single batch and only then resched if it
> was needed before we go and grab the next batch. That should fix the
> "small batch" problem without the potential for changing the
> shrink_dentry_list() behaviour adversely for other users....

I considered only modifying shrink_dcache_parent() as you show above.
Either approach fixes the problem I've seen.  My initial approach adds
cond_resched() deeper into shrink_dentry_list() because I thought that
there might a secondary benefit: shrink_dentry_list() would be willing
to give up the processor when working on a huge number of dentry.  This
could improve interactivity during shrinker and umount.  I don't feel
strongly on this and would be willing to test and post the
add-cond_resched-to-shrink_dcache_parent approach.
