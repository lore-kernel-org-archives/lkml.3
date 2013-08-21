Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915Ab3HUEqa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 00:46:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:46001 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728Ab3HUEq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 00:46:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,925,1367996400"; 
   d="scan'208";a="389520003"
Message-ID: <5214461D.9000009@intel.com>
Date: Tue, 20 Aug 2013 21:46:21 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Libin <huawei.libin@huawei.com>
CC: Vegard Nossum <vegardno@ifi.uio.no>, Pekka Enberg <penberg@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>, guohanjun@huawei.com,
        zhangdianfang@huawei.com
Subject: Re: [BUG REPORT]kernel panic with kmemcheck config
References: <5212D7F2.3020308@huawei.com> <521381A9.4020501@intel.com> <521429D5.8070003@huawei.com>
In-Reply-To: <521429D5.8070003@huawei.com>
Content-Type: text/plain; charset=gb18030
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2013 07:45 PM, Libin wrote:
> [    3.158023] ------------[ cut here ]------------
> [    3.162626] WARNING: CPU: 0 PID: 1 at arch/x86/mm/kmemcheck/kmemcheck.c:634 kmemcheck_fault+0xb1/0xc0()
...
> [    3.314877]  [<ffffffff81046aa7>] ? kmemcheck_trap+0x17/0x30
> [    3.320507]  <<EOE>>  <#DB>  [<ffffffff8150de8a>] do_debug+0x16a/0x1c0
> [    3.327029]  [<ffffffff8150d815>] debug+0x25/0x40
> [    3.331714]  [<ffffffff812776cc>] ? rb_insert_color+0xcc/0x150
> [    3.337518]  <<EOE>>  [<ffffffff811eefd8>] sysfs_link_sibling+0xa8/0xf0
> [    3.344124]  [<ffffffff811ef46a>] ? __sysfs_add_one+0x6a/0x120
> [    3.349931]  [<ffffffff811ef477>] __sysfs_add_one+0x77/0x120
> [    3.355563]  [<ffffffff811ef546>] sysfs_add_one+0x26/0xe0
> [    3.360937]  [<ffffffff811f007c>] create_dir+0x7c/0xd0
> [    3.366050]  [<ffffffff811f0163>] sysfs_create_dir+0x93/0xd0
> [    3.371684]  [<ffffffff81274249>] kobject_add_internal+0xe9/0x270
> [    3.377748]  [<ffffffff81274598>] kobject_add_varg+0x38/0x60
> [    3.383380]  [<ffffffff8127464e>] ? kobject_add+0x1e/0x70
> [    3.388751]  [<ffffffff81274674>] kobject_add+0x44/0x70
> [    3.393954]  [<ffffffff81364f72>] ? device_add+0xc2/0x580
> [    3.399328]  [<ffffffff81364f83>] device_add+0xd3/0x580
> [    3.404529]  [<ffffffff8136455b>] ? device_initialize+0xab/0xc0
> [    3.410422]  [<ffffffff81365449>] device_register+0x19/0x20
> [    3.415971]  [<ffffffff8137abeb>] init_memory_block+0xfb/0x120
> [    3.421776]  [<ffffffff8137aebc>] add_memory_section+0xdc/0x140
> [    3.427672]  [<ffffffff81b33274>] memory_dev_init+0xa3/0xc1
> [    3.433264]  [<ffffffff81b32eef>] driver_init+0x2f/0x31
> [    3.438466]  [<ffffffff81aee7ed>] do_basic_setup+0x29/0xce
> [    3.443929]  [<ffffffff81b0ffd5>] ? sched_init_smp+0x14f/0x156
> [    3.449735]  [<ffffffff81aeea9f>] kernel_init_freeable+0x20d/0x291
> [    3.455886]  [<ffffffff81501330>] ? rest_init+0x80/0x80
> [    3.461084]  [<ffffffff81501339>] kernel_init+0x9/0x180
> [    3.466285]  [<ffffffff8151562c>] ret_from_fork+0x7c/0xb0
> [    3.471659]  [<ffffffff81501330>] ? rest_init+0x80/0x80
> [    3.476865] ---[ end trace bae4d98dd36296b7 ]---

So it's a kmemcheck trap while poking sysfs in the middle of the memory
kobjects getting created.  This code gets run at boot on a *LOT* of
systems, so it's probably something specific to your hardware.  I'd
suspect something like a memory section getting added twice, or a bug in
some error handling path.

You might want to double-check that all the calls to
add_memory_section() look sane.  It's also a bummer that kmemcheck
doesn't dump out the actual faulting address.


