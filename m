Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143Ab3LIDgZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 22:36:25 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:42005 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760259Ab3LIDgU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 22:36:20 -0500
MIME-Version: 1.0
Date: Sun, 8 Dec 2013 19:36:18 -0800
Message-ID: <CAMEtUuwGyDfYT-twem4z_sAaG1DeUp7ams69dQKyxkdBfSsC7Q@mail.gmail.com>
Subject: binary blob no more! Was: [RFC PATCH tip 0/5] tracing filters with BPF
From: Alexei Starovoitov <ast@plumgrid.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>, Pekka Enberg <penberg@iki.fi>,
        "David S. Miller" <davem@davemloft.net>,
        Arjan van de Ven <arjan@infradead.org>,
        Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 5, 2013 at 9:43 PM, Alexei Starovoitov <ast@plumgrid.com> wrote:
> On Thu, Dec 5, 2013 at 2:38 AM, Ingo Molnar <mingo@kernel.org> wrote:
>>
>>> Also I'm thinking to add 'license_string' section to bpf binary format
>>> and call license_is_gpl_compatible() on it during load.
>>> If false, then just reject it…. not even messing with taint flags...
>>> That would be way stronger indication of bpf licensing terms than what
>>> we have for .ko
>>
>> But will BFP tools generate such gpl-compatible license tags by
>> default? If yes then this might work, combined with the facility
>> below. If not then it's just a nuisance to users.
>
> yes. similar to existing .ko module_license() tag. see below.
>
>> My concern would be solved by adding a facility to always be able to
>> dump source code as well, i.e. trivially transform it to C or so, so
>> that people can review it - or just edit it on the fly, recompile and
>> reinsert? Most BFP scripts ought to be pretty simple.
>
> C code has '#include' in them, so without storing fully preprocessed code
> it will not be equivalent. but then true source will be gigantic.
> Can be zipped, but that sounds like an overkill.
> Also we might want other languages with their own dependent includes.
> Sure, we can have a section in bpf binary that has the source, but it's not
> enforceable. Kernel cannot know that it's an actual source.
> gcc/llvm will produce different bpf code out of the same source.
> the source is in C or in language X, etc.
> Doesn't seem that including some form of source will help
> with enforcing the license.
>
> imo requiring module_license("gpl"); line in C code and equivalent
> string in all other languages that want to translate to bpf would be
> stronger indication of licensing terms.
> then compiler would have to include that string into 'license_string'
> section and kernel can actually enforce it.

Actually I think there are few ways to include the source equivalent
in bpf image.

Approach #1
include original C source code into bpf image:
  bpf_image = bpf_insns + original_C
this will imply that C code can have #include's of linux kernel headers only
and it can only be C source.
this way the user can do 'cat /sys/kernel/debug/bpf/filter', kernel
will print original_C and these restrictions will guarantee that it
will compile into similar bpf code whether gcc or llvm compiler is
used.

Approach #2
include original llvm bitcode:
  bpf_image = bpf_insns + llvm_bc
The user can do 'cat .../filter' and use llvm-dis to see human readable bitcode.
It takes practice to read it, but it's high level enough to understand
what filter is doing. llvm-llc can be used to generate bpf_insns
again, or generate C from bitcode.
Pro vs 1: bitcode is very compact
Con: only llvm compiler can used to generate bpf instructions

Enforcement can be done by having a user space daemon that
walks over all loaded filters and recompiles them from C or from bitcode.

Please let me know which approach you prefer.

I still think that bpf_image = bpf_insns + license_string is just as good,
since bpf code can only call tiny set of functions, so no matter what
the code does its scope is very limited and license enforcement
guarantees that original source has to be available,
but I'm ok whichever way.

Also please indicate whether gcc or llvm backend is preferred to
be hosted in tools.

Build of gcc backend is slow (takes ~100 sec), since front-end,
optimizer and backend are single binary of ~13M.
It doesn't need any other files to compile filter.c into bpf_image

Build of llvm backend ('llc') takes ~10 sec, since it has to compile only
bpf backend files. But it would need clang package to translate C into
llvm bitcode and 'llc' (single 8M binary) to compile bitcode into
bpf_image.

Thanks
Alexei
