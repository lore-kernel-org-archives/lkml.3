Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482AbaAHWxa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 17:53:30 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:59039 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757101AbaAHWx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 17:53:27 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Baoquan <bhe@redhat.com>, linux-acpi@vger.kernel.org,
        zhangyanfei@cn.fujitsu.com, tangchen@cn.fujitsu.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        dyoung@redhat.com
Subject: Re: kdump failed because of hotplug memory adding in kdump kernel
Date: Thu, 09 Jan 2014 00:07:17 +0100
Message-ID: <8500545.JVNPnKcyD1@vostro.rjw.lan>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc6+; KDE/4.11.3; x86_64; ; )
In-Reply-To: <20140108155829.GC13649@redhat.com>
References: <52CD6E33.400@redhat.com> <20140108155829.GC13649@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 08, 2014 10:58:29 AM Vivek Goyal wrote:
> On Wed, Jan 08, 2014 at 11:26:43PM +0800, Baoquan wrote:
> 
> [..]
> > [    1.592222] acpi PNP0A03:03: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
> > [    1.605045] PCI host bridge to bus 0000:ff
> > [    1.609615] pci_bus 0000:ff: root bus resource [bus ff]
> > [    1.632117] System RAM resource [mem 0x01000000-0x7bffffff] cannot be added
> > [    1.639892] init_memory_mapping: [mem 0x100000000-0x87fffffff]
> > [    1.717793] swapper/0: page allocation failure: order:9, mode:0x84d0
> > [    1.724884] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.10.0-59.el7.x86_64 #1
> > [    1.732842] Hardware name: QCI QSSC-S4R/QSSC-S4R, BIOS QSSC-S4R.QCI.01.00.S001.032520101647 03/25/2010
> > [    1.743224]  0000000000000000 ffff8800339878c8 ffffffff815b64ad ffff880033987950
> > [    1.751513]  ffffffff8113a980 ffff88003673ab28 00000000000001fe 0000000000000001
> > [    1.759804]  ffff880000000040 ffffffff810bc28a 0000000000000000 0000000000000200
> > [    1.768096] Call Trace:                                                                                                                                            [348/1928]
> > [    1.770834]  [<ffffffff815b64ad>] dump_stack+0x19/0x1b
> > [    1.776561]  [<ffffffff8113a980>] warn_alloc_failed+0xf0/0x160
> > [    1.783076]  [<ffffffff810bc28a>] ? on_each_cpu_mask+0x2a/0x60
> > [    1.789581]  [<ffffffff8113e92f>] __alloc_pages_nodemask+0x7ff/0xa00
> > [    1.796672]  [<ffffffff815ada2c>] vmemmap_alloc_block+0x62/0xba
> > [    1.803274]  [<ffffffff815ada99>] vmemmap_alloc_block_buf+0x15/0x3b
> > [    1.810263]  [<ffffffff815ab8a6>] vmemmap_populate+0xb4/0x21b
> > [    1.816673]  [<ffffffff815adecd>] sparse_mem_map_populate+0x27/0x35
> > [    1.823665]  [<ffffffff815ad8bf>] sparse_add_one_section+0x7a/0x185
> > [    1.830659]  [<ffffffff8159b74f>] __add_pages+0xaf/0x240
> > [    1.836588]  [<ffffffff81047359>] arch_add_memory+0x59/0xd0
> > [    1.842804]  [<ffffffff8159ba89>] add_memory+0xb9/0x1b0
> > [    1.848638]  [<ffffffff8132dd2c>] acpi_memory_device_add+0x18d/0x26d
> > [    1.855728]  [<ffffffff81303b91>] acpi_bus_device_attach+0x7d/0xcd
> > [    1.862625]  [<ffffffff8131d92d>] acpi_ns_walk_namespace+0xc8/0x17f
> > [    1.869616]  [<ffffffff81303b14>] ? acpi_bus_type_and_status+0x90/0x90
> > [    1.876896]  [<ffffffff81303b14>] ? acpi_bus_type_and_status+0x90/0x90
> > [    1.884177]  [<ffffffff8131de1c>] acpi_walk_namespace+0x95/0xc5
> > [    1.890780]  [<ffffffff81304866>] acpi_bus_scan+0x8b/0x9d
> > [    1.896805]  [<ffffffff81a14a15>] acpi_scan_init+0x63/0x160
> > [    1.903021]  [<ffffffff81a14830>] acpi_init+0x25d/0x2a6
> 
> So basically acpi thinks that some memory block is a hot plug memory
> and tries to add it. And that consumes lots of memory and we don't have
> that memory in second kernel.

That's not exactly the case.  What seems to happen is that there is an ACPI
memory object in the ACPI namespace and the ACPI memory hotplug driver
attempts to bind to it.  That driver attempts to find removable memory blocks
associated with that object and to add them to the memory map.

Why don't you simply append acpi=off to the kexec command line?  That should
make the problem go away.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
