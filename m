Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400AbaHTMfh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 08:35:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45366 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752688AbaHTMfg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 08:35:36 -0400
Message-ID: <53F49615.3030101@suse.com>
Date: Wed, 20 Aug 2014 14:35:33 +0200
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: stefan.bader@canonical.com, toshi.kani@hp.com,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com, ville.syrjala@linux.intel.com, hpa@zytor.com,
        x86@kernel.org
Subject: Re: [PATCH RFC 0/3] x86: Full support of PAT
References: <1408454745-32358-1-git-send-email-jgross@suse.com> <20140820130511.771aeafa@alan.etchedpixels.co.uk>
In-Reply-To: <20140820130511.771aeafa@alan.etchedpixels.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2014 02:05 PM, One Thousand Gnomes wrote:
>> The Linux kernel currently supports only 4 different cache modes. The PAT MSR
>> is set up in a way that the setting of _PAGE_PAT in a pte doesn't matter: the
>> top 4 entries in the PAT MSR are the same as the 4 lower entries.
>>
>> This results in the kernel not supporting e.g. write-through mode. Especially
>> this cache mode would speed up drivers of video cards which now have to use
>> uncached accesses.
>
>
> Pentium II erratum A52 (and similar on quite a few other processors)
>
> Problem: The Page Attribute Table (PAT) contains eight entries, which
> must all be initialized and considered when setting up memory types for
> the Pentium II processor. However, in Mode B or Mode C paging, the upper
> four entries do not function correctly for 4-Kbyte pages. Specifically,
> bit seven of page table entries that translate addresses to 4-Kbyte pages
> should be used as the upper bit of a three-bit index to determine the PAT
> entry that specifies the memory type for the page. When Mode B (CR4.PSE =
> 1) and/or Mode C (CR4.PAE) are enabled, the processor forces this bit to
> zero when determining the memory type regardless of the value in the page
> table entry. The upper four entries of the PAT function correctly for
> 2-Mbyte and 4-Mbyte large pages (specified by bit 12 of the page
> directory entry for those translations). Implication: Only the lower four
> PAT entries are useful for 4 KB translations when Mode B or C paging is
> used. In Mode A paging (4-Kbyte pages only), all eight entries may be
> used. All eight entries may be used for large pages in Mode B or C paging.
>
>
>
> Doing this stuff for Xen also IMHO makes no sense at all. We shouldn't
> have a kernel full of crap to deal with Xen-isms. IFF it means the
> changes can also implement a mix of four PAT entries on Pentium-M or
> earlier CPUs with PAT errata, and the full PAT on processors without
> errata then IMHO it becomes a whole world more interesting.

This is the case.

The patches as posted don't change PAT MSR settings at all. Using all 8
PAT MSR entries on processors without errata is easy while limit usage
to only 4 entries is possible as well. It is possible to make the
decision dynamically while booting the system. The only difference is
the value written to the PAT MSR, as this value is used to modify the
tables used for translating between cache modes and pte bits. If a
driver wants to set write-through mode on a processor with the PAT
erratum, the translation will result in uncached mode which is okay.

Regarding Xen: The patches don't introduce further Xen-isms. They reduce
the Xen specialties by being able to use the same translation mechanisms
on a native system as on a Xen based system. The only differences are
the values in the translation tables, as Xen is using a different PAT
configuration as native Linux (with my patches Linux could use the same
PAT configuration as Xen, of course).

Juergen

