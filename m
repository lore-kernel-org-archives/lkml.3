Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417Ab3BUVma (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 16:42:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51709 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894Ab3BUVm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 16:42:29 -0500
Date: Thu, 21 Feb 2013 13:42:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH v6] lockdep: check that no locks held at freeze time
Message-Id: <20130221134227.33679567.akpm@linux-foundation.org>
In-Reply-To: <1361465501-19744-1-git-send-email-msb@chromium.org>
References: <3556388.kjl7k6r8W6@vostro.rjw.lan>
	<1361465501-19744-1-git-send-email-msb@chromium.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Feb 2013 08:51:41 -0800
Mandeep Singh Baines <msb@chromium.org> wrote:

> We shouldn't try_to_freeze if locks are held. Holding a lock
> can cause a deadlock if the lock is later acquired in the
> suspend or hibernate path (e.g. by dpm). Holding a lock can
> also cause a deadlock in the case of cgroup_freezer if a
> lock is held inside a frozen cgroup that is later acquired by
> a process outside that group.
> 
> ...
>
> --- a/include/linux/freezer.h
> +++ b/include/linux/freezer.h
>
> ...
>
> @@ -43,6 +44,8 @@ extern void thaw_kernel_threads(void);
>  
>  static inline bool try_to_freeze(void)
>  {
> +	if (!(current->flags & PF_NOFREEZE))
> +		debug_check_no_locks_held();
>  	might_sleep();
>  	if (likely(!freezing(current)))
>  		return false;
>
> ...
>

It still needs
http://ozlabs.org/~akpm/mmots/broken-out/lockdep-check-that-no-locks-held-at-freeze-time-fix.patch
