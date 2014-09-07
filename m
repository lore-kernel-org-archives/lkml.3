Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393AbaIGUYP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 16:24:15 -0400
Received: from mail-oi0-f49.google.com ([209.85.218.49]:42032 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589AbaIGUYN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 16:24:13 -0400
MIME-Version: 1.0
In-Reply-To: <20140905154402.GF30520@kernel.org>
References: <1409893157-469-1-git-send-email-namhyung@kernel.org>
	<540964C0.1050702@intel.com>
	<20140905141123.GE30520@kernel.org>
	<1409930200.1662.16.camel@leonhard>
	<20140905154402.GF30520@kernel.org>
Date: Sun, 7 Sep 2014 22:24:12 +0200
Message-ID: <CABPqkBQxcTK7YFhcaV5PORx7ub+scwpkd3Rd=bAPgTK6Cvh1Rg@mail.gmail.com>
Subject: Re: [PATCH v2] perf tools: Fix build-id matching on vmlinux
From: Stephane Eranian <eranian@google.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 5, 2014 at 5:44 PM, Arnaldo Carvalho de Melo
<acme@kernel.org> wrote:
> Em Sat, Sep 06, 2014 at 12:16:40AM +0900, Namhyung Kim escreveu:
>> Hi Adrian and Arnaldo,
>>
>> 2014-09-05 (금), 11:11 -0300, Arnaldo Carvalho de Melo:
>> > Em Fri, Sep 05, 2014 at 10:22:40AM +0300, Adrian Hunter escreveu:
>> > > On 09/05/2014 07:59 AM, Namhyung Kim wrote:
>> > > > +++ b/tools/perf/util/machine.c
>> > > > @@ -1060,10 +1060,14 @@ static int machine__process_kernel_mmap_event(struct machine *machine,
>> > > >                                 strlen(kmmap_prefix));
>> > > >                 /*
>> > > >                  * Should be there already, from the build-id table in
>> > > > -                * the header.
>> > > > +                * the header (but maybe with a different name: "vmlinux").
>> > > >                  */
>> > > > -               struct dso *kernel = __dsos__findnew(&machine->kernel_dsos,
>> > > > -                                                    kmmap_prefix);
>> > > > +               struct dso *kernel = dsos__find(&machine->kernel_dsos,
>> > > > +                                               "vmlinux", true);
>> >
>> > > Isn't "vmlinux" just the basename of the original file name, so if it had a
>> > > different name this wouldn't work e.g. if the filename had been
>> > > /boot/vmlinuz-3.11.0-26-generic then you would need
>> > > "vmlinuz-3.11.0-26-generic" for this to work?
>> >
>> > Yeah, looking for well known pathnames to then check if the build-id
>> > matches the one we're looking for, be it because we obtained it from
>> > /sys/kernel/notes (for the running kernel), or from the perf.data file
>> > build-id table is ok, as we don't know where it is.
>> >
>> > Plain sticking "vmlinux" there is not.
>>
>> I don't get it.  AFAIK when perf record runs, it uses [kernel.kallsyms]
>> name for kernel map.  But it can be changed only if it found a "vmlinux"
>> file in the vmlinux_path[].  So short name will always be "vmlinux" -
>> okay, it might be vmlinux-$(uname -r) too; I can add it.
>>
>> As you know, the vmlinux file is a ELF image that created during kernel
>> build process so I guess its name is fixed.  It's different from the
>> vmlinu"z" which resides in /boot directory.
>>
>> Am I missing something?
>
> [acme@zoo linux]$ perf report --help 2>&1 | grep vmlin
>        -k, --vmlinux=<file>
>            vmlinux pathname
> [acme@zoo linux]$
>
> Yes, it is using [kernel.kallsyms].ref_reloc_sym for the synthesized
> KERNEL mmap event, but it stores the full path in the build-id table.
>
> It seems we need a way to state that an entry in the build-id table is
> for the kernel, without looking at its file name. That or to put the
> build-id into the synthesized kernel mmap event. Which is better,
> because:
>
Can't you figure out it is from the kernel (in perf record) by remembering
you got the buildid from /sys/kernel/notes?


> That leads to another problem that needs to get solved eventually: We
> need to have the build-id into PERF_RECORD_MMAP, because we're now using
> just the mmap filename as the key, not the contents, and for long
> running sessions, DSOs can get updated, etc.
>
> - Arnaldo
