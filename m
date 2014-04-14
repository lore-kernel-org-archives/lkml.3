Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982AbaDNLoL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 07:44:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45693 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbaDNLoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 07:44:08 -0400
Date: Mon, 14 Apr 2014 04:47:04 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Chen Tingjie <tingjie.chen@intel.com>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Zhang Jun <jun.zhang@intel.com>
Subject: Re: [PATCH] [PATCH V2] tty: memleak in alloc_pid
Message-ID: <20140414114704.GB19027@kroah.com>
References: <1397460675-17983-1-git-send-email-tingjie.chen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397460675-17983-1-git-send-email-tingjie.chen@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 03:31:15PM +0800, Chen Tingjie wrote:
> There is memleak in alloc_pid:
> ------------------------------
> unreferenced object 0xd3453a80 (size 64):
>   comm "adbd", pid 1730, jiffies 66363 (age 6586.950s)
>   hex dump (first 32 bytes):
>     01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 40 c2 f6 d5 00 d3 25 c1 59 28 00 00  ....@.....%.Y(..
>   backtrace:
>     [<c1a6f15c>] kmemleak_alloc+0x3c/0xa0
>     [<c1320546>] kmem_cache_alloc+0xc6/0x190
>     [<c125d51e>] alloc_pid+0x1e/0x400
>     [<c123d344>] copy_process.part.39+0xad4/0x1120
>     [<c123da59>] do_fork+0x99/0x330
>     [<c123dd58>] sys_fork+0x28/0x30
>     [<c1a89a08>] syscall_call+0x7/0xb
>     [<ffffffff>] 0xffffffff
> 
> the leak is due to unreleased pid->count, which execute in function:
> get_pid()(pid->count++) and put_pid()(pid->count--).
> 
> The race condition as following:
> task[dumpsys]               task[adbd]
> in disassociate_ctty()      in tty_signal_session_leader()
> -----------------------     -------------------------
> tty = get_current_tty();
> // tty is not NULL
> ...
> spin_lock_irq(&current->sighand->siglock);
> put_pid(current->signal->tty_old_pgrp);
> current->signal->tty_old_pgrp = NULL;
> spin_unlock_irq(&current->sighand->siglock);
> 
>                             spin_lock_irq(&p->sighand->siglock);
>                             ...
>                             p->signal->tty = NULL;
>                             ...
>                             spin_unlock_irq(&p->sighand->siglock);
> 
> tty = get_current_tty();
> // tty NULL, goto else branch by accident.
> if (tty) {
>     ...
>     put_pid(tty_session);
>     put_pid(tty_pgrp);
>     ...
> } else {
>     print msg
> }
> 
> in task[dumpsys], in disassociate_ctty(), tty is set NULL by task[adbd],
> tty_signal_session_leader(), then it goto else branch and lack of
> put_pid(), cause memleak.
> 
> move spin_unlock(sighand->siglock) after get_current_tty() can avoid
> the race and fix the memleak.
> 
> Change-Id: Ic960dda039c8f99aad3e0f4d176489a966c62f6a

Why is this line here?

