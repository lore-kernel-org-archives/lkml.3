Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbaHLAel (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 20:34:41 -0400
Received: from mail-oi0-f44.google.com ([209.85.218.44]:65193 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528AbaHLAej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 20:34:39 -0400
X-Greylist: delayed 829 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Aug 2014 20:34:39 EDT
MIME-Version: 1.0
In-Reply-To: <20140811131828.GF15312@dhcp22.suse.cz>
References: <1407545198-9009-1-git-send-email-xiyou.wangcong@gmail.com>
	<20140811131828.GF15312@dhcp22.suse.cz>
Date: Mon, 11 Aug 2014 17:34:39 -0700
Message-ID: <CAM_iQpUFAvNn0--i-t_8TU4tcKQTzmqyP5uNgrOecv30Z=udRQ@mail.gmail.com>
Subject: Re: [Patch] freezer: check OOM kill signal while being frozen
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, David Rientjes <rientjes@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 6:18 AM, Michal Hocko <mhocko@suse.cz> wrote:
>
> OK, so the system/memcg is still OOM and a new allocation/charge
> would trigger killer again, right? Then oom_scan_process_thread sees
> TIF_MEMDIE frozen task and thaw it so it can go away and die. So this
> shouldn't be a permanent state. Or am I missing something?
>

Good point!

Reading the code again, I think David's commit (f660daac) doesn't
work any more, __thaw_task() just checks if it's frozen and then wakes
it up, but the frozen task, after waking up, will check if it's freezing() and
continue to freeze itself if so. __thaw_task() can't make freezing() return
false since it doesn't change any of these conditions, especially
cgroup_freezing().

This reminds me I should revert that code in oom_killer, checking
TIF_MEMDIE in __refrigerator() is more correct and clear.

I will update my patch.

Thanks!
