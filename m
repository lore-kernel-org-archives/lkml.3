Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758289Ab3AQB2U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 20:28:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:39418 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758257Ab3AQB2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 20:28:18 -0500
MIME-Version: 1.0
In-Reply-To: <20130116153744.70210fa3.akpm@linux-foundation.org>
References: <1357352744-8138-1-git-send-email-ming.lei@canonical.com>
	<20130116153744.70210fa3.akpm@linux-foundation.org>
Date: Thu, 17 Jan 2013 09:28:14 +0800
Message-ID: <CACVXFVOipr0VMyPQaZTLckxTaPan7ZneERUqZ1S_mYo11A5AeA@mail.gmail.com>
Subject: Re: [PATCH v7 0/6] solve deadlock caused by memory allocation with I/O
From: Ming Lei <ming.lei@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-mm@kvack.org, Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.de>, Minchan Kim <minchan@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <axboe@kernel.dk>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 7:37 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Sat,  5 Jan 2013 10:25:38 +0800
> Ming Lei <ming.lei@canonical.com> wrote:
>
>> This patchset try to solve one deadlock problem which might be caused
>> by memory allocation with block I/O during runtime PM and block device
>> error handling path. Traditionly, the problem is addressed by passing
>> GFP_NOIO statically to mm, but that is not a effective solution, see
>> detailed description in patch 1's commit log.
>>
>> This patch set introduces one process flag and trys to fix the deadlock
>> problem on block device/network device during runtime PM or usb bus reset.
>
> The patchset doesn't look like the worst thing I've ever applied ;)
>
> One thing I'm wondering: during suspend and resume, why are GFP_KERNEL
> allocation attempts even getting down to the device layer?  Presumably
> the page scanner is encountering dirty pagecache or dirty swapcache
> pages?
>
> If so, I wonder if we could avoid the whole problem by appropriately
> syncing all dirty memory back to storage before starting to turn devices
> off?

The patchset is to address the probable deadlock problem by GFP_KERNEL
during runtime suspend/resume which is per block/network device. I am
wondering if syncing all dirty memory is suitable or necessary during
per-storage/network device runtime resume/suspend:

      - sys_sync is very slow and runtime pm operation is frequent

      - it is not efficient because only sync dirty memory against the affected
        device is needed in theory and not necessary to sync all

     - we still need some synchronization to avoid accessing the storage
       between sys_sync and device suspend, just like system sleep case,
       pm_restrict_gfp_mask is needed even sys_sync has been done
       inside enter_state().

So looks the approach in the patch is simpler and more efficient, :-)

Also, with the patchset, we can avoid many GFP_NOIO allocation
which is fragile and not easy to use.

Thanks,
--
Ming Lei
