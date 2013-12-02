Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314Ab3LBPhS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 10:37:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58953 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751895Ab3LBPhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 10:37:15 -0500
Date: Mon, 2 Dec 2013 10:36:47 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Baoquan He <bhe@redhat.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        mjg59@srcf.ucam.org, greg@kroah.com, ebiederm@xmission.com,
        hpa@zytor.com
Subject: Re: [PATCH 5/6] kexec-bzImage: Support for loading bzImage using
 64bit entry
Message-ID: <20131202153647.GE18642@redhat.com>
References: <1384969851-7251-1-git-send-email-vgoyal@redhat.com>
 <1384969851-7251-6-git-send-email-vgoyal@redhat.com>
 <20131128113514.GD4318@dhcp-16-252.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131128113514.GD4318@dhcp-16-252.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 28, 2013 at 07:35:14PM +0800, Baoquan He wrote:

[..]
> > +void *bzImage64_load(struct kimage *image, char *kernel,
> > +		unsigned long kernel_len,
> > +		char *initrd, unsigned long initrd_len,
> > +		char *cmdline, unsigned long cmdline_len)
> > +{
> > +
> > +	struct setup_header *header;
> > +	int setup_sects, kern16_size_needed, kern16_size, ret = 0;
> > +	unsigned long setup_size, setup_header_size;
> > +	struct boot_params *params;
> > +	unsigned long bootparam_load_addr, kernel_load_addr, initrd_load_addr;
> > +	unsigned long kernel_bufsz, kernel_memsz, kernel_align;
> > +	char *kernel_buf;
> > +	struct bzimage64_data *ldata;
> > +
> > +	header = (struct setup_header *)(kernel + 0x1F1);
> > +	setup_sects = header->setup_sects;
> > +	if (setup_sects == 0)
> > +		setup_sects = 4;
> > +
> > +	kern16_size = (setup_sects + 1) * 512;
> > +	if (kernel_len < kern16_size) {
> > +		pr_debug("bzImage truncated\n");
> > +		return ERR_PTR(-ENOEXEC);
> > +	}
> > +
> > +	if (cmdline_len > header->cmdline_size) {
> > +		pr_debug("Kernel command line too long\n");
> > +		return ERR_PTR(-EINVAL);
> > +	}
> > +
> > +	/* Allocate loader specific data */
> > +	ldata = kzalloc(sizeof(struct bzimage64_data), GFP_KERNEL);
> > +	if (!ldata)
> > +		return ERR_PTR(-ENOMEM);
> > +
> > +	/* Argument/parameter segment */
> > +	kern16_size_needed = kern16_size;
> > +	if (kern16_size_needed < 4096)
> > +		kern16_size_needed = 4096;
> > +
> > +	setup_size = kern16_size_needed + cmdline_len;
> > +	params = kzalloc(setup_size, GFP_KERNEL);
> > +	if (!params) {
> > +		ret = -ENOMEM;
> > +		goto out_free_loader_data;
> > +	}
> > +
> > +	/* Copy setup header onto bootparams. */
> > +	setup_header_size = 0x0202 + kernel[0x0201] - 0x1F1;
> > +
> > +	/* Is there a limit on setup header size? */
> > +	memcpy(&params->hdr, (kernel + 0x1F1), setup_header_size);
> > +	ret = kexec_add_buffer(image, (char *)params, setup_size,
> > +			setup_size, 16, 0x3000, -1, 1, &bootparam_load_addr);
> > +	if (ret)
> > +		goto out_free_params;
> > +	pr_debug("Loaded boot_param and command line at 0x%lx\n",
> > +			bootparam_load_addr);
> > +
> > +	/* Load kernel */
> > +	kernel_buf = kernel + kern16_size;
> > +	kernel_bufsz =  kernel_len - kern16_size;
> > +	kernel_memsz = ALIGN(header->init_size, 4096);
> > +	kernel_align = header->kernel_alignment;
> > +
> > +	ret = kexec_add_buffer(image, kernel_buf,
> > +			kernel_bufsz, kernel_memsz, kernel_align, 0x100000,
> > +			-1, 1, &kernel_load_addr);
> > +	if (ret)
> > +		goto out_free_params;
> > +
> > +	pr_debug("Loaded 64bit kernel at 0x%lx sz = 0x%lx\n", kernel_load_addr,
> > +				kernel_memsz);
> > +
> > +	/* Load initrd high */
> > +	if (initrd) {
> > +		ret = kexec_add_buffer(image, initrd, initrd_len, initrd_len,
> > +			4096, 0x10000000, ULONG_MAX, 1, &initrd_load_addr);
> 
> Here the minimal starting addr to locate initrd is 256M, though it's
> allocated from top to down, I am still wondering why.

Hi Bao,

Good catch. It is vestige of some hard coding I had done initially to
test my patches. Forgot to remove the hardcoding here. Will fix it in
next version.

Thanks
Vivek
