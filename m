Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758815AbaGOLdb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 07:33:31 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:35521 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758628AbaGOLd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 07:33:29 -0400
MIME-Version: 1.0
In-Reply-To: <20140715105547.C4832E00A3@blue.fi.intel.com>
References: <748020aaaf5c5c2924a16232313e0175.squirrel@webmail.tu-dortmund.de>
	<alpine.LSU.2.11.1407141209160.17242@eggly.anvils>
	<CALYGNiM9Fu9-i7hXMQNTUP69RfydN+2NqO29wZYd+4Gn25GbCQ@mail.gmail.com>
	<20140715105547.C4832E00A3@blue.fi.intel.com>
Date: Tue, 15 Jul 2014 15:33:29 +0400
Message-ID: <CALYGNiM3tQUCvSPxPbum5jkhNOPeKpAVL=x3ggFmZH-QaqULcA@mail.gmail.com>
Subject: Re: PROBLEM: repeated remap_file_pages on tmpfs triggers bug on
 process exit
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>, Ingo Korb <ingo.korb@tu-dortmund.de>,
        Ning Qu <quning@google.com>, Dave Jones <davej@redhat.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 2:55 PM, Kirill A. Shutemov
<kirill.shutemov@linux.intel.com> wrote:
> Konstantin Khlebnikov wrote:
>> It seems boundng logic in do_fault_around is wrong:
>>
>> start_addr = max(address & fault_around_mask(), vma->vm_start);
>> off = ((address - start_addr) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1);
>> pte -= off;
>> pgoff -= off;
>>
>> Ok, off  <= 511, but it might be bigger than pte offset in pte table.
>
> I don't see how it possible: fault_around_mask() cannot be more than 0x1ff000
> (x86-64, fault_around_bytes == 2M). It means start_addr will be aligned to 2M
> boundary in this case which is start of the page table pte belong to.
>
> Do I miss something?

Nope, you're right. This fixes kernel crash but not the original problem.

Problem is caused by calling do_fault_around for _non-linear_ faiult.
In this case pgoff is shifted and might become negative during calculation.
I'll send another patch.

>
> --
>  Kirill A. Shutemov
