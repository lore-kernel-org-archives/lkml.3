Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004AbaDYSX0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 14:23:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9469 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723AbaDYSXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 14:23:23 -0400
Date: Fri, 25 Apr 2014 20:23:10 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-security-module <linux-security-module@vger.kernel.org>,
        john.johansen@canonical.com, Mimi Zohar <zohar@linux.vnet.ibm.com>,
        James Morris <jmorris@namei.org>, viro@ZenIV.linux.org.uk,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kernel-team@lists.ubuntu.com
Subject: Re: Kernel panic at Ubuntu: IMA + Apparmor
Message-ID: <20140425182310.GA9128@redhat.com>
References: <535A5C78.1070901@samsung.com> <535A75C1.3050901@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <535A75C1.3050901@samsung.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25, Dmitry Kasatkin wrote:
>
> On 25/04/14 16:00, Dmitry Kasatkin wrote:
> > Hello,
> >
> > I discovered a kernel panic on system running Ubuntu when IMA is enabled.
> > It happens on reboot.
> >
> > ----------------------
> > [  106.750100] NSPROXY is NULL: error.log (/var/log/mysql/error.log)
> > [  106.750167] BUG: unable to handle kernel NULL pointer dereference at
> > 0000000000000018
> > [  106.750221] IP: [<ffffffff811ec7da>] our_mnt+0x1a/0x30
...
> > [  106.751149] Call Trace:
> > [  106.751172]  [<ffffffff813434eb>] ? aa_path_name+0x2ab/0x430
> > [  106.751199]  [<ffffffff8101b9b9>] ? sched_clock+0x9/0x10
> > [  106.751225]  [<ffffffff8134a68d>] aa_path_perm+0x7d/0x170
> > [  106.751250]  [<ffffffff8101b945>] ? native_sched_clock+0x15/0x80
> > [  106.751276]  [<ffffffff8134aa73>] aa_file_perm+0x33/0x40
> > [  106.751301]  [<ffffffff81348c5e>] common_file_perm+0x8e/0xb0
> > [  106.751327]  [<ffffffff81348d78>] apparmor_file_permission+0x18/0x20
> > [  106.751355]  [<ffffffff8130c853>] security_file_permission+0x23/0xa0
> > [  106.751382]  [<ffffffff811c77a2>] rw_verify_area+0x52/0xe0
> > [  106.751407]  [<ffffffff811c789d>] vfs_read+0x6d/0x170
> > [  106.751432]  [<ffffffff811cda31>] kernel_read+0x41/0x60
> > [  106.751457]  [<ffffffff8134fd45>] ima_calc_file_hash+0x225/0x280
> > [  106.751483]  [<ffffffff8134fb52>] ? ima_calc_file_hash+0x32/0x280
> > [  106.751509]  [<ffffffff8135022d>] ima_collect_measurement+0x9d/0x160
> > [  106.751536]  [<ffffffff810b552d>] ? trace_hardirqs_on+0xd/0x10
> > [  106.751562]  [<ffffffff8134f07c>] ? ima_file_free+0x6c/0xd0
> > [  106.751587]  [<ffffffff81352824>] ima_update_xattr+0x34/0x60
> > [  106.751612]  [<ffffffff8134f0d0>] ima_file_free+0xc0/0xd0
> > [  106.751637]  [<ffffffff811c9635>] __fput+0xd5/0x300

fantastic ;)

> > [  106.751662]  [<ffffffff811c98ae>] ____fput+0xe/0x10
> > [  106.751687]  [<ffffffff81086774>] task_work_run+0xc4/0xe0
> > [  106.751712]  [<ffffffff81066fad>] do_exit+0x2bd/0xa90
> > [  106.751738]  [<ffffffff8173c958>] ? retint_swapgs+0x13/0x1b
> > [  106.751763]  [<ffffffff8106780c>] do_group_exit+0x4c/0xc0
...
> It seems the problem is the order of functions in do_exit
>
> do_exit()
> {
>     ...
>     exit_task_namespaces(tsk);
>     exit_task_work(tsk);

Yes.

Eric, this makes me think again that we should do exit_task_namespaces()
after exit_task_work(). We already discussed this before, but this looks
like another indication this change makes sense.

The problem with fput() from free_nsproxy() was hopefully also fixed by
e7b2c4069252. The main motivation for "move" was "outside of exit_notify".
Even if we fix the paths above task_work_add() can have another user which
wants ->nsproxy.

What do you think?

Oleg.

