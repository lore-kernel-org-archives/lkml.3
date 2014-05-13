Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198AbaEMWpG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 18:45:06 -0400
Received: from www.sr71.net ([198.145.64.142]:48555 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687AbaEMWo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 18:44:58 -0400
Message-ID: <5372A067.9010808@sr71.net>
Date: Tue, 13 May 2014 15:44:55 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Anthony Iliopoulos <anthony.iliopoulos@huawei.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org,
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
References: <20140514092948.GA17391@server-36.huawei.corp>
In-Reply-To: <20140514092948.GA17391@server-36.huawei.corp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2014 02:29 AM, Anthony Iliopoulos wrote:
> The invalidation is required in order to maintain proper semantics
> under CoW conditions. In scenarios where a process clones several
> threads, a thread operating on a core whose DTLB entry for a
> particular hugepage has not been invalidated, will be reading from
> the hugepage that belongs to the forked child process, even after
> hugetlb_cow().
> 
> The thread will not see the updated page as long as the stale DTLB
> entry remains cached, the thread attempts to write into the page,
> the child process exits, or the thread gets migrated to a different
> processor.

No to be too nitpicky, but this applies to ITLB too, right?

I believe this bug came all the way back from:

> commit 1e8f889b10d8d2223105719e36ce45688fedbd59
> Author: David Gibson <david@gibson.dropbear.id.au>
> Date:   Fri Jan 6 00:10:44 2006 -0800
> 
>     [PATCH] Hugetlb: Copy on Write support

It was probably the first time that we ever changed an _existing_
hugetlbfs pte, and that patch probably just missed the TLB flush because
none of the other pte-setting hugetlb.c code needed TLB flushes.

The bogus x86 version of huge_ptep_clear_flush() came from the s390
guys, so double-shame on IBM! :P

> commit 8fe627ec5b7c47b1654dff50536d9709863295a3
> Author: Gerald Schaefer <gerald.schaefer@de.ibm.com>
> Date:   Mon Apr 28 02:13:28 2008 -0700
> 
>     hugetlbfs: add missing TLB flush to hugetlb_cow()

This is probably an opportunity for all the other architecture
maintainers to make sure that they have proper copies of
huge_ptep_clear_flush().

I went through the hugetlb code on x86 and couldn't find another TLB
flush that fixes this issue, and I believe this is correct, so:

Acked-by: Dave Hansen <dave.hansen@intel.com>
