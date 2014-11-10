Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977AbaKJDQf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 22:16:35 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:51272 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbaKJDQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 22:16:33 -0500
Message-ID: <54602E0E.6060409@kernel.dk>
Date: Sun, 09 Nov 2014 20:16:30 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org
CC: Thomas Gleixner <tglx@linutronix.de>, Clark Williams <williams@redhat.com>
Subject: Re: [PATCH 0/2] blk-mq: switch from preempt_disable/enable to get/put_cpu
References: <1415397840-18041-1-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1415397840-18041-1-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-11-07 15:03, Paolo Bonzini wrote:
> blk-mq is using preempt_disable/enable in order to ensure that the
> queue runners are placed on the right CPU.  This does not work with
> the RT patches, because __blk_mq_run_hw_queue takes a non-raw
> spinlock with the preemption-disabled region.  If there is contention
> on the lock, this violates the rules for preemption-disabled regions.
>
> While this could be fixed easily within the RT patches just by doing
> migrate_disable/enable (note: this was not tested :)), we can do
> better.  The first patch concentrates the preempt_disable/enable in
> a single place in blk_mq_run_hw_queue, and also avoids useless calls
> when the caller wants to start __blk_mq_run_hw_queue asynchronously.
> (There is already a call to __blk_mq_run_hw_queue that does not disable
> preemption in blk-flush.c; not coincidentially, it passes async=true).
>
> Once this is done, it is trivial to use get/put_cpu instead of
> preempt_disable/smp_processor_id/preempt_enable, which is what the
> second patch does.  The RT patches then can change this to use
> get_cpu_light.
>
> With these changes (and the additional switch to get_cpu_light),
> virtio-blk can be used again with RT kernels.

These both look good. I'll double check and run through some testing, 
then apply for 3.19 if it all passes.


-- 
Jens Axboe

