Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935600AbaDJOUK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 10:20:10 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:58189 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934295AbaDJOUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 10:20:06 -0400
Date: Thu, 10 Apr 2014 10:19:57 -0400
From: Tejun Heo <tj@kernel.org>
To: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, gregkh@linuxfoundation.org,
        rlove@rlove.org, containers@lists.linux-foundation.org, kay@vrfy.org,
        linux-kernel@vger.kernel.org, lennart@poettering.net,
        cgroups@vger.kernel.org, eparis@parisplace.org, john@johnmccutchan.com
Subject: Re: [PATCH 3/3] cgroup: implement cgroup.subtree_populated for the
 default hierarchy
Message-ID: <20140410141957.GE25308@htj.dyndns.org>
References: <1397056052-2829-1-git-send-email-tj@kernel.org>
 <1397056052-2829-4-git-send-email-tj@kernel.org>
 <20140410030855.GA29658@mail.hallyn.com>
 <20140410130831.GA25308@htj.dyndns.org>
 <20140410140424.GA4481@sergelap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140410140424.GA4481@sergelap>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Apr 10, 2014 at 09:04:24AM -0500, Serge Hallyn wrote:
> Except for the keeping state.  If the userspace agent crashes when it
> was meant to drop 100 cgroups when they become empty, then when it
> restarts those 100 cgroups may never be freed.  Of course userspace
> can do things about this, but it just seems like it would be so
> trivial to handle this case in the kernel.  Like you say there is

But it's also trivial from userland.  You can write up a separate
backup agent or just make the main agent perform cleanup on restart,
which it should probably be doing anyway.

> no need for all the fancy agent spawning - just notice that the
> cgroup became empty, that releaseonempty was true, and so unlink the
> thing.  It'll be freed when anyone who has it held open closes it.

It'd be a superflous feature which require a separate control knob on
each cgroup and can lead to confusion too as there are now two
entities acting on it by default.  The manager has to worry about
keeping those knobs in sync and deal with cases where cgroups
disappear unexpectedly.  Think about it.  What should the default
value of the knob be?  What if the manager crashes before setting up
the knob to its desired state?  It needs to perform a cleanup pass
after crash *anyway*.  How is it gonna synchronize with the current
state of cgroup hierarchy otherwise?

It's adding complexity without any actual benefits.  This is kernel
API.  It should be concise and orthogonal where it can be.  There of
course are cases where convenience should be considered but what
you're suggesting doesn't seem beneficial in any substantial way.

> > The case where you move a task out of x1/y1 to another cgroup doesn't
> > generate an event.  One could say that that's unnecessary because the
> 
> Still confused.
> 
> If I create x1/y1 and x3/y3, set notify_on_release on x1 and x1/y1,
> move a task into x1/y1, then move it to x3/y3, then x1/y1 and x1 both
> do get removed.

Ah, you're right, cgroup_task_migrate() sets CGRP_RELEASABLE
explicitly.  I was confused because put_css_set_locked() sets
CGRP_RELEASABLE only if @taskexit is set.  Will drop that part from
the description.

Thanks.

-- 
tejun
