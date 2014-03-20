Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759898AbaCTWuc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 18:50:32 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:56864 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759365AbaCTWu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 18:50:29 -0400
MIME-Version: 1.0
In-Reply-To: <20140320124143.GA10751@localhost>
References: <20140320124143.GA10751@localhost>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 20 Mar 2014 16:50:08 -0600
Message-ID: <CAErSpo7i1sD=mNd1MZ+yWrPrPJDpZx2w-L3Dj=2N+gJBqVdSzA@mail.gmail.com>
Subject: Re: [pci] WARNING: CPU: 0 PID: 1 at drivers/gpu/drm/drm_crtc.c:94 drm_warn_on_modeset_not_all_locked()
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Alex Deucher <alexander.deucher@amd.com>,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2014 at 6:41 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> Greetings,
>
> I got the below dmesg and the first bad commit is
>
> git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git pci/resource
>
> commit aa11fc58dc71c27701b1f9a529a36a38d4337722
> Author:     Bjorn Helgaas <bhelgaas@google.com>
> AuthorDate: Fri Mar 7 13:39:01 2014 -0700
> Commit:     Bjorn Helgaas <bhelgaas@google.com>
> CommitDate: Wed Mar 19 15:00:16 2014 -0600
>
>     PCI: Check all IORESOURCE_TYPE_BITS in pci_bus_alloc_from_region()
>
>     When allocating space from a bus resource, i.e., from apertures leading to
>     this bus, make sure the entire resource type matches.  The previous code
>     assumed the IORESOURCE_TYPE_BITS field was a bitmask with only a single bit
>     set, but this is not true.  IORESOURCE_TYPE_BITS is really an enumeration,
>     and we have to check all the bits.
>
>     See 72dcb1197228 ("resources: Add register address resource type").
>
>     No functional change.  If we used this path for allocating IRQs, DMA
>     channels, or bus numbers, this would fix a bug because those types are
>     indistinguishable when masked by IORESOURCE_IO | IORESOURCE_MEM.  But we
>     don't, so this shouldn't make any difference.
>
>     Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

