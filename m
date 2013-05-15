Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759924Ab3EORxX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 13:53:23 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:16483 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759840Ab3EORxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 13:53:20 -0400
Message-ID: <1368640396.5673.35.camel@misato.fc.hp.com>
Subject: Re: V3.10-rc1 memory leak
From: Toshi Kani <toshi.kani@hp.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "rjw@sisk.pl" <rjw@sisk.pl>, Larry Finger <Larry.Finger@lwfinger.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Date: Wed, 15 May 2013 11:53:16 -0600
In-Reply-To: <20130515164743.GD9324@arm.com>
References: <51912567.6090507@lwfinger.net>
	 <1368558586.6828.53.camel@gandalf.local.home>
	 <20130514203028.GA2997@MacBook-Pro.local> <5192A847.1000100@lwfinger.net>
	 <1368566427.6828.58.camel@gandalf.local.home>
	 <1368579423.6828.63.camel@gandalf.local.home>
	 <5192FDE2.1020305@lwfinger.net>
	 <20130515150228.GC1096@darko.cambridge.arm.com>
	 <1368632990.5673.33.camel@misato.fc.hp.com> <20130515164743.GD9324@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-15 at 17:47 +0100, Catalin Marinas wrote:
> On Wed, May 15, 2013 at 04:49:50PM +0100, Toshi Kani wrote:
> > On Wed, 2013-05-15 at 16:02 +0100, Catalin Marinas wrote:
> > > On Wed, May 15, 2013 at 04:15:46AM +0100, Larry Finger wrote:
> > > > I do not see that particular one; however, I see 4 instances of
> > > > 
> > > > unreferenced object 0xffff8800b7979750 (size 8):
> > > >    comm "swapper/0", pid 1, jiffies 4294892402 (age 21888.316s)
> > > >    hex dump (first 8 bytes):
> > > >      31 38 00 b7 00 88 ff ff                          18......
> > > >    backtrace:
> > > >      [<ffffffff81432ea1>] kmemleak_alloc+0x21/0x50
> > > >      [<ffffffff81145d50>] __kmalloc_track_caller+0x140/0x2b0
> > > >      [<ffffffff81119fb5>] kstrdup+0x35/0x70
> > > >      [<ffffffff8125febc>] acpi_set_pnp_ids+0xd0/0x304
> > > >      [<ffffffff81260c47>] acpi_scan_init_hotplug+0x47/0xa1
> > > >      [<ffffffff81261223>] acpi_bus_check_add+0x66/0xd7
> > > >      [<ffffffff8127877a>] acpi_ns_walk_namespace+0xb9/0x173
> > > >      [<ffffffff81278bf3>] acpi_walk_namespace+0x93/0xc6
> > > >      [<ffffffff812612dc>] acpi_bus_scan+0x48/0x9a
> > > >      [<ffffffff818c983d>] acpi_scan_init+0x57/0x14b
> > > >      [<ffffffff818c966a>] acpi_init+0x244/0x286
> > > >      [<ffffffff810002fa>] do_one_initcall+0x10a/0x160
> > > >      [<ffffffff8189cef0>] kernel_init_freeable+0x103/0x192
> > > >      [<ffffffff814313a9>] kernel_init+0x9/0xf0
> > > >      [<ffffffff8144992c>] ret_from_fork+0x7c/0xb0
> > > >      [<ffffffffffffffff>] 0xffffffffffffffff
> > > > 
> > > > All four were allocated early in the bootup, and are the only leaks reported in 
> > > > my system. I have not yet tested to see if they are false.
> > > 
> > > This looks to me like a real leak, possibly introduced by commit
> > > 6b772e8f9 (ACPI: Update PNPID match handling for notify). The
> > > acpi_scan_init_hotplug() function calls acpi_set_pnp_ids() which
> > > allocates pnp.unique_id (kstrdup()) but for some reason it fails and
> > > does not set pnp.type.hardware_id. The return does not call
> > > acpi_free_pnp_ids() which would be responsible for such freeing.
> > 
> > I agree with your analysis.  It appears that this ACPI device object has
> > _UID but not _HID.  ACPI spec defines that _UID is a unique ID among a
> > same _HID.  So, it is odd to have _UID without _HID.  But, nonetheless,
> > this case needs to be handled as such systems exist.
> > 
> > > Something like below, but not tested and may fail some NULL pointer
> > > checks:
> > 
> > The change looks good.  acpi_free_pnp_ids() handles this empty list
> > pnp->ids properly.  Are you going to submit this patch with your
> > signed-off?
> 
> Yes, I'll post it shortly. But I'd like an acked/tested-by as I don't
> have a platform to test it.

I was able to reproduce this issue by adding a fake ACPI device object
with _UID only.  I will test your change as well.

Thanks,
-Toshi

