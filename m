Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932660AbaKSBhs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 20:37:48 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:23257 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932229AbaKSBho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 20:37:44 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="43602227"
Message-ID: <546BF53A.7010603@cn.fujitsu.com>
Date: Wed, 19 Nov 2014 09:41:14 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH vfs 1/2] lib: implement ptrset
References: <20141113220927.GF2598@htj.dyndns.org> <546B0F16.90901@cn.fujitsu.com> <20141118115530.GC7809@htj.dyndns.org>
In-Reply-To: <20141118115530.GC7809@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2014 07:55 PM, Tejun Heo wrote:
> Hello,
> 
> On Tue, Nov 18, 2014 at 05:19:18PM +0800, Lai Jiangshan wrote:
>> Is it too ugly?
> 
> What is "it"?  The whole thing?  percpu preloading?  I'm just gonna
> continue assuming that you're talking about preloading.  If you think
> it's ugly, please go ahead and explain why you think it is.

Sorry.
"it" = "preload"

> 
> It's almost impossible to respond to your "review".  It's not clear
> what your subject matter or opinion on it is.  Might as well just bang
> on the keyboard randomly.  When reviewing (or communicating in
> general), please try to properly form and elaborate your points.
> Other people can't know what's going on in your brain and have to
> speculate what you could have meant.
> 
> This implementation of preloading an evolution of a design pattern
> which, IIRC, first started with the radix tree.  The non-failing
> aspect was introduced while the pattern was being applied to idr.  I
> think it's one of the better ways to implement preloading.
> 
>> What will be the most important result it achieve?
> 
> This is the same as other preloading.  It allows pulling allocation
> out of critical section so that it can be done with more generous
> allocation mask (ie. GFP_KERNEL instead of GPF_NOWAIT).  It's a common
> pattern found in data structures which may allocate memory internally
> such as radix tree or idr.

To me, this does explain why it is ugly. The "preload" trick separates one operation
(the memory-allocation) into 3 steps(functions) and creates a special critical region
which is preempt-disabled, which is non-workable-when-nested, the later drawback also
means preload can't work in softirqs/irqs...

I can't argue for existing code. I accept the prelaod in radix tree and idr.
And they are important data structures. (I mean they achieve important result)
so tricks or some thing applied to them seems some kinds of acceptable.

Even in idr, idr_alloc() includes two operations, id-allocation (includes memroy-allocation)
and id-resource-association. These two operations can be separated into 2 functions
without any "preload". (this separation is different from the one in "preload",
this possible separation makes one function only do one thing,
"preload"-approach uses 3 functions together to do one thing or 2 things.)

Thanks.
Lai

