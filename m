Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751295AbaDOCtI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 22:49:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:34293 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbaDOCtG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 22:49:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,861,1389772800"; 
   d="scan'208";a="520828010"
From: "Chen, Tingjie" <tingjie.chen@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Jiri Slaby <jslaby@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhang, Jun" <jun.zhang@intel.com>,
        "One Thousand Gnomes" <gnomes@lxorguk.ukuu.org.uk>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>
Subject: RE: [PATCH] [PATCH V2] tty: memleak in alloc_pid
Thread-Topic: [PATCH] [PATCH V2] tty: memleak in alloc_pid
Thread-Index: AQHPV7JyCUamM6iyGUeFZWzTAGRct5sQeQEAgAFsfSA=
Date: Tue, 15 Apr 2014 02:49:02 +0000
Message-ID: <BA0C77F83D4255479F53DBBC4C4BAFC55FF699@SHSMSX101.ccr.corp.intel.com>
References: <1397460675-17983-1-git-send-email-tingjie.chen@intel.com>
 <20140414114704.GB19027@kroah.com>
In-Reply-To: <20140414114704.GB19027@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The related code in disassociate_ctty() as following:

---------------------------------------
    /* sometimes current->signal->tty_old_pgrp is NULL    (a stand for tty_old_pgrp not NULL, !a for tty_old_pgrp is NULL) */
    spin_lock_irq(&current->sighand->siglock);
	put_pid(current->signal->tty_old_pgrp);        // when a is NULL, will not actually put_pid() by decrease the count
	current->signal->tty_old_pgrp = NULL;
	spin_unlock_irq(&current->sighand->siglock);
    
    /* sometimes current->signal->tty is NULL     (b stand for signal->tty, !b for signal->tty is NULL) */
	tty = get_current_tty();
	if (tty) {
		unsigned long flags;
		spin_lock_irqsave(&tty->ctrl_lock, flags);
		put_pid(tty->session);
		put_pid(tty->pgrp);
		tty->session = NULL;
		tty->pgrp = NULL;
		spin_unlock_irqrestore(&tty->ctrl_lock, flags);
		tty_kref_put(tty);
	} else {
#ifdef TTY_DEBUG_HANGUP
		printk(KERN_DEBUG "error attempted to write to tty [0x%p]"
		       " = NULL", tty);
#endif
	}
------------------------------------

Commonly there are 2 normal case flow for the code:
1/ in task: getprop: !a --> b

  This case, current->signal->tty_old_pgrp is NULL, but get_current_tty() is not NULL, 
  Really put_pid() as following:
      put_pid(tty->session);
      put_pid(tty->pgrp);

2/ in task: dumpsys: a --> !b

  This case, currnet->signal->tty_old_pgrp is not NULL, but get_current_tty() is NULL,
  Really put_pid() as following:
      put_pid(current->signal->tty_old_pgrp);

There is one abnormal case:
3/ in task: dumpsys: !a -> !b

  This case, because of race, current->signal->tty_old_pgrp and get_current_tty() are NULL,
  Lack of put_pid(), pid->count will not be 0 at last, this pid will be leak.


When read the current->signal->tty_old_pgrp and current->signal->tty,
The 2 operations should be atomic, which protected by spinlock: current->sighand->siglock.
So the sentence: spin_unlock_irq(&current->sighand->siglock);
need to move down after tty has process completed.

Thanks,

-----Original Message-----
From: Greg Kroah-Hartman [mailto:gregkh@linuxfoundation.org] 
Sent: Monday, April 14, 2014 7:47 PM
To: Chen, Tingjie
Cc: Jiri Slaby; linux-kernel@vger.kernel.org; Zhang, Jun
Subject: Re: [PATCH] [PATCH V2] tty: memleak in alloc_pid

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
> in task[dumpsys], in disassociate_ctty(), tty is set NULL by 
> task[adbd], tty_signal_session_leader(), then it goto else branch and 
> lack of put_pid(), cause memleak.
> 
> move spin_unlock(sighand->siglock) after get_current_tty() can avoid 
> the race and fix the memleak.
> 
> Change-Id: Ic960dda039c8f99aad3e0f4d176489a966c62f6a

Why is this line here?

