Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757720Ab3FLBXH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 21:23:07 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51715 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757609Ab3FLBXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 21:23:05 -0400
Date: Wed, 12 Jun 2013 02:23:04 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Nix <nix@esperi.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: NFS/lazy-umount/path-lookup-related panics at shutdown (at kill
 of processes on lazy-umounted filesystems) with 3.9.2 and 3.9.5
Message-ID: <20130612012304.GF4165@ZenIV.linux.org.uk>
References: <871u89vp46.fsf@spindle.srvr.nix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871u89vp46.fsf@spindle.srvr.nix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 06:42:49PM +0100, Nix wrote:
> Yes, my shutdown scripts are panicking the kernel again! They're not
> causing filesystem corruption this time, but it's still fs-related.
> 
> Here's the 3.9.5 panic, seen on an x86-32 NFS client using NFSv3: NFSv4
> was compiled in but not used. This happened when processes whose
> current directory was on one of those NFS-mounted filesystems were being
> killed, after it had been lazy-umounted (so by this point its cwd was in
> a disconnected mount point).
> 
> [  251.246800] BUG: unable to handle kernel NULL pointer dereference at 00000004
> [  251.256556] IP: [<c01739f6>] path_init+0xc7/0x27f
> [  251.256556] *pde = 00000000
> [  251.256556] Oops: 0000 [#1]
> [  251.256556] Pid: 748, comm: su Not tainted 3.9.5+ #1
> [  251.256556] EIP: 0060:[<c01739f6>] EFLAGS: 00010246 CPU: 0
> [  251.256556] EIP is at path_init+0xc7/0x27f

Apparently that's set_root_rcu() with current->fs being NULL.  Which comes from
AF_UNIX connect done by some twisted call chain in context of hell knows what.

> [  251.256556]  [<c02ef8da>] ? unix_stream_connect+0xe1/0x2f7
> [  251.256556]  [<c026a14d>] ? kernel_connect+0x10/0x14
> [  251.256556]  [<c031ecb1>] ? xs_local_connect+0x108/0x181
> [  251.256556]  [<c031c83b>] ? xprt_connect+0xcd/0xd1
> [  251.256556]  [<c031fd1b>] ? __rpc_execute+0x5b/0x156
> [  251.256556]  [<c0128ac2>] ? wake_up_bit+0xb/0x19
> [  251.256556]  [<c031b83d>] ? rpc_run_task+0x55/0x5a
> [  251.256556]  [<c031b8bc>] ? rpc_call_sync+0x7a/0x8d
> [  251.256556]  [<c0325127>] ? rpcb_register_call+0x11/0x20
> [  251.256556]  [<c032548a>] ? rpcb_v4_register+0x87/0xf6
> [  251.256556]  [<c0321187>] ? svc_unregister.isra.22+0x46/0x87
> [  251.256556]  [<c03211d0>] ? svc_rpcb_cleanup+0x8/0x10
> [  251.256556]  [<c03213df>] ? svc_shutdown_net+0x18/0x1b
> [  251.256556]  [<c01cb1f3>] ? lockd_down+0x22/0x97
> [  251.256556]  [<c01c89df>] ? nlmclnt_done+0xc/0x14
> [  251.256556]  [<c01b9064>] ? nfs_free_server+0x7f/0xdb
> [  251.256556]  [<c016e776>] ? deactivate_locked_super+0x16/0x3e
> [  251.256556]  [<c0187e17>] ? free_fs_struct+0x13/0x20
> [  251.256556]  [<c011a009>] ? do_exit+0x224/0x64f
> [  251.256556]  [<c016d51f>] ? vfs_write+0x82/0x108
> [  251.256556]  [<c011a492>] ? do_group_exit+0x3a/0x65
> [  251.256556]  [<c011a4ce>] ? sys_exit_group+0x11/0x11
> [  251.256556]  [<c0332b3d>] ? syscall_call+0x7/0xb

Why is it done in essentially random process context, anyway?  There's such thing
as chroot, after all, which would screw that sucker as hard as NULL ->fs, but in
a less visible way...
