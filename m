Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337AbaGaWDa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 18:03:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52278 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbaGaWD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 18:03:29 -0400
Date: Thu, 31 Jul 2014 15:03:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH percpu/for-3.17 1/2] percpu: implement percpu_pool
Message-Id: <20140731150328.d2b57d5f6d7aafa33f5ad979@linux-foundation.org>
In-Reply-To: <20140718200804.GG13012@htj.dyndns.org>
References: <20140718200804.GG13012@htj.dyndns.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jul 2014 16:08:04 -0400 Tejun Heo <tj@kernel.org> wrote:

> percpu allocator requires sleepable context for allocations.  Most use
> cases are fine with the requirement but blk-throttle currently
> implements its own asynchronous allocation mechanism to allow
> initiating allocation from atomic contexts and there are expected to
> be more similar use cases.
> 
> It'd be best to make percpu allocator take GFP mask like other
> allocators but its entanglement with kernel virtual address management
> makes it very cumbersome.  Also, percpu allocations from atomic
> contexts are likely to remain highly restricted.
> 
> This patch implements a simple asynchronous allocation pool, named
> percpu_pool, which can be used from any context and is refilled
> automatically.  A pool is initialized with the size and alignment of
> the percpu areas to serve and the low an high watermarks.  When the
> number of cached areas fall below the low watermark, a work item is
> kicked off to fill it up to the high mark.  A pool can be statically
> defined and can be manually filled and emptied.

I don't think we should add facilities such as this.  Because if we do,
people will use them and thereby make the kernel less reliable, for
obvious reasons.

It would be better to leave the nasty hack localized within
blk-throttle.c and hope that someone finds a way of fixing it.

