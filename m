Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967AbaLAJhk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 04:37:40 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:50811 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbaLAJhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 04:37:38 -0500
Message-ID: <547C36DB.7060903@hitachi.com>
Date: Mon, 01 Dec 2014 18:37:31 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steve Capper <steve.capper@linaro.org>
Cc: David Long <dave.long@linaro.org>, "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        William Cohen <wcohen@redhat.com>, David Miller <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Re: Re: [PATCH v3 0/5] ARM64: Add kernel probes(Kprobes) support
References: <1416292375-29560-1-git-send-email-dave.long@linaro.org> <20141120135851.GA32528@linaro.org> <54759041.9080105@hitachi.com> <20141126100325.GA9157@linaro.org> <5476120D.9030703@linaro.org> <CAPvkgC3eVOZEn79C9PC9c7TqC_-yCtDhw5LL6ZWUJxr+oQFaow@mail.gmail.com> <5476BFB4.2020705@hitachi.com> <CAPvkgC0ELPPWfa-8kQ4H_e_O5G1ER4KEKuSWLxh_u-VZgh7W6A@mail.gmail.com>
In-Reply-To: <CAPvkgC0ELPPWfa-8kQ4H_e_O5G1ER4KEKuSWLxh_u-VZgh7W6A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/11/29 1:01), Steve Capper wrote:
> On 27 November 2014 at 06:07, Masami Hiramatsu
> <masami.hiramatsu.pt@hitachi.com> wrote:
>> (2014/11/27 3:59), Steve Capper wrote:
>>> The crash is extremely easy to reproduce.
>>>
>>> I've not observed any missed events on a kprobe on an arm64 system
>>> that's still alive.
>>> My (limited!) understanding is that this suggests there could be a
>>> problem with how missed events from a recursive call to memcpy are
>>> being handled.
>>
>> I think so too. BTW, could you bisect that? :)
>>
> 
> I can't bisect, but the following functions look suspicious to me
> (again I'm new to kprobes...):
> kprobes_save_local_irqflag
> kprobes_restore_local_irqflag
> 
> I think these are breaking somehow when nested (i.e. from a recursive probe).

Agreed. On x86, prev_kprobe has old_flags and saved_flags, this
at least must have saved_irqflag and save/restore it in
save/restore_previous_kprobe().

What about adding this?

 struct prev_kprobe {
 	struct kprobe *kp;
 	unsigned int status;
+	unsigned long saved_irqflag;
 };

and

 static void __kprobes save_previous_kprobe(struct kprobe_ctlblk *kcb)
 {
 	kcb->prev_kprobe.kp = kprobe_running();
 	kcb->prev_kprobe.status = kcb->kprobe_status;
+	kcb->prev_kprobe.saved_irqflag = kcb->saved_irqflag;
 }

 static void __kprobes restore_previous_kprobe(struct kprobe_ctlblk *kcb)
 {
 	__this_cpu_write(current_kprobe, kcb->prev_kprobe.kp);
 	kcb->kprobe_status = kcb->prev_kprobe.status;
+	kcb->saved_irqflag = kcb->prev_kprobe.saved_irqflag;
 }



> That would explain why the state of play of the interrupts is in an
> unexpected state in the crash I reported:
> "The point of failure in the panic was:
> fs/buffer.c:1257
> 
> static inline void check_irqs_on(void)
> {
> #ifdef irqs_disabled
>         BUG_ON(irqs_disabled());
> #endif
> }
> "
> 
> This is all new to me so I'm still at the head-scratching stage.

Ah, I see.

Thank you,

> 
> David,
> Does the above make sense to you? Have you managed to reproduce the crash I get?
> 
> Cheers,
> --
> Steve
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


