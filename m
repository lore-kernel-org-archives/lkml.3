Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239AbaIKUBh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 16:01:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25331 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798AbaIKUBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 16:01:36 -0400
Date: Thu, 11 Sep 2014 16:01:10 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Petr Tesarik <ptesarik@suse.cz>
Cc: Eric Biederman <ebiederm@xmission.com>, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Put each per-cpu kdump ELF notes into a single page
Message-ID: <20140911200110.GA24699@redhat.com>
References: <20140905183314.23690175@hananiah.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140905183314.23690175@hananiah.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 06:33:14PM +0200, Petr Tesarik wrote:
> On architectures that use percpu-vm, the percpu region is not guaranteed
> to be contiguous in physical space.

Petr,

Which are those arches?

> However, fs/proc/vmcore.c expects
> all ELF notes to be contiguous. If the ELF note happens to occupy
> two non-adjacent physical pages, part of the note may be read from an
> incorrect memory location by the kdump kernel, resulting in failure to
> initialize /proc/vmcore (if the content of the following physical page,
> incorrectly interpreted as an ELF note specifies a large number), wrong
> register values or other apparent random memory corruption.
> 
> There is currently no mechanism to pass the virtual-to-physical mapping
> of the percpu allocation to the kdump kernel. So, instead, I'm changing
> the alignment of the ELF note buffer. Since sizeof(note_buf_t) is less
> than PAGE_SIZE, aligning the buffer to the nearest higher power of 2
> is enough to make sure that the buffer cannot cross a page boundary,
> effectively ensuring that the whole buffer is contiguous in physical
> space.
> 
> Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
> ---
>  kernel/kexec.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/kexec.c b/kernel/kexec.c
> index 2bee072..cdab59d 100644
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -1610,7 +1610,8 @@ void crash_save_cpu(struct pt_regs *regs, int cpu)
>  static int __init crash_notes_memory_init(void)
>  {
>  	/* Allocate memory for saving cpu registers. */
> -	crash_notes = alloc_percpu(note_buf_t);
> +	crash_notes = __alloc_percpu(sizeof(note_buf_t),
> +				     roundup_pow_of_two(sizeof(note_buf_t)));

I think some of the changelog should show up here as comment in short
form. I don't think it is obvious that why we are using __alloc_percpu()
and why aligning to nearst higher power of 2 is needed here. Please also
mention here which arches run into issues.

Thanks
Vivek

>  	if (!crash_notes) {
>  		pr_warn("Kexec: Memory allocation for saving cpu register states failed\n");
>  		return -ENOMEM;
> -- 
> 1.8.4.5
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
