Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474AbaFJWFJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 18:05:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59154 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002AbaFJWFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 18:05:07 -0400
Date: Wed, 11 Jun 2014 00:04:51 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Christoph Lameter <cl@gentwo.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH, RFC 00/10] THP refcounting redesign
Message-ID: <20140610220451.GG19660@redhat.com>
References: <1402329861-7037-1-git-send-email-kirill.shutemov@linux.intel.com>
 <alpine.DEB.2.10.1406101518510.19364@gentwo.org>
 <20140610204640.GA9594@node.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140610204640.GA9594@node.dhcp.inet.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 11:46:40PM +0300, Kirill A. Shutemov wrote:
> Agreed. The patchset drops tail page refcounting.

Very possibly I misread something or a later patch fixes this up, I
just did a basic code review, but from the new code of split_huge_page
it looks like it returns -EBUSY after checking the individual tail
page refcounts, so it's not clear how that defines as "dropped".

+       for (i = 0; i < HPAGE_PMD_NR; i++)
+               tail_count += page_mapcount(page + i);
+       if (tail_count != page_count(page) - 1) {
+               BUG_ON(tail_count > page_count(page) - 1);
+               compound_unlock(page);
+               spin_unlock_irq(&zone->lru_lock);
+               return -EBUSY;
