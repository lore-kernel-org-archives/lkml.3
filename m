Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368AbaBMQ0i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 11:26:38 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:44817 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbaBMQ0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 11:26:32 -0500
MIME-Version: 1.0
In-Reply-To: <52FC12E3.9060300@lge.com>
References: <CABPqkBSzttXoe3f_jC=Fv+ieN7_TNxLMDs4CH1C0TLYRq+Oz7g@mail.gmail.com>
	<52FC12E3.9060300@lge.com>
Date: Thu, 13 Feb 2014 17:26:30 +0100
Message-ID: <CABPqkBRMZV_5XH0C5EDD547XcFy=qbREwx8ZA+KWVQxK0nrnug@mail.gmail.com>
Subject: Re: [BUG] perf report/annotate: consuming too many file descriptors
From: Stephane Eranian <eranian@google.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Your patch does solve the file consumption problem on my test case.
We still open and do the ELF read 5 times.

Now, if on top of your patch, we also add the following, we save one
open().

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 4045d08..87a0ecb 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -45,7 +45,7 @@ int dso__read_binary_type_filename(const struct dso *dso,
  debuglink--;
  if (*debuglink == '/')
  debuglink++;
- filename__read_debuglink(dso->long_name, debuglink,
+ ret = filename__read_debuglink(dso->long_name, debuglink,
  size - (debuglink - filename));
  }
  break;

On Thu, Feb 13, 2014 at 1:33 AM, Namhyung Kim <namhyung.kim@lge.com> wrote:
> Hi Stephane,
>
> (I'd be better if you use my korg address).
>
>
> 2014-02-12 PM 11:32, Stephane Eranian wrote:
>>
>> Hi,
>>
>>
>> I was testing 3.14-rc2 (tip.git) perf and ran into a serious problem
>> with report/annotate on a collection with lots of shared libraries (500).
>>
>> Perf ran out of file descriptors (ulimit set to 1024). It did not print
>> an error message, but simply refused to proceed to objdump.
>>
>> I ran strace and discovered it was running out of descriptors to
>> my big surprise! I narrowed it down with strace -etrace=open.
>> I saw an appalling result.
>>
>> My .so files were opened at least 4 times each, each
>> allocated an fd that was kept open, each open incur a read of the ELF
>> headers. So each dso was consuming 4 fd.
>>
>> Why?
>>
>> Because of what's going on in dso__load() when perf iterates
>> over the binary_type_symtab[]. It tries a bunch of types. For
>> each match, symsrc_init() is invoked to read the ELF image.
>> The fd opened there is kept open (for later loading).
>>
>> The first problem is why is dso__read_binary_type_filename()
>> blindly returning success on many types. For my files, I got matches
>> on DEBUGLINK, SYSTEM_DSO_PATH, GUEST_KMODULE,
>> SYSTEM_PATH_KMODULE.
>>
>> I have a tendency to believe that the dso__read_binary_type_filename()
>> meaning has been abused to stash things that do not really
>> belong there.
>>
>> Furthermore, I believe many of the type matches do NOT need an ELF
>> read and certainly not one that keeps a descriptor opened.
>>
>> This problem is not just about consuming too many fd, it is also about
>> execution overhead. Why read the ELF headers 4 times?
>>
>> The current situation makes reporting on large collection impossible for
>> regular users. I don't quite know how to best address this issue. One way
>> I found would be for  dso__read_binary_type_filename() to return a value
>> meaning success but no ELF read. Not sure would be correct, though.
>
>
> It looks like a case of stripped binary or static build.  dso__load() looked
> for both of symtab and dynsym, but it failed.  So it iterated through the
> binary types and continued to fail with fd open. :(
>
> I think we should close/destroy the duplicate symsrcs.  Does attached patch
> fix your problem?
>
> Thanks,
> Namhyung
>
