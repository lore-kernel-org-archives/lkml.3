Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937440Ab3DKAP1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 20:15:27 -0400
Received: from mail-ob0-f201.google.com ([209.85.214.201]:34327 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937173Ab3DKAPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 20:15:23 -0400
From: Greg Thelen <gthelen@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] vfs: dcache: cond_resched in shrink_dentry_list
References: <1364232151-23242-1-git-send-email-gthelen@google.com>
	<20130325235614.GI6369@dastard>
	<xr93fvzjgfke.fsf@gthelen.mtv.corp.google.com>
	<20130326024032.GJ6369@dastard>
	<xr934nfyg4ld.fsf@gthelen.mtv.corp.google.com>
	<xr9361zvdxvj.fsf@gthelen.mtv.corp.google.com>
	<20130410164455.a3cbcbdf86bc72455c22f420@linux-foundation.org>
Date: Wed, 10 Apr 2013 17:15:21 -0700
In-Reply-To: <20130410164455.a3cbcbdf86bc72455c22f420@linux-foundation.org>
	(Andrew Morton's message of "Wed, 10 Apr 2013 16:44:55 -0700")
Message-ID: <xr93mwt59b3a.fsf@gthelen.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10 2013, Andrew Morton wrote:

> On Tue, 09 Apr 2013 17:37:20 -0700 Greg Thelen <gthelen@google.com> wrote:
>
>> > Call cond_resched() in shrink_dcache_parent() to maintain
>> > interactivity.
>> >
>> > Before this patch:
>> >
>> > void shrink_dcache_parent(struct dentry * parent)
>> > {
>> > 	while ((found = select_parent(parent, &dispose)) != 0)
>> > 		shrink_dentry_list(&dispose);
>> > }
>> >
>> > select_parent() populates the dispose list with dentries which
>> > shrink_dentry_list() then deletes.  select_parent() carefully uses
>> > need_resched() to avoid doing too much work at once.  But neither
>> > shrink_dcache_parent() nor its called functions call cond_resched().
>> > So once need_resched() is set select_parent() will return single
>> > dentry dispose list which is then deleted by shrink_dentry_list().
>> > This is inefficient when there are a lot of dentry to process.  This
>> > can cause softlockup and hurts interactivity on non preemptable
>> > kernels.
>> >
>> > This change adds cond_resched() in shrink_dcache_parent().  The
>> > benefit of this is that need_resched() is quickly cleared so that
>> > future calls to select_parent() are able to efficiently return a big
>> > batch of dentry.
>> >
>> > These additional cond_resched() do not seem to impact performance, at
>> > least for the workload below.
>> >
>> > Here is a program which can cause soft lockup on a if other system
>> > activity sets need_resched().
>
> I was unable to guess what word was missing from "on a if other" ;)

Less is more ;)  Reword to:

  Here is a program which can cause soft lockup if other system activity
  sets need_resched().

>> Should this change go through Al's or Andrew's branch?
>
> I'll fight him for it.

Thanks.

> Softlockups are fairly serious, so I'll put a cc:stable in there.  Or
> were the changes which triggered this problem added after 3.9?

This also applies to stable.  I see the problem at least back to v3.3.
I did not test earlier kernels, but could if you want.
