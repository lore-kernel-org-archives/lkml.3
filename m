Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbaENVMt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 17:12:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42147 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbaENVMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 17:12:48 -0400
Date: Wed, 14 May 2014 16:50:21 -0400
From: Don Zickus <dzickus@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, peterz@infradead.org,
        acme@ghostprotocols.net, jolsa@redhat.com, jmario@redhat.com,
        eranian@google.com
Subject: Haswell mem-store question
Message-ID: <20140514205021.GU39568@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

Joe was playing with our c2c tool today and noticed we were losing store
events from perf's mem-stores event.  Upon investigation we stumbled into
some differences in data that Haswell reports vs. Ivy/Sandy Bridge.

This leaves our tool needing two different paths depending on the
architect, which seems odd.

I was hoping you or someone can explain to me the correct way to interpret
the mem-stores data.

My current problem is mem_lvl.  It can be defined as

/* memory hierarchy (memory level, hit or miss) */
#define PERF_MEM_LVL_NA         0x01  /* not available */
#define PERF_MEM_LVL_HIT        0x02  /* hit level */
#define PERF_MEM_LVL_MISS       0x04  /* miss level  */
#define PERF_MEM_LVL_L1         0x08  /* L1 */
#define PERF_MEM_LVL_LFB        0x10  /* Line Fill Buffer */
#define PERF_MEM_LVL_L2         0x20  /* L2 */
#define PERF_MEM_LVL_L3         0x40  /* L3 */
#define PERF_MEM_LVL_LOC_RAM    0x80  /* Local DRAM */
#define PERF_MEM_LVL_REM_RAM1   0x100 /* Remote DRAM (1 hop) */
#define PERF_MEM_LVL_REM_RAM2   0x200 /* Remote DRAM (2 hops) */
#define PERF_MEM_LVL_REM_CCE1   0x400 /* Remote Cache (1 hop) */
#define PERF_MEM_LVL_REM_CCE2   0x800 /* Remote Cache (2 hops) */
#define PERF_MEM_LVL_IO         0x1000 /* I/O memory */
#define PERF_MEM_LVL_UNC        0x2000 /* Uncached memory */
#define PERF_MEM_LVL_SHIFT      5

Currently IVB and SNB use LVL_L1 & (LVL_HIT or LVL_MISS) seen here in
arch/x86/kernel/cpu/perf_event_intel_ds.c

static u64 precise_store_data(u64 status)
{
        union intel_x86_pebs_dse dse;
        u64 val = P(OP, STORE) | P(SNOOP, NA) | P(LVL, L1) | P(TLB, L2);
						^^^^^^^^^
						defined here

        dse.val = status;

<snip>
        /*
         * bit 0: hit L1 data cache
         * if not set, then all we know is that
         * it missed L1D
         */
        if (dse.st_l1d_hit)
                val |= P(LVL, HIT);
        else
                val |= P(LVL, MISS);

	^^^^^^^
	updated here

<snip>
}

However Haswell does something different:

static u64 precise_store_data_hsw(u64 status)
{
        union perf_mem_data_src dse;

        dse.val = 0;
        dse.mem_op = PERF_MEM_OP_STORE;
        dse.mem_lvl = PERF_MEM_LVL_NA;
			^^^^^^
			defines NA here


        if (status & 1)
                dse.mem_lvl = PERF_MEM_LVL_L1;

		^^^^^^^
		switch to LVL_L1 here
<snip>
}

So our c2c tool kept store statistics to help determine what types of
stores are causing conflicts

<snip>
        } else if (op & P(OP,STORE)) {
                /* store */
                stats->t.store++;

                if (!daddr) {
                        stats->t.st_noadrs++;
                        return -1;
                }

                if (lvl & P(LVL,HIT)) {
                        if (lvl & P(LVL,UNC)) stats->t.st_uncache++;
			if (lvl & P(LVL,L1 )) stats->t.st_l1hit++;
                } else if (lvl & P(LVL,MISS)) {
                        if (lvl & P(LVL,L1)) stats->t.st_l1miss++;
		}
	}
<snip>

This no longer works on Haswell because Haswell doesn't set LVL_HIT or
LVL_MISS any more.  Instead it uses LVL_NA or LVL_L1.

So from a generic tool perspective, what is the recommended way to
properly capture these stats to cover both arches?  The hack I have now
is:

        } else if (op & P(OP,STORE)) {
                /* store */
                stats->t.store++;

                if (!daddr) {
                        stats->t.st_noadrs++;
                        return -1;
                }

                if ((lvl & P(LVL,HIT)) || (lvl & P(LVL,L1))) {
                        if (lvl & P(LVL,UNC)) stats->t.st_uncache++;
                        if (lvl & P(LVL,L1 )) stats->t.st_l1hit++;
                } else if ((lvl & P(LVL,MISS)) || (lvl & P(LVL,NA))) {
                        if (lvl & P(LVL,L1)) stats->t.st_l1miss++;
                        if (lvl & P(LVL,NA)) stats->t.st_l1miss++;
                }
	}

I am not sure that is really future proof.  Thoughts? Help?

Cheers,
Don