Thanks (I think).  I'm afraid I'm going to need some more help to
debug this.  I built aa11fc58dc with the config you supplied and
booted it on qemu with no real issues (it didn't boot all the way
because the config doesn't include a driver for my root disk, but
that's to be expected).

The dmesg you supplied is for some other commit 2d18516 that I don't
have, so I'm confused about why it's not from aa11fc58dc.

I did reproduce what appears to be basically the same problem with
a654dc797f3e, which is the 20140320 linux-next tree.  I backed up to
93ecdc077282, which is where pci/next was merged (this includes
aa11fc58dc), but I could not reproduce the problem there.

So bottom line, I'm confused because your bisection doesn't match what
I'm seeing, and I don't want to spend more time flailing around.

Bjorn


> +------------------------------------------------------------------------------------------------+------------+------------+
> |                                                                                                | aa11fc58dc | 2d18516523 |
> +------------------------------------------------------------------------------------------------+------------+------------+
> | boot_successes                                                                                 | 19         | 0          |
> | boot_failures                                                                                  | 1          | 19         |
> | BUG:unable_to_handle_kernel_NULL_pointer_dereference                                           | 1          | 1          |
> | Oops                                                                                           | 1          | 1          |
> | EIP_is_at_rapl_pmu_init                                                                        | 1          | 1          |
> | Kernel_panic-not_syncing:Attempted_to_kill_init_exitcode=                                      | 1          | 1          |
> | backtrace:rapl_pmu_init                                                                        | 1          | 1          |
> | backtrace:kernel_init_freeable                                                                 | 1          | 19         |
> | WARNING:CPU:PID:at_drivers/gpu/drm/drm_crtc.c:drm_warn_on_modeset_not_all_locked()             | 0          | 18         |
> | WARNING:CPU:PID:at_drivers/gpu/drm/drm_crtc_helper.c:drm_helper_encoder_in_use()               | 0          | 18         |
> | WARNING:CPU:PID:at_drivers/gpu/drm/drm_crtc_helper.c:drm_helper_crtc_in_use()                  | 0          | 18         |
> | WARNING:CPU:PID:at_drivers/gpu/drm/drm_crtc_helper.c:drm_helper_probe_single_connector_modes() | 0          | 18         |
> | WARNING:CPU:PID:at_drivers/gpu/drm/drm_modes.c:drm_mode_probed_add()                           | 0          | 18         |
> | WARNING:CPU:PID:at_drivers/gpu/drm/drm_modes.c:drm_mode_connector_list_update()                | 0          | 18         |
> | backtrace:drm_helper_disable_unused_functions                                                  | 0          | 18         |
> | backtrace:cirrus_fbdev_init                                                                    | 0          | 18         |
> | backtrace:cirrus_modeset_init                                                                  | 0          | 18         |
> | backtrace:__pci_register_driver                                                                | 0          | 18         |
> | backtrace:drm_pci_init                                                                         | 0          | 18         |
> | backtrace:cirrus_init                                                                          | 0          | 18         |
> | backtrace:drm_fb_helper_initial_config                                                         | 0          | 18         |
> +------------------------------------------------------------------------------------------------+------------+------------+
>
> [    1.624247] [TTM] Initializing pool allocator
> [    1.625248] ------------[ cut here ]------------
> [    1.625248] ------------[ cut here ]------------
> [    1.626136] WARNING: CPU: 0 PID: 1 at drivers/gpu/drm/drm_crtc.c:94 drm_warn_on_modeset_not_all_locked+0x61/0xc6()
>
> git bisect start 2d1851652373730f6b8c7fa7f45eaa854f23da8f dcb99fd9b08cfe1afe426af4d8d3cbc429190f15 --
> git bisect  bad 82202f95148065d7a0f5d86d4d6e39f31dbd7937  # 12:19      0-     10  Merge 'asoc/fix/cs42l51' into devel-hourly-2014032007
> git bisect good 9115e0b3218bd6b97e830bc36e6e80c4890f6fe4  # 12:45     20+      0  Merge 'scsi/misc' into devel-hourly-2014032007
> git bisect good 4fb88b0dc2d9b229d03a9e6555d9056888c90137  # 14:42     20+      0  Merge 'target/for-next' into devel-hourly-2014032007
> git bisect  bad c5011f998a8e94c052c5aa71cf19510f2d0bf5fd  # 15:06      0-      1  Merge 'pci/pci/resource' into devel-hourly-2014032007
> git bisect good daec480a6e6be6e9716a56029aafcbfb79e6b47b  # 15:41     20+      0  Merge 'netdev-next/master' into devel-hourly-2014032007
> git bisect good 937441ae220fd3fae143ef394227337c969ad155  # 15:57     20+      0  Merge 'kvm/queue' into devel-hourly-2014032007
> git bisect good 3cedcc3621289d41bd21c5dbe0b886d57c83a1ea  # 16:27     20+      0  PCI: Don't enable decoding if BAR hasn't been assigned an address
> git bisect good d75332325389a95c4ddbfa0f0cd7e5e08a54aa43  # 16:54     20+      0  s390/PCI: Use generic pci_enable_resources()
> git bisect  bad aa11fc58dc71c27701b1f9a529a36a38d4337722  # 17:11      0-      1  PCI: Check all IORESOURCE_TYPE_BITS in pci_bus_alloc_from_region()
> git bisect good 6404e88e8385638123f4b18b104430480870601a  # 17:23     20+      0  resources: Set type in __request_region()
> # first bad commit: [aa11fc58dc71c27701b1f9a529a36a38d4337722] PCI: Check all IORESOURCE_TYPE_BITS in pci_bus_alloc_from_region()
> git bisect good 6404e88e8385638123f4b18b104430480870601a  # 17:27     60+      0  resources: Set type in __request_region()
> git bisect  bad 2d1851652373730f6b8c7fa7f45eaa854f23da8f  # 17:27      0-     19  0day head guard for 'devel-hourly-2014032007'
> git bisect good 887843961c4b4681ee993c36d4997bf4b4aa8253  # 19:24     60+      0  mm: fix bad rss-counter if remap_file_pages raced migration
> git bisect  bad a654dc797f3ea1cb5719a71a17af35f57fddb2d8  # 20:10      0-      1  Add linux-next specific files for 20140320
>
> Thanks,
> Fengguang
