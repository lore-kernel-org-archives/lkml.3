Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbaJNGyE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 02:54:04 -0400
Received: from ozlabs.org ([103.22.144.67]:48683 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754112AbaJNGxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 02:53:54 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ming Lei <ming.lei@canonical.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kick In <pierre-andre.morey@canonical.com>,
        Chris J Arges <chris.j.arges@canonical.com>
Subject: Re: [PATCH] blk-merge: fix blk_recount_segments
In-Reply-To: <CACVXFVPf-3DazWWAjGSavdN2KzP=P7FBN9+OZUTTr8qjp5aH7w@mail.gmail.com>
References: <1409670180-17352-1-git-send-email-ming.lei@canonical.com> <20140902162146.GA28741@infradead.org> <5405EF38.60007@kernel.dk> <20140903121902.7a9f5a5a@tom-ThinkPad-T410> <87bnquk4fe.fsf@rustcorp.com.au> <878ulyjn23.fsf@rustcorp.com.au> <87y4trhwqr.fsf@rustcorp.com.au> <CACVXFVOX=Tcc9fN_C0FuEHsF22dave9vXtoVct5sx1iK1AWRXg@mail.gmail.com> <87oaulhav5.fsf@rustcorp.com.au> <CACVXFVPf-3DazWWAjGSavdN2KzP=P7FBN9+OZUTTr8qjp5aH7w@mail.gmail.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 14 Oct 2014 14:24:10 +1030
Message-ID: <874mv7cnml.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ming Lei <ming.lei@canonical.com> writes:
> Hi Rusty,

Hi Ming! 

        Sorry, I was on vacation.  I'm back and slowly working through
all my mail...

> 1, FIO script
> [global]
> direct=1
> size=128G
> bsrange=${BS}-${BS}
> timeout=60
> numjobs=4
> ioengine=libaio
> iodepth=64
> filename=/dev/vdb     #backed by /dev/nullb0, 4 virtqueues per virtio-blk
> group_reporting=1
>
> [f]
> rw=randread

> 5, result
> 5.1 without Rusty's virtio-vring patch
> - BS=4K, throughput: 179K
> - BS=256K, throughput: 27540

(ie. always using indirect)

> 5.2 with Rusty's virtio-vring patch
> - BS=4K, throughput: 173K
> - BS=256K, throughput: 25350

(ie. usually using indirect).

> Looks throughput decreases if BS is 256K in case of your patch.

Interesting.  Looks like we're ending up with fewer descs in flight,
though I'm surprised: with 256K blocks I'd expect us to hit the
steady state of "all indirect" almost immediately.

Hmm... I think the heuristic in my patch is flawed.  Let me try again,
and get back to you.

Thanks,
Rusty.
