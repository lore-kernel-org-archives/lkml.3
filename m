Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299Ab3JNSlc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 14:41:32 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:50823 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757091Ab3JNSlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 14:41:31 -0400
MIME-Version: 1.0
In-Reply-To: <20131014132711.GC4722@htj.dyndns.org>
References: <1380663729-18243-1-git-send-email-tj@kernel.org>
	<20131006004032.GA3601@kroah.com>
	<20131007170005.GB2481@htj.dyndns.org>
	<20131007231136.GB27270@kroah.com>
	<CAE9FiQV-bs0hiTDSzOR0GREMf=whichBocLPBF_uV09=LjTCtw@mail.gmail.com>
	<20131011204904.GA1308@kroah.com>
	<20131014132711.GC4722@htj.dyndns.org>
Date: Mon, 14 Oct 2013 11:41:30 -0700
X-Google-Sender-Auth: wgpPWyQ-9kXTXProUX1_LutNOR8
Message-ID: <CAE9FiQWJfc=c9zVyFcj9HLBRCkYaJD8UzggjdiJ9oU1mSEzBBw@mail.gmail.com>
Subject: Re: [PATCH driver-core-next] sysfs: make sysfs_file_ops() follow
 ignore_lockdep flag
From: Yinghai Lu <yinghai@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, Kay Sievers <kay@vrfy.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 6:27 AM, Tejun Heo <tj@kernel.org> wrote:
> 375b611e60 ("sysfs: remove sysfs_buffer->ops") introduced
> sysfs_file_ops() which determines the associated file operation of a
> given sysfs_dirent.  As file ops access should be protected by an
> active reference, the new function includes a lockdep assertion on the
> sysfs_dirent; unfortunately, I forgot to take attr->ignore_lockdep
> flag into account and the lockdep assertion trips spuriously for files
> which opt out from active reference lockdep checking.
>
> # cat /sys/devices/pci0000:00/0000:00:01.2/usb1/authorized
>
>  ------------[ cut here ]------------
>  WARNING: CPU: 1 PID: 540 at /work/os/work/fs/sysfs/file.c:79 sysfs_file_ops+0x4e/0x60()
>  Modules linked in:
>  CPU: 1 PID: 540 Comm: cat Not tainted 3.11.0-work+ #3
>  Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
>   0000000000000009 ffff880016205c08 ffffffff81ca0131 0000000000000000
>   ffff880016205c40 ffffffff81096d0d ffff8800166cb898 ffff8800166f6f60
>   ffffffff8125a220 ffff880011ab1ec0 ffff88000aff0c78 ffff880016205c50
>  Call Trace:
>   [<ffffffff81ca0131>] dump_stack+0x4e/0x82
>   [<ffffffff81096d0d>] warn_slowpath_common+0x7d/0xa0
>   [<ffffffff81096dea>] warn_slowpath_null+0x1a/0x20
>   [<ffffffff8125994e>] sysfs_file_ops+0x4e/0x60
>   [<ffffffff8125a274>] sysfs_open_file+0x54/0x300
>   [<ffffffff811df612>] do_dentry_open.isra.17+0x182/0x280
>   [<ffffffff811df820>] finish_open+0x30/0x40
>   [<ffffffff811f0623>] do_last+0x503/0xd90
>   [<ffffffff811f0f6b>] path_openat+0xbb/0x6d0
>   [<ffffffff811f23ba>] do_filp_open+0x3a/0x90
>   [<ffffffff811e09a9>] do_sys_open+0x129/0x220
>   [<ffffffff811e0abe>] SyS_open+0x1e/0x20
>   [<ffffffff81caf3c2>] system_call_fastpath+0x16/0x1b
>  ---[ end trace aa48096b111dafdb ]---
>
> Rename fs/sysfs/dir.c::ignore_lockdep() to sysfs_ignore_lockdep() and
> move it to fs/sysfs/sysfs.h and make sysfs_file_ops() skip lockdep
> assertion if sysfs_ignore_lockdep() is true.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Yinghai Lu <yinghai@kernel.org>

Tested-by: Yinghai Lu <yinghai@kernel.org>
