Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365Ab3CTN5f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 09:57:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615Ab3CTN5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 09:57:34 -0400
Date: Wed, 20 Mar 2013 09:57:16 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        heiko.carstens@de.ibm.com, akpm@linux-foundation.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        zhangyanfei@cn.fujitsu.com
Subject: Re: [PATCH v3 18/21] vmcore: check if vmcore objects satify mmap()'s
 page-size boundary requirement
Message-ID: <20130320135716.GE17274@redhat.com>
References: <20130316040003.15064.62308.stgit@localhost6.localdomain6>
 <20130316040228.15064.28019.stgit@localhost6.localdomain6>
 <877gl3koay.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877gl3koay.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 03:38:45PM -0700, Eric W. Biederman wrote:
> HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> writes:
> 
> > If there's some vmcore object that doesn't satisfy page-size boundary
> > requirement, remap_pfn_range() fails to remap it to user-space.
> >
> > Objects that posisbly don't satisfy the requirement are ELF note
> > segments only. The memory chunks corresponding to PT_LOAD entries are
> > guaranteed to satisfy page-size boundary requirement by the copy from
> > old memory to buffer in 2nd kernel done in later patch.
> >
> > This patch doesn't copy each note segment into the 2nd kernel since
> > they amount to so large in total if there are multiple CPUs. For
> > example, current maximum number of CPUs in x86_64 is 5120, where note
> > segments exceed 1MB with NT_PRSTATUS only.
> 
> So you require the first kernel to reserve an additional 20MB, instead
> of just 1.6MB.  336 bytes versus 4096 bytes.
> 
> That seems like completely the wrong tradeoff in memory consumption,
> filesize, and backwards compatibility.

Agreed. 

So we already copy ELF headers in second kernel's memory. If we start
copying notes too, then both headers and notes will support mmap().

For mmap() of memory regions which are not page aligned, we can map
extra bytes (as you suggested in one of the mails). Given the fact
that we have one ELF header for every memory range, we can always modify
the file offset where phdr data is starting to make space for mapping
of extra bytes.

That way whole of vmcore should be mmappable and user does not have
to worry about reading part of the file and mmaping the rest.

Thanks
Vivek
