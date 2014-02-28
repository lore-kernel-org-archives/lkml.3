Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751344AbaB1EHF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 23:07:05 -0500
Received: from g2t2353.austin.hp.com ([15.217.128.52]:50492 "EHLO
	g2t2353.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbaB1EHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 23:07:03 -0500
Message-ID: <53100B62.8000704@hp.com>
Date: Thu, 27 Feb 2014 23:06:58 -0500
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: jaegeuk.kim@samsung.com
CC: Al Viro <viro@ZenIV.linux.org.uk>,
        "Linux Kernel, Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] deadlock on rename_lock
References: <1393548357.4705.75.camel@kjgkr>
In-Reply-To: <1393548357.4705.75.camel@kjgkr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2014 07:45 PM, Jaegeuk Kim wrote:
> Hi Al,
>
> In the following configuration, I met a deadlock condition like below.
>
> Kernel: 3.14-rc3
> Workload: fsstress with 10 threads
> Reproducible scenario: N/A
>
> Is it related to this patch?
> commit 1370e97bb2eb1ef2df7355204e5a4ba13e12b861
> Author: Waiman Long<Waiman.Long@hp.com>
> Date:   Thu Sep 12 10:55:34 2013 -0400
>
>      seqlock: Add a new locking reader type
>
> In d_walk(),
>                  /*
>                   * might go back up the wrong parent if we have had a
> rename
>                   * or deletion
>                   */
>                  if (this_parent != child->d_parent ||
>                           (child->d_flags&  DCACHE_DENTRY_KILLED) ||
>
> -->  I suspect that the upper conditions can trigger rename_retry even
> though rename_retry was done once before.
>
>                           need_seqretry(&rename_lock, seq)) {
>                          spin_unlock(&this_parent->d_lock);
>                          rcu_read_unlock();
>                          goto rename_retry;
>                  }
>
> Thanks,
>
>

It seems like the rename_lock may not be able to fully protect against 
the setting of the DCACHE_DENTRY_KILLED flag. Al, should this case be 
handled separately? I am 100% sure if we could just release the lock and 
let it try again without causing infinite loop.

-Longman
