Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634Ab3H2RPE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 13:15:04 -0400
Received: from mail-vb0-f50.google.com ([209.85.212.50]:41003 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228Ab3H2RPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 13:15:01 -0400
MIME-Version: 1.0
In-Reply-To: <20130829135216.GA1032@krava.brq.redhat.com>
References: <CAFrcx1n5eA4zz+nUhraE_fi_Usc=PCZTC=RCT=S285K4=jqHSg@mail.gmail.com>
	<CAFrcx1nr4-qyzC=zFRdnMavHy5p_r9Ng+zSVwNPk6snYtBm6gw@mail.gmail.com>
	<521CCFD8.90201@gmail.com>
	<20130829135216.GA1032@krava.brq.redhat.com>
Date: Thu, 29 Aug 2013 19:15:00 +0200
Message-ID: <CAFrcx1=U8SapYd=Hw8YaAnKNggJMuY4r03zYeevc0Ttq5hFr7Q@mail.gmail.com>
Subject: Re: Fwd: perf: callchain feature on ARM - question about libunwind API
From: Jean Pihet <jean.pihet@linaro.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On 29 August 2013 15:52, Jiri Olsa <jolsa@redhat.com> wrote:
> On Tue, Aug 27, 2013 at 10:12:08AM -0600, David Ahern wrote:
>> [Added Jiri who added the feature to perf]
>>
>> On 8/27/13 5:58 AM, Jean Pihet wrote:
>> >Hi!
>> >
>> >I am looking for info and help on the libunwind API.
>> >
>> >What I am trying to achieve is to allow the callchain feature on perf
>> >for ARM (v7 to start with, then ARMv8), from the DWARF info found in
>> >the .debug_frame section.
>> >
>> > From the source code in tools/perf I have added the call to
>> >dwarf_find_debug_frame to load and parse the debug info from
>> >.debug_frame. This works correctly, all IP ranges are found from the
>> >debug code (test program and libraries). Then at some point I get an
>> >assertion: 'perf: dwarf/Gparser.c:459: fetch_proc_info: Assertion
>> >`c->pi.unwind_info' failed.' At that point c->pi is NULL. Cf. below
>> >for more info.
>
> I checked the patch and it looks ok, thought I've never touched
> the .debug_frames code paths which are separated to some extend
> in the libunwind code..
>
>> >
>> >It looks like I am not using the libunwind API as it should, so that
>> >the perf code apparently builds a list of IP ranges to resolve but
>> >cannot use it later on to gather statistics on the runtime info.
>> >
>> >Any idea on how to progress? I am also looking at the *_proc_info API
>> >of libunwind.
>
> keep digging ;-) also I dont have that assert exactly
Indeed!

I found the right implementation ;-p In fact I have to call the
following in order:
- check if the .debug_frame section exists for the binary,
- call dwarf_find_debug_frame to load the debug info,
- call dwarf_search_unwind_table to lookup the called function from the IP.

The patches are coming asap.

It works great now!
Here is an excerpt of the output below:

$ ./tools/perf/perf record -g dwarf -- ../../perf-libunwind/test_app/stress_bt
Total count: 3472419716
[ perf record: Woken up 226 times to write data ]
[ perf record: Captured and wrote 56.488 MB perf.data (~2467981 samples) ]
$ ./tools/perf/perf report --sort symbol --call-graph --stdio
...
# Samples: 7K of event 'cpu-clock'
# Event count (approx.): 1764500000
#
# Overhead                              Symbol
# ........  ..................................
#
    0.00%  [.] foo_128
            |
            |--98.29%-- foo_127
            |          |
            |          |--99.29%-- foo_126
            |          |          |
            |          |          |--99.12%-- foo_125
            |          |          |          |
            |          |          |          |--99.40%-- foo_124
            |          |          |          |          |
            |          |          |          |          |--99.13%-- foo_123
            |          |          |          |          |          |
            |          |          |          |          |
|--99.24%-- foo_122
...
            |          |          |           --0.60%-- bar
            |          |          |                     doit
            |          |          |                     main
            |          |          |                     __libc_start_main
            |          |          |
            |          |           --0.88%-- bar
            |          |                     doit
            |          |                     main
            |          |                     __libc_start_main
            |          |
            |           --0.71%-- bar
            |                     doit
            |                     main
            |                     __libc_start_main
            |
            |--0.86%-- bar
            |          doit
            |          main
            |          __libc_start_main
             --0.86%-- [...]


The problem is that it is slow as hell (couple of minutes to report
the callchain from a simple test app ;-|). I will look at the sampling
rate and the caching next.

> at dwarf/Gparser.c:459 so maybe try latest code
> git://git.sv.gnu.org/libunwind.git
I am using the version with commit ID 3b8254d3 ('2013-05-19 Matt
Fischer Fix unwind info freeing code in DWARF parser'), which is very
recent.

>
> sorry not to help help you much, you might try to ask
> Arun Sharma <asharma@fb.com> who helped me before.
Ok!

Thanks for your reply and your help!

>
> jirka

Cheers,
Jean
