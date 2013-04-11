Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935985Ab3DKPIE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 11:08:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42499 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765117Ab3DKPIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 11:08:01 -0400
Message-ID: <5166D18A.7090800@zytor.com>
Date: Thu, 11 Apr 2013 08:06:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Renninger <trenn@suse.de>, Simon Horman <horms@verge.net.au>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Vivek Goyal <vgoyal@redhat.com>, Cliff Wickman <cpw@sgi.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] kexec: X86: Pass memory ranges via e820 table instead
 of memmap= boot parameter
References: <1365683207-42425-1-git-send-email-trenn@suse.de> <1365683207-42425-6-git-send-email-trenn@suse.de> <CAE9FiQXnZzVC7dtvXWrqz=jYAGH053R8Vw1qkrMd2F+hAaMxdQ@mail.gmail.com>
In-Reply-To: <CAE9FiQXnZzVC7dtvXWrqz=jYAGH053R8Vw1qkrMd2F+hAaMxdQ@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2013 07:55 AM, Yinghai Lu wrote:
> On Thu, Apr 11, 2013 at 5:26 AM, Thomas Renninger <trenn@suse.de> wrote:
>> Currently ranges are passed via kernel boot parameters:
>> memmap=exactmap memmap=X#Y memmap=
>>
>> Pass them via e820 table directly instead.
> 
> how to address "saved_max_pfn" referring in kernel?
> 
> kernel need to use saved_max_pfn from old e820 in
> drivers/char/mem.c::read_oldmem()
> 
> mips and powerpc they are passing that from command line "savemaxmem="
> 
> x86 should use that too?
> 

Oh bloody hell, yet another f-ing "max_pfn" variable.

The *only* one that makes any kind of sense is max_low_pfn (marking the
cutoff to highmem)... the pretty much the rest of them are just plain wrong.

And I don't mean "mildly annoying", I mean "catastrophically wrong
semantics".  In this case, it introduces a completely arbitrary
distinction between a nonmemory range below a high water mark and a
nonmemory range above that high water mark.  In fact, from reading the
code it seems pretty clear that the device will blindly assume that
anything below saved_max_pfn is memory and will try to map it
cachable... which will #MC on quite a few machines.

This kind of crap HAS TO STOP.  Memory is discontiguous, deal with it
and deal with it properly.

I also have to admit that I don't see the difference between /dev/mem
and /dev/oldmem, as the former allows access to memory ranges outside
the ones used by the current kernel, which is what the oldmem device
seems to be intended to od.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

