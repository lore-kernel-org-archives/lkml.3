Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462Ab3G0RGX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 13:06:23 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:63780 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407Ab3G0RGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 13:06:22 -0400
MIME-Version: 1.0
In-Reply-To: <20130727062512.GC8508@moon>
References: <20130726201807.GJ8661@moon> <CALCETrUJa-Y40vnb6YOPry0dCXb3zCQ0y19i2yHWdzKR75HUzg@mail.gmail.com>
 <20130726211844.GB8508@moon> <CALCETrW7Ukh8KfKzpNgRc1D_5OK1o7bmEmFbtQTYoSoFiOSeKw@mail.gmail.com>
 <20130727062512.GC8508@moon>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sat, 27 Jul 2013 10:06:01 -0700
Message-ID: <CALCETrWbF_e98w0d9-0tLOaTUv-mZv_RQgqOpuNiVaDOacHT0g@mail.gmail.com>
Subject: Re: [PATCH] mm: Save soft-dirty bits on file pages
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 11:25 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> On Fri, Jul 26, 2013 at 02:36:51PM -0700, Andy Lutomirski wrote:
>> >> Unless I'm misunderstanding this, it's saving the bit in the
>> >> non-present PTE.  This sounds wrong -- what happens if the entire pmd
>> >
>> > It's the same as encoding pgoff in pte entry (pte is not present),
>> > but together with pgoff we save soft-bit status, later on #pf we decode
>> > pgoff and restore softbit back if it was there, pte itself can't disappear
>> > since it holds pgoff information.
>>
>> Isn't that only the case for nonlinear mappings?
>
> Andy, I'm somehow lost, pte either exist with file encoded, either not,
> when pud/ptes are zapped and any access to it should cause #pf pointing
> kernel to read/write data from file to a page, if it happens on write
> the pte is obtaining dirty bit (which always set together with soft
> bit).

Hmm.  I may have been wrong.

By my reading of this stuff, when a pte is freed to reclaim memory, if
it's an un-cowed file mapping, it's cleared completely by
zap_pte_range -- no swap entry is left behind.  That's this code in
zap_pte_range:

				/*
				 * unmap_shared_mapping_pages() wants to
				 * invalidate cache without truncating:
				 * unmap shared but keep private pages.
				 */
				if (details->check_mapping &&
				    details->check_mapping != page->mapping)
					continue;

In theory, if you map 2MB (on x86_64) of a file as MAP_PRIVATE,
aligned, then you get a whole pmd.  If you don't write any of it
(triggering COW), the kernel could, in theory, free all those ptes, so
you can't save any state in there.  (I can't find any code that does
this, though.)

That being said, a MAP_PRIVATE, un-cowed mapping must be clean -- if
it had been (soft-)dirtied, it would also have been cowed.  So you
might be okay.


--Andy
