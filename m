Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435AbaB0U6L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 15:58:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39223 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbaB0U6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 15:58:08 -0500
Date: Thu, 27 Feb 2014 12:58:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: NeilBrown <neilb@suse.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux RAID <linux-raid@vger.kernel.org>,
        "majianpeng" <majianpeng@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] md / procfs: avoid Oops if md-mod removed while
 /proc/mdstat is being polled.
Message-Id: <20140227125807.d034c50c7fe2e1a9f3c38ec1@linux-foundation.org>
In-Reply-To: <20140227172445.13644477@notabene.brown>
References: <20140227172445.13644477@notabene.brown>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Feb 2014 17:24:45 +1100 NeilBrown <neilb@suse.de> wrote:

> If poll or select is waiting on /proc/mdstat when md-mod is unloaded
> an oops will ensure when the poll/select completes.
> 
> This is because the wait_queue_head which is registered with poll_wait()
> is local to the module and no longer exists when the poll completes and
> detaches that wait_queue_head (in poll_free_wait -> remove_wait_queue).
> 
> To fix this we need the wait_queue_head to have (at least) the same life
> time as the proc_dir_entry.  So this patch places it in that structure.
> 
> We:
>   - add pde_poll_wait to struct proc_dir_entry
>   - call poll_wait() passing this when poll() is called on the proc file
>   - export a function proc_wake_up which will call wake_up() on pde_poll_wait
> 
> and make use of all that in md.c

This sounds wrong.  If a userspace process is waiting on
md_event_waiters then the md module is "busy" and the rmmod attempt
should fail?
