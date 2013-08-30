Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771Ab3H3G5Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 02:57:16 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:42750 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340Ab3H3G5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 02:57:15 -0400
Date: Fri, 30 Aug 2013 09:57:10 +0300
From: Dan Aloni <alonid@stratoscale.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Martin =?utf-8?Q?MOKREJ=C5=A0?= <mmokrejs@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: 3.10.9: Oops at elf_core_dump()
Message-ID: <20130830065707.GA31940@gmail.com>
References: <521FC12A.9060302@gmail.com>
 <20130829220550.GA4486@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130829220550.GA4486@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 03:05:50PM -0700, Greg KH wrote:
> On Thu, Aug 29, 2013 at 11:46:18PM +0200, Martin MOKREJŠ wrote:
> > Hi,
> >   I just got this stacktrace. Not sure whom to send it, poking throu MAINTAINERS
> > file and looking for ELF gave me nothing. ;-)
> > 
> > [105670.434336] BUG: unable to handle kernel NULL pointer dereference at           (null)
> > [105670.434366] IP: [<ffffffff812f7b42>] strlen+0x2/0x20
> > [105670.434385] PGD 18c8e5067 PUD 2b547e067 PMD 0 
> > [105670.434401] Oops: 0000 [#1] SMP 
> > [105670.434413] Modules linked in: iwldvm iwlwifi
> > [105670.434432] CPU: 0 PID: 7497 Comm: emerge Not tainted 3.10.9-default-pciehp #8
> 
> Is this reproducable?

Yes, and here is my analysis:

fill_files_note(&info->files) exits early because of too many VM areas, or
due to memory pressure (vmalloc failing), leaving a NULL string in info->files, 
letting notesize() crash on it.

as root do: 

   echo 300000 > /proc/sys/vm/max_map_count 

then, as a regular user:

   ulimit -c unlimited
   gcc prog.c -o prog
   ./prog

prog.c:
-------
int main(int argc, char *argv[])
{
	char *p, *t;
	int i;

	p = (void *)0x444400000000;

	for (i = 0; i < 200000; i++) {
		t = mmap(p, 0x1000, PROT_READ | PROT_WRITE | PROT_EXEC,
		     MAP_FIXED | MAP_ANONYMOUS | MAP_PRIVATE,
		     -1, 0);
		p = &p[0x2000];
	}

	*((char *)0x0) = 0;

	return 0;
}

And the result:

user@guestvm:~$ c[  380.520865] BUG: unable to handle kernel NULL pointer dereference at 0000000000000086
[  380.523196] IP: [<ffffffff812ee180>] strim+0x80/0x80
[  380.524477] PGD 3abc6067 PUD 3c7b4067 PMD 0 
[  380.525974] Oops: 0000 [#1] SMP 

Entering kdb (current=0xffff880033ee8000, pid 1716) on processor 0 Oops: (null)
due to oops @ 0xffffffff812ee180
dCPU: 0 PID: 1716 Comm: a.out Not tainted 3.10.9-mod-nodbg+ #1
dHardware name: Bochs Bochs, BIOS Bochs 01/01/2011
dtask: ffff880033ee8000 ti: ffff880034eec000 task.ti: ffff880034eec000
dRIP: 0010:[<ffffffff812ee180>]  [<ffffffff812ee180>] strim+0x80/0x80
dRSP: 0000:ffff880034eeda30  EFLAGS: 00010292
dRAX: 0000000000c353c0 RBX: 00000000ffff8800 RCX: ffff880033ee8000
dRDX: 0000000000493f78 RSI: 00000000ffff8800 RDI: 0000000000000086
dRBP: ffff880034eeda48 R08: 00000000fffffffd R09: 0000000000000000
dR10: 0000000000000000 R11: ffffffff812e6c4e R12: ffff880034eedb78
dR13: 00007ffffffff000 R14: 0000000000000000 R15: ffffffff81802708
dFS:  00007fd9f8bf7740(0000) GS:ffff88003f200000(0000) knlGS:0000000000000000
dCS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
dCR2: 0000000000000086 CR3: 000000003ae91000 CR4: 00000000001407f0
dDR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
dDR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
dStack:
 ffffffff811d29a5 ffff880033ee8000 00000000000003d8 ffff880034eedc38
 ffffffff811d3579 ffff880034eeda88 ffffffff8108625a ffff88003a522300
 ffff880033ee8000 0000000000493f78 0000ffff00030d51 ffff880000493f78
dCall Trace:
d [<ffffffff811d29a5>] ? notesize.isra.9+0x15/0x30
d [<ffffffff811d3579>] elf_core_dump+0xbb9/0x1460
d [<ffffffff8108625a>] ? finish_task_switch+0x4a/0x100
d [<ffffffff8164054d>] ? schedule+0x5d/0x60
d [<ffffffff81084a23>] ? __wake_up+0x53/0x70
d [<ffffffff811dbaee>] do_coredump+0xb8e/0xef0
d [<ffffffff8106632d>] ? __sigqueue_free+0x3d/0x50
d [<ffffffff81069bcf>] get_signal_to_deliver+0x53f/0x5d0
d [<ffffffff81637c03>] ? bad_area+0x44/0x4c
d [<ffffffff810123c7>] do_signal+0x57/0x570
d [<ffffffff8108cf0d>] ? __dequeue_entity+0x3d/0x50
d [<ffffffff81637eda>] ? printk+0x61/0x63
d [<ffffffff8108625a>] ? finish_task_switch+0x4a/0x100
d [<ffffffff8164030b>] ? __schedule+0x6bb/0x800
d [<ffffffff8101291e>] do_notify_resume+0x3e/0x90
d [<ffffffff81641b3c>] retint_signal+0x48/0x8c

On some systems the requirements for max_map_count are really large, so we can't
avoid it. So, binfmt_elf.c should be fixed.

-- 
Dan Aloni
