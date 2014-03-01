Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175AbaCAQvY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 11:51:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33632 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005AbaCAQvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 11:51:23 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <20140301095042.GA16524@pd.tnic>
References: <alpine.DEB.2.10.1402280914550.6727@vincent-weaver-1.um.maine.edu> <20140228092341.12a40f7c@gandalf.local.home> <alpine.DEB.2.10.1402280957470.6727@vincent-weaver-1.um.maine.edu> <1c583986-74f8-4829-883b-390dc49ddabb@email.android.com> <20140228154026.GH9987@twins.programming.kicks-ass.net> <5310B60F.30806@zytor.com> <20140228112946.1f194397@gandalf.local.home> <20140228205638.GD14089@laptop.programming.kicks-ass.net> <20140228160638.3b045dbc@gandalf.local.home> <20140301091650.GD5885@gmail.com> <20140301095042.GA16524@pd.tnic>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: perf_fuzzer compiled for x32 causes reboot
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 01 Mar 2014 08:50:17 -0800
To: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Message-ID: <7f55737e-25a2-4cf0-aa07-17102a368ef2@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bottom line is that if we want hard numbers we probably have to measure.

Hoisting the cr2 read is a no-brainer, might even help performance...

On March 1, 2014 1:50:42 AM PST, Borislav Petkov <bp@alien8.de> wrote:
>On Sat, Mar 01, 2014 at 10:16:50AM +0100, Ingo Molnar wrote:
>> 
>> * Steven Rostedt <rostedt@goodmis.org> wrote:
>> 
>> > > Also, this function is called a _LOT_ under certain workloads, I 
>> > > don't know how cheap a CR2 read is, but it had better be really 
>> > > cheap.
>> > 
>> > That's a HPA question.
>> 
>> We read CR2 in the page fault hot path, so it's on the top of CPU 
>> architects' minds and it's reasonably optimized. A couple of cycles 
>> IIRC, but would be nice to hear actual numbers.
>
>Yeah, we were discussing this last night on IRC.
>
>And hpa actually meant that the optimization potential was there but no
>one did do it, except maybe Transmeta. :-)
>
>So the expensive thing is writing to CR2 because it is a serializing
>instruction. In fact, all writes to control registers except CR8 are
>serializing.
>
>The reading from CR2 should be cheaper but not as cheap as a normal
>MOV %reg %reg is. On AMD, MOV %reg, %cr2 is done with microcode so
>definitely at least a couple of cycles and I'd guess it is not a
>trivial
>MOV on Intel too.
>
>Maybe a way to hide this cost is the OoO, as hpa suggested, depending
>on
>how much parallelism that particular code region can offer (serializing
>instructions close by).

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
