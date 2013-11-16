Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab3KPWtv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 17:49:51 -0500
Received: from blu0-omc1-s3.blu0.hotmail.com ([65.55.116.14]:13630 "EHLO
	blu0-omc1-s3.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752682Ab3KPWto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 17:49:44 -0500
X-TMN: [TM1vwKUntIIov+gEgHFEzFuQ4oMGYm8V]
X-Originating-Email: [dave.anglin@bell.net]
Message-ID: <BLU0-SMTP37F8F388A1DE7927BB765997FA0@phx.gbl>
From: John David Anglin <dave.anglin@bell.net>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
In-Reply-To: <1384641466.3614.19.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH] aio: fix D-cache aliasing issues
References: <20131115220529.GA3160@ls3530.box> <1384555325.2003.39.camel@dabdike.int.hansenpartnership.com> <20131116200717.GA18939@schnuecks.de> <1384639590.3614.16.camel@dabdike.int.hansenpartnership.com> <BLU0-SMTP77F560605C9D02E4CA7C6997FA0@phx.gbl> <1384641466.3614.19.camel@dabdike.int.hansenpartnership.com>
Content-Type: text/plain; charset="US-ASCII"; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0 (Apple Message framework v936)
Date: Sat, 16 Nov 2013 17:49:33 -0500
CC: Simon Baatz <gmbnomis@gmail.com>, Helge Deller <deller@gmx.de>,
        Benjamin LaHaise <bcrl@kvack.org>, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org
X-Mailer: Apple Mail (2.936)
X-OriginalArrivalTime: 16 Nov 2013 22:49:43.0116 (UTC) FILETIME=[23E690C0:01CEE31E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16-Nov-13, at 5:37 PM, James Bottomley wrote:

> On Sat, 2013-11-16 at 17:32 -0500, John David Anglin wrote:
>> On 16-Nov-13, at 5:06 PM, James Bottomley wrote:
>>
>>> On Sat, 2013-11-16 at 21:07 +0100, Simon Baatz wrote:
>>>> On Fri, Nov 15, 2013 at 02:42:05PM -0800, James Bottomley wrote:
>>>>> On Fri, 2013-11-15 at 23:05 +0100, Helge Deller wrote:
>>>>>> When a user page mapping is released via kunmap*() functions, the
>>>>>> D-cache needs
>>>>>> to be flushed via flush_dcache_page() to avoid D-cache aliasing
>>>>>> issues.
>>>>>>
>>>>>> This patch fixes aio on the parisc platform (and probably  
>>>>>> others).
>>>>>
>>>>> This should be flush_kernel_dcache_page().  flush_dcache_page() is
>>>>> for
>>>>> full coherency but for unmap, we know the page was coherent going
>>>>> in and
>>>>> may have been modified by the kernel, so only the kernel view
>>>>> needs to
>>>>> be sync'd.  Technically, by the kernel API, the flush should be  
>>>>> done
>>>>> *before* unmapping.  This would have mattered on parisc until we  
>>>>> did
>>>>> flush via tmpalias which means we no-longer care if the mapping
>>>>> for the
>>>>> flush exists or not because we always recreate it via the tmpalias
>>>>> pages.
>>>>
>>>> On ARM, flush_kernel_dcache_page() actually assumes that the page  
>>>> is
>>>> mapped.  It avoids double flushing of highmem pages by not flushing
>>>> in those cases where kunmap_atomic() already takes care of  
>>>> flushing.
>>>
>>> On Parisc, kmap/kunmap is currently a nop.  However, if we ever
>>> implemented highmem, we would also need to flush before we unmap,
>>> which
>>> is why the flush needs to go before the kunmap.
>>
>> Not quite.  On PA8800/PA8900, we currently do a flush in kunmap.
>>
>> I'm fairly certain from discussion with Helge that he saw this bug on
>> a C8000
>> with PA8800 processor.  In that case, adding a call to
>> flush_kernel_dcache_page()
>> just duplicates the call in kunmap().
>
> Yes, if that's true it won't be the solution.

The calls may be needed for the two cases where the page is changed,  
but I don't
know how to avoid double flush on PA8800/PA8900 without changing the  
primatives.

Dave
--
John David Anglin	dave.anglin@bell.net



