Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673Ab3JQPYQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 11:24:16 -0400
Received: from smarthost01c.mail.zen.net.uk ([212.23.1.5]:50373 "EHLO
	smarthost01c.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755964Ab3JQPYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 11:24:15 -0400
Message-ID: <1382023441.19506.66.camel@linaro1.home>
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
Date: Thu, 17 Oct 2013 16:24:01 +0100
In-Reply-To: <20131017113826.GJ18765@mudshark.cambridge.arm.com>
References: <1381990781-27814-1-git-send-email-liuj97@gmail.com>
	 <1381990781-27814-3-git-send-email-liuj97@gmail.com>
	 <20131017113826.GJ18765@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01c-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-10-17 at 12:38 +0100, Will Deacon wrote:
> [adding Tixy for stop_machine() question below]
> 
> On Thu, Oct 17, 2013 at 07:19:35AM +0100, Jiang Liu wrote:
[...]
> > +int __kprobes aarch64_insn_patch_text_sync(void *addrs[], u32 insns[], int cnt)
> > +{
> > +	struct aarch64_insn_patch patch = {
> > +		.text_addrs = addrs,
> > +		.new_insns = insns,
> > +		.insn_cnt = cnt,
> > +	};
> > +
> > +	if (cnt <= 0)
> > +		return -EINVAL;
> > +
> > +	/*
> > +	 * Execute __aarch64_insn_patch_text() on every online CPU,
> > +	 * which ensure serialization among all online CPUs.
> > +	 */
> > +	return stop_machine(aarch64_insn_patch_text_cb, &patch, NULL);
> > +}
> 
> Whoa, whoa, whoa! The comment here is wrong -- we only run the patching on
> *one* CPU, which is the right thing to do. However, the arch/arm/ call to
> stop_machine in kprobes does actually run the patching code on *all* the
> online cores (including the cache flushing!). I think this is to work around
> cores without hardware cache maintenance broadcasting, but that could easily
> be called out specially (like we do in patch.c) and the flushing could be
> separated from the patching too.
[...]

For code modifications done in 32bit ARM kprobes (and ftrace) I'm not
sure we ever actually resolved the possible cache flushing issues. If
there was specific reasons for flushing on all cores I can't remember
them, sorry. I have a suspicion that doing so was a case of sticking
with what the code was already doing, and flushing on all cores seemed
safest to guard against problems we hadn't thought about.

Some of the issues discussed were that we couldn't have one core
potentially executing instructions being modified by another CPU,
because that's architecturally unpredictable except for a few
instructions [1], and we also have the case where a 32-bit Thumb
instruction can straddle two different cache-lines. But these may not be
reasons to flush on all cores if stop machine is synchronising all CPU's
in a kind of holding pen and the cache operations done on one core are
broadcast to others. (Are there correct barriers involved in
stop-machine so that when the other cores resume they are guaranteed to
only see the new version of the modified code, or do we only get that
guarantee because we happen to execute the cache flushing on all cores?)

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2012-December/136441.html

Another of the issues I hit was big.LITTLE related whereby the cache
line size is different on different cores [2].

[2] http://lists.infradead.org/pipermail/linux-arm-kernel/2013-February/149794.html

I don't think anything I've said above actually gives a solid reason why
we _must_ execute cache flushing on all cores for kprobes and can't just
use the relatively new patch_text function (which checks for the one
case we do need to flush on all cores using cache_ops_need_broadcast).

Sorry, I don't think I've added much light on things here have I?

-- 
Tixy

