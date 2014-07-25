Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759223AbaGYBZu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 21:25:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59661 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756093AbaGYBZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 21:25:48 -0400
MIME-Version: 1.0
In-Reply-To: <53D12343.8050507@oracle.com>
References: <1406156130-15575-1-git-send-email-ming.lei@canonical.com>
	<1406156130-15575-8-git-send-email-ming.lei@canonical.com>
	<20140723231600.GE17798@lenny.home.zabbo.net>
	<CACVXFVPXTQyipPLrQML6ONwD3b4g4nHWc=OVjkUMZOiv5daevg@mail.gmail.com>
	<53D12343.8050507@oracle.com>
Date: Fri, 25 Jul 2014 09:25:43 +0800
Message-ID: <CACVXFVPc7A0X0SFAUj3-_ArXvtJi3aQHO8+GO78CfuyC7370JQ@mail.gmail.com>
Subject: Re: [PATCH 7/9] aio: add aio_kernel_() interface
From: Ming Lei <ming.lei@canonical.com>
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Zach Brown <zab@zabbo.net>, Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Benjamin LaHaise <bcrl@kvack.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "open list:AIO <linux-aio@kvack.org>, Kent Overstreet" 
	<kmo@daterainc.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 11:16 PM, Dave Kleikamp
<dave.kleikamp@oracle.com> wrote:
> On 07/23/2014 08:57 PM, Ming Lei wrote:
>> On Thu, Jul 24, 2014 at 7:16 AM, Zach Brown <zab@zabbo.net> wrote:
>>> On Thu, Jul 24, 2014 at 06:55:28AM +0800, Ming Lei wrote:
>>>> From: Dave Kleikamp <dave.kleikamp@oracle.com>
>>>>
>>>> This adds an interface that lets kernel callers submit aio iocbs without
>>>> going through the user space syscalls.  This lets kernel callers avoid
>>>> the management limits and overhead of the context.  It will also let us
>>>> integrate aio operations with other kernel apis that the user space
>>>> interface doesn't have access to.
>>>>
>>>> This patch is based on Dave's posts in below links:
>>>>
>>>>       https://lkml.org/lkml/2013/10/16/365
>>>>       https://groups.google.com/forum/#!topic/linux.kernel/l7mogGJZoKQ
>>>
>>> This was originally written a billion years ago when dinosaurs roamed
>>> the earth.  Also, notably, before Kent and Ben reworked a bunch of the
>>
>> Not so far away, this patch is based on Dave's last version of V9, which
>> was posted in Oct, 2013, :-)
>
> Which was based on a much earlier patch from Zach. I regret that I left
> aio_kernel_submit entangled with aio_run_iocb when I reworked his patches.
>
>>> aio core.  I'd want them to take a look at this patch to make sure that
>>> it doesn't rely on any assumptions that have changed.
>>
>> Looks I missed to Cc Ken, :-(
>>
>>>
>>>> +/* opcode values not exposed to user space */
>>>> +enum {
>>>> +     IOCB_CMD_READ_ITER = 0x10000,
>>>> +     IOCB_CMD_WRITE_ITER = 0x10001,
>>>> +};
>>>
>>> And I think the consensus was that this isn't good enough.  Find a way
>>> to encode the kernel caller ops without polluting the uiocb cmd name
>>> space.
>>
>> That is easy, since the two cmd names are only for kernel AIO, whatever
>> should be OK, but looks I didn't see such comment.
>
> Agreed. These were added because the flags had been interpreted by
> aio_run_iocb(). I'm happy that is no longer the case.

We can remove the two cmd names completely, and just use one
read/write flag, will do it in V1.

>
>>>
>>> (I've now come to think that this entire approach of having loop use aio
>>> is misguided and that the way forward is to have dio consume what loop
>>> naturally produces -- bios, blk-mq rqs, whatever -- but I'm on to other
>>
>> Yes, that is what these patches are doing, and actually AIO's
>> model is a good match to driver's interface. Lots of drivers
>> use the asynchronous model(submit, complete, ...).
>>
>>> things these days.)
>>
>> At least, loop can improve its throughput much by kernel AIO
>> without big changes to fs/direct-io(attribute much to ITER_BVEC),
>> and vhost-scsi should benefit from it too.
>>
>> Thanks,
>>
