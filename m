Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741Ab3JKUtS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:49:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47187 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754689Ab3JKUtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 16:49:05 -0400
Date: Fri, 11 Oct 2013 13:49:04 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Kay Sievers <kay@vrfy.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCHSET v2] sysfs: use seq_file and unify regular and bin file
 handling
Message-ID: <20131011204904.GA1308@kroah.com>
References: <1380663729-18243-1-git-send-email-tj@kernel.org>
 <20131006004032.GA3601@kroah.com>
 <20131007170005.GB2481@htj.dyndns.org>
 <20131007231136.GB27270@kroah.com>
 <CAE9FiQV-bs0hiTDSzOR0GREMf=whichBocLPBF_uV09=LjTCtw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQV-bs0hiTDSzOR0GREMf=whichBocLPBF_uV09=LjTCtw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 12:11:18PM -0700, Yinghai Lu wrote:
> On Mon, Oct 7, 2013 at 4:11 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Mon, Oct 07, 2013 at 01:00:05PM -0400, Tejun Heo wrote:
> >> > How are you going to use sysfs from another kernel subsystem?  Is this
> >> > for another filesystem, or do you want to use kobjects for some other
> >> > subsystem that doesn't export them using sysfs?
> >>
> >> I was at first trying to convert sysfs interface to not use kobject
> >> but that caused too much disruption and I'm now trying to separate out
> >> the core functionality into a separate filesystem - currently named
> >> kernfs, so sysfs will be a consumer of kernfs translating between
> >> kobject and kernfs interface, and cgroup will be the second user which
> >> replaces its own pseudo filesystem implementation with kernfs.
> >
> > Ah, that would be nice, if it works out well, I might have to move
> > debugfs over to it also, as the current implementation of it has some
> > major issues.
> >
> got warning from drivers core next.
> 
> 
> [  448.189960] ------------[ cut here ]------------
> [  448.195214] WARNING: CPU: 6 PID: 69219 at fs/sysfs/file.c:79
> sysfs_file_ops+0x59/0x70()
> [  448.204188] Modules linked in:
> [  448.207630] CPU: 6 PID: 69219 Comm: hald Not tainted
> 3.12.0-rc4-yh-01397-gaac2c70 #1976
> [  448.216608] Hardware name:
> [  448.226753]  0000000000000009 ffff8ddee8731b88 ffffffff820f6b7e
> 0000000000000046
> [  448.235143]  0000000000000000 ffff8ddee8731bc8 ffffffff8109758c
> 0000000000000246
> [  448.243540]  ffff8ddf424c6098 ffff8ddf31c84480 ffff8ddf424c6098
> ffff8ddee8731f24
> [  448.251937] Call Trace:
> [  448.254711]  [<ffffffff820f6b7e>] dump_stack+0x46/0x58
> [  448.260496]  [<ffffffff8109758c>] warn_slowpath_common+0x8c/0xc0
> [  448.267249]  [<ffffffff810975da>] warn_slowpath_null+0x1a/0x20
> [  448.273805]  [<ffffffff81248bd9>] sysfs_file_ops+0x59/0x70
> [  448.279973]  [<ffffffff81249628>] sysfs_open_file+0x88/0x330
> [  448.286334]  [<ffffffff812495a0>] ? sysfs_release+0x70/0x70
> [  448.292606]  [<ffffffff811d3a49>] do_dentry_open.isra.15+0x1d9/0x2b0
> [  448.299745]  [<ffffffff811d3b4c>] finish_open+0x2c/0x40
> [  448.305621]  [<ffffffff811e5657>] do_last.isra.47+0xa37/0xc50
> [  448.312089]  [<ffffffff811e1bcd>] ? inode_permission+0x4d/0x50
> [  448.318655]  [<ffffffff811e5ac2>] path_openat+0x252/0x660
> [  448.324734]  [<ffffffff81100078>] ? trace_hardirqs_off_caller+0x28/0x160
> [  448.332264]  [<ffffffff811e62d3>] do_filp_open+0x43/0xb0
> [  448.338240]  [<ffffffff811f38e1>] ? __alloc_fd+0x121/0x140
> [  448.344409]  [<ffffffff811d4ea0>] do_sys_open+0x170/0x210
> [  448.350476]  [<ffffffff811d4f62>] SyS_open+0x22/0x30
> [  448.356057]  [<ffffffff82113d6a>] tracesys+0xd4/0xd9
> [  448.361629] ---[ end trace d1986b41b84640de ]---
> [  448.366842] ------------[ cut here ]------------
> [  448.372030] WARNING: CPU: 6 PID: 69219 at fs/sysfs/file.c:79
> sysfs_file_ops+0x59/0x70()
> [  448.381002] Modules linked in:
> [  448.384459] CPU: 6 PID: 69219 Comm: hald Tainted: G        W
> 3.12.0-rc4-yh-01397-gaac2c70 #1976
> [  448.394497] Hardware name:
> [  448.404630]  0000000000000009 ffff8ddee8731db8 ffffffff820f6b7e
> 0000000000004480
> [  448.413020]  0000000000000000 ffff8ddee8731df8 ffffffff8109758c
> 0000000000000246
> [  448.421418]  ffff8ddf424c6098 ffff8ddf30fb4e00 ffff8ddf424c6098
> ffff8ddf4668d000
> [  448.429805] Call Trace:
> [  448.432575]  [<ffffffff820f6b7e>] dump_stack+0x46/0x58
> [  448.438354]  [<ffffffff8109758c>] warn_slowpath_common+0x8c/0xc0
> [  448.445102]  [<ffffffff810975da>] warn_slowpath_null+0x1a/0x20
> [  448.451640]  [<ffffffff81248bd9>] sysfs_file_ops+0x59/0x70
> [  448.457806]  [<ffffffff81248cbb>] sysfs_seq_show+0xcb/0x180
> [  448.464069]  [<ffffffff811f99ec>] seq_read+0x19c/0x3a0
> [  448.469847]  [<ffffffff811d624d>] vfs_read+0xbd/0x170
> [  448.475517]  [<ffffffff811d6495>] SyS_read+0x55/0xb0
> [  448.481104]  [<ffffffff82113d6a>] tracesys+0xd4/0xd9
> [  448.486678] ---[ end trace d1986b41b84640df ]---
> [  448.662721]  [<ffffffff81100078>] ? trace_hardirqs_off_caller+0x28/0x160
> [  448.662730]  [<ffffffff811e62d3>] do_filp_open+0x43/0xb0
> [  448.662738]  [<ffffffff811f38e1>] ? __alloc_fd+0x121/0x140
> [  448.662747]  [<ffffffff811d4ea0>] do_sys_open+0x170/0x210
> [  448.662755]  [<ffffffff811d4f62>] SyS_open+0x22/0x30
> [  448.662763]  [<ffffffff82113d6a>] tracesys+0xd4/0xd9
> [  448.662766] ---[ end trace d1986b41b84640ea ]---
> [  448.662786] ------------[ cut here ]------------
> ....


Ick.  Tejun, any ideas?


