Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365AbaIIQrG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 12:47:06 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:65281 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742AbaIIQrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 12:47:04 -0400
Date: Wed, 10 Sep 2014 01:46:58 +0900
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch v4 1/2] freezer: check OOM kill while being frozen
Message-ID: <20140909164658.GB11748@mtj.dyndns.org>
References: <1409869842-10807-1-git-send-email-xiyou.wangcong@gmail.com>
 <3827451.ToKxd7Xb2J@vostro.rjw.lan>
 <20140908222253.GB3806@mtj.dyndns.org>
 <2588099.AI1YmNFQ25@vostro.rjw.lan>
 <20140908225012.GE3806@mtj.dyndns.org>
 <20140909151655.GB4851@dhcp22.suse.cz>
 <20140909152336.GB8890@mtj.dyndns.org>
 <20140909160625.GC4851@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140909160625.GC4851@dhcp22.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Sep 09, 2014 at 06:06:25PM +0200, Michal Hocko wrote:
> > Even for userland tasks, try_to_freeze() can currently be anywhere in
> > the kernel.  The frequently used ones are few but there are some odd
> 
> I always thought that user space tasks can be in the fridge only on the
> way out from the kernel (get_signal_to_deliver). I have quickly greped

It *can* be anywhere.  We used to have some deep in nfs.  They got
removed later due to deadlocks but in theory they still can be
anywhere.

> the code and the only place I can see seems to be run_guest but that
> one bails out quickly when there are signals pending so it should be
> safe in this context.
> cifs is doing something suspicious (cifs_reconnect) but I didn't check
> more closely all the contexts it is called from.

Prolly something similar with what nfs was doing?

> > ones out, and, again, there's nothing enforcing any structure on
> > try_to_freeze() usage. 
> 
> Would it make sense to have try_to_freeze_user_task or similar and check
> for kernel thread in try_to_freeze and complain loudly if called from
> user task context? I mean does it even make sense to call try_to_freeze
> in the middle of kernel operation for a user task?

I personally think the whole try_to_freeze() was a mistake at least
for userland tasks.  We should have collected them in a (mostly)
single place like a jobctl stop.  I'm not sure whether distinguishing
the two interfaces would buy us much tho.

> > The other thing is that we may do quite a bit during exiting including
> > allocating memory. 
> 
> yes, we can allocate memory and even page fault on the exit path. But
> TIF_MEMDIE will make sure that the allocation will be successful if
> there is some memory left.

TIF_MEMDIE ensures forward progress so that the task can exit;
however, I'm not sure whether all the things that a task does during
exit are safe for PM freezes.

Thanks.

-- 
tejun
