Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574AbaHQVlh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 17:41:37 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:52472 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751368AbaHQVlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 17:41:36 -0400
Date: Sun, 17 Aug 2014 22:41:23 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Nicolas Pitre <nico@linaro.org>
Subject: Re: [PATCH v4] irqchip: gic: Allow gic_arch_extn hooks to call
	into scheduler
Message-ID: <20140817214123.GY30401@n2100.arm.linux.org.uk>
References: <1407938238-21413-1-git-send-email-sboyd@codeaurora.org> <20140817173236.GG12769@titan.lakedaemon.net> <20140817185522.GX30401@n2100.arm.linux.org.uk> <20140817190434.GJ12769@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140817190434.GJ12769@titan.lakedaemon.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 17, 2014 at 03:04:34PM -0400, Jason Cooper wrote:
> Quoting Nico:
> 
> "Of course it would be good to clarify things wrt Russell's remark
> independently from this patch."
> 
> I took 'independently' to mean "This patch is ok, *and* we need to
> address Russell's concerns in a follow-up patch."
> 
> Nico's Reviewed-by with that comment was sent August 13th.  The most
> recent activity on this thread was also August 13th.  After four days, I
> reasoned there were no objections to his comment.

Right, during the merge window, and during merge windows, I tend to
ignore almost all email now because people don't stop developing, and
they don't take any notice where the mainline cycle is.  In fact, I go
off and do non-kernel work during a merge window and only briefly scan
for bug fixes.

However, I have other concerns with this patch, which I've yet to air.
For example, I don't like this crappy conditional locking that people
keep dreaming up - that kind of stuff makes the kernel much harder to
statically check that everything is correct.  It's an anti-lockdep
strategy.

Secondly, I don't like this:

+       raw_spin_lock(&gic_sgi_lock);
+       /*
+        * Ensure that the gic_cpu_map update above is seen in
+        * gic_raise_softirq() before we redirect any pending SGIs that
+        * may have been raised for the outgoing CPU (cur_cpu_id)
+        */
+       smp_mb__after_unlock_lock();
+       raw_spin_unlock(&gic_sgi_lock);

That goes against the principle of locking, that you lock the data,
not the code.

I have no problem with changing gic_raise_softirq() to use a different
lock, which gic_migrate_target(), and gic_set_affinity() can also use.
There's no need for horrid locking here, because the only thing we're
protecting is gic_map[] and the write to the register to trigger an
IPI - and nothing using gic_arch_extn has any business knowing about
SGIs.

No need for these crappy sgi_map_lock() macros and all the ifdeffery.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
