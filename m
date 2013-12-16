Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab3LPQF4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 11:05:56 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:33500 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540Ab3LPQFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 11:05:55 -0500
Date: Mon, 16 Dec 2013 11:05:42 -0500
From: Tejun Heo <tj@kernel.org>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Nigel Cunningham <nigel@nigelcunningham.com.au>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jens Axboe <axboe@kernel.dk>, tomaz.solc@tablix.org,
        aaron.lu@intel.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH] libata, freezer: avoid block device removal while system
 is frozen
Message-ID: <20131216160542.GG32509@htj.dyndns.org>
References: <20131213174932.GA27070@htj.dyndns.org>
 <20131213185237.GD27070@htj.dyndns.org>
 <20131213204034.GE27070@htj.dyndns.org>
 <52AB8E27.90308@nigelcunningham.com.au>
 <20131213230744.GA17954@htj.dyndns.org>
 <CACVXFVOWfJKOzUQcRRkQo8TLEkBvU6ByHbtrrD3R_ZncrbpZQQ@mail.gmail.com>
 <20131216124504.GB32509@htj.dyndns.org>
 <CACVXFVMPQUjAmvNpO+WVLDzVBwkwPtqqyBga_uXxfptVpEPPbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVMPQUjAmvNpO+WVLDzVBwkwPtqqyBga_uXxfptVpEPPbw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ming.

On Mon, Dec 16, 2013 at 09:24:40PM +0800, Ming Lei wrote:
> You mean there are still some write I/O scheduled after processes are
> frozen? by unfreezable kernel threads?

By unfreezable kernel threads, timer, bh, freezable kernel threads,
whatever really.  Please note that freezer doesn't enforce any order
in how the target tasks are frozen.  There's no mechanism to guarantee
that flusher is frozen after all other freezable tasks are frozen.
There isn't even a meachnism which guarantees flusher flushes all its
queues before getting frozen.  There's no interlocking whatsoever.
The only thing which happens is that we flush all filesystems before
freezing the kernel threads, so the queues are *likely* to be empty.

I think trying to control all IO sources using the freezer is a
fundamentally flawed idea.  There are N sources which are difficult to
track down reliably while there is *single* queue all those have to go
through, which needs to be quiesced anyway.  The only thing which
makes sense is controlling the queue.

Maybe it really is necessary for hibernation.  If so, let's please
make it something tailored for that purpose - quiesce only the ones
which are actually relevant and in the places where it's necessary.
Not this "we stopped most of the system, whatever that means, and it
feels good" thing which doesn't really solve anything while
introducing this fuzzy wishful idea of mostly stopped system and giant
lock semantics all over the place.

Thanks.

-- 
tejun
