Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922AbaGHWf7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 18:35:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37175 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbaGHWf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 18:35:57 -0400
Date: Tue, 8 Jul 2014 15:40:22 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Vinayak Menon <vinayakm.list@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, arve@android.com,
        john.stultz@linaro.org, serban.constantinescu@arm.com
Subject: Re: [PATCH] staging: binder: add vm_fault handler
Message-ID: <20140708224022.GA4244@kroah.com>
References: <1401713279-5612-1-git-send-email-vinayakm.list@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401713279-5612-1-git-send-email-vinayakm.list@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 06:17:59PM +0530, Vinayak Menon wrote:
> An issue was observed when a userspace task exits.
> The page which hits error here is the zero page.
> In binder mmap, the whole of vma is not mapped.
> On a task crash, when debuggerd reads the binder regions,
> the unmapped areas fall to do_anonymous_page in handle_pte_fault,
> due to the absence of a vm_fault handler. This results in
> zero page being mapped. Later in zap_pte_range, vm_normal_page
> returns zero page in the case of VM_MIXEDMAP and it results in the
> error.
> 
> BUG: Bad page map in process mediaserver  pte:9dff379f pmd:9bfbd831
> page:c0ed8e60 count:1 mapcount:-1 mapping:  (null) index:0x0
> page flags: 0x404(referenced|reserved)
> addr:40c3f000 vm_flags:10220051 anon_vma:  (null) mapping:d9fe0764 index:fd
> vma->vm_ops->fault:   (null)
> vma->vm_file->f_op->mmap: binder_mmap+0x0/0x274
> CPU: 0 PID: 1463 Comm: mediaserver Tainted: G        W    3.10.17+ #1
> [<c001549c>] (unwind_backtrace+0x0/0x11c) from [<c001200c>] (show_stack+0x10/0x14)
> [<c001200c>] (show_stack+0x10/0x14) from [<c0103d78>] (print_bad_pte+0x158/0x190)
> [<c0103d78>] (print_bad_pte+0x158/0x190) from [<c01055f0>] (unmap_single_vma+0x2e4/0x598)
> [<c01055f0>] (unmap_single_vma+0x2e4/0x598) from [<c010618c>] (unmap_vmas+0x34/0x50)
> [<c010618c>] (unmap_vmas+0x34/0x50) from [<c010a9e4>] (exit_mmap+0xc8/0x1e8)
> [<c010a9e4>] (exit_mmap+0xc8/0x1e8) from [<c00520f0>] (mmput+0x54/0xd0)
> [<c00520f0>] (mmput+0x54/0xd0) from [<c005972c>] (do_exit+0x360/0x990)
> [<c005972c>] (do_exit+0x360/0x990) from [<c0059ef0>] (do_group_exit+0x84/0xc0)
> [<c0059ef0>] (do_group_exit+0x84/0xc0) from [<c0066de0>] (get_signal_to_deliver+0x4d4/0x548)
> [<c0066de0>] (get_signal_to_deliver+0x4d4/0x548) from [<c0011500>] (do_signal+0xa8/0x3b8)
> 
> Add a vm_fault handler which returns VM_FAULT_SIGBUS, and prevents the
> wrong fallback to do_anonymous_page.
> 
> Signed-off-by: Vinayak Menon <vinayakm.list@gmail.com>
> ---
>  drivers/staging/android/binder.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)

Given a lack of objections, I'll go merge this...

thanks,

greg k-h
