Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758726Ab3AOXq2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 18:46:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44505 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933105Ab3AOXqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 18:46:22 -0500
Message-ID: <50F5EA3F.70002@zytor.com>
Date: Tue, 15 Jan 2013 15:46:07 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Gleb Natapov <gleb@redhat.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [RFCv3][PATCH 1/3] create slow_virt_to_phys()
References: <20130109185904.DD641DCE@kernel.stglabs.ibm.com> <50F5B214.5060604@zytor.com> <50F5DD45.4060603@linux.vnet.ibm.com>
In-Reply-To: <50F5DD45.4060603@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2013 02:50 PM, Dave Hansen wrote:
>
>> static inline unsigned long page_level_size(int level)
>> {
>>      return (PAGE_SIZE/PGDIR_SIZE) << (PGDIR_SHIFT*level);
>> }
>> static inline unsigned long page_level_shift(int level)
>> {
>>      return (PAGE_SHIFT-PGDIR_SHIFT) + (PGDIR_SHIFT*level);
>> }
>
> (PAGE_SHIFT-PGDIR_SHIFT) == -27, so this can't possibly work, right?
>

Ah right... sorry, got messed up in my head what that constant is about.

> How about something like this?
>
> /*
>   * Note: this only holds true for pagetable levels where PTEs can be
>   * present.  It would break if you used it on the PGD level where PAE
>   * is in use.  It basically assumes that the shift between _all_
>   * adjacent levels of the pagetables are the same as the lowest-level
>   * shift.
>   */

This comment is totally misleading.  What it refers to is the separation 
between various levels of the page hierarchy; in x86 it is always the same.

Perhaps a cleaner way to do this is:

#define PTRS_PER_PTE_SHIFT	ilog2(PTRS_PER_PTE)

> #define PG_SHIFT_PER_LEVEL (PMD_SHIFT-PAGE_SHIFT)
>
> static inline unsigned long page_level_shift(int level)
> {
> 	return PAGE_SHIFT + (level - PG_LEVEL_4K) * PG_SHIFT_PER_LEVEL;
> }
> static inline unsigned long page_level_size(int level)
> {
> 	return 1 << page_level_shift(level);
> }
>
> The generated code for page_level_size() looks pretty good, despite it
> depending on page_level_shift(), so we might as well leave it defined
> this way for simplicity:
>

Make sure to make that 1UL instead of 1; page_level_shift() should 
return int.  See below.

> 0000000000400610 <plsize>:
>    400610:       8d 7c bf fb             lea    -0x5(%rdi,%rdi,4),%edi
>    400614:       b8 01 00 00 00          mov    $0x1,%eax
>    400619:       8d 4c 3f 0c             lea    0xc(%rdi,%rdi,1),%ecx
>    40061d:       d3 e0                   shl    %cl,%eax
>    40061f:       c3                      retq

We get better code with:

static inline int page_level_shift(int level)
{
	return (PAGE_SHIFT - PTRS_PER_PTE_SHIFT) +
		level * PTRS_PER_PTE_SHIFT;
}
static inline unsigned long page_level_size(int level)
{
	return 1UL << page_level_shift(level);
}

... the resulting code has one lea instead of two:

0000000000000000 <plsize>:
    0:   8d 4c ff 03             lea    0x3(%rdi,%rdi,8),%ecx
    4:   b8 01 00 00 00          mov    $0x1,%eax
    9:   48 d3 e0                shl    %cl,%rax
    c:   c3                      retq

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

