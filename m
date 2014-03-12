Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149AbaCLQNl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 12:13:41 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48737 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754875AbaCLQNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 12:13:40 -0400
Date: Wed, 12 Mar 2014 16:13:32 +0000
From: Will Deacon <will.deacon@arm.com>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: "steve.capper@linaro.org" <steve.capper@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnaldo <acme@ghostprotocols.net>, Ingo Molnar <mingo@kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 1/3] perf tests: Introduce perf_regs_load function on ARM
Message-ID: <20140312161332.GF9691@mudshark.cambridge.arm.com>
References: <1393840403-26639-1-git-send-email-jean.pihet@linaro.org>
 <1393840403-26639-2-git-send-email-jean.pihet@linaro.org>
 <20140304110042.GD8766@mudshark.cambridge.arm.com>
 <CAFrcx1=3+zZPErXC7dehwpKHnmwE=cWh1mR0kzN0PONpFZKaUw@mail.gmail.com>
 <20140306113314.GD5202@mudshark.cambridge.arm.com>
 <20140306172217.GB1269@krava.brq.redhat.com>
 <CAFrcx1mCTLzc1dcSZyk_GOENsD-QGbyU+4NHa3BZFLYxyk7n_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFrcx1mCTLzc1dcSZyk_GOENsD-QGbyU+4NHa3BZFLYxyk7n_Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 06:25:11PM +0000, Jean Pihet wrote:
> HI Will, Steve,

Hi Jean,

> On 6 March 2014 18:22, Jiri Olsa <jolsa@redhat.com> wrote:
> > On Thu, Mar 06, 2014 at 11:33:15AM +0000, Will Deacon wrote:
> >> On Wed, Mar 05, 2014 at 02:17:00AM +0000, Jean Pihet wrote:
> >> > On 4 March 2014 12:00, Will Deacon <will.deacon@arm.com> wrote:
> >> > > On Mon, Mar 03, 2014 at 09:53:21AM +0000, Jean Pihet wrote:
> >> > >> +     str lr, [r0, #PC]       @ Save caller PC
> >> > >
> >> > > This isn't necessarily the `caller PC' (depending on how you define it).
> >> > > It's the return address, which is probably (but not always) the instruction
> >> > > following the branch to this function.
> >> > Agreed. However the perf test code expects a registers buffer filled
> >> > in with the caller's values.
> >> > I can change the comment here, is that needed?
> >>
> >> It depends what the perf test code really expects. At the moment, you're not
> >> providing it with anything consistent which doesn't sound correct.
> >
> > the code expects caller's PC. That is what the x86 test code
> > expects from perf_regs_load. We take the return IP saved by
> > call instruction:
> >
> > ENTRY(perf_regs_load)
> >         ...
> >         movq 0(%rsp), %rax
> >         movq %rax, IP(%rdi)
> >         ...
> >
> > jirka
> 
> The perf built-in test code expects the caller PC to do the unwinding
> from. Does that sound correct to you?

Yes, but we're not necessarily providing that in your code. We're providing
the return address, which could be different (e.g., if this was a tail
call).

> Do you want me to add a note like this one (as done in the upcoming
> aarch64 patches, to be submitted asap after testing):
> "
> /*
>  * Implementation of void perf_regs_load(u64 *regs);
>  *
>  * This functions fills in the 'regs' buffer from the actual registers values.
>  *
>  * Notes:
>  *  1. the return value of the pc is retrieved from lr and stored, in order
>  *  to skip the call to this function,
>  *  2. the current value of lr is merely retrieved and stored because the
>  *  value before the call to this function is unknown at this time; it will
>  *  be unwound from the dwarf information in unwind__get_entries.
>  */
> "

I think the main thing is that your code may well work for this specific
test case (and perhaps that's good enough) but we should be clear about the
assumptions you're making.

Will
