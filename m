Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126AbaFRQTb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 12:19:31 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:64884 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655AbaFRQTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 12:19:30 -0400
Message-ID: <53A1BC0E.8040704@kernel.dk>
Date: Wed, 18 Jun 2014 09:19:26 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, kmo@daterainc.com, nab@linux-iscsi.org
Subject: Re: [PATCHSET block/for-next] blk-mq: update freezing
References: <1403104872-22236-1-git-send-email-tj@kernel.org>
In-Reply-To: <1403104872-22236-1-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-06-18 08:21, Tejun Heo wrote:
> Hello, Jens.
>
> While reading through blk-mq, I spotted several issues and this
> patchset addresses them.  The biggest one is how freezing is
> implemented.  Coupling it with bypassing doesn't seem to work well and
> there's a subtle bug in the perpcu switch implementation.
>
> I don't think open-coding this level of percpu logic is a good idea.
> It tends to be very error-prone and difficult to follow.  The barrier
> problem is the only thing I spotted but it's very difficult to say
> that it's correct.  percpu_ref already implements most of what's
> necessary to implement this sort of percpu switch and I added the
> missing bits in a recent patchset and converted blk-mq freezing
> mechanism to use it in this patch.
>
> It's far simpler and easier to wrap one's head around, and, as it's
> shared with other mechanisms including aio and cgroups, we should have
> better testing coverage and more eyes scrutinizing it.
>
> This patchset contains the following six patches.
>
>   0001-blk-mq-make-blk_mq_stop_hw_queue-reliably-block-queu.patch
>   0002-blk-mq-fix-a-memory-ordering-bug-in-blk_mq_queue_ent.patch
>   0003-block-blk-mq-draining-can-t-be-skipped-even-if-bypas.patch
>   0004-blk-mq-decouble-blk-mq-freezing-from-generic-bypassi.patch
>   0005-blk-mq-collapse-__blk_mq_drain_queue-into-blk_mq_fre.patch
>   0006-blk-mq-use-percpu_ref-for-mq-usage-count.patch
>
> 0001-0003 are fix patches that can be applied separately.
>
> 0004 decouples blk-mq freezing from queue bypassing.
>
> 0005-0006 replace the custom percpu switch with percpu_ref.
>
> This patchset is on top of
>
>   percpu/for-3.17 6fbc07bbe2b5 ("percpu: invoke __verify_pcpu_ptr() from the generic part of accessors and operations")
> +[1] [PATCHSET percpu/for-3.17] percpu: implement percpu_ref_reinit()
>
> and available in the following git branch.
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git review-mq-percpu_ref
>
>   block/blk-core.c       |   13 ++++---
>   block/blk-mq.c         |   90 ++++++++++++++++---------------------------------
>   block/blk-mq.h         |    2 -
>   block/blk-sysfs.c      |    2 -
>   include/linux/blkdev.h |    4 +-
>   5 files changed, 44 insertions(+), 67 deletions(-)

Thanks Tejun, this looks pretty good. I was worried the tryget_live() 
would be too expensive, but that looks not to be the case. I like the 
cleanups to using a general mechanism. I'll run this through some 
functional and performance testing.

-- 
Jens Axboe

