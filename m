Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475Ab3CSUCc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 16:02:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60383 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076Ab3CSUCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 16:02:31 -0400
Date: Tue, 19 Mar 2013 13:02:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: vgoyal@redhat.com, ebiederm@xmission.com, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, zhangyanfei@cn.fujitsu.com
Subject: Re: [PATCH v3 18/21] vmcore: check if vmcore objects satify
 mmap()'s page-size boundary requirement
Message-Id: <20130319130229.fe83c985678146980ecc6102@linux-foundation.org>
In-Reply-To: <20130316040228.15064.28019.stgit@localhost6.localdomain6>
References: <20130316040003.15064.62308.stgit@localhost6.localdomain6>
	<20130316040228.15064.28019.stgit@localhost6.localdomain6>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Mar 2013 13:02:29 +0900 HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> wrote:

> If there's some vmcore object that doesn't satisfy page-size boundary
> requirement, remap_pfn_range() fails to remap it to user-space.
> 
> Objects that posisbly don't satisfy the requirement are ELF note
> segments only. The memory chunks corresponding to PT_LOAD entries are
> guaranteed to satisfy page-size boundary requirement by the copy from
> old memory to buffer in 2nd kernel done in later patch.
> 
> This patch doesn't copy each note segment into the 2nd kernel since
> they amount to so large in total if there are multiple CPUs. For
> example, current maximum number of CPUs in x86_64 is 5120, where note
> segments exceed 1MB with NT_PRSTATUS only.

I don't really understand this.  Why does the number of or size of
note segments affect their alignment?

> --- a/fs/proc/vmcore.c
> +++ b/fs/proc/vmcore.c
> @@ -38,6 +38,8 @@ static u64 vmcore_size;
>  
>  static struct proc_dir_entry *proc_vmcore = NULL;
>  
> +static bool support_mmap_vmcore;

This is quite regrettable.  It means that on some kernels/machines,
mmap(vmcore) simply won't work.  This means that people might write
code which works for them, but which will fail for others when deployed
on a small number of machines.

Can we avoid this?  Why can't we just copy the notes even if there are
a large number of them?

