Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbaHSCwz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 22:52:55 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:60303 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbaHSCwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 22:52:53 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Static build of libtraceevent failing on ubuntu13 x86_64
References: <20140813225438.GM2718@kernel.org>
Date: Tue, 19 Aug 2014 11:52:51 +0900
In-Reply-To: <20140813225438.GM2718@kernel.org> (Arnaldo Carvalho de Melo's
	message of "Wed, 13 Aug 2014 19:54:38 -0300")
Message-ID: <87ppfxchrw.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

On Wed, 13 Aug 2014 19:54:38 -0300, Arnaldo Carvalho de Melo wrote:
> Hi guys,
>
> 	Have you ever stumbled on this?
>
> 	It is the only target breaking when I do a test build of perf + libtraceevent
> on several distros/arches, the command is:
>
> $ make -C tools/perf build-test
>
> Distro is ubuntu12
>
> acme@ubuntu13:~/git/linux$ cat /etc/debian_version 
> wheezy/sid
> acme@ubuntu13:~/git/linux$ uname -a
> Linux ubuntu13 3.11.0-26-generic #45-Ubuntu SMP Tue Jul 15 04:02:06 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux
>
> - Arnaldo
>
> - make_static: cd . && make -f Makefile DESTDIR=/tmp/tmp.18qUa2nzwd LDFLAGS=-static
> cd . && make -f Makefile DESTDIR=/tmp/tmp.18qUa2nzwd LDFLAGS=-static
[SNIP]
>   LINK     perf
> /home/acme/git/linux/tools/lib/traceevent/libtraceevent.a(event-plugin.o): In function `load_plugin':
> /home/acme/git/linux/tools/lib/traceevent/event-plugin.c:256: warning: Using 'dlopen' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking

Hmm.. this one is actually related to the libtraceevent.  It seems glibc
(and libdl) emits warnings if a static build try to link to the libdl
functions (for obvious reason) and/or nss functions (which might use
libdl).

I found this article [1] but couldn't find how can suppress them.  But
as it's for loading plugins at runtime, we can disable the plugin
support for static builds if we really nervous about the warnings.


[1] http://www.airs.com/blog/archives/54



> /usr/lib/gcc/x86_64-linux-gnu/4.8/../../../x86_64-linux-gnu/libaudit.a(libaudit.o): In function `audit_rule_fieldpair_data':
> (.text+0x191b): warning: Using 'getgrnam' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
> /usr/lib/gcc/x86_64-linux-gnu/4.8/../../../x86_64-linux-gnu/libaudit.a(libaudit.o): In function `audit_rule_fieldpair_data':
> (.text+0x1978): warning: Using 'getpwnam' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
> libperf.a(target.o): In function `target__parse_uid':
> /home/acme/git/linux/tools/perf/util/target.c:79: warning: Using 'getpwnam_r' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
> /home/acme/git/linux/tools/perf/util/target.c:91: warning: Using 'getpwuid_r' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
> /usr/lib/gcc/x86_64-linux-gnu/4.8/../../../../lib/libnuma.a(affinity.o): In function `affinity_ip':
> (.text+0x765): warning: Using 'getaddrinfo' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking

Likewise.


> /usr/lib/gcc/x86_64-linux-gnu/4.8/../../../../lib/libbfd.a(compress.o): In function `bfd_compress_section_contents':
> /build/buildd/binutils-2.23.52.20130913/builddir-single/bfd/../../bfd/compress.c:100: undefined reference to `compressBound'
> /build/buildd/binutils-2.23.52.20130913/builddir-single/bfd/../../bfd/compress.c:106: undefined reference to `compress'
> /usr/lib/gcc/x86_64-linux-gnu/4.8/../../../../lib/libbfd.a(compress.o): In function `decompress_contents':
> /build/buildd/binutils-2.23.52.20130913/builddir-single/bfd/../../bfd/compress.c:49: undefined reference to `inflateInit_'
> /build/buildd/binutils-2.23.52.20130913/builddir-single/bfd/../../bfd/compress.c:56: undefined reference to `inflate'
> /build/buildd/binutils-2.23.52.20130913/builddir-single/bfd/../../bfd/compress.c:59: undefined reference to `inflateReset'
> /build/buildd/binutils-2.23.52.20130913/builddir-single/bfd/../../bfd/compress.c:61: undefined reference to `inflateEnd'

This one is different and seems like linking with libbfd but without zlib?

Thanks,
Namhyung


> collect2: error: ld returned 1 exit status
> make[3]: *** [perf] Error 1
> make[2]: *** [all] Error 2
>   test: test -x ./perf
> make[1]: *** [make_static] Error 1
> make: *** [build-test] Error 2
> make: Leaving directory `/home/acme/git/linux/tools/perf'
>
> real	14m52.077s
> user	39m36.668s
> sys	6m27.970s
> acme@ubuntu13:~/git/linux$ 
