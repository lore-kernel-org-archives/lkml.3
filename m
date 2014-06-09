Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595AbaFIPmW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 11:42:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37551 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755089AbaFIPmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 11:42:20 -0400
Date: Mon, 9 Jun 2014 11:41:37 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: WANG Chao <chaowang@redhat.com>
Cc: Dave Young <dyoung@redhat.com>, mjg59@srcf.ucam.org, bhe@redhat.com,
        jkosina@suse.cz, greg@kroah.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, bp@alien8.de, ebiederm@xmission.com,
        hpa@zytor.com, akpm@linux-foundation.org
Subject: Re: [PATCH 07/13] kexec: Implementation of new syscall
 kexec_file_load
Message-ID: <20140609154137.GD22049@redhat.com>
References: <1401800822-27425-1-git-send-email-vgoyal@redhat.com>
 <1401800822-27425-8-git-send-email-vgoyal@redhat.com>
 <20140606065605.GE2785@dhcp-17-89.nay.redhat.com>
 <20140606181859.GK1526@redhat.com>
 <20140609021122.GB1924@darkstar.nay.redhat.com>
 <20140609053538.GA2874@dhcp-17-89.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140609053538.GA2874@dhcp-17-89.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2014 at 01:35:38PM +0800, WANG Chao wrote:

[..]
> > > What's the upper length of vzalloc(). I think if it is too big to alloc,
> > > then vzalloc() should return me an error?
> 
> When allocating too large, eg. vzalloc(-1), kernel spits:
> 
> [  457.407579] vmalloc: allocation failure: 18446744073709551606 bytes
> [  457.413854] kexec: page allocation failure: order:0, mode:0x80d2
> [  457.419853] CPU: 3 PID: 2058 Comm: kexec Not tainted
> 3.15.0-rc8-00096-g3dc85e8 #10
> [  457.427408] Hardware name: Dell Inc. OptiPlex 760
> /0M860N, BIOS A12 05/23/2011
> [  457.435999]  ffffffff81a2f678 ffff8800bfb03db0 ffffffff816944fd
> 00000000000080d2
> [  457.443422]  ffff8800bfb03e38 ffffffff8118a31a ffffffff81a2f678
> ffff8800bfb03dd0
> [  457.450851]  ffff880100000018 ffff8800bfb03e48 ffff8800bfb03de8
> ffff8800bfb03e10
> [  457.458278] Call Trace:
> [  457.460731]  [<ffffffff816944fd>] dump_stack+0x45/0x56
> [  457.465865]  [<ffffffff8118a31a>] warn_alloc_failed+0xda/0x140
> [  457.471693]  [<ffffffff811f56d1>] ? kernel_read+0x41/0x60
> [  457.477085]  [<ffffffff811bf466>] __vmalloc_node_range+0x1b6/0x270
> [  457.483256]  [<ffffffff811bf5bb>] vzalloc+0x4b/0x50
> [  457.488132]  [<ffffffff81121815>] ?
> kimage_file_prepare_segments.part.10+0x85/0x140
> [  457.495774]  [<ffffffff81121815>]
> kimage_file_prepare_segments.part.10+0x85/0x140
> [  457.503244]  [<ffffffff8112301a>] SyS_kexec_file_load+0x38a/0x690
> [  457.509330]  [<ffffffff816a2f29>] system_call_fastpath+0x16/0x1b
> [..]
> 
> I think it's better to do some sane check to prevent such warning when
> taking arbitrary argument from user space.

Hmm.., I did not know that memory allocation failures had to dump stack
trace.

Anyway, I think I can implement another function which calls into image
loader and query the maximum command length size they will support and
use that number as uppper limit. It is little more code and one extra
call. Hopefully it is worth it.

> 
 > 
> > function __vmalloc_node_range:
> >         if (!size || (size >> PAGE_SHIFT) > totalram_pages)
> >                 goto fail;
> > 
> > So I think only checking cmdline_len == 0 is enough.
> > 
> > For the upper length shouldn't it be stripped to COMMAND_LINE_SIZE?
> 
> Yes, COMMAND_LINE_SIZE

IIUC, COMMAND_LINE_SIZE gives max limits of running kernel and it does
not tell us anything about command line size supported by kernel being
loaded.

Thanks
Vivek
