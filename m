Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447Ab3BTXYt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 18:24:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41698 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375Ab3BTXYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 18:24:47 -0500
Date: Wed, 20 Feb 2013 15:24:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Tejun Heo <tj@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH v4] lockdep: check that no locks held at freeze time
Message-Id: <20130220152446.a65ff84f.akpm@linux-foundation.org>
In-Reply-To: <1361402236-28644-1-git-send-email-msb@chromium.org>
References: <20130220223013.GA15760@redhat.com>
	<1361402236-28644-1-git-send-email-msb@chromium.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2013 15:17:16 -0800
Mandeep Singh Baines <msb@chromium.org> wrote:

> We shouldn't try_to_freeze if locks are held.
> 
> ...
>
> @@ -43,6 +44,9 @@ extern void thaw_kernel_threads(void);
>  
> +	if (!(current->flags & PF_NOFREEZE))
> +		debug_check_no_locks_held(current,
> +
>					  "lock held while trying to freeze");
> ...
>
> +	debug_check_no_locks_held(tsk, "lock held at task exit time");

There doesn't seem much point in adding the `msg' to
debug_check_no_locks_held() - the dump_stack() in
print_held_locks_bug() will tell us the same thing.  Maybe just change
the print_held_locks_bug() messages so they stop assuming they were
called from do_exit()?

Also, I wonder if the `tsk' arg is needed.  In both callers
tsk==current.  Is it likely that we'll ever call
debug_check_no_locks_held() for any task other than `current'?

