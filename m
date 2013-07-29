Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757424Ab3G2QKf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 12:10:35 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:61365 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383Ab3G2QKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 12:10:33 -0400
Date: Mon, 29 Jul 2013 12:10:26 -0400
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kent.overstreet@gmail.com,
        Li Zefan <lizefan@huawei.com>, Glauber Costa <glommer@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: memcg creates an unkillable task in 3.2-rc2
Message-ID: <20130729161026.GD22605@mtj.dyndns.org>
References: <20130723174711.GE21100@mtj.dyndns.org>
 <8761vui4cr.fsf@xmission.com>
 <20130729075939.GA4678@dhcp22.suse.cz>
 <87ehahg312.fsf@xmission.com>
 <20130729095109.GB4678@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130729095109.GB4678@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Jul 29, 2013 at 11:51:09AM +0200, Michal Hocko wrote:
> Isn't this a bug in freezer then? I am not familiar with the freezer
> much but memcg oom handling seems correct to me. The task is sleeping
> KILLABLE and fatal_signal_pending in mem_cgroup_handle_oom will tell us
> to bypass the charge and let the taks go away.

Is the problem a frozen task not being killed even when SIGKILL is
received?  If so, it is a known problem and a side-effect of
cgroup_freezer (ab)using and making the existing power management
freezer visible to userland without really thinking about the
implications.  :(

So, yeah, if you use cgroup_freezer now, the tasks will get stuck in
states which aren't well defined when visible from userland and will
just stay there until unfrozen no matter what.  Yet another reason
I'll be screaming like a banshee at anyone who says that cgroup is
built to delegate subtree access rights to !root users.

It's on the to-do list but a very long term one.  Right now, if you
combine userland OOM handling with freezer and whatnot, it'd be pretty
easy to get into trouble.

Thanks.

-- 
tejun
