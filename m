Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170Ab3GWEZp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 00:25:45 -0400
Received: from ozlabs.org ([203.10.76.45]:56611 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753399Ab3GWEZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 00:25:40 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: monstr@monstr.eu
Cc: Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: scatterlist: sg_set_buf() argument must be in linear mapping (sha1: ac4e97abce9b80c020e7113325f49e58b7b15e3f)
In-Reply-To: <51ED2C74.7050502@monstr.eu>
References: <51E64C6B.3080306@monstr.eu> <87siz7xt4z.fsf@rustcorp.com.au> <51ED2C74.7050502@monstr.eu>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Tue, 23 Jul 2013 12:00:30 +0930
Message-ID: <87ppua9feh.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Simek <monstr@monstr.eu> writes:
> + Ohad
>
> On 07/22/2013 03:47 AM, Rusty Russell wrote:
>> Michal Simek <monstr@monstr.eu> writes:
>>> Hi Rusty and Jens,
>>>
>>> I am getting problem with your patch which you have added to the kernel.
>>> The problem is with my arm zynq remoteproc driver where
>>> I use dma_declare_coherent_memory() to specify memory for remoteproc
>>> which is ioremap to the vmalloc area.
>>>
>>> Based on that buf addr is not inside ram even this coherent memory is in ram.
>>> That's why virt_addr_valid(buf) is failing.
>> 
>> But sg_set_buf() calls virt_to_page(buf).  So does that work?
>> 
>> I would think calling sg_set_page() directly would be what you want
>> here...
>
> Let me take some code from virtio_rpmsg_bus.c to show that problematic part.
>
> bufs_va = dma_alloc_coherent(vdev->dev.parent->parent,
> 				RPMSG_TOTAL_BUF_SPACE,
> 				&vrp->bufs_dma, GFP_KERNEL);
> vrp->rbufs = bufs_va;
> for (i = 0; i < RPMSG_NUM_BUFS / 2; i++) {
> 	struct scatterlist sg;
> 	void *cpu_addr = vrp->rbufs + i * RPMSG_BUF_SIZE;
>
> 	sg_init_one(&sg, cpu_addr, RPMSG_BUF_SIZE);
> }

Hmm.  Looking at arch/arm/include/asm/memory.h:

#define virt_to_page(kaddr)	pfn_to_page(__pa(kaddr) >> PAGE_SHIFT)
#define virt_addr_valid(kaddr)	((unsigned long)(kaddr) >= PAGE_OFFSET && (unsigned long)(kaddr) < (unsigned long)high_memory)

pfn_to_page in ARM seems to be the asm-generic one, which depends on
CONFIG_SPARSEMEM/CONFIG_DISCONTIGMEM/CONFIG_FLATMEM etc.

Perhaps virt_addr_valid() is wrong for your config?  It's pretty clear
that you shouldn't call virt_to_page() on something for which
!virt_addr_valid().

Cheers,
Rusty.
