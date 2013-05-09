Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705Ab3EIMrV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 08:47:21 -0400
Received: from mail.skyhub.de ([78.46.96.112]:55231 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751952Ab3EIMrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 08:47:19 -0400
Date: Thu, 9 May 2013 14:50:40 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Tony Luck <tony.luck@intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: NOHZ: WARNING: at arch/x86/kernel/smp.c:123
 native_smp_send_reschedule
Message-ID: <20130509125040.GF27333@pd.tnic>
References: <alpine.LNX.2.00.1305091423460.23038@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1305091423460.23038@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 09, 2013 at 02:29:18PM +0200, Jiri Kosina wrote:
> Hi,
> 
> I just got the warning below when resuming from hibernation with kernel 
> that has NO_HZ_FULL_ALL=y. This is with topmost commit e0fd9affeb640.

Did you boot with any of the NO_HZ_FULL options on the command line,
i.e. rcu_nocbs?

Because I saw the same issue during boot when I was testing the
NO_HZ_FULL stuff previously:

Feb 21 11:13:17 gondor kernel: [    0.093417]  #3
Feb 21 11:13:17 gondor kernel: [    0.106844] SMP alternatives: lockdep: fixing up alternatives
Feb 21 11:13:17 gondor kernel: [    0.118060] ------------[ cut here ]------------
Feb 21 11:13:17 gondor kernel: [    0.118069] WARNING: at arch/x86/kernel/smp.c:123 native_smp_send_reschedule+0x58/0x60()
Feb 21 11:13:17 gondor kernel: [    0.118069] Hardware name: Precision T3600
Feb 21 11:13:17 gondor kernel: [    0.106955]  #4
Feb 21 11:13:17 gondor kernel: [    0.118070] Modules linked in:
Feb 21 11:13:17 gondor kernel: [    0.118073] Pid: 0, comm: swapper/4 Not tainted 3.8.0-rc6+ #4
Feb 21 11:13:17 gondor kernel: [    0.118074] Call Trace:
Feb 21 11:13:17 gondor kernel: [    0.118076]  [<ffffffff8103d35f>] warn_slowpath_common+0x7f/0xc0
Feb 21 11:13:17 gondor kernel: [    0.118079]  [<ffffffff8103d3ba>] warn_slowpath_null+0x1a/0x20
Feb 21 11:13:17 gondor kernel: [    0.118081]  [<ffffffff81024a58>] native_smp_send_reschedule+0x58/0x60
Feb 21 11:13:17 gondor kernel: [    0.118083]  [<ffffffff81071ba0>] wake_up_nohz_cpu+0x80/0x90
Feb 21 11:13:17 gondor kernel: [    0.118086]  [<ffffffff8104e611>] add_timer_on+0x91/0x110
Feb 21 11:13:17 gondor kernel: [    0.118090]  [<ffffffff8101ccab>] mce_start_timer.isra.12+0x6b/0x80
Feb 21 11:13:17 gondor kernel: [    0.118092]  [<ffffffff8101cd1d>] __mcheck_cpu_init_timer+0x5d/0x70
Feb 21 11:13:17 gondor kernel: [    0.118094]  [<ffffffff815cc466>] mcheck_cpu_init+0x36b/0x400
Feb 21 11:13:17 gondor kernel: [    0.118097]  [<ffffffff815ca15b>] identify_cpu+0x39d/0x3d0
Feb 21 11:13:17 gondor kernel: [    0.118099]  [<ffffffff815ca1a2>] identify_secondary_cpu+0x14/0x1b
Feb 21 11:13:17 gondor kernel: [    0.118101]  [<ffffffff815cd008>] smp_store_cpu_info+0x38/0x3a
Feb 21 11:13:17 gondor kernel: [    0.118103]  [<ffffffff815cd550>] start_secondary+0xfb/0x1f7
Feb 21 11:13:17 gondor kernel: [    0.118121] ---[ end trace 8ffeaaf1f7048154 ]---

And I *think* I saw this yesterday too on a randbuild kernel.

Looks like we're sending a resched IPI to a cpu which is not online yet
in order to start the MCE polling timer. So the rcu* options are kinda
unlikely to be related, AFAICT.

Frederic?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
