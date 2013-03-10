Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467Ab3CJIxO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 04:53:14 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:51132 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302Ab3CJIxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 04:53:12 -0400
MIME-Version: 1.0
In-Reply-To: <CA+ydwtqHtwizg1=-KeLOjUUr+tzoFSPWRaeitE=10sm+pOYYKw@mail.gmail.com>
References: <CA+ydwtqqLZykdJXRPcd0_6UoNQJmTb2VeVKheHYDA+8-4wkW1g@mail.gmail.com>
	<20130308204113.GA15334@kroah.com>
	<CACVXFVP1_wXXw46KJCLhWy-TfGdnmSijnKGcycbZxS_0ZQUikg@mail.gmail.com>
	<CA+ydwtqHtwizg1=-KeLOjUUr+tzoFSPWRaeitE=10sm+pOYYKw@mail.gmail.com>
Date: Sun, 10 Mar 2013 16:53:11 +0800
Message-ID: <CACVXFVNJR69B=0G59FEqnu4Vhpn0_S_gf8j+vdUG2+0oLSPi_Q@mail.gmail.com>
Subject: Re: kernel BUG at fs/sysfs/group.c:65!
From: Ming Lei <tom.leiming@gmail.com>
To: Tommi Rantala <tt.rantala@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guo Chao <yan@linux.vnet.ibm.com>, Tejun Heo <tj@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 10, 2013 at 12:36 AM, Tommi Rantala <tt.rantala@gmail.com> wrote:
> [   40.089036]  [<ffffffff81222e29>] sysfs_get_dirent+0x39/0x80
> [   40.089036]  [<ffffffff81224ad9>] sysfs_remove_group+0x29/0x100
> [   40.089036]  [<ffffffff8113f2c4>] blk_trace_remove_sysfs+0x14/0x20
> [   40.089036]  [<ffffffff813453ae>] blk_unregister_queue+0x5e/0x90
> [   40.089036]  [<ffffffff8134d417>] del_gendisk+0x107/0x250
> [   40.089036]  [<ffffffff814f66b8>] loop_remove+0x18/0x40

Then the crash is triggered in device release path, which should have
been avoided in device add path.

If we want to fix the problem completely, add_disk() must handle failure
path correctly and return error code on failures, which may involve big
work, since add_disk() are called by 50+ drivers.

> [   40.089036]  [<ffffffff814f9369>] loop_control_ioctl+0x109/0x170
> [   40.089036]  [<ffffffff811b9542>] do_vfs_ioctl+0x522/0x570
> [   40.089036]  [<ffffffff8130a4b3>] ? file_has_perm+0x83/0xa0
> [   40.089036]  [<ffffffff811b95ed>] sys_ioctl+0x5d/0xa0
> [   40.089036]  [<ffffffff8136642e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [   40.089036]  [<ffffffff81faeda9>] system_call_fastpath+0x16/0x1b
> [   40.089036] Code: d8 4c 8b 65 e0 4c 8b 6d e8 4c 8b 75 f0 4c 8b 7d
> f8 c9 c3 0f 1f 80 00 00 00 00 55 48 89 e5 41 56 49 89 f6 41 55 49 89
> d5 41 54 53 <0f> b7 87 90 00 00 00 48 8b 9f 88 00 00 00 f6 c4 0f 0f 95
> c0 48
> [   40.089036] RIP  [<ffffffff81222c11>] sysfs_find_dirent+0x11/0x100
> [   40.089036]  RSP <ffff880076b61d38>
> [   40.089036] CR2: 0000000000000090
> [   40.141131] ---[ end trace c506c3563256809f ]---
> [3406] Random reseed: 2579687274
> [watchdog] 27757 iterations. [F:24388 S:3368]
> [watchdog] kernel became tainted! Last seed was 2579687274

Thanks,
-- 
Ming Lei
