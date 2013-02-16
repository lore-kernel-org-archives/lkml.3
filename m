Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451Ab3BPFmB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 00:42:01 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40961 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853Ab3BPFl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 00:41:59 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D414A9A312@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D414A64C5B@USINDEM103.corp.hds.com> <511ECF2B.8090202@zytor.com> <1360977902.23152.119.camel@gandalf.local.home> <A5ED84D3BB3A384992CBB9C77DEDA4D414A9A312@USINDEM103.corp.hds.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: RE: [PATCH v9 3/3] trace,x86: code-sharing between non-trace and trace irq handlers
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 15 Feb 2013 21:39:56 -0800
To: Seiji Aguchi <seiji.aguchi@hds.com>, Steven Rostedt <rostedt@goodmis.org>
CC: "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Thomas Gleixner (tglx@linutronix.de)" <tglx@linutronix.de>,
        "'mingo@elte.hu' (mingo@elte.hu)" <mingo@elte.hu>,
        "Borislav Petkov (bp@alien8.de)" <bp@alien8.de>,
        Satoru Moriya <satoru.moriya@hds.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>
Message-ID: <72465757-1907-4272-9950-36ac41898106@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fair enough.  Sounds good.

Seiji Aguchi <seiji.aguchi@hds.com> wrote:

>> > How important is it that the tracepoint is *inside* the enter/exit
>> > handling?  If not, it would be simpler to just do:
>> >
>> > smp_trace_irq_handler()
>> > {
>> > 	trace_irq_entry();
>> > 	smp_irq_handler();
>> > 	trace_irq_exit();
>> > }
>> >
>> > ... which seems a bit cleaner.  If this isn't possible, then this
>> > patch is fine, but please add to the patch description why the
>simple
>> > wrapper isn't doable.
>> 
>> The problem is with irq_enter/exit() being called. They must be
>called before trace_irq_enter/exit(), because of the rcu_irq_enter()
>> must be called before any tracepoints are used, as tracepoints use
>rcu to synchronize.
>>
>
>I tried to place tracepoints outside the enter/exit handling. But it
>didn't work because of the rcu_irq_enter().
>
>> Now perhaps we could do this and have trace_irq_entry().
>> 
>> Not only that, the tracepoint callbacks expect irq_enter() to already
>be called.
>> 
>> Hmm, if irq_enter() can nest, which I think it can, perhaps we can
>call
>> irq_enter() first. I'm not sure if that will screw up the second
>> irq_entry() inside smp_irq_handler().
>> 
>> smp_trace_irq_hander()
>> {
>> 	irq_entry();
>> 	trace_irq_entry();
>> 	smp_irq_handler();
>> 	trace_irq_exit();
>> 	irq_exit();
>> }
>
>If irq_enter() is nested, it may have a time penalty because it has to
>check if it was already called or not.  
>It doesn't satisfy a goal of this patch.
>Therefore, I think current coding is reasonable.
>
>I will update the patch description.
>
>Seiji

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
