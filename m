Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161654AbaKNRzk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 12:55:40 -0500
Received: from mail-qg0-f42.google.com ([209.85.192.42]:58573 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161175AbaKNRzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 12:55:39 -0500
Date: Fri, 14 Nov 2014 12:55:34 -0500
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        linux-pm@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "\\\"Rafael J. Wysocki\\\"" <rjw@rjwysocki.net>,
        David Rientjes <rientjes@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [RFC 1/4] OOM, PM: Do not miss OOM killed frozen tasks
Message-ID: <20141114175534.GH25889@htj.dyndns.org>
References: <20141110163055.GC18373@dhcp22.suse.cz>
 <1415818732-27712-1-git-send-email-mhocko@suse.cz>
 <1415818732-27712-2-git-send-email-mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415818732-27712-2-git-send-email-mhocko@suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Michal.

On Wed, Nov 12, 2014 at 07:58:49PM +0100, Michal Hocko wrote:
> Also change the return value semantic as the current one is little bit
> awkward. There is just one caller (try_to_freeze_tasks) which checks
> the return value and it is only interested whether the request was
> successful or the task blocks the freezing progress. It is natural to
> reflect the success by true rather than false.

I don't know about this.  It's also customary to return %true when
further action needs to be taken.  I don't think either is
particularly wrong but the flip seems gratuitous.

>  bool freeze_task(struct task_struct *p)
>  {
> @@ -129,12 +130,20 @@ bool freeze_task(struct task_struct *p)
>  	 * normally.
>  	 */
>  	if (freezer_should_skip(p))
> +		return true;
> +
> +	/*
> +	 * Do not check freezing state or attempt to freeze a task
> +	 * which has been killed by OOM killer. We are just waiting
> +	 * for the task to wake up and die.

Maybe saying sth like "consider the task freezing as ...." is a
clearer way to put it?

> +	 */
> +	if (!test_tsk_thread_flag(p, TIF_MEMDIE))
>  		return false;

Thanks.

-- 
tejun
