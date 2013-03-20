Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758213Ab3CTJyW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 05:54:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1476 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755410Ab3CTJyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 05:54:20 -0400
Message-ID: <51498737.8000800@redhat.com>
Date: Wed, 20 Mar 2013 10:53:59 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Venkatesh Srinivas <venkateshs@google.com>
CC: Wanlong Gao <gaowanlong@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-scsi@vger.kernel.org, mst@redhat.com,
        JBottomley@parallels.com, virtualization@lists.linux-foundation.org,
        vsrinivas@ops101.org, digitaleric@google.com, mikew@google.com
Subject: Re: [PATCH V5 4/5] virtio-scsi: introduce multiqueue support
References: <1363687057-13580-1-git-send-email-gaowanlong@cn.fujitsu.com> <1363687057-13580-5-git-send-email-gaowanlong@cn.fujitsu.com> <20130320014657.GA14714@google.com>
In-Reply-To: <20130320014657.GA14714@google.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 20/03/2013 02:46, Venkatesh Srinivas ha scritto:
> This looks pretty good!
> 
> I rather like the (lack of) locking in I/O completion (around the req
> count vs. target/queue binding). It is unfortunate that you need to hold
> the per-target lock in virtscsi_pick_vq() though; have any idea
> how much that lock hurts?

It doesn't hurt, the lock is mostly uncontended.

- if you have lots of I/O, it's held for a very small period of time; if
you have little I/O, it's uncontended anyway.

- the SCSI layer will serialize on the host lock anyway before calling
into the LLD.  Locks are "pipelined" so that in the end the host lock
will be a bigger bottleneck than the others.

Most of the time it only costs 2 extra atomic operations, which should
be galf a microsecond or less.

Paolo

> Just two minor comments:
> 
> (in struct virtio_scsi_target_data):
> +       /* This spinlock never help at the same time as vq_lock. */
>                                ^^^^ held?
> 
> (in struct virtio_scsi):
> +       /* Does the affinity hint is set for virtqueues? */
> Could you rephrase that, please?
> 
> Tested on qemu and w/ Google Compute Engine's virtio-scsi device.
> 
> Reviewed-and-tested-by: Venkatesh Srinivas <venkateshs@google.com>
> 
> Thanks,
> -- vs;

