Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647Ab3B0HaJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 02:30:09 -0500
Received: from ozlabs.org ([203.10.76.45]:48398 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818Ab3B0HaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 02:30:07 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 02/16] virtio_ring: virtqueue_add_sgs, to add multiple sgs.
In-Reply-To: <512C5E0E.5040305@redhat.com>
References: <1361260594-601-1-git-send-email-rusty@rustcorp.com.au> <1361260594-601-3-git-send-email-rusty@rustcorp.com.au> <20130224221255.GA5300@redhat.com> <512C5E0E.5040305@redhat.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Wed, 27 Feb 2013 17:58:37 +1030
Message-ID: <87obf6dxlm.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:
> Il 24/02/2013 23:12, Michael S. Tsirkin ha scritto:
>> On Tue, Feb 19, 2013 at 06:26:20PM +1030, Rusty Russell wrote:
>>> virtio_scsi can really use this, to avoid the current hack of copying
>>> the whole sg array.  Some other things get slightly neater, too.
>>>
>>> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
>> 
>> Hmm, this makes add_buf a bit slower. virtio_test results
>> (I'll send a patch to update the test shortly):
>> 
>> Before:
>> 0.09user 0.01system 0:00.12elapsed 91%CPU (0avgtext+0avgdata 480maxresident)k
>> 0inputs+0outputs (0major+145minor)pagefaults 0swaps
>> 
>> After:
>> 0.11user 0.01system 0:00.13elapsed 90%CPU (0avgtext+0avgdata 480maxresident)k
>> 0inputs+0outputs (0major+145minor)pagefaults 0swaps
>
> Not unexpected at all... :(
>
> Some of it can be recovered, but if it's 20% I doubt all of it.  So my
> patches were not premature optimization; you really can take just two
> among speed, flexibility, and having a nice API.

The error bars on this are far too large to say "20%".

Here are my numbers, using 50 runs of:
time tools/virtio/vringh_test --indirect --eventidx --parallel and
stats --trim-outliers:

Baseline (before add_sgs):
        2.840000-3.040000(2.927292)user

After add_sgs:
        2.970000-3.150000(3.053750)user

After simplifying add_buf a little:
        2.950000-3.210000(3.081458)user

After inlining virtqueue_add/vring_add_indirect:
        2.920000-3.150000(3.026875)user

After passing in iteration functions (chained vs unchained):
        2.760000-2.970000(2.883542)user

After removing the now-unnecessary chain-cleaning in add_buf:
        2.660000-2.830000(2.753542)user

Any questions?
Rusty.
