Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751144AbaHONU4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 09:20:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54542 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbaHONUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 09:20:54 -0400
MIME-Version: 1.0
In-Reply-To: <20140814180751.GB429@lenny.home.zabbo.net>
References: <1408031441-31156-1-git-send-email-ming.lei@canonical.com>
	<1408031441-31156-2-git-send-email-ming.lei@canonical.com>
	<20140814180751.GB429@lenny.home.zabbo.net>
Date: Fri, 15 Aug 2014 21:20:52 +0800
Message-ID: <CACVXFVNKQm_NYBX17YWndm4zbMbnV4K--o0SZXeT6LAUS5eU=A@mail.gmail.com>
Subject: Re: [PATCH v1 1/9] aio: add aio_kernel_() interface
From: Ming Lei <ming.lei@canonical.com>
To: Zach Brown <zab@zabbo.net>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Benjamin LaHaise <bcrl@kvack.org>,
        Christoph Hellwig <hch@infradead.org>,
        Kent Overstreet <kmo@daterainc.com>, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/15/14, Zach Brown <zab@zabbo.net> wrote:
> On Thu, Aug 14, 2014 at 11:50:32PM +0800, Ming Lei wrote:
>> From: Dave Kleikamp <dave.kleikamp@oracle.com>
>>
>> This adds an interface that lets kernel callers submit aio iocbs without
>> going through the user space syscalls.  This lets kernel callers avoid
>> the management limits and overhead of the context.  It will also let us
>> integrate aio operations with other kernel apis that the user space
>> interface doesn't have access to.
>>
>> This patch is based on Dave's posts in below links:
>>
>> 	https://lkml.org/lkml/2013/10/16/365
>> 	https://groups.google.com/forum/#!topic/linux.kernel/l7mogGJZoKQ
>
> (And some other werido's posts, almost 5 entire earth years ago:
>  http://permalink.gmane.org/gmane.linux.file-systems/36246)

Wow, thank you guys for proposing the idea so early.

Care to add your Signed-off-by? And Dave

>
>> +struct kiocb *aio_kernel_alloc(gfp_t gfp, unsigned extra)
>> +{
>> +	return kzalloc(sizeof(struct kiocb) + extra, gfp);
>
> Is kzalloc really necessary?  It's insane, but in the past we've had

You are right, and kmalloc should be enough.

> people whine about the cycle costs of zeroing fields that are to be
> initialized:
>
> 	commit 23aee091d804efa8cc732a31c1ae5d625e1ec886
> 	Author: Jeff Moyer <jmoyer@redhat.com>
> 	Date:   Tue Dec 15 16:47:49 2009 -0800
>
> 	    dio: don't zero out the pages array inside struct dio
>
> Maybe add a guard value to the ctx and have submission freak out of it's
> called without being initialized?  If callers really want to zero they
> can pass in __GFP_ZERO.

At least now, other fields won't be touched in kernel AIO path, and they
can be handled in future if need.

>
> The extra allocation at the end that's freed is nice, but the callers
> having a clumsy manual cast to access it isn't nice at all.  Can you add
> a little helper to get a pointer to the extra allocation?    That'd let

OK.

> the aio bits allocation the iocbs however the like (slab, per-cpu,
> whatever) and have extra allocations separate if that ends up making
> sense.

In the future, maybe it is needed for sake of performance, and now it is OK
to not introduce the extra complexity.

>
>> +	iocb->ki_ctx = (void *)-1;
>
> The magic -1 is gross.  Use a constant?  (bonus points for having it use
> ERR_PTR() :))

OK.

>
>> +	/*
>> +	 * use same policy with userspace aio, req may have been
>> +	 * completed already, so release it by aio completion.
>> +	 */
>> +	if (ret != -EIOCBQUEUED)
>> +		iocb->ki_obj.complete(iocb->ki_user_data, ret);
>
> I wonder if this needs to handle the restarting error codes like
> aio_complete() does.

For same reason, kernel path needn't restart too, and caller won't
see such error code.

>
> 	commit a0c42bac79731276c9b2f28d54f9e658fcf843a2
> 	Author: Jan Kara <jack@suse.cz>
> 	Date:   Wed Sep 22 13:05:03 2010 -0700
>
> 	    aio: do not return ERESTARTSYS as a result of AIO
>
> I like how this has evolved to get rid of the magic key and commands..
> just the ki_ctx and calling iter methods, nice stuff.


Thanks,
-- 
Ming Lei
