Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489Ab3EANss (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 09:48:48 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:21323 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970Ab3EANsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 09:48:40 -0400
Date: Wed, 1 May 2013 09:48:14 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: rostedt@goodmis.org, ard@telegraafnet.nl, akpm@linux-foundation.org,
        hpa@zytor.com, len.brown@intel.com, linux-kernel@vger.kernel.org,
        mchehab@redhat.com, rjw@sisk.pl
Subject: initcall ffh_cstate_init+0x0/0x2a returned with error code -1 throws
 WARN
Message-ID: <20130501134814.GA5001@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now with the git commit f91eb62f71b31e69e405663ff8d047bc3b9f7525
(init: scream bloody murder if interrupts are enabled too early)

I get this on unrealted initcall throwing out -1, and -22 errors:

[    7.235568] initcall ffh_cstate_init+0x0/0x2a returned -1 after 0 usecs
[    7.242463] ------------[ cut here ]------------
[    7.247294] WARNING: at /home/konrad/linux-linus/init/main.c:700 do_one_initcall+0x171/0x180()
[    7.256243] initcall ffh_cstate_init+0x0/0x2a returned with error code -1
[    7.263407] Modules linked in:
[    7.266622] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.9.0upstream-05391-gd63e0d5 #1
[    7.274771] Hardware name: System manufacturer System Product Name/F1A75-M, BIOS 0406 06/11/2011
[    7.283901]  ffffffff81922400 ffff8801f3141e28 ffffffff81664903 ffff8801f3141e68
[    7.291593]  ffffffff8108c0fb 0000000014cd5140 00000000ffffffff ffffffff81ad5d77
[    7.299290]  0000000000000000 ffff8801f3141fd8 0000000000000000 ffff8801f3141ec8
[    7.306987] Call Trace:
[    7.309597]  [<ffffffff81664903>] dump_stack+0x19/0x1e
[    7.314967]  [<ffffffff8108c0fb>] warn_slowpath_common+0x6b/0xa0
[    7.321228]  [<ffffffff81ad5d77>] ? acpi_sleep_setup+0x123/0x123
[    7.327493]  [<ffffffff8108c1d1>] warn_slowpath_fmt+0x41/0x50
[    7.333490]  [<ffffffff81ad5d77>] ? acpi_sleep_setup+0x123/0x123
[    7.339755]  [<ffffffff81ad5d77>] ? acpi_sleep_setup+0x123/0x123
[    7.346020]  [<ffffffff81002171>] do_one_initcall+0x171/0x180
[    7.352019]  [<ffffffff81ac4a03>] kernel_init_freeable+0x157/0x1e6
[    7.358462]  [<ffffffff81ac4a92>] ? kernel_init_freeable+0x1e6/0x1e6
[    7.365085]  [<ffffffff8164eae0>] ? rest_init+0xa0/0xa0
[    7.370549]  [<ffffffff8164eae9>] kernel_init+0x9/0xf0
[    7.375920]  [<ffffffff8167077c>] ret_from_fork+0x7c/0xb0
[    7.381557]  [<ffffffff8164eae0>] ? rest_init+0xa0/0xa0
[    7.387022] ---[ end trace d5e314f425291f41 ]---
[    7.391846] calling  activate_jump_labels+0x0/0x32 @ 1


which is b/c the machine is an AMD box and does not have FFH.

Should the ffh_cstate_init be changed to return -ENODEV instead
of -1?
Ah wait, nope. I get this too:

[   13.308853] initcall hugepage_init+0x0/0x145 returned -22 after 0 usecs
[   13.315741] ------------[ cut here ]------------
[   13.320579] WARNING: at /home/konrad/linux-linus/init/main.c:700 do_one_initcall+0x171/0x180()
[   13.329526] initcall hugepage_init+0x0/0x145 returned with error code -22
[   13.336685] Modules linked in:
[   13.339903] CPU: 1 PID: 1 Comm: swapper/0 Tainted: G        W    3.9.0upstream-05391-gd63e0d5 #1
[   13.349038] Hardware name: System manufacturer System Product Name/F1A75-M, BIOS 0406 06/11/2011
[   13.358167]  ffffffff81922400 ffff8801f3141e28 ffffffff81664903 ffff8801f3141e68
[   13.365858]  ffffffff8108c0fb 0000000000000000 00000000ffffffea ffffffff81af0228
[   13.373573]  0000000000000000 ffff8801f3141fd8 0000000000000000 ffff8801f3141ec8
[   13.381279] Call Trace:
[   13.383879]  [<ffffffff81664903>] dump_stack+0x19/0x1e
[   13.389248]  [<ffffffff8108c0fb>] warn_slowpath_common+0x6b/0xa0
[   13.395513]  [<ffffffff81af0228>] ? ftrace_define_fields_mm_migrate_pages+0xcf/0xcf
[   13.403478]  [<ffffffff8108c1d1>] warn_slowpath_fmt+0x41/0x50
[   13.409475]  [<ffffffff81af0228>] ? ftrace_define_fields_mm_migrate_pages+0xcf/0xcf
[   13.417441]  [<ffffffff81af0228>] ? ftrace_define_fields_mm_migrate_pages+0xcf/0xcf
[   13.425407]  [<ffffffff81002171>] do_one_initcall+0x171/0x180
[   13.431405]  [<ffffffff81ac4a03>] kernel_init_freeable+0x157/0x1e6
[   13.437848]  [<ffffffff81ac4a92>] ? kernel_init_freeable+0x1e6/0x1e6
[   13.444472]  [<ffffffff8164eae0>] ? rest_init+0xa0/0xa0
[   13.449931]  [<ffffffff8164eae9>] kernel_init+0x9/0xf0
[   13.455302]  [<ffffffff8167077c>] ret_from_fork+0x7c/0xb0
[   13.460941]  [<ffffffff8164eae0>] ? rest_init+0xa0/0xa0
[   13.466397] ---[ end trace d5e314f425291f42 ]---

and (if I boot the machine with acpi=off):
[   14.808890] GHES: HEST is not enabled!
[   14.812829] initcall ghes_init+0x0/0x171 returned -22 after 3845 usecs
[   14.819633] ------------[ cut here ]------------
[   14.824473] WARNING: at /home/konrad/linux-linus/init/main.c:700 do_one_initcall+0x171/0x180()
[   14.833416] initcall ghes_init+0x0/0x171 returned with error code -22
[   14.840217] Modules linked in:
[   14.843441] CPU: 3 PID: 1 Comm: swapper/0 Tainted: G        W    3.9.0upstream-05391-gd63e0d5 #1
[   14.852570] Hardware name: System manufacturer System Product Name/F1A75-M, BIOS 0406 06/11/2011
[   14.861700]  ffffffff81922400 ffff8801f3141e28 ffffffff81664903 ffff8801f3141e68
[   14.869396]  ffffffff8108c0fb 00000001add97f74 00000000ffffffea ffffffff81aff1ca
[   14.877087]  0000000000000000 ffff8801f3141fd8 0000000000000000 ffff8801f3141ec8
[   14.884784] Call Trace:
[   14.887393]  [<ffffffff81664903>] dump_stack+0x19/0x1e
[   14.892762]  [<ffffffff8108c0fb>] warn_slowpath_common+0x6b/0xa0
[   14.899027]  [<ffffffff81aff1ca>] ? erst_init+0x2bb/0x2bb
[   14.904665]  [<ffffffff8108c1d1>] warn_slowpath_fmt+0x41/0x50
[   14.910663]  [<ffffffff81aff1ca>] ? erst_init+0x2bb/0x2bb
[   14.916302]  [<ffffffff81aff1ca>] ? erst_init+0x2bb/0x2bb
[   14.921940]  [<ffffffff81002171>] do_one_initcall+0x171/0x180
[   14.927937]  [<ffffffff81ac4a03>] kernel_init_freeable+0x157/0x1e6
[   14.934381]  [<ffffffff81ac4a92>] ? kernel_init_freeable+0x1e6/0x1e6
[   14.941004]  [<ffffffff8164eae0>] ? rest_init+0xa0/0xa0
[   14.946467]  [<ffffffff8164eae9>] kernel_init+0x9/0xf0
[   14.951835]  [<ffffffff8167077c>] ret_from_fork+0x7c/0xb0
[   14.957472]  [<ffffffff8164eae0>] ? rest_init+0xa0/0xa0
[   14.962930] ---[ end trace d5e314f425291f43 ]---
[   14.967764] calling  einj_init+0x0/0x49d @ 1


So... should the WARN be more selective?
