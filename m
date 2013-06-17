Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668Ab3FQIxD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 04:53:03 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:58420 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880Ab3FQIxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 04:53:00 -0400
MIME-Version: 1.0
In-Reply-To: <20130613015602.GA9024@localhost>
References: <20130613015602.GA9024@localhost>
From: Peng Tao <bergwolf@gmail.com>
Date: Mon, 17 Jun 2013 16:52:39 +0800
Message-ID: <CA+a=Yy6Pwin8D2etEfQLi3zqwDU_Mcv-CBJ-C3-vr1RhHNZfhw@mail.gmail.com>
Subject: Re: [lustre] WARNING: at kernel/mutex.c:341 mutex_lock_nested()
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Dilger, Andreas" <andreas.dilger@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 9:56 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> Greetings,
>
> I got the below dmesg and the first bad commit is
>
Hi Fengguang,

Thanks for reporting and my apology for the late reply. I was out of
town last week.

> commit ee04fd11f11fb67ff0ae482a6710f97f499c19e2
> Author: Peng Tao <bergwolf@gmail.com>
> Date:   Thu Jun 6 22:59:14 2013 +0800
>
>     Revert "Revert "staging/lustre: drop CONFIG_BROKEN dependency""
>
>     This reverts commit 37d4093fd34775bbbf99bddb84a711bdb3ec6d5c.
>
>     I've verified that we now don't break build on X86_64 allmodconfig.
>
>     Cc: Stephen Rothwell <sfr@canb.auug.org.au>
>     Signed-off-by: Peng Tao <tao.peng@emc.com>
>     Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> [   16.644069] alg: No test for adler32 (adler32-zlib)
> [   24.640247] ------------[ cut here ]------------
> [   24.640960] WARNING: at /c/kernel-tests/src/tip/kernel/mutex.c:341 mutex_lock_nested+0x1cb/0x526()
> [   24.642199] DEBUG_LOCKS_WARN_ON(l->magic != l)
This indicated that the_lnet.ln_lnd_mutex is not initialized but I am
confused because socklnd depends on lnet that is in charge of
initializing many things include the ln_lnd_mutex. If lnet is not
initialized, socklnd should not be called. And Lustre was built
in-kernel as shown in the config file. Does that mean module
dependency no longer works? I don't think so, but not sure how kernel
decides dependency if drivers are built-in.

Andreas, any ideas?

Thanks,
Tao

