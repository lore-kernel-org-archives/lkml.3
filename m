Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778AbaDQU6t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 16:58:49 -0400
Received: from mail.skyhub.de ([78.46.96.112]:54478 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751786AbaDQU6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 16:58:11 -0400
Date: Thu, 17 Apr 2014 22:58:07 +0200
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Owen Kibel <qmewlo@gmail.com>
Cc: Josh Boyer <jwboyer@fedoraproject.org>, "Luck, Tony" <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "atodorov@redhat.com" <atodorov@redhat.com>,
        "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/urgent] x86/mce: Fix CMCI preemption bugs
Message-ID: <20140417205807.GA27852@pd.tnic>
References: <tip-ea431643d6c38728195e2c456801c3ef66bb9991@git.kernel.org>
 <20140417100944.GG11096@twins.programming.kicks-ass.net>
 <20140417102442.GA8215@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F31E2A1D3@ORSMSX106.amr.corp.intel.com>
 <20140417152611.GD4321@pd.tnic>
 <CA+5PVA7i=RrGUk_7zz1yU5gseWpvr+a=4dfkg=n9cNc53S7nPA@mail.gmail.com>
 <20140417192330.GE4321@pd.tnic>
 <CA+55aFyz62W7CD9=9p9OxKuFs9Rck_p93E_40CqLat1HvDdf0Q@mail.gmail.com>
 <20140417194241.GF4321@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140417194241.GF4321@pd.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 09:42:41PM +0200, Borislav Petkov wrote:
> On Thu, Apr 17, 2014 at 12:25:14PM -0700, Linus Torvalds wrote:
> > No, Owen tested a simpler patch that just changes the "get_cpu_var()"
> > to "__get_cpu_var()" and avoids the preempt increment.
> 
> Which basically would be the same as doing this_cpu_write() in the
> proposed fix - both don't touch preemption. So it is something else.
> More staring...

Ok, in one of the mails Ingo forwarded to me, it said it still failed with

> kernel: [    7.341085] BUG: using __this_cpu_write() in preemptible [00000000] code: modprobe/546

but considering Owen tried with a simpler __get_cpu_var version, I
fail to see how the __this_cpu_write() BUG will happen. Btw, those
__this_cpu_write things have received preemption checks. I'm seeing
right now another thread happening on lkml:

http://lkml.kernel.org/r/8761m7lm3j.fsf@canonical.com

So, Owen, can you please clarify which patch you *did* text exactly and
whether it worked or not.

Also, did you test the patch below? If not, please give it a run too.

Thanks.

---
This bug is introduced by me in commit 27f6c573e0. I forget
to execute put_cpu_var operation after get_cpu_var. Fix it
via this_cpu_write instead of get_cpu_var.

v2 -> v1: Separate cleanup from bug fix.

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
Suggested-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index eeee23f..68317c8 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -598,7 +598,6 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 {
        struct mce m;
        int i;
-       unsigned long *v;

        this_cpu_inc(mce_poll_count);

@@ -618,8 +617,7 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
                if (!(m.status & MCI_STATUS_VAL))
                        continue;

-               v = &get_cpu_var(mce_polled_error);
-               set_bit(0, v);
+               this_cpu_write(mce_polled_error, 1);
                /*
                 * Uncorrected or signalled events are handled by the exception
                 * handler when it is enabled, so don't process those here.
--
1.9.0


-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
