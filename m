Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab3DLOb6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 10:31:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17477 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746Ab3DLOb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 10:31:57 -0400
Date: Fri, 12 Apr 2013 10:31:04 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Renninger <trenn@suse.de>,
        Simon Horman <horms@verge.net.au>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Cliff Wickman <cpw@sgi.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] kexec: X86: Pass memory ranges via e820 table
 instead of memmap= boot parameter
Message-ID: <20130412143104.GA4301@redhat.com>
References: <1365683207-42425-1-git-send-email-trenn@suse.de>
 <1365683207-42425-6-git-send-email-trenn@suse.de>
 <CAE9FiQXnZzVC7dtvXWrqz=jYAGH053R8Vw1qkrMd2F+hAaMxdQ@mail.gmail.com>
 <5166D18A.7090800@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5166D18A.7090800@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 08:06:50AM -0700, H. Peter Anvin wrote:
> On 04/11/2013 07:55 AM, Yinghai Lu wrote:
> > On Thu, Apr 11, 2013 at 5:26 AM, Thomas Renninger <trenn@suse.de> wrote:
> >> Currently ranges are passed via kernel boot parameters:
> >> memmap=exactmap memmap=X#Y memmap=
> >>
> >> Pass them via e820 table directly instead.
> > 
> > how to address "saved_max_pfn" referring in kernel?
> > 
> > kernel need to use saved_max_pfn from old e820 in
> > drivers/char/mem.c::read_oldmem()
> > 
> > mips and powerpc they are passing that from command line "savemaxmem="
> > 
> > x86 should use that too?
> > 
> 
> Oh bloody hell, yet another f-ing "max_pfn" variable.
> 
> The *only* one that makes any kind of sense is max_low_pfn (marking the
> cutoff to highmem)... the pretty much the rest of them are just plain wrong.
> 
> And I don't mean "mildly annoying", I mean "catastrophically wrong
> semantics".  In this case, it introduces a completely arbitrary
> distinction between a nonmemory range below a high water mark and a
> nonmemory range above that high water mark.  In fact, from reading the
> code it seems pretty clear that the device will blindly assume that
> anything below saved_max_pfn is memory and will try to map it
> cachable... which will #MC on quite a few machines.
> 
> This kind of crap HAS TO STOP.  Memory is discontiguous, deal with it
> and deal with it properly.

Agreed. saved_max_pfn is bad idea. Passing all the mappable memory of
old kernel as "RESERVED" (Or KDUMP_RESERVED or KDUMP_MEM or whatever) to
next kernel in e820 map sounds better. And next kernel can allow access
to RESERVED range using /dev/oldmem interface.

For backward compatibility with old kexec-tools we can probably retain
saved_max_pfn for some time. We can set saved_max_pfn to end of
memory range including "RESERVED" regions.  And this will be overwritten
if old kexec-tools have passed this parameter on command line. Also
whenever user passes saved_max_pfn on command line, we can do WARN_ONCE()
to upgrade to kexec-tools and let them know that saved_max_pfn will be
deprecated.

For issue of doing ioremap() on everything as cacheable, we should be
able to modify copy_olmem_page() and it should go through memory map
and check whether said pfn is mappable or not and what flags should
be used to map it.

I think this will again be problem with old kexec-tools. May be we check
of presence of atleast one "KDUMP_RESERVED" range in memory map. If none
is present, we know old kexec-tools were used and in that we can map
all pfn ioremap() blindly. We can do WARN_ONCE() and ask user to upgrade
the kexec-tools and after some time do away with this hack in
copy_oldmem_page() as well as remove saved_max_pfn.
> 
> I also have to admit that I don't see the difference between /dev/mem
> and /dev/oldmem, as the former allows access to memory ranges outside
> the ones used by the current kernel, which is what the oldmem device
> seems to be intended to od.
> 

I think one difference seems to be that /dev/mem assumes that validly
accessed memory is already mapped in kernel while /dev/oldmeme assumes
it is not mapped and creates temporary mappings explicitly.

Thanks
Vivek
