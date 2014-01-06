Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260AbaAFUxN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 15:53:13 -0500
Received: from merlin.infradead.org ([205.233.59.134]:41048 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979AbaAFUxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 15:53:12 -0500
Message-ID: <52CB1783.4050205@kernel.dk>
Date: Mon, 06 Jan 2014 13:52:19 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Kent Overstreet <kmo@daterainc.com>, Shaohua Li <shli@kernel.org>
CC: linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [patch 1/2]percpu_ida: fix a live lock
References: <20131231033827.GA31994@kernel.org> <20140104210804.GA24199@kmo-pixel> <20140105131300.GB4186@kernel.org> <20140106204641.GB9037@kmo>
In-Reply-To: <20140106204641.GB9037@kmo>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2014 01:46 PM, Kent Overstreet wrote:
> On Sun, Jan 05, 2014 at 09:13:00PM +0800, Shaohua Li wrote:

>>> - we explicitly don't guarantee that all
>>> the tags will be available for allocation at any given time, only half
>>> of them. 
>>
>> only half of the tags can be used? this is scaring. Of course we hope all tags
>> are available.
> 
> No: that behaviour is explicitly documented and it's the behaviour we want.

That is going to end horribly, for the cases (ie most cases) where we
really want to be able to use all tags. If we can't support that
reliably or in a fast manner with percpu ida, then that's pretty close
to a show stopper. And I suspect that will be the case for most use
cases. We can't just feasibly throw away half of the tag space, that's
crazy.

> There is an inherent performance tradeoff here between internal fragmentation
> and performance: your patch tries to drive internal fragmentation to 0, but
> under workloads that hit this, running on enough cores, this will have a VERY
> high performance cost.

For most workloads that are somewhat localized, we should be able to
support this without melting.

>>> Can you explain more how this is being used where you're seeing
>>> the issue? And I don't see the other patch in your patch series.
>>
>> tasks are bound to specific cpus. And I saw one cpu has a lot of free (but less
>> than half of total tags), but other cpus can't allocate tags, so I saw a live
>> lock.
> 
> You're using it wrong - don't assume all nr_tags can be allocated. If you need
> to guarantee that you'll always be able to allocate a certain number of tags,
> you pass twice that to percpu_ida_init() instead.

But that wont work at all. To take a concrete example, lets assume the
device is some sort of NCQ. We have 0..31 tags. If we throw away half of
those tags, we're at 16. You can't double the tag space in software.

So what's the proposal?

-- 
Jens Axboe

