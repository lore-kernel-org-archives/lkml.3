Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757642Ab3APXhr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 18:37:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42441 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755308Ab3APXhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 18:37:45 -0500
Date: Wed, 16 Jan 2013 15:37:44 -0800
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
Message-Id: <20130116153744.70210fa3.akpm@linux-foundation.org>
In-Reply-To: <1357352744-8138-1-git-send-email-ming.lei@canonical.com>
References: <1357352744-8138-1-git-send-email-ming.lei@canonical.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat,  5 Jan 2013 10:25:38 +0800
Ming Lei <ming.lei@canonical.com> wrote:

> This patchset try to solve one deadlock problem which might be caused
> by memory allocation with block I/O during runtime PM and block device
> error handling path. Traditionly, the problem is addressed by passing
> GFP_NOIO statically to mm, but that is not a effective solution, see
> detailed description in patch 1's commit log.
> 
> This patch set introduces one process flag and trys to fix the deadlock
> problem on block device/network device during runtime PM or usb bus reset.

The patchset doesn't look like the worst thing I've ever applied ;)

One thing I'm wondering: during suspend and resume, why are GFP_KERNEL
allocation attempts even getting down to the device layer?  Presumably
the page scanner is encountering dirty pagecache or dirty swapcache
pages?

If so, I wonder if we could avoid the whole problem by appropriately
syncing all dirty memory back to storage before starting to turn devices
off?

