Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab3GYInm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 04:43:42 -0400
Received: from relay.parallels.com ([195.214.232.42]:35244 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab3GYIni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 04:43:38 -0400
Message-ID: <51F0E52C.1080101@parallels.com>
Date: Thu, 25 Jul 2013 12:43:24 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Hush Bensen <hush.bensen@gmail.com>
CC: Andy Lutomirski <luto@amacapital.net>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] mm: Save soft-dirty bits on swapped pages
References: <CALCETrXYnkonpBANnUuX+aJ=B=EYFwecZO27yrqcEU8WErz9DA@mail.gmail.com> <20130724163734.GE24851@moon> <CALCETrVWgSMrM2ujpO092ZLQa3pWEQM4vdmHhCVUohUUcoR8AQ@mail.gmail.com> <20130724171728.GH8508@moon> <1374687373.7382.22.camel@dabdike> <CALCETrV5MD1qCQsyz4=t+QW1BJuTBYainewzDfEaXW12S91K=A@mail.gmail.com> <20130724181516.GI8508@moon> <CALCETrV5NojErxWOc2RpuYKE0g8FfOmKB31oDz46CRu27hmDBA@mail.gmail.com> <20130724185256.GA24365@moon> <51F0232D.6060306@parallels.com> <20130724190453.GJ8508@moon> <CALCETrVRQBLrQBL8_Zu0VqBRkDXXr2np57-gt4T59A4jG9jMZw@mail.gmail.com> <51F0D3CA.3080902@parallels.com> <51F0E144.9030304@gmail.com>
In-Reply-To: <51F0E144.9030304@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.16.114]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2013 12:26 PM, Hush Bensen wrote:
> On 07/25/2013 03:29 PM, Pavel Emelyanov wrote:
>> On 07/24/2013 11:40 PM, Andy Lutomirski wrote:
>>> On Wed, Jul 24, 2013 at 12:04 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>>>> On Wed, Jul 24, 2013 at 10:55:41PM +0400, Pavel Emelyanov wrote:
>>>>>> Well, some part of information already lays in pte (such as 'file' bit,
>>>>>> swap entries) so it looks natural i think to work on this level. but
>>>>>> letme think if use page struct for that be more convenient...
>>>>> It hardly will be. Consider we have a page shared between two tasks,
>>>>> then first one "touches" it and soft-dirty is put onto his PTE and,
>>>>> subsequently, the page itself. The we go and clear sofr-dirty for the
>>>>> 2nd task. What should we do with the soft-dirty bit on the page?
>>>> Indeed, this won't help. Well then, bippidy-boppidy-boo, our
>>>> pants are metaphorically on fire (c)
>>> Hmm.  So there are at least three kinds of memory:
>>>
>>> Anonymous pages: soft-dirty works
>>> Shared file-backed pages: soft-dirty does not work
>>> Private file-backed pages: soft-dirty works (but see below)
>> The shared file-backed pages case works, but unmap-map case doesn't
> 
> What's the meaning of unmap-map case?

Unmap is what happens when Linux runs out of memory, starts memory
reclaim procedure and removes a page from task's address space, replacing
the respective pte with an information where (in swap or in file) the
page can be found.

Map is what occurs when the task touches the unmapped page again, the
respective page is read back from file/swap and the respective pte if
filled with its pfn.

This patch fixes the soft-dirty bit preservation during the unmap-map cycle
for pages, that go to swap.

Sorry for confusion.

>> preserve the soft-dirty bit. Just like the private file did. We'll
>> fix this case next.

Thanks,
Pavel