> [   24.642805] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.10.0-rc5-00678-ge764df6 #78
> [   24.647268] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
> [   24.648073]  ffffffff8235d9d1 ffff88000cc65d58 ffffffff81e18a81 ffff88000cc65d98
> [   24.649184]  ffffffff810a24a7 0000000000000000 ffff88000cc65da8 ffffffff83ae6c98
> [   24.650041]  0000000000000246 0000000000000000 ffffffff83ae6ca0 ffff88000cc65df8
> [   24.650041] Call Trace:
> [   24.650041]  [<ffffffff81e18a81>] dump_stack+0x27/0x30
> [   24.650041]  [<ffffffff810a24a7>] warn_slowpath_common+0x85/0xb5
> [   24.650041]  [<ffffffff810a2566>] warn_slowpath_fmt+0x54/0x5d
> [   24.650041]  [<ffffffff81e2361f>] mutex_lock_nested+0x1cb/0x526
> [   24.650041]  [<ffffffff81c07db1>] ? lnet_register_lnd+0x24/0x1ee
> [   24.650041]  [<ffffffff8124f351>] ? __register_sysctl_paths+0x1c4/0x22d
> [   24.650041]  [<ffffffff81c07db1>] ? lnet_register_lnd+0x24/0x1ee
> [   24.650041]  [<ffffffff81c07db1>] lnet_register_lnd+0x24/0x1ee
> [   24.650041]  [<ffffffff82b7d78d>] ? fld_mod_init+0x63/0x63
> [   24.650041]  [<ffffffff82b7d824>] ksocknal_module_init+0x97/0xa3
> [   24.650041]  [<ffffffff82b103a5>] do_one_initcall+0xb7/0x195
> [   24.650041]  [<ffffffff82b1069e>] kernel_init_freeable+0x21b/0x31e
> [   24.650041]  [<ffffffff82b0f84e>] ? loglevel+0x46/0x46
> [   24.650041]  [<ffffffff81e00bf6>] ? rest_init+0x13a/0x13a
> [   24.650041]  [<ffffffff81e00c0b>] kernel_init+0x15/0x16a
> [   24.650041]  [<ffffffff81e2a26c>] ret_from_fork+0x7c/0xb0
> [   24.650041]  [<ffffffff81e00bf6>] ? rest_init+0x13a/0x13a
> [   24.650041] ---[ end trace 87ffcbcb0b7b7e53 ]---
>
> git bisect start 5f43264c5320624f3b458c5794f37220c4fc2934 v3.9 --
> git bisect good 7b1e427d685e2aee91f9a622f9c2691130f8e57d  # 19:45     38+  s390/zcore: calculate real memory size using own get_mem_size function
> git bisect good a8c4b90e670be3b01e9395c7310639c8109fc77e  # 20:05     38+  Merge tag 'soc-for-linus-2' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc
> git bisect good a87af7c58b1f5af0d6a6093465d1a5ed8054434c  # 20:20     38+  staging/speakup: Replaced deprecated function
> git bisect good 11e7064f35bb87da8f427d1aa4bbd8b7473a3993  # 20:38     38+  ALSA: usb-audio - Fix invalid volume resolution on Logitech HD webcam c270
> git bisect good 17d8dfcda6ce570ddc4844f490104fed4af215aa  # 21:05     38+  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu
> git bisect good 423e118c0be32274de137a4d97f0dcac3edd136a  # 21:24     38+  Staging: csr: fix indentation style issue in bh.c
> git bisect  bad 3275b4d3db1f087c67fa115b150a9d2f9d8429f9  # 21:29      0-  staging: comedi: pcmad: tidy up pcmad_ai_insn_read()
> git bisect good 3e842f73c68fe44e8569107b94d710f4bbdcbb1f  # 21:50     38+  staging: octeon-usb: fix checkpatch error
> git bisect good 15bc85bdb509902e65fcf481c28369093097d92a  # 22:06     38+  staging: comedi: pcmda12: tidy up multi-line comments
> git bisect  bad ee04fd11f11fb67ff0ae482a6710f97f499c19e2  # 22:10      0-  Revert "Revert "staging/lustre: drop CONFIG_BROKEN dependency""
> git bisect good 88e5a934d3836b9eb948b46f402357c4c0e0eafe  # 22:35     38+  staging: rtl8192u: remove trailing whitespace in r8192U_core.c
> git bisect good d29dc2e418a7a4a5a776417dd3574f3e91824088  # 22:47     38+  staging/lustre: remove lu_context_keys_dump and lu_debugging_setup
> git bisect good 4a1a01ea52ad3d9bc0ac36f5a9739d6cce0bae75  # 22:57     38+  staging/lustre: surround module_refcount with CONFIG_MODULE_UNLOAD
> git bisect good 9c782da4f09d7665eb60b70dd83280b6a819857f  # 01:41     38+  staging/lustre/libcfs: cleanup linux-crypto
> git bisect good 9c782da4f09d7665eb60b70dd83280b6a819857f  # 05:21    114+  staging/lustre/libcfs: cleanup linux-crypto
> git bisect  bad e764df67963940b4123325710536a9471d1e24ae  # 05:21      0-  iio: frequency: adf4350: Add support for dt bindings
> git bisect good be62b98c327bed3d4b749e53b50bead5510aa11f  # 05:50    114+  Revert "Revert "Revert "staging/lustre: drop CONFIG_BROKEN dependency"""
> git bisect good 1a9c3d68d65f4b5ce32f7d67ccc730396e04cdd2  # 06:20    114+  Merge branch 'upstream' of git://git.linux-mips.org/pub/scm/ralf/upstream-linus
> git bisect good c04efed734409f5a44715b54a6ca1b54b0ccf215  # 06:49    114+  Add linux-next specific files for 20130607
>
> Thanks,
> Fengguang
