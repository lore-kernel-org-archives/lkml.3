Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582AbbAHLva (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 06:51:30 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:59877 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199AbbAHLv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 06:51:28 -0500
Date: Thu, 8 Jan 2015 12:51:24 +0100
From: Michal Hocko <mhocko@suse.cz>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        "\\\"Rafael J. Wysocki\\\"" <rjw@rjwysocki.net>,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Oleg Nesterov <oleg@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-pm@vger.kernel.org
Subject: Re: [PATCH -v2 5/5] OOM, PM: make OOM detection in the freezer path
 raceless
Message-ID: <20150108115124.GA6027@dhcp22.suse.cz>
References: <20141110163055.GC18373@dhcp22.suse.cz>
 <1417797707-31699-1-git-send-email-mhocko@suse.cz>
 <1417797707-31699-6-git-send-email-mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417797707-31699-6-git-send-email-mhocko@suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 05-12-14 17:41:47, Michal Hocko wrote:
[...]
> +bool oom_killer_disable(void)
> +{
> +	/*
> +	 * Make sure to not race with an ongoing OOM killer
> +	 * and that the current is not the victim.
> +	 */
> +	down_write(&oom_sem);
> +	if (test_thread_flag(TIF_MEMDIE)) {
> +		up_write(&oom_sem);
> +		return false;
> +	}
> +
> +	oom_killer_disabled = true;
> +	up_write(&oom_sem);
> +
> +	wait_event(oom_victims_wait, atomic_read(&oom_victims));

Ups brainfart... Should be !atomic_read(&oom_victims). Condition says
for what we are waiting not when we are waiting.

> +
> +	return true;
> +}
[...]
-- 
Michal Hocko
SUSE Labs
