Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759206Ab3EAHi0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 03:38:26 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:59900 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108Ab3EAHiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 03:38:18 -0400
Message-ID: <5180C663.7080803@gmail.com>
Date: Wed, 01 May 2013 15:38:11 +0800
From: Will Huck <will.huckk@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jerome Marchand <jmarchan@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH] swap: redirty page if page write fails on swap file
References: <516E918B.3050309@redhat.com> <20130422133746.ffbbb70c0394fdbf1096c7ee@linux-foundation.org> <5177AC75.7090101@redhat.com>
In-Reply-To: <5177AC75.7090101@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jerome,
On 04/24/2013 05:57 PM, Jerome Marchand wrote:
> On 04/22/2013 10:37 PM, Andrew Morton wrote:
>> On Wed, 17 Apr 2013 14:11:55 +0200 Jerome Marchand <jmarchan@redhat.com> wrote:
>>
>>> Since commit 62c230b, swap_writepage() calls direct_IO on swap files.
>>> However, in that case page isn't redirtied if I/O fails, and is therefore
>>> handled afterwards as if it has been successfully written to the swap
>>> file, leading to memory corruption when the page is eventually swapped
>>> back in.
>>> This patch sets the page dirty when direct_IO() fails. It fixes a memory
>>> corruption that happened while using swap-over-NFS.
>>>
>>> ...
>>>
>>> --- a/mm/page_io.c
>>> +++ b/mm/page_io.c
>>> @@ -222,6 +222,8 @@ int swap_writepage(struct page *page, struct writeback_control *wbc)
>>>   		if (ret == PAGE_SIZE) {
>>>   			count_vm_event(PSWPOUT);
>>>   			ret = 0;
>>> +		} else {
>>> +			set_page_dirty(page);
>>>   		}
>>>   		return ret;
>>>   	}
>> So what happens to the page now?  It remains dirty and the kernel later
>> tries to write it again?
> Yes. Also, AS_EIO or AS_ENOSPC is set to the address space flags (in this
> case, swapper_space).

After set AS_EIO or AS_ENOSPC, we can't touch swapper_space any more,  
correct?

>
>> And if that write also fails, the page is
>> effectively leaked until process exit?
> AFAICT, there is no special handling for that page afterwards, so if all
> subsequent attempts fail, it's indeed going to stay in memory until freed.
>
> Jerome
>
>
>>
>> Aside: Mel, __swap_writepage() is fairly hair-raising.  It unlocks the
>> page before doing the IO and doesn't set PageWriteback().  Why such an
>> exception from normal handling?
>>
>> Also, what is protecting the page from concurrent reclaim or exit()
>> during the above swap_writepage()?
>>
>> Seems that the code needs a bunch of fixes or a bunch of comments
>> explaining why it is safe and why it has to be this way.
>>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

