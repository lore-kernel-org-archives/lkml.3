Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529AbaDQTXq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 15:23:46 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39281 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110AbaDQTXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 15:23:34 -0400
Date: Thu, 17 Apr 2014 21:23:30 +0200
From: Borislav Petkov <bp@alien8.de>
To: Josh Boyer <jwboyer@fedoraproject.org>, Owen Kibel <qmewlo@gmail.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "atodorov@redhat.com" <atodorov@redhat.com>,
        "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>,
        "qmewlo@gmail.com" <qmewlo@gmail.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/urgent] x86/mce: Fix CMCI preemption bugs
Message-ID: <20140417192330.GE4321@pd.tnic>
References: <tip-ea431643d6c38728195e2c456801c3ef66bb9991@git.kernel.org>
 <20140417100944.GG11096@twins.programming.kicks-ass.net>
 <20140417102442.GA8215@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F31E2A1D3@ORSMSX106.amr.corp.intel.com>
 <20140417152611.GD4321@pd.tnic>
 <CA+5PVA7i=RrGUk_7zz1yU5gseWpvr+a=4dfkg=n9cNc53S7nPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Ycz6tD7Th1CMF4v7"
Content-Disposition: inline
In-Reply-To: <CA+5PVA7i=RrGUk_7zz1yU5gseWpvr+a=4dfkg=n9cNc53S7nPA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Ycz6tD7Th1CMF4v7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Thu, Apr 17, 2014 at 12:54:21PM -0400, Josh Boyer wrote:
> A user (Owen) reported seeing the following backtrace with 3.15-rc1+:
> 
> kernel: [  120.253539] Hardware name: Hewlett-Packard HP ENVY 15
> Notebook PC/1962, BIOS F.24 08/27/2013
> kernel: [  120.253540]  ffff88025f2146c0 ffffffff81c01e40
> ffffffff8171dc1d ffffffff81d11aa0
> kernel: [  120.253543]  ffffffff81c01e50 ffffffff81719a39
> ffffffff81c01eb0 ffffffff8172151b
> kernel: [  120.253545]  ffffffff81c18480 ffffffff81c01fd8
> 00000000000146c0 00000000000146c0
> kernel: [  120.253548] Call Trace:
> kernel: [  120.253555]  [<ffffffff8171dc1d>] dump_stack+0x4d/0x6f
> kernel: [  120.253558]  [<ffffffff81719a39>] __schedule_bug+0x4c/0x5a
> kernel: [  120.253560]  [<ffffffff8172151b>] __schedule+0x6eb/0x7a0
> kernel: [  120.253563]  [<ffffffff81721b91>] schedule_preempt_disabled+0x31/0x80
> kernel: [  120.253566]  [<ffffffff810af8f3>] cpu_startup_entry+0x173/0x490
> kernel: [  120.253570]  [<ffffffff8170e3e4>] rest_init+0x84/0x90
> kernel: [  120.253574]  [<ffffffff81d34f83>] start_kernel+0x450/0x45b
> kernel: [  120.253576]  [<ffffffff81d3493c>] ? repair_env_string+0x5c/0x5c
> kernel: [  120.253578]  [<ffffffff81d34120>] ? early_idt_handlers+0x120/0x120
> kernel: [  120.253581]  [<ffffffff81d345ee>] x86_64_start_reservations+0x2a/0x2c
> kernel: [  120.253583]  [<ffffffff81d3472e>] x86_64_start_kernel+0x13e/0x14d
> 
> For whatever reason, his report didn't hit lkml, but it did hit Linus'
> inbox.  Linus took a look around, googled some, and came across a
> report that Alexander filed 2 days ago against Fedora rawhide with a
> similar backtrace:
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=1087810
> 
> Linus CC'd me and Alexander on his reply to Owen, Ingo, Peter, etc.
> Ingo was aware of Chen Gong's patch, but when Owen tested it it
> produced the BUG line above.  So Ingo came up with a slightly
> different fix to hopefully resolve that as well.  We haven't heard
> from Owen whether Ingo's patch resolves everything yet.
> 
> I think (hope) that is the full backstory.  Ingo or Peter could correct me.

Thanks Josh, that explains it. Owen bounced me his mail too, in the
meantime.

So, the only thing I'm seeing so far is that I cannot reproduce this
with Owen's config on my machines with Linus' tree from right now.

And the only sane idea I have currently is that without the get_cpu_var
fix, preemption count gets fumbled just right down the

identify_boot_cpu ->
 mcheck_cpu_init ->
  machine_check_poll ->
   get_cpu_var ->
    preempt_disable

path so that the initial schedule we do, catches it:

start_kernel -> rest_init -> schedule_preempt_disabled

Which would mean that the only fix for that should be Gong's
initial fix which Tony just sent (see attached), i.e. without the
s/raw_spin_lock/spin_lock/ changes from Ingo.

But you're saying here, Owen tested it already. Which kinda hints at with that

kernel: [    7.341085] BUG: using __this_cpu_write() in preemptible [00000000] code: modprobe/546

line which was in one of the previous mails.

Anyway, I did merge Owen's config wrt PREEMPT into mine:

$ grep PREEMPT .config
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_PREEMPT_NOTIFIERS=y
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
# CONFIG_DEBUG_PREEMPT is not set
# CONFIG_PREEMPT_TRACER is not set

and I can't repro it. With, or without the attached patch :-\.
Which basically could mean that there's either some specific timing
Owen's or Alex' boxes are hitting which mine aren't or there's some
miscommunication in the whole thing.

@Owen: can you please test the attached patch if you haven't done so
already and report back?

Thanks.

/me is still confused.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

--Ycz6tD7Th1CMF4v7
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename=diff

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


--Ycz6tD7Th1CMF4v7--
