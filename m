Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbaFLGq4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 02:46:56 -0400
Received: from fgwmail.fujitsu.co.jp ([164.71.1.133]:32994 "EHLO
	fgwmail.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbaFLGqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 02:46:54 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.2.3
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20140219
Date: Thu, 12 Jun 2014 15:46:37 +0900 (JST)
Message-Id: <20140612.154637.361874821.d.hatayama@jp.fujitsu.com>
To: peterz@infradead.org
Cc: acme@kernel.org, mingo@redhat.com, paulus@samba.org, hpa@zytor.com,
        tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf/x86/intel: ignore CondChgd bit to avoid false NMI
 handling
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
In-Reply-To: <20140611085448.GI3213@twins.programming.kicks-ass.net>
References: <20140611073028.9847.65622.stgit@localhost6.localdomain6>
	<20140611085448.GI3213@twins.programming.kicks-ass.net>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5C6l162003699

From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] perf/x86/intel: ignore CondChgd bit to avoid false NMI handling
Date: Wed, 11 Jun 2014 10:54:48 +0200

> On Wed, Jun 11, 2014 at 04:30:28PM +0900, HATAYAMA Daisuke wrote:
>> Currently, a NMI handler for NMI watchdog may falsely handle any NMI
>> signaled for different purpose if CondChgd bit in
>> MSR_CORE_PERF_GLOBAL_STATUS MSR is set.
>> 
>> This commit deals with the issue simply by ignoring CondChgd bit.
>> 
>> Here is explanation in detail.
>> 
>> On x86 NMI watchdog uses performance monitoring feature to
>> periodically signal NMI each time performance counter gets overflowed.
>> 
>> intel_pmu_handle_irq() is called as a NMI_LOCAL handler from a NMI
>> handler of NMI watchdog, perf_event_nmi_handler(). It identifies owner
>> of a given NMI by looking at overflow status bits in
>> MSR_CORE_PERF_GLOBAL_STATUS MSR. If some of the bits are set, then it
>> handles the given NMI as its own NMI.
>> 
>> The problem is that intel_pmu_handle_irq() doesn't distinguish
>> CondChgd bit from other bits. Unlike the other status bits, CondChgd
>> bit doesn't represent overflow status for performance counters. Thus,
>> CondChgd bit cannot be thought of as a mark indicating a given NMI is
>> NMI watchdog's.
> 
> So what was the problem? It ate another NMI?
> 

Yes.

The handler for NMI watchdog is called in NMI_LOCAL. This is done in
earlier timing than NMI_UNKNOWN, and if some of the handlers in
NMI_LOCAL handles at least one NMI, then handlers in NMI_UNKNOWN are
not called. Like this:

        handled = nmi_handle(NMI_LOCAL, regs, b2b);
        __this_cpu_add(nmi_stats.normal, handled);
        if (handled) {
                /*
                 * There are cases when a NMI handler handles multiple
                 * events in the current NMI.  One of these events may
                 * be queued for in the next NMI.  Because the event is
                 * already handled, the next NMI will result in an unknown
                 * NMI.  Instead lets flag this for a potential NMI to
                 * swallow.
                 */
                if (handled > 1)
                        __this_cpu_write(swallow_nmi, true);
                return;
        }

For example, we use unknown NMI to make system panic by enabling
kernel.unkown_nmi_panic. Without this fix, unknown NMI is robbed by
NMI handler for NMI watchdog.

>> I noticed this behavior on systems with Ivy Bridge processors: Intel
>> Xeon CPU E5-2630 v2 and Intel Xeon CPU E7-8890 v2. On both systems,
>> CondChgd bit in MSR_CORE_PERF_GLOBAL_STATUS MSR has already been set
>> in the beginning at boot. (then the CondChgd bit is cleared by next
>> wrmsr to MSR_CORE_PERF_GLOBAL_CTRL MSR and appears to remain 0.)
>> 
>> On the other hand, on older processors such as Nehalem, CondChgd bit
>> is not set in the beginning at boot.
>> 
>> I'm not sure about exact behavior of CondChgd bit, in particular when
>> this bit is set. Although I read Intel System Programmer's Manual to
>> figure out but I have yet completed that. At least, I think ignoring
>> CondChgd bit should be enough for NMI watchdog perspective.
> 
> So yes, the SDM lists the bit as existing but never once mentions it
> outside of that, and its been doing that at least back to 2008.
> 
> Ooh, I found it:
> 
>   "The IA32_PERF_GLOBAL_STATUS MSR also provides a ¡sticky bit¢ to
> indicate changes to the state of performance monitoring hardware (see
> Figure 18-29)."
> 
> Which is of course completely useless, not to mention inconsistent with
> the later CondChgd name.
> 
> HPA, can you explain wtf that bit does and why hatayama-san's ivb feels
> like having that set on boot? 

--
Thanks.
HATAYAMA, Daisuke
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
