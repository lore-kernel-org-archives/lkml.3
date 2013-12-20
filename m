Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414Ab3LTTAw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 14:00:52 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:45996 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222Ab3LTTAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 14:00:49 -0500
MIME-Version: 1.0
In-Reply-To: <1387564464.3404.106.camel@linaro1.home>
References: <1387166930-13182-1-git-send-email-dave.long@linaro.org>
 <1387166930-13182-16-git-send-email-dave.long@linaro.org> <1387564464.3404.106.camel@linaro1.home>
From: Rabin Vincent <rabin@rab.in>
Date: Fri, 20 Dec 2013 20:00:08 +0100
X-Google-Sender-Auth: aifacgLSjq-EunwTGjZvbYIobiw
Message-ID: <CAH+eYFDqVpBzzjxR5tVpPUUKS3XLWiDU1Fe5p0CQTUP4yWUDhg@mail.gmail.com>
Subject: Re: [PATCH v4 15/16] ARM: add uprobes support
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
Cc: David Long <dave.long@linaro.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        davem@davemloft.net, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/12/20 Jon Medhurst (Tixy) <tixy@linaro.org>
> On Sun, 2013-12-15 at 23:08 -0500, David Long wrote:
> > +static int uprobes_substitute_pc(unsigned long *pinsn, u32 oregs)
> > +{
> > +     probes_opcode_t insn = __mem_to_opcode_arm(*pinsn);
> > +     probes_opcode_t temp;
> > +     probes_opcode_t mask;
> > +     int freereg;
> > +     u32 free = 0xffff;
> > +     u32 regs;
> > +
> > +     for (regs = oregs; regs; regs >>= 4, insn >>= 4) {
> > +             if ((regs & 0xf) == REG_TYPE_NONE)
> > +                     continue;
> > +
> > +             free &= ~(1 << (insn & 0xf));
> > +     }
> > +
> > +     /* No PC, no problem */
> > +     if (free & (1 << 15))
> > +             return 15;
> > +
> > +     if (!free)
> > +             return -1;
> > +
> > +     /*
> > +      * fls instead of ffs ensures that for "ldrd r0, r1, [pc]" we would
> > +      * pick LR instead of R1.
>
> Do we know why this is desirable, i.e. preferring the higher numbered
> registers? If there isn't a preference, then no need for comment really.
>
> Also, the comment as is is wrong, should be "...pick LR instead of R2"
> because R1 wouldn't be chosen as the instruction already uses it.

The second destination register of LDRD (R1 in the example above) is
not encoded in the instruction and so the code above would believe it
is free.  Using ffs instead of fls would thus lead to R1 being used to
substitute PC.
