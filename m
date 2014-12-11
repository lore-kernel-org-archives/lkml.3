Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758138AbaLKOnT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 09:43:19 -0500
Received: from mail.skyhub.de ([78.46.96.112]:58963 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702AbaLKOnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 09:43:17 -0500
Date: Thu, 11 Dec 2014 15:43:13 +0100
From: Borislav Petkov <bp@alien8.de>
To: Calvin Owens <calvinowens@fb.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-team@fb.com" <kernel-team@fb.com>
Subject: Re: [PATCH] x86: mce: Avoid timer double-add during CMCI interrupt
 storms.
Message-ID: <20141211144313.GB31140@pd.tnic>
References: <1417746575-23299-1-git-send-email-calvinowens@fb.com>
 <20141209180835.GF3990@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F329640BC@ORSMSX114.amr.corp.intel.com>
 <20141210031102.GB1437888@mail.thefacebook.com>
 <20141210192340.GF17053@pd.tnic>
 <20141211023438.GA3239919@mail.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141211023438.GA3239919@mail.thefacebook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 06:34:38PM -0800, Calvin Owens wrote:
> This doens't fix the original issue though: the timer double-add can
> still happen if the CMCI interrupt that hits the STORM threshold pops
> off during mce_timer_fn() and calls mce_timer_kick().

Right, I guess we could do something similar to what you proposed
already (diff below ontop of my previous diff).

> The polling is unnecessary on a CMCI-capable machine except in STORMs,
> right? Wouldn't it be better to eliminate it in that case?

Right, the problem with error thresholding is that it only counts errors
and raises the APIC interrupt when a certain count has been reached.
But there's no way for the software to look at *each* error and try to
discover trends and stuff.

Thus, we've been working on something which looks at each memory error,
collects them and then decays them over time and acts only for the
significant ones by poisoning pages:

https://lkml.kernel.org/r/1404242623-10094-1-git-send-email-bp@alien8.de

When we have that thing in place we can probably even go a step further
and simply disable error thresholding because it simply doesn't give us
what we need.

Btw, we would very much welcome your thoughs on this collector thing and
whether it would be usable in large installations. Or if not, what else
would it need added.

> That said, I ran mce-test with your patch on top of 3.18, looks good
> there. But that doesn't simulate CMCI interrupts.

Thanks, I had a machine here which was the perfect natural error
injector (has faulty DIMMs). I need to dig it out and play with it again
:)

Thanks.

---
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index e3f426698164..8cf2f486b81e 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1331,6 +1331,24 @@ int ce_error_seen(void)
 	return test_and_clear_bit(0, v);
 }
 
+static void __restart_timer(struct timer_list *t, unsigned long interval)
+{
+	unsigned long when = jiffies + interval;
+	unsigned long flags;
+
+	local_irq_save(flags);
+
+	if (timer_pending(t)) {
+		if (time_before(when, t->expires))
+			mod_timer_pinned(t, when);
+	} else {
+		t->expires = round_jiffies(when);
+		add_timer_on(t, smp_processor_id());
+	}
+
+	local_irq_restore(flags);
+}
+
 static void mce_timer_fn(unsigned long data)
 {
 	struct timer_list *t = this_cpu_ptr(&mce_timer);
@@ -1362,8 +1380,7 @@ static void mce_timer_fn(unsigned long data)
 
 done:
 	__this_cpu_write(mce_next_interval, iv);
-	t->expires = jiffies + iv;
-	add_timer_on(t, cpu);
+	__restart_timer(t, iv);
 }
 
 /*
@@ -1372,16 +1389,10 @@ done:
 void mce_timer_kick(unsigned long interval)
 {
 	struct timer_list *t = this_cpu_ptr(&mce_timer);
-	unsigned long when = jiffies + interval;
 	unsigned long iv = __this_cpu_read(mce_next_interval);
 
-	if (timer_pending(t)) {
-		if (time_before(when, t->expires))
-			mod_timer_pinned(t, when);
-	} else {
-		t->expires = round_jiffies(when);
-		add_timer_on(t, smp_processor_id());
-	}
+	__restart_timer(t, interval);
+
 	if (interval < iv)
 		__this_cpu_write(mce_next_interval, interval);
 }

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
