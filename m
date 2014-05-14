Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166AbaENRYi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 13:24:38 -0400
Received: from www.sr71.net ([198.145.64.142]:55941 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751646AbaENRYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 13:24:36 -0400
Message-ID: <5373A6D2.9050304@sr71.net>
Date: Wed, 14 May 2014 10:24:34 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Anthony Iliopoulos <anthony.iliopoulos@huawei.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Shay Goikhman <shay.goikhman@huawei.com>,
        Paul Mundt <paul.mundt@huawei.com>,
        Carlos Villavieja <villavieja@hps.utexas.edu>,
        Nacho Navarro <nacho.navarro@bsc.es>,
        Avi Mendelson <avi.mendelson@tce.technion.ac.il>,
        Yoav Etsion <yetsion@tce.technion.ac.il>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        linux-arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] x86, hugetlb: add missing TLB page invalidation for hugetlb_cow()
References: <20140514092948.GA17391@server-36.huawei.corp> <5372A067.9010808@sr71.net> <20140515170035.GA15779@server-36.huawei.corp>
In-Reply-To: <20140515170035.GA15779@server-36.huawei.corp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2014 10:00 AM, Anthony Iliopoulos wrote:
> I have actually also wondered about another related thing:
> even when we actually do invalidate the page, there may still be a
> race between a thread on a core that reads the page in some tight
> loop (e.g. on a spinlock), and the page fault handler running on
> a different core, at the point where the pte is set. Since we
> invalidate the page via the TLB shootdowns *before* we update
> the pte (this is true for all do_wp_page(), do_huge_pmd_wp_page()
> as well as hugetlb_cow()), there may be some tiny window where the
> thread might re-read the page before the pte is set.

Don't forget about the "clear" part.  ptep_clear_flush() does:

        pte = ptep_get_and_clear(mm, address, ptep);
        if (pte_accessible(mm, pte))
                flush_tlb_page(vma, address);

so it makes the pte !present and guarantees that any other CPUs looking
at it after the flush but before the set_pte() will also end up in the
page fault handler, and they'll wait until the first fault has finished
with the page tables.
