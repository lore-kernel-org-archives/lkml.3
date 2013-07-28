Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301Ab3G1J3A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 05:29:00 -0400
Received: from relay.parallels.com ([195.214.232.42]:54293 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021Ab3G1J27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 05:28:59 -0400
Message-ID: <51F4E446.6060907@parallels.com>
Date: Sun, 28 Jul 2013 13:28:38 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>,
        Cyrill Gorcunov <gorcunov@gmail.com>
CC: Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>,
        "Xiao Guangrong" <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "Stephen Rothwell" <sfr@canb.auug.org.au>
Subject: Re: [PATCH] mm: Save soft-dirty bits on file pages
References: <20130726201807.GJ8661@moon> <CALCETrUJa-Y40vnb6YOPry0dCXb3zCQ0y19i2yHWdzKR75HUzg@mail.gmail.com> <51F41FA0.6060205@parallels.com>
In-Reply-To: <51F41FA0.6060205@parallels.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [89.169.95.100]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2013 11:29 PM, Pavel Emelyanov wrote:
> On 07/27/2013 12:55 AM, Andy Lutomirski wrote:
>> On Fri, Jul 26, 2013 at 1:18 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>>> Andy reported that if file page get reclaimed we loose soft-dirty bit
>>> if it was there, so save _PAGE_BIT_SOFT_DIRTY bit when page address
>>> get encoded into pte entry. Thus when #pf happens on such non-present
>>> pte we can restore it back.
>>>
>>
>> Unless I'm misunderstanding this, it's saving the bit in the
>> non-present PTE.  This sounds wrong -- what happens if the entire pmd
>> (or whatever the next level is called) gets zapped?  (Also, what
>> happens if you unmap a file and map a different file there?)
> 
> The whole pte gets zapped on vma unmap, and in this case forgetting
> the soft-dirty bit completely is OK.

I mean -- soft-dirty bits denote changes in the vm area, if you remove
one, then it can be found out from the /proc/pid/maps file that the
vma has disappeared.

But one problem really went unnoticed here -- if we map a new vma in 
place of some old one with the same flags and prots. It looks like we 
need a vma soft-dirty mark, that is set on mmap and mremap, is cleared 
on soft dirty clear and is propagated into pte pagemap bits.

>> --Andy

Thanks,
Pavel
