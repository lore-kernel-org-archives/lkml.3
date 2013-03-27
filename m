Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275Ab3C0Tzz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 15:55:55 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:40096 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689Ab3C0Tzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 15:55:54 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1303261454080.2572@eggly.anvils>
References: <514C94C4.4050008@gmx.de>
	<20130325155347.75290358a6985e17fb10ad14@linux-foundation.org>
	<5151D08A.2060400@gmx.de>
	<alpine.LNX.2.00.1303261454080.2572@eggly.anvils>
Date: Wed, 27 Mar 2013 20:55:53 +0100
Message-ID: <CAFLxGvxWs2jNA6z0TrHUuc5=GWN2kv--+JScJW7v=ei62=aEgw@mail.gmail.com>
Subject: Re: linux-v3.9-rc3: BUG: Bad page map in process trinity-child6
 pte:002f9045 pmd:29e421e1
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Hugh Dickins <hughd@google.com>
Cc: Toralf Foerster <toralf.foerster@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        user-mode-linux-user@lists.sourceforge.net,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 12:03 AM, Hugh Dickins <hughd@google.com> wrote:
> On Tue, 26 Mar 2013, Toralf Foerster wrote:
>> On 03/25/2013 11:53 PM, Andrew Morton wrote:
>> > On Fri, 22 Mar 2013 18:28:36 +0100 Toralf Foerster <toralf.foerster@gmx.de> wrote:
>> >
>> >> > Using trinity I often trigger under a user mode linux image with host kernel 3.8.4
>> >> > and guest kernel linux-v3.9-rc3-244-g9217cbb the following :
>> >> > (The UML guest is a 32bit stable Gentoo Linux)
>> > I assume 3.8 is OK?
>> >
>> With UML kernel 3.7.10 (host kernel still 3.8.4) I can trigger this
>> issue too.
>> Just to clarify it - here the bug appears in the UML kernel - the host
>> kernel is ok (I can of course crash a host kernel too by trinity'ing an
>> UML guest, but that's another thread - see [1])
>>
>>
>> FWIW he trinity command is just a test of 1 syscall:
>>
>> $> trinity --children 1 --victims /mnt/nfs/n22/victims -c mremap
>>
>>
>>
>> [1] https://lkml.org/lkml/2013/3/24/174
>
> I should think it's been like this for five years, or even more: maybe
> you are the first person to try unmapping user address 0x100000 on UML;
> though it's odd that you find it using mremap than the more common munmap.

Sounds sane.
I fear trinity will find more "you are the first person to try"-bugs in UML.
I'll look at it.

> uml_setup_stubs() sets up the special vma with install_special_mapping(),
> but instead of then faulting in the two pages concerned, it has preset
> the ptes with init_stub_pte(), which did not increment page mapcount.
>
> munmap() that area (or set up another mapping in that place), and
> zap_pte_range() will decrement page mapcount negative, hence the
> "Bad page" errors.  Whereas UML uses an arch_exit_mmap() hook to
> clear the ptes at exit time, to avoid encountering such errors.
>
> I think that adding VM_PFNMAP to those install_special_mapping() flags
> would be enough to fix it (and avoid the need for the arch_exit_mmap(),
> and let vm_insert_pfn() do the work of init_stub_pte()); but I'm not
> certain that would be the approved way, and I may have missed problems
> doing it like this (which would disallow get_user_pages(), e.g. ptrace,
> on that area: which might or might not be a good thing, I don't know).
>
> I'm saying this just by examination, I've not tried any of it at all.
> Over to Richard.

:-)

-- 
Thanks,
//richard
