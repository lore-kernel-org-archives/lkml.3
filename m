Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632Ab3KFSKz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 13:10:55 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46531 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750755Ab3KFSKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 13:10:54 -0500
Date: Wed, 6 Nov 2013 18:09:56 +0000
From: Will Deacon <will.deacon@arm.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 2/7] arm64: introduce interfaces to hotpatch kernel
 and module code
Message-ID: <20131106180956.GC4524@mudshark.cambridge.arm.com>
References: <1382109602-27432-1-git-send-email-liuj97@gmail.com>
 <1382109602-27432-3-git-send-email-liuj97@gmail.com>
 <20131030001245.GB25346@mudshark.cambridge.arm.com>
 <527671E9.8040704@gmail.com>
 <CA+b37P2WU74NU7wG_H+KfmL6Y-fdhipsuOruU-z=wv=8ENwrfQ@mail.gmail.com>
 <20131106104110.GC21074@mudshark.cambridge.arm.com>
 <527A6A5D.2050206@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <527A6A5D.2050206@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 04:12:13PM +0000, Jiang Liu wrote:
> On 11/06/2013 06:41 PM, Will Deacon wrote:
> > On Mon, Nov 04, 2013 at 03:12:56PM +0000, Sandeepa Prabhu wrote:
> >> On 3 November 2013 23:55, Jiang Liu <liuj97@gmail.com> wrote:
> >>> On 10/30/2013 08:12 AM, Will Deacon wrote:
> >>>> On Fri, Oct 18, 2013 at 04:19:56PM +0100, Jiang Liu wrote:
> >>>>> +    atomic_set(&text_patch_id, smp_processor_id());
> >>>>> +    ret = stop_machine(aarch64_insn_patch_text_cb, &patch, cpu_online_mask);
> >>>>
> >>>> Instead of doing this, why not instead call aarch64_insn_patch_text_nosync
> >>>> inline, then call kick_all_cpus_sync immediately afterwards, without the
> >>>> need to stop_machine.
> >>> Sandeepa, who is working on kprobe for ARM64, needs the stop_machine()
> >>> mechanism to synchronize all online CPUs, so it's a preparation for
> >>> kprobe.
> >>
> >> I had published kprobes patches for ARM64:
> >> http://lwn.net/Articles/570648/  and using your patcset (v3) for
> >> patching support, it works so far.
> >> I CCed you on my RFC but unfortunately to your huawei email not the gmail.
> >>
> >> I can give a try with kick_all_cpus_sync but wanted to understand this
> >> a bit  detail on hows different from stop_machine and how this work.
> > 
> > My point was just that for nosync patching, the update to the instruction
> > stream is atomic with respect to instruction fetch, so stop_machine seems a
> > bit overkill. kick_all_cpus can be used to ensure visibility of the new
> > instruction.
> > 
> > Jiang Liu seemed to imply that this isn't suitable for kprobes, but I would
> > like to know if/why that is the case.
> > 
> > Will
> > 
> Hi Will and Sandeepa,
> 	Seems some misunderstanding here. We provide three interfaces
> here.
> 1) aarch64_insn_patch_text_nosync(), which patches kernel/module text
> without explicitly synchronization. It may be used in cases of
> 1.a) There's only one CPU running during early boot stage
> 1.b) All other CPU has been put into safe state in kgdb.
> 1.c) The instructions before and after patching are both hot-patch safe.
> 
> 2) aarch64_insn_patch_text_sync(), which patches kernel/module text
> with explicitly synchronization by stop_machine() mechanism. It may
> be used to support kprobe because kprobe may patch multiple and/or
> non-hotpatch safe instructions at runtime, so we need stop_machine()
> for synchronization.
> 
> 3) aarch64_insn_patch_text() intelligently choose
> aarch64_insn_patch_text_nosync() or aarch64_insn_patch_text_sync().
> 
> So for kprobe, I think need to use stop_machine() for synchronization.

Yup that sounds right. I think I must've got confused as to what exactly was
being patched and the interaction with the mutex; if we're patching live
code which isn't hot-patch safe, then stop_machine sounds like the thing to
do.

Sorry for the confusion,

Will
