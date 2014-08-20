Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303AbaHTMHD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 08:07:03 -0400
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:50862 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174AbaHTMGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 08:06:09 -0400
Date: Wed, 20 Aug 2014 13:05:11 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: jgross@suse.com
Cc: stefan.bader@canonical.com, toshi.kani@hp.com,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com, ville.syrjala@linux.intel.com, hpa@zytor.com,
        x86@kernel.org
Subject: Re: [PATCH RFC 0/3] x86: Full support of PAT
Message-ID: <20140820130511.771aeafa@alan.etchedpixels.co.uk>
In-Reply-To: <1408454745-32358-1-git-send-email-jgross@suse.com>
References: <1408454745-32358-1-git-send-email-jgross@suse.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The Linux kernel currently supports only 4 different cache modes. The PAT MSR
> is set up in a way that the setting of _PAGE_PAT in a pte doesn't matter: the
> top 4 entries in the PAT MSR are the same as the 4 lower entries.
> 
> This results in the kernel not supporting e.g. write-through mode. Especially
> this cache mode would speed up drivers of video cards which now have to use
> uncached accesses.


Pentium II erratum A52 (and similar on quite a few other processors)

Problem: The Page Attribute Table (PAT) contains eight entries, which
must all be initialized and considered when setting up memory types for
the Pentium II processor. However, in Mode B or Mode C paging, the upper
four entries do not function correctly for 4-Kbyte pages. Specifically,
bit seven of page table entries that translate addresses to 4-Kbyte pages
should be used as the upper bit of a three-bit index to determine the PAT
entry that specifies the memory type for the page. When Mode B (CR4.PSE =
1) and/or Mode C (CR4.PAE) are enabled, the processor forces this bit to
zero when determining the memory type regardless of the value in the page
table entry. The upper four entries of the PAT function correctly for
2-Mbyte and 4-Mbyte large pages (specified by bit 12 of the page
directory entry for those translations). Implication: Only the lower four
PAT entries are useful for 4 KB translations when Mode B or C paging is
used. In Mode A paging (4-Kbyte pages only), all eight entries may be
used. All eight entries may be used for large pages in Mode B or C paging.



Doing this stuff for Xen also IMHO makes no sense at all. We shouldn't
have a kernel full of crap to deal with Xen-isms. IFF it means the
changes can also implement a mix of four PAT entries on Pentium-M or
earlier CPUs with PAT errata, and the full PAT on processors without
errata then IMHO it becomes a whole world more interesting.

Alan
