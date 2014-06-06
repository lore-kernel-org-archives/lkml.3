Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207AbaFFG4x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 02:56:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38782 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803AbaFFG4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 02:56:51 -0400
Date: Fri, 6 Jun 2014 14:56:05 +0800
From: WANG Chao <chaowang@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, bp@alien8.de, jkosina@suse.cz, dyoung@redhat.com,
        bhe@redhat.com, akpm@linux-foundation.org
Subject: Re: [PATCH 07/13] kexec: Implementation of new syscall
 kexec_file_load
Message-ID: <20140606065605.GE2785@dhcp-17-89.nay.redhat.com>
References: <1401800822-27425-1-git-send-email-vgoyal@redhat.com>
 <1401800822-27425-8-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401800822-27425-8-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/14 at 09:06am, Vivek Goyal wrote:
> Previous patch provided the interface definition and this patch prvides
> implementation of new syscall.
> 
> Previously segment list was prepared in user space. Now user space just
> passes kernel fd, initrd fd and command line and kernel will create a
> segment list internally.
> 
> This patch contains generic part of the code. Actual segment preparation
> and loading is done by arch and image specific loader. Which comes in
> next patch.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

[..]
> diff --git a/kernel/kexec.c b/kernel/kexec.c
> index a3044e6..1ad4d60 100644
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c

> +static int kimage_file_prepare_segments(struct kimage *image, int kernel_fd,
> +		int initrd_fd, const char __user *cmdline_ptr,
> +		unsigned long cmdline_len)
> +{
> +	int ret = 0;
> +	void *ldata;
> +
> +	ret = copy_file_from_fd(kernel_fd, &image->kernel_buf,
> +					&image->kernel_buf_len);
> +	if (ret)
> +		return ret;
> +
> +	/* Call arch image probe handlers */
> +	ret = arch_kexec_kernel_image_probe(image, image->kernel_buf,
> +						image->kernel_buf_len);
> +
> +	if (ret)
> +		goto out;
> +
> +	ret = copy_file_from_fd(initrd_fd, &image->initrd_buf,
> +					&image->initrd_buf_len);
> +	if (ret)
> +		goto out;
> +
> +	image->cmdline_buf = vzalloc(cmdline_len);

You should validate the upper/lower boundary of cmdline_len before
calling vzalloc. When cmdline_len is 0 or too large, vmalloc failure
message would be fired.

> +	if (!image->cmdline_buf)
> +		goto out;
> +
> +	ret = copy_from_user(image->cmdline_buf, cmdline_ptr, cmdline_len);
> +	if (ret) {
> +		ret = -EFAULT;
> +		goto out;
> +	}
> +
> +	image->cmdline_buf_len = cmdline_len;
> +
> +	/* command line should be a string with last byte null */
> +	if (image->cmdline_buf[cmdline_len - 1] != '\0') {
> +		ret = -EINVAL;
> +		goto out;
> +	}

Given the fact that command line is optional as well as initrd, I think
above chunk of code needs to update a bit for the case cmdline_len is 0
or cmdline_buf is pointing NULL?

Thanks
WANG Chao
