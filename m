Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031AbaHOBH0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 21:07:26 -0400
Received: from mail.kernel.org ([198.145.19.201]:48499 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449AbaHOBHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 21:07:25 -0400
Date: Thu, 14 Aug 2014 22:07:16 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Brendan Gregg <brendan.d.gregg@gmail.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@gmail.com>, yrl.pp-manager.tt@hitachi.com,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH] perf probe: Warn user to rebuild target with debuginfo
Message-ID: <20140815010716.GA3148@kernel.org>
References: <53ECF7E9.3050200@hitachi.com>
 <20140814182938.13429.90615.stgit@kbuild-fedora.novalocal>
 <CAE40pdd_Fy-x5VuhAt46YWSAWmd3z6C5A3DeB6AjBQF4YDZKXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE40pdd_Fy-x5VuhAt46YWSAWmd3z6C5A3DeB6AjBQF4YDZKXw@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Aug 14, 2014 at 01:07:28PM -0700, Brendan Gregg escreveu:
> On Thu, Aug 14, 2014 at 11:29 AM, Masami Hiramatsu
> <masami.hiramatsu.pt@hitachi.com> wrote:
> [...]
> > The "rebuild with ..." part changes to "rebuild with CONFIG_DEBUG_INFO"
> > if the target is the kernel or a kernel module.
 
> Thanks, definitely an improvement! Should the kernel message also
> mention kernel debuginfo packages? Depends on the distribution and
> environment, but I think for some users the solution is to add the
> package.

Yeah, something like what is suggested by gdb and documented here:

https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Developer_Guide/intro.debuginfo.html

--------------------------------------------------------------------
In some cases (such as loading a core file), GDB does not know the
name, version, or release of a name-debuginfo-version-release.rpm
package; it only knows the build-id. In such cases, GDB suggests a
different command:

gdb -c ./core
[...]
Missing separate debuginfo for the main executable filename
Try: yum --disablerepo='*' --enablerepo='*debug*' install /usr/lib/debug/.build-id/ef/dd0b5e69b0742fa5e5bad0771df4d1df2459d1
---------------------------------------------------------------------

This is something I want to have eventually, i.e. to have per distro
plugins to automatically download packages required for some features,
like probing and annotation, for instance.

E.g:

[acme@zoo ~]$ perf record usleep 1 
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.014 MB perf.data (~615 samples) ]
[acme@zoo ~]$ perf buildid-list
34412145145a7561db0d0063a925c17d9af67a1f [kernel.kallsyms]
efc76c94d401b3b7f0f8ecb893c829d82f10e4b2 /usr/lib64/libc-2.18.so
[acme@zoo ~]$ sudo yum --disablerepo='*' --enablerepo='*debug*' install /usr/lib/debug/.build-id/34/412145145a7561db0d0063a925c17d9af67a1f
Loaded plugins: auto-update-debuginfo, langpacks, refresh-packagekit
Resolving Dependencies
--> Running transaction check
---> Package kernel-debuginfo.x86_64 0:3.15.8-200.fc20 will be installed
--> Processing Dependency: kernel-debuginfo-common-x86_64 =
3.15.8-200.fc20 for package: kernel-debuginfo-3.15.8-200.fc20.x86_64
--> Running transaction check
---> Package kernel-debuginfo-common-x86_64.x86_64 0:3.15.8-200.fc20
will be installed
--> Finished Dependency Resolution

Dependencies Resolved
<SNIP>

- Arnaldo
