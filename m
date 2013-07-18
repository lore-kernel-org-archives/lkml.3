Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236Ab3GRKHX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 06:07:23 -0400
Received: from mail-vb0-f47.google.com ([209.85.212.47]:49069 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757343Ab3GRKHV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 06:07:21 -0400
MIME-Version: 1.0
In-Reply-To: <000101ce8356$65011940$2f034bc0$@lge.com>
References: <000001ce82aa$feac9ee0$fc05dca0$@lge.com>
	<CACVXFVOu-2q74JmHLEo3mCVSAzfc7n8GmqPDMPhEDp0wL37w_w@mail.gmail.com>
	<000101ce8356$65011940$2f034bc0$@lge.com>
Date: Thu, 18 Jul 2013 18:07:19 +0800
Message-ID: <CACVXFVNV-hGZpcy2ANQaca1K5yXJ88EOq1PTkJUEHEkFk9Btvw@mail.gmail.com>
Subject: Re: [PATCH] [RFC] EHCI: add to memory barrier to updating hw_next
From: Ming Lei <tom.leiming@gmail.com>
To: Gioh Kim <gioh.kim@lge.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Salter <msalter@redhat.com>,
        namhyung.kim@lge.com, Minchan Kim <minchan.kim@lge.com>,
        Chanho Min <chanho.min@lge.com>, Jong-Sung Kim <neidhard.kim@lge.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 9:30 AM, Gioh Kim <gioh.kim@lge.com> wrote:
> Thanks for your reply.
>
>> -----Original Message-----
>> From: Ming Lei [mailto:tom.leiming@gmail.com]
>> Sent: Wednesday, July 17, 2013 5:52 PM
>> To: ±è±â¿À
>> Cc: Alan Stern; linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org;
>> Mark Salter; namhyung.kim@lge.com; Minchan Kim; Chanho Min; Jong-Sung Kim;
>> linux-arm-kernel
>> Subject: Re: [PATCH] [RFC] EHCI: add to memory barrier to updating hw_next
>>
>> Cc: ARM list
>>
>> On Wed, Jul 17, 2013 at 1:03 PM, ±è±â¿À <gioh.kim@lge.com> wrote:
>> > Hi,
>> >
>> > I have a missing urb completion problem on ARMv7 based platform.
>> >
>> > I thought the above problem was caused by coherent memory between the
>> > EHCI device and CPU so I tryied to allocates device type memory for
>> > EHCI via dma_declare_coherent_memory at machine initialization step so
>> > that EHCI always allocates from those device type memory.
>> > It seems to solve the issue because I didn't see any problem.
>> >
>> > But I am not sure it is acceptable solution. So I applied the patch
>> > https://lkml.org/lkml/2011/8/31/344.
>> > But it could not solve the problem so that I added another wmb() as my
>> > patch, and now my platform works fine.
>>
>> I remember the previous problem reported on Pandaboard firstly was fixed
>> by Will's commit 11ed0ba1(ARM: 7161/1: errata: no automatic store buffer
>> drain), so could you try to enable PL310_ERRATA_769419 and see if your
>> problem can be fixed?
>
>
> I also know the errata but it didn't work for my platform.
>
>
>>
>> >
>> > I am not sure what's the exact problem and what wmb I added could
>> > solve but I just think the problem is related to store buffer flush of
>> hw_next.
>>
>> Yes, per the above commit, but it might be one hardware problem.
>>
>> > Anyway, important thing is that it fixed my problem so I expect you
>> > expert guys could find what I am missing and a right solution.
>> > IMHO, the patch might miss updating hw_next pointer.
>> > Am I correct?
>> >
>> > I understand the wmb() is just memory barrier, not write-buffer flush.
>> > But it is true that wmb() can flush write buffer in ARM.
>> > Anyhow I think that memory type, "normal memory, non-cacheable", may
>> > have a problem for some devices that needs device type memory.
>>
>> Currently on ARMv7 DMA coherent buffer has to be bufferable, in theory we
>> might need one API to flush CPU write buffer, as described in
>> Documentation/DMA-API-HOWTO.txt:
>>
>>              Also, on some platforms your driver may need to flush CPU write
>>              buffers in much the same way as it needs to flush write buffers
>>              found in PCI bridges (such as by reading a register's value
>>              after writing it).
>>
>> But actually on hardware without the problem(such as A15), I don't see any
>> effect without flushing store buffer explicitly.
>
>
> The problem of my platform is occurring when it has very heavy traffic such as
> HD video streaming service or very many small images display.

Could you describe your test case in a bit detail?  Which USB
applications/drivers
may trigger your URB completion miss problem? Under what kind of video
streaming service(USB video or only kind of heavy load)?

> I guess that HC could have a use-after-free problem like following situation.
>
> 1. A qtd which is not at the queue head should be removed in qh_completions().
> 2. The last->hw_next become be pointing at the next qtd but the hw_next value is delayed in write-buffer.
> 3. The qtd is removed in the list.
> 4. The qtd is freed into DMA pool and re-allocated for another urb.
> 5. HC try to process last->hw_next and it is pointing re-allocated qtd.
>
> What do you think about it? Is it possible?

I understand it might not be possible because:  when 'stopped' is set, that
said the HC might not advance the queue. But I don't understand why
'last->hw_next' is patched here under 'stopped' situation.

Even the 'stopped' case may be seldom triggered, do you know under
which condition the stopped is triggered in your problem?(stall, short read
or others)


Thanks,
-- 
Ming Lei
