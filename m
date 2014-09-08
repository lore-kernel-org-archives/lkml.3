Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984AbaIHN3i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 09:29:38 -0400
Received: from service88.mimecast.com ([195.130.217.12]:55134 "EHLO
	service88.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997AbaIHN3h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 09:29:37 -0400
From: Al Grant <Al.Grant@arm.com>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
CC: Pawel Moll <Pawel.Moll@arm.com>, Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        "kan.liang@intel.com" <kan.liang@intel.com>,
        Michael Williams <Michael.Williams@arm.com>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>,
        Deepak Saxena <dsaxena@linaro.org>
Date: Mon, 8 Sep 2014 14:29:32 +0100
Subject: RE: [PATCH v4 00/22] perf: Add infrastructure and support for Intel
 PT
Thread-Topic: [PATCH v4 00/22] perf: Add infrastructure and support for
 Intel PT
Thread-Index: Ac/LZORNIi7pMRfhSOu6sPbghgPo8AAAeDTQ
Message-ID: <DEE44AFE682197449410588EB783A514688830A524@BUNGLE.Emea.Arm.com>
References: <1408538179-792-1-git-send-email-alexander.shishkin@linux.intel.com>
 <20140901163039.GV27892@worktop.ger.corp.intel.com>
 <1409591843.4343.65.camel@hornet>
 <CANLsYky0vuwo7MwKbiGXypkLkrX7k6BOEf2uej3-Z3-HZHKd7w@mail.gmail.com>
 <20140904082656.GM3190@worktop.ger.corp.intel.com>
 <CANLsYkwdRBfOFb5c6=nb+1qzt1R=MJ4NbPWymgp5J6iRs02KDQ@mail.gmail.com>
 <87iokyuy15.fsf@ashishki-desk.ger.corp.intel.com>
In-Reply-To: <87iokyuy15.fsf@ashishki-desk.ger.corp.intel.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, en-GB
MIME-Version: 1.0
X-MC-Unique: 114090814293500902
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ok, in perf the trace configuration would be part of 'session'
> information, so the way the tracing was configured by userspace will
> be
> saved to the resulting trace file (perf.data) by the userspace.
> We have that with Intel PT as well.

For ETM, in principle, those aspects of the ETM configuration that
affect packet-level decode might change during a trace session (you'd
have to disable the ETM while you did that, but you might still be
capturing trace).  The decoder would then need to switch its own
model of the configuration at exactly the right time.  The most
robust way I could think of for doing that (given that timestamps
might not be precise enough) was to switch the ETM to use a new
trace source identifier.  But there also needs to be a sideband
message that the decoder can listen to - a "trace configuration
changed" message.  That could go in perf.data somewhere.

I don't know if you have that issue for PT.

You might decide that reconfiguring a trace source during a trace
capture is not a valid use case...


> > Metadata refer to exactly that - the configuration of the trace
> > engine.  It has to be somehow lumped with the trace stream for off
> > target analysis.
>
> What we call sideband data in our code is more like runtime
> metadata,
> such as executable mappings (so that you know what is mapped to
> which
> addresses, iirc ETM/PTM also deals in virtual addresses, so you'll
> need
> this information to make sense of the trace, right?) and context
> switches.

Yes, that's exactly the information ETM/PTM needs too - a dynamic
mapping from virtual address to opcodes.

For context switches, if the kernel is set up to use the hardware
context id register (CONTEXTIDR), it might not be necessary to have
a message on every context switch, only on changes to the address
space maps.  So you get less invasive tracing (because you're not
generating a perf event every context switch) at the expense of a
slight fixed increase in context switch time due to the kernel
updating CONTEXTIDR.

There's a lot more about this in

http://people.linaro.org/~mathieu.poirier/coresight/cs-decode.pdf

where I've used the term "static metadata" for the basic trace
configuration vs. "dynamic metadata" for the data that changes as
the OS executes whatever workload you're tracing.  Both are sideband
data as far as ETM is concerned as they aren't in the ETM stream.


> One of the great things about perf here is that it provides all this
> information practically for free.

That's good to know!

Tracing of JITted code also creates challenges and it would be
interesting to hear how PT and perf solve that problem.
The trace decoder needs the address->opcode mapping, but as the
opcodes have only a transient lifetime now, they need to be
captured somewhere - either in the perf stream itself or in a
side channel.  Hopefully, you only have to do that when you JIT
a block, and not every time you execute the cached code block,
so it's not so invasive as to negate the benefits of JIT.

Al



>
> >>
> >> The way I read your explanation it is a one time blob generated
> once you
> >> setup the hardware.
> >
> > Correct.
> >
> >> I suppose we could either dump it once into the
> >> normal data stream or maybe dump it once every time we generate
> an AUX
> >> buffer event into the normal data stream -- if its not too big.
> >
> > Right, there is a set of meta-data to be generated with each trace
> > run.  With the current implementation a "trace run" pertains to
> all
> > the information collected between the beginning and end of a trace
> > scenario.  Future work involve triggering a DMA transfer of the
> full
> > coresight buffer to a kernel memory area, something that is
> probably
> > close to the "buffer event" you are referring to.
>
> Again correct me if I'm wrong, but the TMC(?) controller can be
> configured to direct ETM/PTM output right into system memory by
> means of
> a scatter-gather table. This is what we call AUX area, it's
> basically a
> circular buffer with trace data. Trace output is sent to the system
> memory, which is also mmap()ed to the userspace tracing tool (perf),
> so
> that it can capture it in real time. Well, that's one of the
> scenarios.
>
> Regards,
> --
> Alex


-- IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium.  Thank you.

ARM Limited, Registered office 110 Fulbourn Road, Cambridge CB1 9NJ, Registered in England & Wales, Company No:  2557590
ARM Holdings plc, Registered office 110 Fulbourn Road, Cambridge CB1 9NJ, Registered in England & Wales, Company No:  2548782

