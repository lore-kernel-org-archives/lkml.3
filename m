Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964783Ab3GSKpk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 06:45:40 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:42605 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab3GSKpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 06:45:39 -0400
X-AuditID: 9c93016f-b7b50ae0000021a9-68-51e918d098dc
From: "Gioh Kim" <gioh.kim@lge.com>
To: "'Alan Stern'" <stern@rowland.harvard.edu>,
        "'Ming Lei'" <tom.leiming@gmail.com>
Cc: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "'Mark Salter'" <msalter@redhat.com>, <namhyung.kim@lge.com>,
        "'Minchan Kim'" <minchan.kim@lge.com>,
        "'Chanho Min'" <chanho.min@lge.com>,
        "'Jong-Sung Kim'" <neidhard.kim@lge.com>,
        "'linux-arm-kernel'" <linux-arm-kernel@lists.infradead.org>,
        "HyoJun Im" <hyojun.im@lge.com>
References: <CACVXFVNV-hGZpcy2ANQaca1K5yXJ88EOq1PTkJUEHEkFk9Btvw@mail.gmail.com> <Pine.LNX.4.44L0.1307181004190.1245-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1307181004190.1245-100000@iolanthe.rowland.org>
Subject: RE: [PATCH] [RFC] EHCI: add to memory barrier to updating hw_next
Date: Fri, 19 Jul 2013 19:45:36 +0900
Message-ID: <003101ce846d$1a74ffa0$4f5efee0$@lge.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQEmaxjpMNQvv+XOwJIu5BYHLh/tLZq71/Xw
Content-Language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks a lot for your replay.

> -----Original Message-----
> From: Alan Stern [mailto:stern@rowland.harvard.edu]
> Sent: Thursday, July 18, 2013 11:09 PM
> To: Ming Lei
> Cc: Gioh Kim; linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org;
> Mark Salter; namhyung.kim@lge.com; Minchan Kim; Chanho Min; Jong-Sung Kim;
> linux-arm-kernel
> Subject: Re: [PATCH] [RFC] EHCI: add to memory barrier to updating hw_next
> 
> On Thu, 18 Jul 2013, Ming Lei wrote:
> 
> > > I guess that HC could have a use-after-free problem like following
> situation.
> > >
> > > 1. A qtd which is not at the queue head should be removed in
> qh_completions().
> > > 2. The last->hw_next become be pointing at the next qtd but the
> hw_next value is delayed in write-buffer.
> > > 3. The qtd is removed in the list.
> > > 4. The qtd is freed into DMA pool and re-allocated for another urb.
> > > 5. HC try to process last->hw_next and it is pointing re-allocated
qtd.
> > >
> > > What do you think about it? Is it possible?
> >
> > I understand it might not be possible because:  when 'stopped' is set,
> > that said the HC might not advance the queue. But I don't understand
> > why 'last->hw_next' is patched here under 'stopped' situation.
> 
> It should not be possible.  When "stopped" is set, the QH gets unlinked
> and relinked before it can start up again.  Relinking involves some memory
> barriers, so the qTD will not be accessed again by the HC.
> 
> last->hw_next gets patched because the qTD might belong to some URB in
> the middle of the queue that is being unlinked.  The URBs before it and
> after it will still be active, so the queue link has to be updated.
> 


You're right. I misunderstand those codes. Please forget about it.


> > Even the 'stopped' case may be seldom triggered, do you know under
> > which condition the stopped is triggered in your problem?(stall, short
> > read or others)
> 
> I was going to ask the same question.  This particular piece of code gets
> executed _only_ when an URB is unlinked.  Not during any other kind of
> error.


I've got the problem when I listened to the mp3 file of USB HDD.
I checked the urb data when the problem occurred, the last-status value of
urb was EINPROGRESS and 
urb->unlinked was ECONNRESET. 
I think the 'stopped' case was occurred by the reset of USB port.
The block device driver did reset USB port because there is no return from
USB device.
If I made block device driver could not reset USB port, the EHCI driver
codes were not executed.
Finally the halt of HC makes 'stopped' case.

I think halt of the HC might be caused that store-buffer delays command for
HC.
When I applied the patch from https://lkml.org/lkml/2011/8/31/344 and added
a mb() into hw_next updating
to remove delay of store-buffer, My platform works well.

Can the store-buffer delay halt HC? Is it possible?

IMHO, if the qTD list is broken the HC think there is no qTD to send.
So I added mb() at hw_next update code.





> 
> Alan Stern

