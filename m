Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263AbaJQG7u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 02:59:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34736 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbaJQG7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 02:59:49 -0400
Date: Fri, 17 Oct 2014 08:59:47 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>, David Rientjes <rientjes@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: + freezer-check-oom-kill-while-being-frozen.patch added to -mm
 tree
Message-ID: <20141017065947.GA8076@dhcp22.suse.cz>
References: <20141016203954.GA26336@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141016203954.GA26336@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 16-10-14 22:39:54, Oleg Nesterov wrote:
> > Fix the issue by checking for TIF_MEMDIE thread flag and get away from the
> > fridge if it is set.  oom_scan_process_thread doesn't have to check for
> > the frozen task anymore because do_send_sig_info will wake up the thread
> > and TIF_MEMDIE is already set by that time.
> 
> I must have missed something... but __refrigerator() sleeps in
> TASK_UNINTERRUPTIBLE and do_send_sig_info() won't wake it up?

Ouch, I have completely missed this part when reviewing Cong's original
patch. I got confused by the retry loop. Anyway you are right and the
patch as is currently doesn't work as intented.

Can we simply make the task sleep interruptible? It retries and rechecks
the freezing conditions after wakeup anyway. It is true this would be a
user visible change because frozen tasks won't be in D state anymore
(this would make a difference for cgroup freezing because nobody would
see this in PM freezer). Does anybody depend on this?

Another possible way would be reintroducing freezer check into OOM path
and kick the task even when it is in UN state.

Thanks!
-- 
Michal Hocko
SUSE Labs
