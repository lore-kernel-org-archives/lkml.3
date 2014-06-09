Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751288AbaFIFg3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 01:36:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45297 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836AbaFIFg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 01:36:28 -0400
Date: Mon, 9 Jun 2014 13:35:38 +0800
From: WANG Chao <chaowang@redhat.com>
To: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, mjg59@srcf.ucam.org, bhe@redhat.com,
        jkosina@suse.cz, greg@kroah.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, bp@alien8.de, ebiederm@xmission.com,
        hpa@zytor.com, akpm@linux-foundation.org
Subject: Re: [PATCH 07/13] kexec: Implementation of new syscall
 kexec_file_load
Message-ID: <20140609053538.GA2874@dhcp-17-89.nay.redhat.com>
References: <1401800822-27425-1-git-send-email-vgoyal@redhat.com>
 <1401800822-27425-8-git-send-email-vgoyal@redhat.com>
 <20140606065605.GE2785@dhcp-17-89.nay.redhat.com>
 <20140606181859.GK1526@redhat.com>
 <20140609021122.GB1924@darkstar.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140609021122.GB1924@darkstar.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/14 at 10:11am, Dave Young wrote:
> On 06/06/14 at 02:19pm, Vivek Goyal wrote:
> > On Fri, Jun 06, 2014 at 02:56:05PM +0800, WANG Chao wrote:
> > > On 06/03/14 at 09:06am, Vivek Goyal wrote:
> > > > Previous patch provided the interface definition and this patch prvides
> > > > implementation of new syscall.
> > > > 
> > > > Previously segment list was prepared in user space. Now user space just
> > > > passes kernel fd, initrd fd and command line and kernel will create a
> > > > segment list internally.
> > > > 
> > > > This patch contains generic part of the code. Actual segment preparation
> > > > and loading is done by arch and image specific loader. Which comes in
> > > > next patch.
> > > > 
> > > > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > > 
> > > [..]
> > > > diff --git a/kernel/kexec.c b/kernel/kexec.c
> > > > index a3044e6..1ad4d60 100644
> > > > --- a/kernel/kexec.c
> > > > +++ b/kernel/kexec.c
> > > 
> > > > +static int kimage_file_prepare_segments(struct kimage *image, int kernel_fd,
> > > > +		int initrd_fd, const char __user *cmdline_ptr,
> > > > +		unsigned long cmdline_len)
> > > > +{
> > > > +	int ret = 0;
> > > > +	void *ldata;
> > > > +
> > > > +	ret = copy_file_from_fd(kernel_fd, &image->kernel_buf,
> > > > +					&image->kernel_buf_len);
> > > > +	if (ret)
> > > > +		return ret;
> > > > +
> > > > +	/* Call arch image probe handlers */
> > > > +	ret = arch_kexec_kernel_image_probe(image, image->kernel_buf,
> > > > +						image->kernel_buf_len);
> > > > +
> > > > +	if (ret)
> > > > +		goto out;
> > > > +
> > > > +	ret = copy_file_from_fd(initrd_fd, &image->initrd_buf,
> > > > +					&image->initrd_buf_len);
> > > > +	if (ret)
> > > > +		goto out;
> > > > +
> > > > +	image->cmdline_buf = vzalloc(cmdline_len);
> > > 
> > > You should validate the upper/lower boundary of cmdline_len before
> > > calling vzalloc. When cmdline_len is 0 or too large, vmalloc failure
> > > message would be fired.
> > 
> > What's the upper length of vzalloc(). I think if it is too big to alloc,
> > then vzalloc() should return me an error?

When allocating too large, eg. vzalloc(-1), kernel spits:

[  457.407579] vmalloc: allocation failure: 18446744073709551606 bytes
[  457.413854] kexec: page allocation failure: order:0, mode:0x80d2
[  457.419853] CPU: 3 PID: 2058 Comm: kexec Not tainted
3.15.0-rc8-00096-g3dc85e8 #10
[  457.427408] Hardware name: Dell Inc. OptiPlex 760
/0M860N, BIOS A12 05/23/2011
[  457.435999]  ffffffff81a2f678 ffff8800bfb03db0 ffffffff816944fd
00000000000080d2
[  457.443422]  ffff8800bfb03e38 ffffffff8118a31a ffffffff81a2f678
ffff8800bfb03dd0
[  457.450851]  ffff880100000018 ffff8800bfb03e48 ffff8800bfb03de8
ffff8800bfb03e10
[  457.458278] Call Trace:
[  457.460731]  [<ffffffff816944fd>] dump_stack+0x45/0x56
[  457.465865]  [<ffffffff8118a31a>] warn_alloc_failed+0xda/0x140
[  457.471693]  [<ffffffff811f56d1>] ? kernel_read+0x41/0x60
[  457.477085]  [<ffffffff811bf466>] __vmalloc_node_range+0x1b6/0x270
[  457.483256]  [<ffffffff811bf5bb>] vzalloc+0x4b/0x50
[  457.488132]  [<ffffffff81121815>] ?
kimage_file_prepare_segments.part.10+0x85/0x140
[  457.495774]  [<ffffffff81121815>]
kimage_file_prepare_segments.part.10+0x85/0x140
[  457.503244]  [<ffffffff8112301a>] SyS_kexec_file_load+0x38a/0x690
[  457.509330]  [<ffffffff816a2f29>] system_call_fastpath+0x16/0x1b
[..]

I think it's better to do some sane check to prevent such warning when
taking arbitrary argument from user space.

> 
> function __vmalloc_node_range:
>         if (!size || (size >> PAGE_SHIFT) > totalram_pages)
>                 goto fail;
> 
> So I think only checking cmdline_len == 0 is enough.
> 
> For the upper length shouldn't it be stripped to COMMAND_LINE_SIZE?

Yes, COMMAND_LINE_SIZE
