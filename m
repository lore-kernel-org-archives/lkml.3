Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbaB0Vwm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 16:52:42 -0500
Received: from mail.skyhub.de ([78.46.96.112]:39528 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393AbaB0Vwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 16:52:39 -0500
Date: Thu, 27 Feb 2014 22:52:32 +0100
From: Borislav Petkov <bp@alien8.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, jkosina@suse.cz
Subject: Re: [PATCH 09/11] kexec: Provide a function to add a segment at
 fixed address
Message-ID: <20140227215232.GQ18191@pd.tnic>
References: <1390849071-21989-1-git-send-email-vgoyal@redhat.com>
 <1390849071-21989-10-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1390849071-21989-10-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 01:57:49PM -0500, Vivek Goyal wrote:
> kexec_add_buffer() can find a suitable range of memory for user buffer and
> add it to list of segments. But ELF loader will require that a buffer can
> be loaded at the address it has been compiled for (ET_EXEC type executables).
> So we need a helper function which can see if requested memory is valid and
> available and add a segment accordiingly. This patch provides that helper
> function. It will be used by elf loader in later patch.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  include/linux/kexec.h |  3 +++
>  kernel/kexec.c        | 65 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 68 insertions(+)
> 
> diff --git a/include/linux/kexec.h b/include/linux/kexec.h
> index d391ed7..2fb052c 100644
> --- a/include/linux/kexec.h
> +++ b/include/linux/kexec.h
> @@ -208,6 +208,9 @@ extern asmlinkage long sys_kexec_load(unsigned long entry,
>  					struct kexec_segment __user *segments,
>  					unsigned long flags);
>  extern int kernel_kexec(void);
> +extern int kexec_add_segment(struct kimage *image, char *buffer,
> +			unsigned long bufsz, unsigned long memsz,
> +			unsigned long base);
>  extern int kexec_add_buffer(struct kimage *image, char *buffer,
>  			unsigned long bufsz, unsigned long memsz,
>  			unsigned long buf_align, unsigned long buf_min,
> diff --git a/kernel/kexec.c b/kernel/kexec.c
> index 20169a4..9e4718b 100644
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -2002,6 +2002,71 @@ static int __kexec_add_segment(struct kimage *image, char *buf,
>  	return 0;
>  }
>  
> +static int validate_ram_range_callback(u64 start, u64 end, void *arg)
> +{
> +	struct kexec_segment *ksegment = arg;
> +	u64 mstart = ksegment->mem;
> +	u64 mend = ksegment->mem + ksegment->memsz - 1;
> +
> +	/* Found a valid range. Stop going through more ranges */
> +	if (mstart >= start && mend <= end)
> +		return 1;
> +
> +	/* Range did not match. Go to next one */
> +	return 0;
> +}
> +
> +/* Add a kexec segment at fixed address provided by caller */
> +int kexec_add_segment(struct kimage *image, char *buffer, unsigned long bufsz,
> +			unsigned long memsz, unsigned long base)
> +{
> +	struct kexec_segment ksegment;
> +	int ret;
> +
> +	/* Currently adding segment this way is allowed only in file mode */
> +	if (!image->file_mode)
> +		return -EINVAL;

Why the guard? On a quick scan, I don't see this function called by
something else except on the kexec_file_load path...

> +
> +	if (image->nr_segments >= KEXEC_SEGMENT_MAX)
> +		return -EINVAL;
> +
> +	/*
> +	 * Make sure we are not trying to add segment after allocating
> +	 * control pages. All segments need to be placed first before
> +	 * any control pages are allocated. As control page allocation
> +	 * logic goes through list of segments to make sure there are
> +	 * no destination overlaps.
> +	 */
> +	WARN_ONCE(!list_empty(&image->control_pages), "Adding kexec segment"

Maybe say at which address here:

... "Adding a kexec segment at address 0x%lx.."

for a bit more helpful info.

> +			" after allocating control pages\n");
> +
> +	if (bufsz > memsz)
> +		return -EINVAL;
> +	if (memsz == 0)
> +		return -EINVAL;
> +
> +	/* Align memsz to next page boundary */
> +	memsz = ALIGN(memsz, PAGE_SIZE);

We even have PAGE_ALIGN for that.

> +
> +	/* Make sure base is atleast page size aligned */
> +	if (base & (PAGE_SIZE - 1))

PAGE_ALIGNED even :)

> +		return -EINVAL;
> +
> +	memset(&ksegment, 0, sizeof(struct kexec_segment));
> +	ksegment.mem = base;
> +	ksegment.memsz = memsz;
> +
> +	/* Validate memory range */
> +	ret = walk_system_ram_res(base, base + memsz - 1, &ksegment,
> +				validate_ram_range_callback);
> +
> +	/* If a valid range is found, 1 is returned */
> +	if (ret != 1)

That's the retval of validate_ram_range_callback, right? So

	if (!ret)

And shouldn't the convention be the opposite? 0 on success, !0 on error?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
