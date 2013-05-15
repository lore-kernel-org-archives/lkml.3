Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759913Ab3EOSvk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 14:51:40 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:45008 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753212Ab3EOSvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 14:51:39 -0400
Date: Wed, 15 May 2013 11:45:28 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Jiri Kosina <jkosina@suse.cz>, Frederic Weisbecker <fweisbec@gmail.com>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: NOHZ: WARNING: at arch/x86/kernel/smp.c:123
 native_smp_send_reschedule
Message-ID: <20130515184528.GO4442@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.LNX.2.00.1305091423460.23038@pobox.suse.cz>
 <20130509125040.GF27333@pd.tnic>
 <20130509125859.GG27333@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130509125859.GG27333@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051518-5806-0000-0000-0000212BD94A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 09, 2013 at 02:58:59PM +0200, Borislav Petkov wrote:
> On Thu, May 09, 2013 at 02:50:40PM +0200, Borislav Petkov wrote:
> > Looks like we're sending a resched IPI to a cpu which is not online
> > yet in order to start the MCE polling timer. So the rcu* options are
> > kinda unlikely to be related, AFAICT.
> 
> On a second thought, they must be somehow indirectly related because I
> had "rcu_nocbs=4-7" on the command line and have the warning on the same
> CPUs: 4 - 7.
> 
> Actually, NO_HZ_FULL_ALL makes all CPUs full dynticks so I'd guess the
> RCU callback offloading happens on all of them, thus the warning can
> happen on every CPU which is in full dynticks mode but not online yet.

Does the following patch help?

							Thanx, Paul

------------------------------------------------------------------------

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 63098a5..68b1f26 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -2371,7 +2371,7 @@ static bool init_nocb_callback_list(struct rcu_data *rdp)
 static void rcu_kick_nohz_cpu(int cpu)
 {
 #ifdef CONFIG_NO_HZ_FULL
-	if (tick_nohz_full_cpu(cpu))
+	if (tick_nohz_full_cpu(cpu) && cpu_online(cpu))
 		smp_send_reschedule(cpu);
 #endif /* #ifdef CONFIG_NO_HZ_FULL */
 }

