Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918Ab3CTVWz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 17:22:55 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:39827 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab3CTVWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 17:22:53 -0400
Date: Wed, 20 Mar 2013 14:22:48 -0700
From: Venkatesh Srinivas <venkateshs@google.com>
To: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-scsi@vger.kernel.org, virtualization@lists.linux-foundation.org,
        rusty@rustcorp.com.au, mst@redhat.com, asias@redhat.com,
        JBottomley@parallels.com, pbonzini@redhat.com
Subject: Re: [PATCH V6 4/5] virtio-scsi: introduce multiqueue support
Message-ID: <20130320212247.GA18276@google.com>
References: <1363762884-11000-1-git-send-email-gaowanlong@cn.fujitsu.com>
 <1363762884-11000-5-git-send-email-gaowanlong@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1363762884-11000-5-git-send-email-gaowanlong@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 03:01:23PM +0800, Wanlong Gao wrote:
>From: Paolo Bonzini <pbonzini@redhat.com>
>
>This patch adds queue steering to virtio-scsi.  When a target is sent
>multiple requests, we always drive them to the same queue so that FIFO
>processing order is kept.  However, if a target was idle, we can choose
>a queue arbitrarily.  In this case the queue is chosen according to the
>current VCPU, so the driver expects the number of request queues to be
>equal to the number of VCPUs.  This makes it easy and fast to select
>the queue, and also lets the driver optimize the IRQ affinity for the
>virtqueues (each virtqueue's affinity is set to the CPU that "owns"
>the queue).
>
>The speedup comes from improving cache locality and giving CPU affinity
>to the virtqueues, which is why this scheme was selected.  Assuming that
>the thread that is sending requests to the device is I/O-bound, it is
>likely to be sleeping at the time the ISR is executed, and thus executing
>the ISR on the same processor that sent the requests is cheap.
>
>However, the kernel will not execute the ISR on the "best" processor
>unless you explicitly set the affinity.  This is because in practice
>you will have many such I/O-bound processes and thus many otherwise
>idle processors.  Then the kernel will execute the ISR on a random
>processor, rather than the one that is sending requests to the device.
>
>The alternative to per-CPU virtqueues is per-target virtqueues.  To
>achieve the same locality, we could dynamically choose the virtqueue's
>affinity based on the CPU of the last task that sent a request.  This
>is less appealing because we do not set the affinity directly---we only
>provide a hint to the irqbalanced running in userspace.  Dynamically
>changing the affinity only works if the userspace applies the hint
>fast enough.

Looks good! Tested as V5.

Tested-by: Venkatesh Srinivas <venkateshs@google.com>

-- vs;
