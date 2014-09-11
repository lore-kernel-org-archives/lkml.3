Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077AbaIKTht (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 15:37:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42753 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752886AbaIKThs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 15:37:48 -0400
Date: Thu, 11 Sep 2014 21:37:44 +0200
From: Petr Tesarik <ptesarik@suse.cz>
To: Eric Biederman <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Put each per-cpu kdump ELF notes into a single page
Message-ID: <20140911213744.42735c3c@hananiah.suse.cz>
In-Reply-To: <20140905183314.23690175@hananiah.suse.cz>
References: <20140905183314.23690175@hananiah.suse.cz>
Organization: SUSE Linux, s.r.o.
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

is anything wrong with the patch below? Are there questions? I thought
this would be an easy one-line bugfix...

Regards,
Petr Tesarik

On Fri, 5 Sep 2014 18:33:14 +0200
Petr Tesarik <ptesarik@suse.cz> wrote:

> On architectures that use percpu-vm, the percpu region is not guaranteed
> to be contiguous in physical space. However, fs/proc/vmcore.c expects
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
>  	if (!crash_notes) {
>  		pr_warn("Kexec: Memory allocation for saving cpu register states failed\n");
>  		return -ENOMEM;

