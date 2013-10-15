Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759574Ab3JOSzr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 14:55:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43579 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759341Ab3JOSzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 14:55:46 -0400
Date: Tue, 15 Oct 2013 20:55:10 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: mm: fix BUG in __split_huge_page_pmd
Message-ID: <20131015185510.GH3479@redhat.com>
References: <alpine.LNX.2.00.1310150358170.11905@eggly.anvils>
 <20131015143407.GE3479@redhat.com>
 <20131015144827.C45DDE0090@blue.fi.intel.com>
 <alpine.LNX.2.00.1310151029040.12481@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1310151029040.12481@eggly.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 10:53:10AM -0700, Hugh Dickins wrote:
> I'm afraid Andrea's mail about concurrent madvises gives me far more
> to think about than I have time for: seems to get into problems he
> knows a lot about but I'm unfamiliar with.  If this patch looks good
> for now on its own, let's put it in; but no problem if you guys prefer
> to wait for a fuller solution of more problems, we can ride with this
> one internally for the moment.

I'm very happy with the patch and I think it's a correct fix for the
COW scenario which is deterministic so the looping makes a meaningful
difference for it. If we wouldn't loop, part of the copied page
wouldn't be zapped after the COW.

The patch also solves the false positive for the other non
deterministic scenario of two MADV_DONTNEED (one partial, one whole)
plus a concurrent page fault.

> And I should admit that the crash has occurred too rarely for us yet
> to be able to judge whether this patch actually fixes it in practice.

It is very rare indeed, and thanks to the BUG_ON it cannot lead to any
user or kernel memory corruption, but it's a nuisance we need to
fix. I only have the two stack traces in the two links I posted in the
previous email and I also don't have the traces of the other CPU.
