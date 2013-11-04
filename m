Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab3KDQpm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 11:45:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151Ab3KDQpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 11:45:41 -0500
Date: Mon, 4 Nov 2013 17:44:31 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 12/13] tracing/uprobes: Add more fetch functions
Message-ID: <20131104164431.GA10053@redhat.com>
References: <1383029621-7384-1-git-send-email-namhyung@kernel.org> <1383029621-7384-13-git-send-email-namhyung@kernel.org> <20131031182218.GB11208@redhat.com> <87k3go35zm.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k3go35zm.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04, Namhyung Kim wrote:
>
> On Thu, 31 Oct 2013 19:22:18 +0100, Oleg Nesterov wrote:
> > On 10/29, Namhyung Kim wrote:
> >>
> >> +static void __user *get_user_vaddr(unsigned long addr, struct trace_uprobe *tu)
> >> +{
> >> +	unsigned long pgoff = addr >> PAGE_SHIFT;
> >> +	struct vm_area_struct *vma;
> >> +	struct address_space *mapping;
> >> +	unsigned long vaddr = 0;
> >> +
> >> +	if (tu == NULL) {
> >> +		/* A NULL tu means that we already got the vaddr */
> >> +		return (void __force __user *) addr;
> >> +	}
> >> +
> >> +	mapping = tu->inode->i_mapping;
> >> +
> >> +	mutex_lock(&mapping->i_mmap_mutex);
> >> +	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
> >> +		if (vma->vm_mm != current->mm)
> >> +			continue;
> >> +		if (!(vma->vm_flags & VM_READ))
> >> +			continue;
> >> +
> >> +		vaddr = offset_to_vaddr(vma, addr);
> >> +		break;
> >> +	}
> >> +	mutex_unlock(&mapping->i_mmap_mutex);
> >> +
> >> +	WARN_ON_ONCE(vaddr == 0);
> >
> > Hmm. But unless I missed something this "addr" passed as an argument can
> > be wrong? And if nothing else this or another thread can unmap the vma?
>
> You mean WARN_ON_ONCE here is superfluous?  I admit that it should
> protect concurrent vma [un]mappings.  Please see my reply in other
> thread for a new approach.

Whatever we do this address can be unmapped. For example, just because of
@invalid_address passed to trace_uprobe.c.

We do not really care, copy_from_user() should fail. But we should not
WARN() in this case.

Oleg.

