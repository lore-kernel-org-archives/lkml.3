Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304Ab3BPOOj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 09:14:39 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:33253 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab3BPOOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 09:14:37 -0500
MIME-Version: 1.0
In-Reply-To: <1360982707.22260.79.camel@pasglop>
References: <1359040242-8269-1-git-send-email-eranian@google.com>
	<1359040242-8269-8-git-send-email-eranian@google.com>
	<20130125090158.GB31478@gmail.com>
	<20130215194622.GA6396@us.ibm.com>
	<1360982707.22260.79.camel@pasglop>
Date: Sat, 16 Feb 2013 15:14:35 +0100
Message-ID: <CABPqkBRwdYANGm8kL+nTzjNdkV_vqdxv_oUXszjx4J=fg=-b7A@mail.gmail.com>
Subject: Re: [PATCH v7 07/18] perf: add generic memory sampling interface
From: Stephane Eranian <eranian@google.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>, Maynard Johnson <mpjohn@us.ibm.com>,
        Anton Blanchard <anton@samba.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 16, 2013 at 3:45 AM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Fri, 2013-02-15 at 11:46 -0800, Sukadev Bhattiprolu wrote:
>>
>> POWER could use an additional field:
>>
>>                         mem_deratmiss:1
>
> If you want to make that field more "generic" make it "lvl1_tlb_miss",
> ie, a miss in the internal "level 1" TLB which is the smallest/fastest
> TLB level in the load/store unit.
>
If you want to express a L1 TLB miss, you already can do that:

PERF_MEM_S(TLB, MISS) | PERF_MEM_S(TLB, L1)

If this is a feature you do not support, then use the NA macro.

For instance:
PERF_MEM_S(LOCK, NA)

Need to be able to differentiate not supported from did not happen.


