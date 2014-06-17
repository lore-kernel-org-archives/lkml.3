Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933829AbaFQUcW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 16:32:22 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:30721 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933502AbaFQUcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 16:32:18 -0400
Message-ID: <53A0A5AF.3000509@oracle.com>
Date: Tue, 17 Jun 2014 16:31:43 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: 3.15-rc8 oops in copy_page_rep after page fault.
References: <20140606174317.GA1741@redhat.com> <CA+55aFxiOsceOsm7zYyvFAxDF3=gxUXj=_61Nce3VkELfJr7cg@mail.gmail.com> <20140606184926.GA16083@node.dhcp.inet.fi> <5392108F.8060405@oracle.com> <alpine.LSU.2.11.1406151957560.5820@eggly.anvils>
In-Reply-To: <alpine.LSU.2.11.1406151957560.5820@eggly.anvils>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2014 11:01 PM, Hugh Dickins wrote:
> On Fri, 6 Jun 2014, Sasha Levin wrote:
>> > On 06/06/2014 02:49 PM, Kirill A. Shutemov wrote:
>>> > > On Fri, Jun 06, 2014 at 11:26:14AM -0700, Linus Torvalds wrote:
>>>>> > >> > On Fri, Jun 6, 2014 at 10:43 AM, Dave Jones <davej@redhat.com> wrote:
>>>>>>> > >>> > >
>>>>>>> > >>> > > RIP: 0010:[<ffffffff8b3287b5>]  [<ffffffff8b3287b5>] copy_page_rep+0x5/0x10
>>>>> > >> > 
>>>>> > >> > Ok, it's the first iteration of "rep movsq" (%rcx is still 0x200) for
>>>>> > >> > copying a page, and the pages are
>>>>> > >> > 
>>>>> > >> >   RSI: ffff880052766000
>>>>> > >> >   RDI: ffff880014efe000
>>>>> > >> > 
>>>>> > >> > which both look like reasonable kernel addresses. So I'm assuming it's
>>>>> > >> > DEBUG_PAGEALLOC that makes this trigger, and since the error code is
>>>>> > >> > 0, and the CR2 value matches RSI, it's the source page that seems to
>>>>> > >> > have been freed.
>>>>> > >> > 
>>>>> > >> > And I see absolutely _zero_ reason for wht your 64k mmap_min_addr
>>>>> > >> > should make any difference what-so-ever. That's just odd.
>>>>> > >> > 
>>>>> > >> > Anyway, can you try to figure out _which_ copy_user_highpage() it is
>>>>> > >> > (by looking at what is around the call-site at
>>>>> > >> > "handle_mm_fault+0x1e0". The fact that we have a stale
>>>>> > >> > do_huge_pmd_wp_page() on the stack makes me suspect that we have hit
>>>>> > >> > that VM_FAULT_FALLBACK case and this is related to splitting. Adding a
>>>>> > >> > few more people explicitly to the cc in case anybody sees anything
>>>>> > >> > (original email on lkml and linux-mm for context, guys).
>>> > > Looks like a known false positive from DEBUG_PAGEALLOC:
>>> > > 
>>> > > https://lkml.org/lkml/2013/3/29/103
>>> > > 
>>> > > We huge copy page in do_huge_pmd_wp_page() without ptl taken and the page
>>> > > can be splitted and freed under us. Once page is copied we take ptl again
>>> > > and recheck that PMD is not changed. If changed, we don't use new page.
>>> > > Not a bug, never triggered with DEBUG_PAGEALLOC disabled.
>>> > > 
>>> > > It would be nice to have a way to mark this kind of speculative access.
>> > 
>> > FWIW, this issue makes fuzzing with DEBUG_PAGEALLOC nearly impossible since
>> > this thing is so common we never get to do anything "fun" before this issue
>> > triggers.
>> > 
>> > A fix would be more than welcome.
> Please give this a try: I think it's right, but I could easily be wrong.
> 
> 
> [PATCH] thp: fix DEBUG_PAGEALLOC oops in copy_page_rep
> 
> Trinity has for over a year been reporting a CONFIG_DEBUG_PAGEALLOC
> oops in copy_page_rep() called from copy_user_huge_page() called from
> do_huge_pmd_wp_page().
> 
> I believe this is a DEBUG_PAGEALLOC false positive, due to the source
> page being split, and a tail page freed, while copy is in progress; and
> not a problem without DEBUG_PAGEALLOC, since the pmd_same() check will
> prevent a miscopy from being made visible.
> 
> Fix by adding get_user_huge_page() and put_user_huge_page(): reducing
> to the usual get_page() and put_page() on head page in the usual config;
> but get and put references to all of the tail pages when DEBUG_PAGEALLOC.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>

Works great, thanks Hugh!


Thanks,
Sasha
