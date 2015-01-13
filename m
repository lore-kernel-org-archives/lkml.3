Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676AbbAMGuC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 01:50:02 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:22591 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbbAMGt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 01:49:59 -0500
X-IronPort-AV: E=Sophos;i="5.07,748,1413270000"; 
   d="scan'208";a="54673081"
Subject: Re: [3.19-rc3] tg3: BUG: sleeping function called from invalid
 context
From: Michael Chan <mchan@broadcom.com>
To: Peter Hurley <peter@hurleysoftware.com>
CC: Prashant Sreedharan <prashant@broadcom.com>, <netdev@vger.kernel.org>,
        Linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <54B46DD5.9050802@hurleysoftware.com>
References: <54B46DD5.9050802@hurleysoftware.com>
Content-Type: text/plain; charset="cp1252"
Date: Mon, 12 Jan 2015 22:49:22 -0800
Message-ID: <1421131762.7208.31.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2015-01-12 at 19:59 -0500, Peter Hurley wrote: 
> [   17.203009] BUG: sleeping function called from invalid context at /home/peter/src/kernels/mainline/kernel/irq/manage.c:104
> [   17.203067] in_atomic(): 1, irqs_disabled(): 0, pid: 1106, name: ip
> [   17.203092] 2 locks held by ip/1106:
> [   17.205255]  #0:  (rtnl_mutex){+.+.+.}, at: [<ffffffff816adf1f>] rtnetlink_rcv+0x1f/0x40
> [   17.207445]  #1:  (&(&tp->lock)->rlock){+.....}, at: [<ffffffffa01073e6>] tg3_start+0xc06/0x11f0 [tg3]
> [   17.209725] CPU: 2 PID: 1106 Comm: ip Not tainted 3.19.0-rc3+wip-xeon+lockdep #rc3+wip
> [   17.211900] Hardware name: Dell Inc. Precision WorkStation T5400  /0RW203, BIOS A11 04/30/2012
> [   17.214086]  0000000000000068 ffff8802ac823498 ffffffff817af7e8 0000000000000005
> [   17.216265]  ffffffff81a9be78 ffff8802ac8234a8 ffffffff810998a5 ffff8802ac8234d8
> [   17.218446]  ffffffff8109991a ffff8802ac8234c8 ffff8802af0aae00 ffffffffa00ed000
> [   17.220636] Call Trace:
> [   17.222743]  [<ffffffff817af7e8>] dump_stack+0x4f/0x7b
> [   17.224808]  [<ffffffff810998a5>] ___might_sleep+0x105/0x140
> [   17.226842]  [<ffffffff8109991a>] __might_sleep+0x3a/0xa0
> [   17.228869]  [<ffffffffa00ed000>] ? 0xffffffffa00ed000
> [   17.230939]  [<ffffffff810d7d78>] synchronize_irq+0x38/0xa0
> [   17.232967]  [<ffffffffa00ed000>] ? 0xffffffffa00ed000
> [   17.234991]  [<ffffffffa010105f>] tg3_chip_reset+0x13f/0x9c0 [tg3]
> [   17.236988]  [<ffffffffa01020ae>] tg3_reset_hw+0x7e/0x2d20 [tg3] 

tp->lock is held in this code path.  If synchronize_irq() sleeps in
wait_event(desc->wait_for_threads, ...), we'll get the warning.

The synchronize_irq() call is to wait for any tg3 irq handler to finish
so that it is guaranteed that next time it will see the CHIP_RESETTING
flag and do nothing.

Not sure if we can drop the tp->lock before we call synchronize_irq()
and then take it again after synchronize_irq().

