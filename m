Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346Ab3CFHR1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 02:17:27 -0500
Received: from ozlabs.org ([203.10.76.45]:45372 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386Ab3CFHRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 02:17:24 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Asias He <asias@redhat.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 08/16] virtio_ring: virtqueue_add_outbuf / virtqueue_add_inbuf.
In-Reply-To: <20130228070124.GD4743@redhat.com>
References: <1361260594-601-1-git-send-email-rusty@rustcorp.com.au> <1361260594-601-9-git-send-email-rusty@rustcorp.com.au> <20130221170902.GA27097@redhat.com> <87sj4pfc61.fsf@rustcorp.com.au> <20130225213504.GC18167@redhat.com> <87lia9c9er.fsf@rustcorp.com.au> <20130228070124.GD4743@redhat.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Wed, 06 Mar 2013 17:03:42 +1100
Message-ID: <87y5e19i9t.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:
>> Without the inline keywords, it doesn't inline virtqueue_add, and thus
>> sg_next_chained and sg_next_add aren't inlined:
>> 
>> $ for i in `seq 50`; do /usr/bin/time --format=%U ./vringh_test --indirect --eventidx --parallel; done 2>&1 | stats --trim-outliers
>> Using CPUS 0 and 3
>> Guest: notified 39102-39145(39105), pinged 39060-39063(39063)
>> Host: notified 39060-39063(39063), pinged 19551-19581(19553)
>> 3.050000-3.220000(3.136875)
>> 
>> With inline:
>> 
>> $ for i in `seq 50`; do /usr/bin/time --format=%U ./vringh_test --indirect --eventidx --parallel; done 2>&1 | stats --trim-outliers
>> Using CPUS 0 and 3
>> Guest: notified 39084-39148(39099), pinged 39062-39063(39062)
>> Host: notified 39062-39063(39062), pinged 19542-19574(19550)
>> 2.940000-3.140000(3.014583)
>> 
>> Cheers,
>> Rusty.
>
> Cool and did it actually unroll all loops?

Sorry for the delay in answering... I spent a day chasing red-herrings,
as my tests became limited by the vringh side, so optimizations on the
virtio side were having no effect :(

I'll answer a related question based on the current tree, where
virtio_add_outbuf (and virtio_add_inbuf) are the stars:

	return virtqueue_add(vq, &sg, sg_next_arr, num, 0, 1, 0, data, gfp);

Ideally, gcc would eliminated the input-descriptor loop altogether (that
0 for in_sgs), and unroll the 1-iteration output-descriptor loop into
straightline code.

Which it seems to have done, by my reading of the asm (at least, for gcc
4.7 on 32-bit x86).

Cheers,
Rusty.
