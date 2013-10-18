Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127Ab3JRI5Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 04:57:25 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:35654 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751228Ab3JRI5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 04:57:23 -0400
Date: Fri, 18 Oct 2013 09:56:38 +0100
From: Will Deacon <will.deacon@arm.com>
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
Cc: Jiang Liu <liuj97@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Jiang Liu <jiang.liu@huawei.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 2/7] arm64: introduce interfaces to hotpatch kernel
 and module code
Message-ID: <20131018085638.GA2858@mudshark.cambridge.arm.com>
References: <1381990781-27814-1-git-send-email-liuj97@gmail.com>
 <1381990781-27814-3-git-send-email-liuj97@gmail.com>
 <20131017113826.GJ18765@mudshark.cambridge.arm.com>
 <1382023441.19506.66.camel@linaro1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382023441.19506.66.camel@linaro1.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tixy,

On Thu, Oct 17, 2013 at 04:24:01PM +0100, Jon Medhurst (Tixy) wrote:
> On Thu, 2013-10-17 at 12:38 +0100, Will Deacon wrote:
> > On Thu, Oct 17, 2013 at 07:19:35AM +0100, Jiang Liu wrote:
> > > +	/*
> > > +	 * Execute __aarch64_insn_patch_text() on every online CPU,
> > > +	 * which ensure serialization among all online CPUs.
> > > +	 */
> > > +	return stop_machine(aarch64_insn_patch_text_cb, &patch, NULL);
> > > +}
> > 
> > Whoa, whoa, whoa! The comment here is wrong -- we only run the patching on
> > *one* CPU, which is the right thing to do. However, the arch/arm/ call to
> > stop_machine in kprobes does actually run the patching code on *all* the
> > online cores (including the cache flushing!). I think this is to work around
> > cores without hardware cache maintenance broadcasting, but that could easily
> > be called out specially (like we do in patch.c) and the flushing could be
> > separated from the patching too.
> [...]
> 
> For code modifications done in 32bit ARM kprobes (and ftrace) I'm not
> sure we ever actually resolved the possible cache flushing issues. If
> there was specific reasons for flushing on all cores I can't remember
> them, sorry. I have a suspicion that doing so was a case of sticking
> with what the code was already doing, and flushing on all cores seemed
> safest to guard against problems we hadn't thought about.

[...]

> Sorry, I don't think I've added much light on things here have I?

I think you missed the bit I was confused about :) Flushing the cache on
each core is necessary if cache_ops_need_broadcast, so I can understand why
you'd have code to do that. The bit I don't understand is that you actually
patch the instruction on each core too!

Will
