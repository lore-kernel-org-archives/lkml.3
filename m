Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011AbbAUDtL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 22:49:11 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:28223 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbbAUDtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 22:49:08 -0500
Message-ID: <54BF21AA.5010601@oracle.com>
Date: Tue, 20 Jan 2015 22:48:58 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Paul Moore <pmoore@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-audit@redhat.com
CC: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] fs: create proper filename objects using getname_kernel()
References: <20150119200408.29706.24386.stgit@localhost> <20150119200808.29706.73419.stgit@localhost>
In-Reply-To: <20150119200808.29706.73419.stgit@localhost>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2015 03:08 PM, Paul Moore wrote:
> There are several areas in the kernel that create temporary filename
> objects using the following pattern:
> 
> 	int func(const char *name)
> 	{
> 		struct filename *file = { .name = name };
> 		...
> 		return 0;
> 	}
> 
> ... which for the most part works okay, but it causes havoc within the
> audit subsystem as the filename object does not persist beyond the
> lifetime of the function.  This patch converts all of these temporary
> filename objects into proper filename objects using getname_kernel()
> and putname() which ensure that the filename object persists until the
> audit subsystem is finished with it.

Hi Paul,

With this patch (bisected) my vm fails to boot with a virtio-9p rootfs:

[   27.313687] fa00         2097152 vda  driver: virtio_blk
[   27.314218] 103:00000       8192 sda  driver: sd
[   27.314714] DEBUG_BLOCK_EXT_DEVT is enabled, you need to specify explicit textual name for "root=" boot option.
[   27.315963] Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)
[   27.316885] CPU: 29 PID: 1 Comm: swapper/0 Not tainted 3.19.0-rc5-next-20150120-sasha-00053-gb2e3c55-dirty #1772
[   27.316885]  ffffffffffffffff ffff88005cb8bd28 ffffffffb14522b5 000000000000004e
[   27.316885]  ffffffffb26d4950 ffff88005cb8bda8 ffffffffb144c298 ffff88005cb8bd48
[   27.316885]  ffffffff00000010 ffff88005cb8bdb8 ffff88005cb8bd58 fffffffffffffffe
[   27.316885] Call Trace:
[   27.316885]  [<ffffffffb14522b5>] dump_stack+0x4f/0x7b
[   27.316885]  [<ffffffffb144c298>] panic+0xd2/0x216
[   27.316885]  [<ffffffffb431558b>] mount_block_root+0x18b/0x244
[   27.316885]  [<ffffffffb43158ae>] mount_root+0x128/0x133
[   27.316885]  [<ffffffffb4315a1b>] prepare_namespace+0x162/0x19b
[   27.316885]  [<ffffffffb4315223>] kernel_init_freeable+0x285/0x29a
[   27.316885]  [<ffffffffb14472b0>] ? rest_init+0xd0/0xd0
[   27.316885]  [<ffffffffb14472be>] kernel_init+0xe/0xf0
[   27.316885]  [<ffffffffb148007c>] ret_from_fork+0x7c/0xb0
[   27.316885]  [<ffffffffb14472b0>] ? rest_init+0xd0/0xd0
[   27.316885] Dumping ftrace buffer:
[   27.316885]    (ftrace buffer empty)
[   27.316885] Kernel Offset: 0x2d000000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
[   27.316885] Rebooting in 1 seconds..

virtio-9p is not even listed as an option now.

Thanks,
Sasha
