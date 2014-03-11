Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbaCKSq6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 14:46:58 -0400
Received: from kanga.kvack.org ([205.233.56.17]:33324 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754047AbaCKSq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 14:46:57 -0400
Date: Tue, 11 Mar 2014 14:46:56 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: viro@zeniv.linux.org.uk, jmoyer@redhat.com, kosaki.motohiro@gmail.com,
        kosaki.motohiro@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        guz.fnst@cn.fujitsu.com, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, linux-kernel@vger.kernel.org,
        miaox@cn.fujitsu.com
Subject: Re: [RESEND v2 PATCH 1/2] aio, memory-hotplug: Fix confliction when migrating and accessing ring pages.
Message-ID: <20140311184656.GD16433@kvack.org>
References: <1394439334-28523-1-git-send-email-tangchen@cn.fujitsu.com> <1394439334-28523-2-git-send-email-tangchen@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394439334-28523-2-git-send-email-tangchen@cn.fujitsu.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 04:15:33PM +0800, Tang Chen wrote:
> IO ring page migration has been implemented by the following patch:
> 
>         https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/fs/aio.c?id=36bc08cc01709b4a9bb563b35aa530241ddc63e3
> 
> In this patch, ctx->completion_lock is used to prevent other processes
> from accessing the ring page being migrated.
> 
> But in aio_setup_ring(), ioctx_add_table() and aio_read_events_ring(),
> when writing to the ring page, they didn't take ctx->completion_lock.

> As a result, for example, we have the following problem:
...
> As above, the new ring page will not be updated.
> 
> The solution is taking ctx->completion_lock in thread 2, which means,
> in aio_setup_ring(), ioctx_add_table() and aio_read_events_ring() when
> writing to ring pages.

Upon review, there are still two accesses of ->ring_pages that are not 
protected by any spinlocks which could potentially race with migration.  One 
is in aio_setup_ring(), which can be easily resolved by moving the assignment 
of ->ring_pages above the unlock_page().  Another spot is in 
aio_read_events_ring() where head and tail are fetched from the ring without 
any locking.  I also fear we'll be introducing new performance issues with 
all the additonal spinlock bouncing, despite the fact that is only ever 
needed for migration.  I'm going to continue looking into this today and 
will try to send out a followup to this email later.

		-ben
-- 
"Thought is the essence of where you are now."
