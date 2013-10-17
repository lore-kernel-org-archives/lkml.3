Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762257Ab3JQDkZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 23:40:25 -0400
Received: from imap.thunk.org ([74.207.234.97]:47084 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761009Ab3JQDkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 23:40:20 -0400
Date: Wed, 16 Oct 2013 23:40:17 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ming Lei <ming.lei@canonical.com>
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        linux-ext4@vger.kernel.org,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] ext4: fix performance regression in ext4_writepages
Message-ID: <20131017034017.GC11932@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Ming Lei <ming.lei@canonical.com>, linux-kernel@vger.kernel.org,
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
References: <1381886317-19539-1-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381886317-19539-1-git-send-email-ming.lei@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 09:18:37AM +0800, Ming Lei wrote:
> Commit 4e7ea81db5(ext4: restructure writeback path) introduces
> another performance regression on random write:
> 
> - one more page may be added to ext4 extent in mpage_prepare_extent_to_map,
>   and will be submitted for I/O so nr_to_write will become -1 before 'done'
>   is set
> 
> - the worse thing is that dirty pages may still be retrieved from page
>   cache after nr_to_write becomes negative, so lots of small chunks can be
>   submitted to block device when page writeback is catching up with write
>   path, and performance is hurted.
> 
> On one arm A15 board with sata 3.0 SSD(CPU: 1.5GHz dura core, RAM: 2GB,
> SATA controller: 3.0Gbps), this patch can improve below test's result
> from 157MB/sec to 174MB/sec(>10%):
> 
> 	dd if=/dev/zero of=./z.img bs=8K count=512K
> 
> The above test is actually prototype of block write in bonnie++ utility.
> 
> This patch makes sure no more pages than nr_to_write can be added to extent
> for mapping, so that nr_to_write won't become negative.
> 
> Cc: Ted Tso <tytso@mit.edu>
> Cc: linux-ext4@vger.kernel.org
> Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
> Acked-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Ming Lei <ming.lei@canonical.com>

Thanks, applied.

					- Ted
