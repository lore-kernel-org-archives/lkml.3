Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567Ab3CTNvs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 09:51:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15234 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928Ab3CTNvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 09:51:46 -0400
Date: Wed, 20 Mar 2013 09:51:33 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>, ebiederm@xmission.com,
        cpw@sgi.com, kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, zhangyanfei@cn.fujitsu.com
Subject: Re: [PATCH v3 18/21] vmcore: check if vmcore objects satify mmap()'s
 page-size boundary requirement
Message-ID: <20130320135133.GD17274@redhat.com>
References: <20130316040003.15064.62308.stgit@localhost6.localdomain6>
 <20130316040228.15064.28019.stgit@localhost6.localdomain6>
 <20130319130229.fe83c985678146980ecc6102@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130319130229.fe83c985678146980ecc6102@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 01:02:29PM -0700, Andrew Morton wrote:
> On Sat, 16 Mar 2013 13:02:29 +0900 HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> wrote:
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
> I don't really understand this.  Why does the number of or size of
> note segments affect their alignment?
> 
> > --- a/fs/proc/vmcore.c
> > +++ b/fs/proc/vmcore.c
> > @@ -38,6 +38,8 @@ static u64 vmcore_size;
> >  
> >  static struct proc_dir_entry *proc_vmcore = NULL;
> >  
> > +static bool support_mmap_vmcore;
> 
> This is quite regrettable.  It means that on some kernels/machines,
> mmap(vmcore) simply won't work.  This means that people might write
> code which works for them, but which will fail for others when deployed
> on a small number of machines.
> 
> Can we avoid this?  Why can't we just copy the notes even if there are
> a large number of them?

Actually initially he implemented copying notes to second kernel and I 
suggested to go other way (Tried too hard to save memory in second
kernel). I guess it was not a good idea and copying notes keeps it simple.

Thanks
Vivek
