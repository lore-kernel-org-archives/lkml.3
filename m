Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311AbaKEPzD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 10:55:03 -0500
Received: from mga01.intel.com ([192.55.52.88]:56181 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755174AbaKEPy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 10:54:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,320,1413270000"; 
   d="scan'208";a="627047129"
From: "Liang, Kan" <kan.liang@intel.com>
To: Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <peterz@infradead.org>
CC: LKML <linux-kernel@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        "Arnaldo Carvalho de Melo" <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: RE: [PATCH V7 13/17] perf, x86: enable LBR callstack when recording
 callchain
Thread-Topic: [PATCH V7 13/17] perf, x86: enable LBR callstack when
 recording callchain
Thread-Index: AQHP+KX/YxlObCt1zUitzjk43uZVUpxRPG2AgAAKQgCAAAy4gIAAA68AgAAfXgCAAAkhgIAAlZ3w
Date: Wed, 5 Nov 2014 15:53:34 +0000
Message-ID: <37D7C6CF3E00A74B8858931C1DB2F077016540B7@SHSMSX103.ccr.corp.intel.com>
References: <1415156173-10035-1-git-send-email-kan.liang@intel.com>
	<1415156173-10035-14-git-send-email-kan.liang@intel.com>
	<20141105092145.GP10501@worktop.programming.kicks-ass.net>
	<CABPqkBS89jrjOMR9b_7WudJ0rDn0uD8XxX2gCJYDvTEssjXcww@mail.gmail.com>
	<20141105104359.GP3337@twins.programming.kicks-ass.net>
	<CABPqkBQFqoZdRZvRT3kHukpYXHBJdB4mUWARNoo1QZmgH24p4w@mail.gmail.com>
	<20141105124926.GS3337@twins.programming.kicks-ass.net>
 <CABPqkBRF6VEigBcBr+6Hy5E3tmfk4vpDiR8Zui8=853GTjG_XQ@mail.gmail.com>
In-Reply-To: <CABPqkBRF6VEigBcBr+6Hy5E3tmfk4vpDiR8Zui8=853GTjG_XQ@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sA5FtAXp027447


Thanks for your comments. There are lots of discussion about the patch.
It's hard to reply them one by one. So I try to reply all the concerns here.

The patchset doesn't try to introduce the 3rd independent callchain option
That's because LBR callstack has some limitations (only available for user
callchain, only 16 entries, cannot collect branch info at the same time, etc).
So itâ€™s designed as a supplement/extension of FP callchain options. It rely
on FP, but can provide the callstack info when FP isn't available in some
cases which Stephane and Andi mentioned.

Since it's not an independent callchain options, I didn't provide an explicit
option for user to enable it.
However, I provide an option in perf report to show the LBR userspace
callchain and FP callchain. That's the main difference between Zheng's 
previous patch and the latest patch.

Here are how it works.
When the user enable FP callchain on HSW, the kernel implicitly enable
both LBR callstack and FP.
Zheng's previous patch does everything in kernel. If FP is not available,
then LBR callstack data will be used implicitly. If FP is available, then LBR
callstack data will be discarded.
While the latest patch expose both LBR callstack and FP data to user tool.
A new option for perf report is introduced. The user can dump the callchain
from either lbr or fp if they are both available. 
E.g.
perf report --call-graph fp (both userspace and kernel callchain from FP)
perf report --call-graph lbr (userspace callchain from LBR, kernel from FP)

> 
> On Wed, Nov 5, 2014 at 1:49 PM, Peter Zijlstra <peterz@infradead.org>
> wrote:
> > On Wed, Nov 05, 2014 at 11:57:10AM +0100, Stephane Eranian wrote:
> >> Yes, but I wonder how would the tool sort this out if you have FP and
> >> LBR for each sample.
> >
> > That's the tools 'problem'. It currently can already have FP and Dwarf
> > bits. And it does not need to request all of them.
> >
> I was thinking about the case where the tool would request both FP and
> LBR at the same to try and construct a complete callstack. Not sure how the
> tool could do that.

Both LBR and FP data are pushed to the tool. User can use newly introduced 
perf report call-graph option to choose how to construct the callstack.

> 
> >> My understanding of the patch is that it does not change the user
> >> interface, it changes the way callchains are gathered by the kernel on
> HSW.
> >
> > I was under the impression it did change, but that shows how well the
> > Changelog explained things I suppose :/
> >
> With the current patches (or the latest version I looked at), there was no
> way to request explicitly LBR mode. It was automatic if CALLCHAIN + user
> mode only sampling.
> 

Yes, currently there is no way to request explicitly LBR mode. 

> >> Is there explicit mention in the API that CALLCHAIN is relying on FP?
> >
> > Don't think so. Although I would much prefer if it uses a single
> > method per arch across both kernel and user space. For x86 that is FP
> > (since that's the only method available to the kernel).
> >
> I tend to agree here. The problem with FP is that it is not easy to figure out
> how a binary has been compiled. Getting valid FP callchains for large
> binaries using lots of shared libraries is very challenging. All libraries must
> be compiled with FP. It is not easy to test if FP was compiled in. There is no
> ELF header flag for this. Need to inspect the x86 asm and look at function
> prologues.
> 
> This is where LBR has an advantage, it works regardless of how a binaries
> and shared libs have been compiled. That is why this is a good (or some
> would say better) approach which is using hardware assist.
> 

Agreed. LBR is a very good supplement.

> >> I think in general it would be better for tools to know which
> >> low-level mechanism is used to better interpret the results and
> >> especially be aware of the limitations of each mechanism.
> >
> > Agreed.
> >
> >> I think the patch is trying some auto-promotion of CALLCHAIN to FP
> >> based on the belief it is better in most cases.
> >
> > We're all more familiar with FP, and it doesn't have the obvious
> > problem if only 16 entries. I've worked on quite a bit of software
> > that had much deeper callchains -- yay for recursive algorithms and/or
> C++.
> >
> Yes, this is true too. But it is not so clear to me if people really care about
> top of callchains that much. I think usually 2-6 would probably yield enough
> useful info.
> 
> LBR callstack fails for leaf function optimization. Where the callee does not
> return to its caller but instead to the caller's caller. That is the one case I
> know about. There are others I believe.
> 
> > With a bit of care FP can be 'perfect', although Andi likes to point
> > out that glibc isn't and often wrecks FP :-(
> >
> Especially any hand-crafted assembly...
> 
> >> It reminds me of the discussion about precise mode. Why not default
> >> to precise for all events that support it?
> >
> > I've no idea where that discussion stranded.
> >
> >> I would be okay if the patch was introducing the 3rd mode for callchains.
> >
> > Right, I would prefer that (as should be clear by now), this would
> > allow running with two (or even all three) and compare results.
> 
> I don't think it would be very hard to modify the patch set to make that 3rd
> mode visible. Just need to make that new PERF_RECORD_* type visible to
> user and modify the compatibility checks.

It's not hard. But LBR is not an independent callchain options. It's better to be
a supplement of FP. Otherwise, it may confuse the user. He enables the
BRANCH_CALL_STACK, but the data is partly or even not at all from hardware.


Thanks,
Kan
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
