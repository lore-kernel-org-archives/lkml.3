Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938AbaAVSIA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 13:08:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62986 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572AbaAVSH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 13:07:56 -0500
Message-ID: <52E008F0.3060602@redhat.com>
Date: Wed, 22 Jan 2014 13:07:44 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: Steven Noonan <steven@uplinklabs.net>,
        Linux Kernel mailing List <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Mel Gorman <mgorman@suse.de>, Alex Thorlton <athorlton@sgi.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BISECTED] Linux 3.12.7 introduces page map handling regression
References: <20140121232708.GA29787@amazon.com>	<20140122014908.GG18164@kroah.com> <CA+55aFw7fTFJtOAa+RETGSL7ZXZE4Ysk9+Xmg6_5yyLkwRtcTw@mail.gmail.com>
In-Reply-To: <CA+55aFw7fTFJtOAa+RETGSL7ZXZE4Ysk9+Xmg6_5yyLkwRtcTw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2014 09:47 PM, Linus Torvalds wrote:
> On Tue, Jan 21, 2014 at 5:49 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>>
>> Odds are this also shows up in 3.13, right?
>
> Probably. I don't have a Xen PV setup to test with (and very little
> interest in setting one up).. And I have a suspicion that it might not
> be so much about Xen PV, as perhaps about the kind of hardware.
>
> I suspect the issue has something to do with the magic _PAGE_NUMA
> tie-in with _PAGE_PRESENT. And then mprotect(PROT_NONE) ends up
> removing the _PAGE_PRESENT bit, and now the crazy numa code is
> confused.
>
> The whole _PAGE_NUMA thing is a f*cking horrible hack, and shares the
> bit with _PAGE_PROTNONE, which is why it then has that tie-in to
> _PAGE_PRESENT.

The numa balancing code should clear _PAGE_PRESENT and
set _PAGE_NUMA / _PAGE_PROTNONE.

The difference between a numa pte and a protnone pte is
the VMA permissions.

When the VMA is protnone, do_page_fault will kill the
app with a segfault. When the VMA has proper permissions,
handle_pte_fault will call do_numa_page, and numa-y things
are done.



>
> Adding Andrea to the Cc, because he's the author of that horridness.
> Putting Steven's test-case here as an attachement for Andrea, maybe
> that makes him go "Ahh, yes, silly case".
>
> Also added Kirill, because he was involved the last _PAGE_NUMA debacle.
>
> Andrea, you can find the thread on lkml, but it boils down to commit
> 1667918b6483 (backported to 3.12.7 as 3d792d616ba4) breaking the
> attached test-case (but apparently only under Xen PV). There it
> apparently causes a "BUG: Bad page map .." error.
>
> And I suspect this is another of those "this bug is only visible on
> real numa machines, because _PAGE_NUMA isn't actually ever set
> otherwise". That has pretty much guaranteed that it gets basically
> zero testing, which is not a great idea when coupled with that subtle
> sharing of the _PAGE_PROTNONE bit..
>
> It may be that the whole "Xen PV" thing is a red herring, and that
> Steven only sees it on that one machine because the one he runs as a
> PV guest under is a real NUMA machine, and all the other machines he
> has tried it on haven't been numa. So it *may* be that that "only
> under Xen PV" is a red herring. But that's just a possible guess.
>
> Christ, how I hate that _PAGE_NUMA bit. Andrea: the fact that it gets
> no testing on any normal machines is a major problem. If it was simple
> and straightforward and the code was "obviously correct", it wouldn't
> be such a problem, but the _PAGE_NUMA code definitely does not fall
> under that "simple and obviously correct" heading.
>
> Guys, any ideas?
>
>                  Linus
>

