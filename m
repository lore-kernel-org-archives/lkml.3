Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759128Ab3KMJLB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 04:11:01 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:43976 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758941Ab3KMJKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 04:10:50 -0500
Message-ID: <52834216.2020409@vmware.com>
Date: Wed, 13 Nov 2013 10:10:46 +0100
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Daniel Vetter <daniel.vetter@ffwll.ch>
CC: dri-devel <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Linaro-mm-sig] [PATCH RFC] dma-buf/fs Add get_[file|dma_buf]_unless_doomed
References: <1383895134-4535-1-git-send-email-thellstrom@vmware.com> <20131108080638.GA14082@phenom.ffwll.local> <527CA5F3.7090605@vmware.com> <CAKMK7uEZggdDmsnhwU_riNDjia__b010ieVLB4pTb+k82xfYuA@mail.gmail.com>
In-Reply-To: <CAKMK7uEZggdDmsnhwU_riNDjia__b010ieVLB4pTb+k82xfYuA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2013 06:28 PM, Daniel Vetter wrote:
> On Fri, Nov 8, 2013 at 9:50 AM, Thomas Hellstrom <thellstrom@vmware.com> wrote:
>> This, however comes with two implications
>> 1) Once a DMA-buf is added, it stays alive at least until someone removes
>> the gem name of the exporting object, regardless whether there are any
>> external users or not. I think this is OK, but unnecessary.
> Imo that's actually fairly nice guarantee, since if you have dumb
> userspace that always re-does the export/import dance accross a device
> the importer can check whether it has the same object already
> somewhere.
>
> Without this guarantee we'll end up mapping the same underlying
> storage multiple times. btw this is the part where userspace can still
> trick the kernel. I have testcases for it, but thus far lacked the
> time to implement the fix. It needs a combination of nasty+dumb
> userspace though to be a real issue.
>
>> 2) If someone decides to get a new handle from fd, and the gem name has
>> already been removed, a new gem name is created for the exporting dma-buf by
>> the requested client. This is why I can't do the same. Because of the
>> relaxed RCU locking, I can't re-add a name to a TTM base object. Removing it
>> is always part of the object destruction sequence.
> Yeah, we seem to have a bit a split in how gem handles userspace
> handles and the weak references they cause and how ttm does it. ttm
> uses kref_get_unless_zero for weak references. Atm gem objects
> themselves still need the big mutex, but the only blocker is the mmap
> code (actually the has table). My plan (somewhere on my todo list) is
> to do the same trick for that weak reference from the mmap offset
> lookup structure.
>
> Anyway I just wanted to point out with my original mail that this
> problem can be solved in different ways. But I see that the weak ref
> approach with a possibly failing get call suits the current ttm design
> (and so I guess vmwgfx) a bit better.

Yes. But anyway, I'll keep that get_dma_buf_unless_doomed() in local 
code until someone else finds it useful.
The fs guys had issues with it as well.

Thanks,
Thomas



> Cheers, Daniel
