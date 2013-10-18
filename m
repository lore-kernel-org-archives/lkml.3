Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab3JRNoo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 09:44:44 -0400
Received: from smarthost01d.mail.zen.net.uk ([212.23.1.7]:55037 "EHLO
	smarthost01d.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754562Ab3JRNom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 09:44:42 -0400
Message-ID: <1382103862.3394.46.camel@linaro1.home>
Subject: Re: [PATCH v4 2/7] arm64: introduce interfaces to hotpatch kernel
 and module code
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Jiang Liu <liuj97@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Jiang Liu <jiang.liu@huawei.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 18 Oct 2013 14:44:22 +0100
In-Reply-To: <20131018085638.GA2858@mudshark.cambridge.arm.com>
References: <1381990781-27814-1-git-send-email-liuj97@gmail.com>
	 <1381990781-27814-3-git-send-email-liuj97@gmail.com>
	 <20131017113826.GJ18765@mudshark.cambridge.arm.com>
	 <1382023441.19506.66.camel@linaro1.home>
	 <20131018085638.GA2858@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01d-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-10-18 at 09:56 +0100, Will Deacon wrote:
> Hi Tixy,
> 
> On Thu, Oct 17, 2013 at 04:24:01PM +0100, Jon Medhurst (Tixy) wrote:
> > On Thu, 2013-10-17 at 12:38 +0100, Will Deacon wrote:
> > > On Thu, Oct 17, 2013 at 07:19:35AM +0100, Jiang Liu wrote:
> > > > +	/*
> > > > +	 * Execute __aarch64_insn_patch_text() on every online CPU,
> > > > +	 * which ensure serialization among all online CPUs.
> > > > +	 */
> > > > +	return stop_machine(aarch64_insn_patch_text_cb, &patch, NULL);
> > > > +}
> > > 
> > > Whoa, whoa, whoa! The comment here is wrong -- we only run the patching on
> > > *one* CPU, which is the right thing to do. However, the arch/arm/ call to
> > > stop_machine in kprobes does actually run the patching code on *all* the
> > > online cores (including the cache flushing!). I think this is to work around
> > > cores without hardware cache maintenance broadcasting, but that could easily
> > > be called out specially (like we do in patch.c) and the flushing could be
> > > separated from the patching too.
> > [...]
> > 
> > For code modifications done in 32bit ARM kprobes (and ftrace) I'm not
> > sure we ever actually resolved the possible cache flushing issues. If
> > there was specific reasons for flushing on all cores I can't remember
> > them, sorry. I have a suspicion that doing so was a case of sticking
> > with what the code was already doing, and flushing on all cores seemed
> > safest to guard against problems we hadn't thought about.
> 
> [...]
> 
> > Sorry, I don't think I've added much light on things here have I?
> 
> I think you missed the bit I was confused about :) Flushing the cache on
> each core is necessary if cache_ops_need_broadcast, so I can understand why
> you'd have code to do that. The bit I don't understand is that you actually
> patch the instruction on each core too!

This is only happens when removing a kprobe with __arch_disarm_kprobe().
We can't just use the intelligent patch_text() function there because we
want to always force stop machine to be used as this prevents the case
where a CPU a hits the probe, starts executing it's handler then another
CPU whips away the probe from under it.

That explains why we use stop_machine, but not why all CPU's must modify
the instruction. I think it's a case of just that it's simpler to do
that unconditionally rather than add extra code for the
cache_ops_need_broadcast() case. I mean, stop_machine() is a sledge
hammer, which stalls the whole system until the next scheduler tick, and
then gets every CPU to busy wait, so there's not much incentive to try
and optimise the code to avoid a memory write + cacheline flush on each
core.

This reminds me, I'm sure I heard rumours quite some time ago that Paul
McKenney was thinking of trying to do away with stop_machine...?

-- 
Tixy

