Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574Ab3AQV5a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 16:57:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55585 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033Ab3AQV52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 16:57:28 -0500
Date: Thu, 17 Jan 2013 13:57:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-mm@kvack.org, Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.de>, Minchan Kim <minchan@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <axboe@kernel.dk>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v7 0/6] solve deadlock caused by memory allocation with
 I/O
Message-Id: <20130117135726.5b31fd0f.akpm@linux-foundation.org>
In-Reply-To: <CACVXFVOipr0VMyPQaZTLckxTaPan7ZneERUqZ1S_mYo11A5AeA@mail.gmail.com>
References: <1357352744-8138-1-git-send-email-ming.lei@canonical.com>
	<20130116153744.70210fa3.akpm@linux-foundation.org>
	<CACVXFVOipr0VMyPQaZTLckxTaPan7ZneERUqZ1S_mYo11A5AeA@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jan 2013 09:28:14 +0800
Ming Lei <ming.lei@canonical.com> wrote:

> > If so, I wonder if we could avoid the whole problem by appropriately
> > syncing all dirty memory back to storage before starting to turn devices
> > off?
> 
> The patchset is to address the probable deadlock problem by GFP_KERNEL
> during runtime suspend/resume which is per block/network device. I am
> wondering if syncing all dirty memory is suitable or necessary during
> per-storage/network device runtime resume/suspend:
> 
>       - sys_sync is very slow and runtime pm operation is frequent
> 
>       - it is not efficient because only sync dirty memory against the affected
>         device is needed in theory and not necessary to sync all
> 
>      - we still need some synchronization to avoid accessing the storage
>        between sys_sync and device suspend, just like system sleep case,
>        pm_restrict_gfp_mask is needed even sys_sync has been done
>        inside enter_state().
> 
> So looks the approach in the patch is simpler and more efficient, :-)
> 
> Also, with the patchset, we can avoid many GFP_NOIO allocation
> which is fragile and not easy to use.

Fair enough, thanks.

I grabbed the patches for 3.9-rc1.  It is good that the page
allocator's newly-added test of current->flags is not on the fastpath.

