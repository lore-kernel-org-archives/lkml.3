Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932847AbaFCPRJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 11:17:09 -0400
Received: from mail-qg0-f52.google.com ([209.85.192.52]:56300 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932225AbaFCPRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 11:17:07 -0400
MIME-Version: 1.0
In-Reply-To: <5384DD67.3010408@intel.com>
References: <1401199802-10212-1-git-send-email-matt.fleming@intel.com>
	<5384DD67.3010408@intel.com>
Date: Tue, 3 Jun 2014 16:17:06 +0100
Message-ID: <CAL01qpvbDRnE0mHBttomcqYtT6i9OaG_kvnj6BMXtqYn4cP1FQ@mail.gmail.com>
Subject: Re: [PATCH] mm: bootmem: Check pfn_valid() before accessing struct page
From: "Fleming, Matt" <matt.fleming@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 May 2014 19:45, Dave Hansen <dave.hansen@intel.com> wrote:
>
> I don't think this is quite right.  pfn_valid() tells us whether we have
> a 'struct page' there or not.  *BUT*, it does not tell us whether it is
> RAM that we can actually address and than can be freed in to the buddy
> allocator.
>
> I think sparsemem is where this matters.  Let's say mem= caused lowmem
> to end in the middle of a section (or that 896MB wasn't
> section-aligned).  Then someone calls free_bootmem_late() on an area
> that is in the last section, but _above_ max_mapnr.  It'll be
> pfn_valid(), we'll free it in to the buddy allocator, and we'll blam the
> first time we try to write to a bogus vaddr after a phys_to_virt().

Ah, the sparsemem case wasn't something I'd considered. Thanks Dave.

> At a higher level, I don't like the idea of the bootmem code papering
> over bugs when somebody calls in to it trying to _free_ stuff that's not
> memory (as far as the kernel is concerned).
>
> I think the right thing to do is to call in to the e820 code and see if
> the range is E820_RAM before trying to bootmem-free it.

OK, this makes sense. I'll try that approach and see if it also fixes
Alan's problem.
