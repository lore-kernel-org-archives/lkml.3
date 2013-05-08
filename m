Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830Ab3EHVmx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 17:42:53 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:61047 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab3EHVmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 17:42:51 -0400
Date: Wed, 8 May 2013 17:42:49 -0400 (EDT)
From: Parag Warudkar <parag.lkml@gmail.com>
X-X-Sender: parag@parag-iMac
To: jkosina@suse.cz
cc: linux-kernel@vger.kernel.org
Subject: Re: HID: protect hid_debug_list
Message-ID: <alpine.DEB.2.02.1305081431300.7947@parag-iMac>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri

Commit 2353f2bea307390e015493118e425152b8a5a431 HID: protect 
hid_debug_list causes the below BUG due to mutex_lock being called in 
atomic context - does this need to be converted to a spin lock?

[ 5636.125330] BUG: sleeping function called from invalid context at 
kernel/mutex.c:95
[ 5636.125331] in_atomic(): 1, irqs_disabled(): 1, pid: 5489, name: 
pm-suspend
[ 5636.125333] CPU: 3 PID: 5489 Comm: pm-suspend Not tainted 3.9.0+ #13
[ 5636.125333] Hardware name: Apple Inc. iMac12,1/Mac-942B5BF58194151B, 
BIOS    IM121.88Z.0047.B1F.1201241648 01/24/12
[ 5636.125336]  ffff880843d96000 ffff88083ead1b88 ffffffff8150579f 
ffff88083ead1b98
[ 5636.125338]  ffffffff8107b600 ffff88083ead1bb8 ffffffff81507cfb 
ffff880843dc1400
[ 5636.125339]  ffff880843d96000 ffff88083ead1c00 ffffffff813c4352 
ffff880843d97e08
[ 5636.125340] Call Trace:
[ 5636.125345]  [<ffffffff8150579f>] dump_stack+0x19/0x1b
[ 5636.125349]  [<ffffffff8107b600>] __might_sleep+0xe0/0x100
[ 5636.125351]  [<ffffffff81507cfb>] mutex_lock+0x2b/0x50
[ 5636.125354]  [<ffffffff813c4352>] hid_debug_event+0x32/0x100
[ 5636.125356]  [<ffffffff813c4807>] hid_dump_input+0x67/0xa0
[ 5636.125358]  [<ffffffff813c6d10>] hid_set_field+0x50/0x120
[ 5636.125361]  [<ffffffff813d48ca>] usb_hidinput_input_event+0x9a/0x120
[ 5636.125363]  [<ffffffff813942f3>] input_dev_toggle+0x83/0x170
[ 5636.125365]  [<ffffffff8139672b>] input_reset_device+0x4b/0x80
[ 5636.125367]  [<ffffffff81396760>] ? input_reset_device+0x80/0x80
[ 5636.125368]  [<ffffffff81396775>] input_dev_resume+0x15/0x20
[ 5636.125372]  [<ffffffff81331168>] dpm_run_callback+0x58/0x90
[ 5636.125374]  [<ffffffff81331a2c>] device_resume+0xac/0x1a0
[ 5636.125376]  [<ffffffff813327c4>] dpm_resume+0x114/0x230
[ 5636.125378]  [<ffffffff81332b01>] dpm_resume_end+0x11/0x20
[ 5636.125381]  [<ffffffff81095d74>] suspend_devices_and_enter+0x144/0x490
[ 5636.125383]  [<ffffffff8109625a>] pm_suspend+0x19a/0x230
[ 5636.125385]  [<ffffffff81094eb7>] state_store+0x87/0xf0
[ 5636.125388]  [<ffffffff812584ff>] kobj_attr_store+0xf/0x20
[ 5636.125391]  [<ffffffff811e86bd>] sysfs_write_file+0xed/0x160
[ 5636.125394]  [<ffffffff81175e25>] vfs_write+0xc5/0x1f0
[ 5636.125395]  [<ffffffff81176312>] SyS_write+0x52/0xa0
[ 5636.125397]  [<ffffffff81512e01>] tracesys+0xd4/0xd9

Parag
