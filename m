Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855Ab3EGPYj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 11:24:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18088 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752817Ab3EGPYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 11:24:38 -0400
Date: Tue, 7 May 2013 11:24:01 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        lisa.mitchell@hp.com, kumagai-atsushi@mxc.nes.nec.co.jp,
        ebiederm@xmission.com, zhangyanfei@cn.fujitsu.com,
        akpm@linux-foundation.org, cpw@sgi.com, jingbai.ma@hp.com
Subject: Re: [PATCH v4 7/8] vmcore: treat memory chunks referenced by PT_LOAD
 program header entries in page-size boundary in vmcore_list
Message-ID: <20130507152401.GB12965@redhat.com>
References: <20130413002000.18245.21513.stgit@localhost6.localdomain6>
 <20130413002145.18245.73180.stgit@localhost6.localdomain6>
 <20130429195154.GR8204@redhat.com>
 <5188AF5C.2070807@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5188AF5C.2070807@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 07, 2013 at 04:38:04PM +0900, HATAYAMA Daisuke wrote:

[..]
> >>  		/* Update the program header offset. */
> >>-		phdr_ptr->p_offset = vmcore_off;
> >>-		vmcore_off = vmcore_off + phdr_ptr->p_memsz;
> >>+		phdr_ptr->p_offset = vmcore_off + (paddr - start);
> >
> >What's paddr-start. Why following is not sufficient.
> >
> >phdr_ptr->p_offset = vmcore_off
> >
> 
> (paddr - start) is offset of the memory program header refers to,
> from which kernel memory starts. Pictrically:
> 
>   vmcore_off                   +----------------------+
>                                |  extra memory        |
>                                |  (non kernel memory) |
> phdr->p_offset =               +----------------------+
>   vmcore_off + (paddr - start) |                      |\
>                                |  kernel memory       | phdr->p_memsz
>                                |                      |/
>                                +----------------------+
>                                |  extra memory        |
>                                |  (non kernel memory) |
>   vmcore_off + size            +----------------------+

Ok, got it. So PT_LOAD header refers to only part of memory and we
align start and end to PAGE_SIZE and then add that full chunk to
vmcore list. We update the phdr->offset to point to PT_LOAD
mapping. vc_list area can contain the page aligned extra memory at the
beginning and end and that can be read from old memory if user wishes
to.

So this is not an issue.

Thanks
Vivek
