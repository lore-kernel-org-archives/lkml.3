Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab3JKWNR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 18:13:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:31429 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753480Ab3JKWNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 18:13:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,478,1378882800"; 
   d="scan'208";a="417963570"
Date: Fri, 11 Oct 2013 15:13:15 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>
Subject: Warning when calling radix_tree_insert on 3.12-rc4
Message-ID: <20131011221315.GE7094@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

I'm testing out some changes to the xHCI USB host controller driver
(which uses a radix tree when a UAS device is attached to the host), and
I noticed the following warning:

Oct 11 14:42:08 xanatos kernel: [18165.819014] usb 2-2: new SuperSpeed USB device number 2 using xhci_hcd
Oct 11 14:42:08 xanatos kernel: [18165.836264] usb 2-2: New USB device found, idVendor=174c, idProduct=55aa
Oct 11 14:42:08 xanatos kernel: [18165.836271] usb 2-2: New USB device strings: Mfr=2, Product=3, SerialNumber=1
Oct 11 14:42:08 xanatos kernel: [18165.836275] usb 2-2: Product: Plugable USB3-SATA-UASP1
Oct 11 14:42:08 xanatos kernel: [18165.836279] usb 2-2: Manufacturer: ASM1053E
Oct 11 14:42:08 xanatos kernel: [18165.836291] usb 2-2: SerialNumber: 123456789045
Oct 11 14:42:08 xanatos kernel: [18165.847661] BUG: using smp_processor_id() in preemptible [00000000] code: modprobe/8759
Oct 11 14:42:08 xanatos kernel: [18165.847667] caller is radix_tree_node_alloc+0x5c/0xa0
Oct 11 14:42:08 xanatos kernel: [18165.847670] CPU: 1 PID: 8759 Comm: modprobe Not tainted 3.12.0-rc4+ #94
Oct 11 14:42:08 xanatos kernel: [18165.847671] Hardware name: LENOVO 2325AP7/2325AP7, BIOS G2ET82WW (2.02 ) 09/11/2012
Oct 11 14:42:08 xanatos kernel: [18165.847673]  ffff88010c1d3fd8 ffff88010c1d38e8 ffffffff816081b9 0000000000000007
Oct 11 14:42:08 xanatos kernel: [18165.847677]  0000000000000001 ffff88010c1d3918 ffffffff812e3ffc ffff88010c26c988
Oct 11 14:42:08 xanatos kernel: [18165.847679]  0000000000000020 00000000000240b1 0000000000000003 ffff88010c1d3938
Oct 11 14:42:08 xanatos kernel: [18165.847682] Call Trace:
Oct 11 14:42:08 xanatos kernel: [18165.847686]  [<ffffffff816081b9>] dump_stack+0x4f/0x84
Oct 11 14:42:08 xanatos kernel: [18165.847689]  [<ffffffff812e3ffc>] debug_smp_processor_id+0xdc/0x100
Oct 11 14:42:08 xanatos kernel: [18165.847692]  [<ffffffff812d47fc>] radix_tree_node_alloc+0x5c/0xa0
Oct 11 14:42:08 xanatos kernel: [18165.847695]  [<ffffffff812d48d5>] radix_tree_insert+0x95/0x260
Oct 11 14:42:08 xanatos kernel: [18165.847702]  [<ffffffffa008446f>] xhci_update_stream_ring+0x8f/0xc0 [xhci_hcd]
Oct 11 14:42:08 xanatos kernel: [18165.847708]  [<ffffffffa00860f0>] xhci_alloc_stream_info+0x190/0x410 [xhci_hcd]
Oct 11 14:42:08 xanatos kernel: [18165.847713]  [<ffffffffa00802ef>] xhci_alloc_streams+0x36f/0x750 [xhci_hcd]
Oct 11 14:42:08 xanatos kernel: [18165.847716]  [<ffffffff8108678f>] ? ttwu_stat+0xef/0x160
Oct 11 14:42:08 xanatos kernel: [18165.847720]  [<ffffffff810c8e93>] ? is_module_address+0x33/0x60
Oct 11 14:42:08 xanatos kernel: [18165.847729]  [<ffffffffa0036e35>] usb_alloc_streams+0x95/0xb0 [usbcore]
Oct 11 14:42:08 xanatos kernel: [18165.847732]  [<ffffffffa01eb874>] uas_configure_endpoints+0x154/0x210 [uas]
Oct 11 14:42:08 xanatos kernel: [18165.847735]  [<ffffffffa01ec367>] uas_probe+0x2d7/0x390 [uas]
Oct 11 14:42:08 xanatos kernel: [18165.847743]  [<ffffffffa0040053>] usb_probe_interface+0x1c3/0x2f0 [usbcore]
Oct 11 14:42:08 xanatos kernel: [18165.847746]  [<ffffffff813ba421>] driver_probe_device+0x91/0x3c0
Oct 11 14:42:08 xanatos kernel: [18165.847749]  [<ffffffff813ba7fb>] __driver_attach+0xab/0xb0
Oct 11 14:42:08 xanatos kernel: [18165.847751]  [<ffffffff813ba750>] ? driver_probe_device+0x3c0/0x3c0
Oct 11 14:42:08 xanatos kernel: [18165.847753]  [<ffffffff813b835e>] bus_for_each_dev+0x5e/0x90
Oct 11 14:42:08 xanatos kernel: [18165.847756]  [<ffffffff813b9e6e>] driver_attach+0x1e/0x20
Oct 11 14:42:08 xanatos kernel: [18165.847758]  [<ffffffff813b988f>] bus_add_driver+0x10f/0x2d0
Oct 11 14:42:08 xanatos kernel: [18165.847760]  [<ffffffff813baf24>] driver_register+0x64/0xf0
Oct 11 14:42:08 xanatos kernel: [18165.847767]  [<ffffffffa003ec34>] usb_register_driver+0xc4/0x180 [usbcore]
Oct 11 14:42:08 xanatos kernel: [18165.847770]  [<ffffffffa01f0000>] ? 0xffffffffa01effff
Oct 11 14:42:08 xanatos kernel: [18165.847773]  [<ffffffffa01f001e>] uas_driver_init+0x1e/0x20 [uas]
Oct 11 14:42:08 xanatos kernel: [18165.847775]  [<ffffffff8100210a>] do_one_initcall+0xda/0x180
Oct 11 14:42:08 xanatos kernel: [18165.847778]  [<ffffffff81080313>] ? __blocking_notifier_call_chain+0x63/0x80
Oct 11 14:42:08 xanatos kernel: [18165.847782]  [<ffffffff810c7e42>] load_module+0x14b2/0x1ad0
Oct 11 14:42:08 xanatos kernel: [18165.847784]  [<ffffffff810c4680>] ? show_initstate+0x50/0x50
Oct 11 14:42:08 xanatos kernel: [18165.847788]  [<ffffffff810c8532>] SyS_init_module+0xd2/0x120
Oct 11 14:42:08 xanatos kernel: [18165.847791]  [<ffffffff816183a9>] system_call_fastpath+0x16/0x1b

This looks possibly related to commit
5e4c0d974139a98741b829b27cf38dc8f9284490 "lib/radix-tree.c: make
radix_tree_node_alloc() work correctly within interrupt".  I'll revert
the commit, and see if the warning disappears.  In the meantime, can you
look into fixing this?

Thanks,
Sarah Sharp
