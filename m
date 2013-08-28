Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569Ab3H1RTo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 13:19:44 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:6393 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111Ab3H1RTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 13:19:43 -0400
Message-ID: <521E312C.2050004@tilera.com>
Date: Wed, 28 Aug 2013 13:19:40 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Tejun Heo <tj@kernel.org>, <akpm@linuxfoundation.org>,
        <linux-arch@vger.kernel.org>, Steven Rostedt <srostedt@redhat.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [guv v2 23/31] tile: Replace __get_cpu_var uses
References: <20130826204351.725357339@linux.com> <00000140bc69acdb-3b2967b0-e224-424b-ad08-973515704be6-000000@email.amazonses.com> <521BD523.3040706@tilera.com> <00000140c03f13d6-07480caf-b5b0-440b-af95-04878ee9f46c-000000@email.amazonses.com>
In-Reply-To: <00000140c03f13d6-07480caf-b5b0-440b-af95-04878ee9f46c-000000@email.amazonses.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/27/2013 10:48 AM, Christoph Lameter wrote:
> On Mon, 26 Aug 2013, Chris Metcalf wrote:
>> > The rest is fine.  Would it make more sense for me to fold all these
>> > changes into the tile tree and just have it meet in linux-next?  There
>> > are certainly a bunch of other changes staged there which likely also
>> > include more uses of __get_cpu_var...
> Yes. Please stage this patch for the next merge window.

Taken into the tile tree, with one extra change; in arch/tile/kernel/messaging.c, using "__this_cpu_read(msg_state)" generated warnings ("'pscr_ret__.opaque[1u]' is used uninitialized in this function", etc), since msg_state is a struct, so I changed it to be "*__this_cpu_ptr(&msg_state)".  Interrupts are disabled here so preemption is not a concern.

In addition, I applied the following commit to clean up the remaining uses that are currently only being carried in the linux-tile tree.

commit db4dd3097952d2fd20e61f820dbb757ba871302d
Author: Chris Metcalf <cmetcalf@tilera.com>
Date:   Wed Aug 28 12:01:44 2013 -0400

    tile: remove newer uses of __get_cpu_var

    See commit eb1fe08d458f for the first round.

    Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>

diff --git a/arch/tile/kernel/kprobes.c b/arch/tile/kernel/kprobes.c
index 1129f52..27cdcac 100644
--- a/arch/tile/kernel/kprobes.c
+++ b/arch/tile/kernel/kprobes.c
@@ -159,7 +159,7 @@ static void __kprobes save_previous_kprobe(struct kprobe_ctlblk *kcb)

 static void __kprobes restore_previous_kprobe(struct kprobe_ctlblk *kcb)
 {
-       __get_cpu_var(current_kprobe) = kcb->prev_kprobe.kp;
+       __this_cpu_write(current_kprobe, kcb->prev_kprobe.kp);
        kcb->kprobe_status = kcb->prev_kprobe.status;
        kcb->kprobe_saved_pc = kcb->prev_kprobe.saved_pc;
 }
@@ -167,7 +167,7 @@ static void __kprobes restore_previous_kprobe(struct kprobe_ctlblk *kcb)
 static void __kprobes set_current_kprobe(struct kprobe *p, struct pt_regs *regs,
                        struct kprobe_ctlblk *kcb)
 {
-       __get_cpu_var(current_kprobe) = p;
+       __this_cpu_write(current_kprobe, p);
        kcb->kprobe_saved_pc = regs->pc;
 }

@@ -228,7 +228,7 @@ static int __kprobes kprobe_handler(struct pt_regs *regs)
                                ret = 1;
                                goto no_kprobe;
                        }
-                       p = __get_cpu_var(current_kprobe);
+                       p = __this_cpu_read(current_kprobe);
                        if (p->break_handler && p->break_handler(p, regs))
                                goto ss_probe;
                }
diff --git a/arch/tile/kernel/time.c b/arch/tile/kernel/time.c
index a7a41a1..30c2c34 100644
--- a/arch/tile/kernel/time.c
+++ b/arch/tile/kernel/time.c
@@ -286,7 +286,7 @@ static int _set_clock_rate_barrier;
 static int _set_clock_rate(void *arg)
 {
        struct _set_clock_rate_args *args = arg;
-       struct clock_event_device *evt = &__get_cpu_var(tile_timer);
+       struct clock_event_device *evt = get_cpu_ptr(&tile_timer);

        /*
         * Only one CPU needs to change the timekeeping parameters and

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

