Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933332Ab3AOWvB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:51:01 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:56892 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933305Ab3AOWu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:50:57 -0500
Message-ID: <50F5DD45.4060603@linux.vnet.ibm.com>
Date: Tue, 15 Jan 2013 14:50:45 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Gleb Natapov <gleb@redhat.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [RFCv3][PATCH 1/3] create slow_virt_to_phys()
References: <20130109185904.DD641DCE@kernel.stglabs.ibm.com> <50F5B214.5060604@zytor.com>
In-Reply-To: <50F5B214.5060604@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011522-4834-0000-0000-0000029DA1AE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2013 11:46 AM, H. Peter Anvin wrote:
> I object to this switch statement.  If we are going to create new
> primitives, let's create a primitive that embody this and put it in
> pgtypes_types.h, especially since it is simply an algorithmic operation:

Yeah, that's a good point.  I did at least copy part of the switch from
elsewhere in the file, so there's certainly room for consolidating some
things.

> static inline unsigned long page_level_size(int level)
> {
>     return (PAGE_SIZE/PGDIR_SIZE) << (PGDIR_SHIFT*level);
> }
> static inline unsigned long page_level_shift(int level)
> {
>     return (PAGE_SHIFT-PGDIR_SHIFT) + (PGDIR_SHIFT*level);
> }

(PAGE_SHIFT-PGDIR_SHIFT) == -27, so this can't possibly work, right?

How about something like this?

/*
 * Note: this only holds true for pagetable levels where PTEs can be
 * present.  It would break if you used it on the PGD level where PAE
 * is in use.  It basically assumes that the shift between _all_
 * adjacent levels of the pagetables are the same as the lowest-level
 * shift.
 */
#define PG_SHIFT_PER_LEVEL (PMD_SHIFT-PAGE_SHIFT)

static inline unsigned long page_level_shift(int level)
{
	return PAGE_SHIFT + (level - PG_LEVEL_4K) * PG_SHIFT_PER_LEVEL;
}
static inline unsigned long page_level_size(int level)
{
	return 1 << page_level_shift(level);
}

The generated code for page_level_size() looks pretty good, despite it
depending on page_level_shift(), so we might as well leave it defined
this way for simplicity:

0000000000400610 <plsize>:
  400610:       8d 7c bf fb             lea    -0x5(%rdi,%rdi,4),%edi
  400614:       b8 01 00 00 00          mov    $0x1,%eax
  400619:       8d 4c 3f 0c             lea    0xc(%rdi,%rdi,1),%ecx
  40061d:       d3 e0                   shl    %cl,%eax
  40061f:       c3                      retq

I'll send out another series doing this.