>> AFAICT, POWER does not currently save the mem_op, snoop or lock info
>> for the sampled instruction.  I guess we can leave them set to 0.
>
> Well, we don't have lock instructions to begin with :-) If we can read
> the IP then we can deduce the memop tho.
>
>> > > +};
>> > > +
>> > > +/* type of opcode (load/store/prefetch,code) */
>> > > +#define PERF_MEM_OP_NA             0x01 /* not available */
>> > > +#define PERF_MEM_OP_LOAD   0x02 /* load instruction */
>> > > +#define PERF_MEM_OP_STORE  0x04 /* store instruction */
>> > > +#define PERF_MEM_OP_PFETCH 0x08 /* prefetch */
>> > > +#define PERF_MEM_OP_EXEC   0x10 /* code (execution) */
>> > > +#define PERF_MEM_OP_SHIFT  0
>> > > +
>> > > +/* memory hierarchy (memory level, hit or miss) */
>> > > +#define PERF_MEM_LVL_NA            0x01  /* not available */
>> > > +#define PERF_MEM_LVL_HIT   0x02  /* hit level */
>> > > +#define PERF_MEM_LVL_MISS  0x04  /* miss level  */
>> > > +#define PERF_MEM_LVL_L1            0x08  /* L1 */
>> > > +#define PERF_MEM_LVL_LFB   0x10  /* Line Fill Buffer */
>> > > +#define PERF_MEM_LVL_L2            0x20  /* L2 hit */
>> > > +#define PERF_MEM_LVL_L3            0x40  /* L3 hit */
>> > > +#define PERF_MEM_LVL_LOC_RAM       0x80  /* Local DRAM */
>> > > +#define PERF_MEM_LVL_REM_RAM1      0x100 /* Remote DRAM (1 hop)
>> */
>> > > +#define PERF_MEM_LVL_REM_RAM2      0x200 /* Remote DRAM (2 hops)
>> */
>> > > +#define PERF_MEM_LVL_REM_CCE1      0x400 /* Remote Cache (1 hop)
>> */
>> > > +#define PERF_MEM_LVL_REM_CCE2      0x800 /* Remote Cache (2 hops)
>> */
>> > > +#define PERF_MEM_LVL_IO            0x1000 /* I/O memory */
>> > > +#define PERF_MEM_LVL_UNC   0x2000 /* Uncached memory */
>> > > +#define PERF_MEM_LVL_SHIFT 5
>>
>> POWER saves following information to describe where the data was
>> loaded from after a Dcache or DTLB miss.
>>
>>         FROM_L2
>>         FROM_L3
>>
>>         FROM_L2.1_SHR   From another L2 or L3 on same chip,
>> shared
>>         FROM_L2.1_MOD   From another L2 or L3 on same chip, modified
>>
>>         FROM_L3.1_SHR   From remote L2 or L3, shared
>>         FROM_L3.1_MOD   From remote L2 or L3, modified
>>
>>         FROM_RL2L3_SHR  From remote L2 or L3, shared
>>         FROM_RL2L3_MOD  From remote L2 or L3, modified
>>
>>         FROM_DL2L3_SHR  From distant L2 or L3, shared
>>         FROM_DL2L3_MOD  From distant L2 or L3, modified
>>
>> POWER uses 4 bits and a running count for its (currently) 13 possible
>> values.
>>
>> The macros in the patch use a separate bit for each level - is that to
>> allow
>> selecting more than one level at the same time ? If so, we will need
>> to reserve
>> a few more bits to allow for Power's memory levels that don't map to
>> the above.
>>
>> > > +
>> > > +/* snoop mode */
>> > > +#define PERF_MEM_SNOOP_NA  0x01 /* not available */
>> > > +#define PERF_MEM_SNOOP_NONE        0x02 /* no snoop */
>> > > +#define PERF_MEM_SNOOP_HIT 0x04 /* snoop hit */
>> > > +#define PERF_MEM_SNOOP_MISS        0x08 /* snoop miss */
>> > > +#define PERF_MEM_SNOOP_HITM        0x10 /* snoop hit modified */
>> > > +#define PERF_MEM_SNOOP_SHIFT       19
>> > > +
>> > > +/* locked instruction */
>> > > +#define PERF_MEM_LOCK_NA   0x01 /* not available */
>> > > +#define PERF_MEM_LOCK_LOCKED       0x02 /* locked transaction */
>> > > +#define PERF_MEM_LOCK_SHIFT        24
>> > > +
>> > > +/* TLB access */
>> > > +#define PERF_MEM_TLB_NA            0x01 /* not available */
>> > > +#define PERF_MEM_TLB_HIT   0x02 /* hit level */
>> > > +#define PERF_MEM_TLB_MISS  0x04 /* miss level */
>> > > +#define PERF_MEM_TLB_L1            0x08 /* L1 */
>> > > +#define PERF_MEM_TLB_L2            0x10 /* L2 */
>> > > +#define PERF_MEM_TLB_WK            0x20 /* Hardware Walker*/
>> > > +#define PERF_MEM_TLB_OS            0x40 /* OS fault handler */
>> > > +#define PERF_MEM_TLB_SHIFT 26
>>
>> On POWER, like with the Dcache source above, we have 4 bits to
>> describe where
>> the DTLB was loaded from after a dTLB miss.
>>
>> We would probably need to allow more bits to for the memory level of
>> the dTLB
>> load source.
>>
>> > > +
>> > > +#define PERF_MEM_S(a, s) \
>> > > +   (((u64)PERF_MEM_##a##_##s) << PERF_MEM_##a##_SHIFT)
>> > > +
>> >
>> > Would be nice to get feedback from PowerPC folks to see how well
>> > this matches their memory profiling hw capabilities?
>> >
>> > I suspect there's a lot of differences, but one can always hope
>> > ...
>> >
>> > If there's some hope for unification we could at least shape it
>> > in a way that they could pick up and extend.
>>
>> Thanks for Ccing.
>>
>> While on the topic of sampled instructions, POWER saves following
>> information
>> (in addition to the above memory info) for sampled instructions.
>>
>>         - whether the sampled instruction encountered a stall
>>         - the reasons for the stall.
>>         - whether the instruction was from hypervisor
>>         - there was a branch mis-predict,
>>         - thresholding information
>>
>> These are clubbed into an "event vector" that is saved for sampled
>> instructions. We have been meaning to find ways to present that to
>> to user space. Are there plans to retreive and present these too.
>
> Ben.
>
>
