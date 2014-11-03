Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744AbaKCQTN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 11:19:13 -0500
Received: from mail.kernel.org ([198.145.19.201]:40529 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036AbaKCQTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 11:19:08 -0500
Date: Mon, 3 Nov 2014 14:19:00 -0200
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: srikar@linux.vnet.ibm.com, Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Brendan Gregg <brendan.gregg@gmail.com>, yrl.pp-manager.tt@hitachi.com,
        namhyung@kernel.org, Hemant Kumar <hemant@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: Re: [PATCH perf/core 0/6] perf-probe: Bugfix and add new options
 for cache
Message-ID: <20141103161900.GA18464@kernel.org>
References: <20141031185128.27889.32747.stgit@localhost.localdomain>
 <20141031121301.GI1313@kernel.org>
 <545770E6.2010506@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <545770E6.2010506@hitachi.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Nov 03, 2014 at 09:11:18PM +0900, Masami Hiramatsu escreveu:
> (2014/10/31 21:13), Arnaldo Carvalho de Melo wrote:
> > Em Fri, Oct 31, 2014 at 02:51:29PM -0400, Masami Hiramatsu escreveu:
> >>   p:probe/reset_early_page_tables _text+12980741
> >>   p:probe/copy_bootdata _text+12980830 real_mode_data=%di:u64
> >>   p:probe/exit_amd_microcode _text+14692680
> >>   p:probe/early_make_pgtable _text+12981274 address=%di:u64
> >>   p:probe/x86_64_start_reservations _text+12981700 real_mode_data=%di:u64
> >>   p:probe/x86_64_start_kernel _text+12981744 real_mode_data=%di:u64
> >>   p:probe/reserve_ebda_region _text+12982117

> >> This event.cache file will be big (but much smaller than native
> >> debuginfo :) ) if your kernel have many option embedded.
> >> Anyway, you can compress it too.

> > How do you validate that the cache can be used against some kernel? I.e.
> > is this that the user has to do? Isn't this prone to errors?

> Actually, kprobe event itself can reject command if the given address
> is not in the kernel text nor instruction boundary (perhaps, uprobes
> may have a problem...), so for the kernel level, it is safe.

No, it is not necessarily safe.

What if you specify function foo() that has address 0x1234 for kernel
v3.16 and then run the cached probe on kernel v3.18 and on that kernel
the function foo() maps to address 0x2345 and function bar() instead
maps to address 0x1234? Oops.

The build-id was designed to uniquely identify a DSO, we need to use it.

I think that at some point not using it should be left to a, in
systemtap parlance, "guru" mode, with tooling warning profusely when
build ids are not available and requiring even more forcing when it
doesn't matches.
 
> > Perhaps you could pick the build-id and store it into the event cache
> > file, in the first lines, somethings like:
 
> Agreed, build-id should be the best way to check that.
 
> For kprobes, user can easy to get and compare it with local one as below :)
>   ----
>   RLOGIN=root@$REMOTE
>   rid=`ssh $RLOGIN "od -j16 -w48 -An -t x1 /sys/kernel/notes |  tr -d ' '"`
>   lid=`od -j16 -w48 -An -t x1 /sys/kernel/notes | tr -d ' '`
>   if [ $rid != $lid ]; then
>     echo "Error: Build-id mis-matched!"
>     exit 1;
>   fi
>   echo "Setting up $EVENTNAME at $REMOTE"
>   zcat event.cache.gz | grep $EVENTNAME |\
>   ssh $RLOGIN "tee -a /sys/kernel/debug/tracing/kprobe_events"
>   echo "Done"
>   ----
 
> With this script, you don't need to install perf at remote hosts.
> (This is what enterprise people called "agent-less")

This is only sufficient (and a cool feature!) if you will immediataly use the
cached info (i.e. using just two systems: one development machine, with all
debugging info, devel tools, etc, and the other the machine to observe, that is
bare bones, no debugging info, etc)), but the moment you store that
event.cache.gz (that has no build id embedded from what I can see from the
above example) then you lose the build id for those cached events.

You need to tightly associate whatever symbol resolution is done with
the build id, at symbol resolution/caching time.

Then, before using the cached symbol resolution, we need to check if the target
kernel/DSO build id is the same as the cached symbol kernel/DSO build id.
 
> > [acme@zoo ~]$ printf "buildid: %s\n" $(perf buildid-list --kernel) 
> > buildid: a4cacca49391fc4f42ac8f58990f4e97042efae8

> > [acme@zoo ~]$ printf "buildid: %s\n" $(perf buildid-list --kernel) 
> > buildid: a4cacca49391fc4f42ac8f58990f4e97042efae8

> > Maybe this would be nice to have integrated with 'perf archive' somehow
> > and then store this into ~/.debug/[probe]/<BUILDID>/dso-name

> > where dso-name would be [kernel] for the kernel and the full path for
> > userspace stuff, and then when adding a new probe we would look there
> > for a pre-built/cached event definition, only looking for the debuginfo
> > (which is done using the build-id already, right) and would insert the
> > probe definitions there, etc.
 
> This will be good for SDT too. Perhaps, both of SDT and cached probes
> should share the same file.

Right, what is in ~/.debug/ may be used by multiple tools, just like
debuginfo files are, by keying the content by its build id.

And also by having separate subdirectory trees for different kinds of
symbol information, i.e. the ~/.debug/.build-id/ links may point to
either ELF files or to kallsyms data. What we are discussing here is to
make it also point to the [ku]probes_tracer cached probes files.

The way that DSO files are cached may by the same that you end up adding
the [ku]probes_tracer cached files, take a look at the example of
caching for the '/usr/bin/gcc' DSO on a test maachine here at my home
lab:
 
[root@zoo ~]# ls -la ~/.debug/usr/bin/gcc/
total 2268
drwxr-xr-x.  2 root root   4096 Oct 15 16:54 .
drwxr-xr-x. 53 root root   4096 Oct 21 18:06 ..
-rwxr-xr-x.  1 root root 768576 Jun 24 14:08 07f4c7f58a6e7ce9177d45f71d9698e906168096
-rwxr-xr-x.  3 root root 772672 Sep 11 08:24 4f80f5b2caaa5bf4f7e46b593934399e2ce56702
-rwxr-xr-x.  1 root root 768560 Dec 12  2013 f2466d61bedca2ae3d4ebbaded2bc4e8e5fe95a8
[root@zoo ~]

For each DSO we have a directory where each different binary that ever lived in
this machine with the name '/usr/bin/gcc' will have one file, the name being each
build id:

[root@zoo ~]# ~/.debug/usr/bin/gcc/07f4c7f58a6e7ce9177d45f71d9698e906168096 --version | head -1
07f4c7f58a6e7ce9177d45f71d9698e906168096 (GCC) 4.8.3 20140624 (Red Hat 4.8.3-1)
[root@zoo ~]# ~/.debug/usr/bin/gcc/4f80f5b2caaa5bf4f7e46b593934399e2ce56702 --version | head -1
4f80f5b2caaa5bf4f7e46b593934399e2ce56702 (GCC) 4.8.3 20140911 (Red Hat 4.8.3-7)
[root@zoo ~]# ~/.debug/usr/bin/gcc/f2466d61bedca2ae3d4ebbaded2bc4e8e5fe95a8 --version | head -1
f2466d61bedca2ae3d4ebbaded2bc4e8e5fe95a8 (GCC) 4.8.2 20131212 (Red Hat 4.8.2-7)
[root@zoo ~]# [root@zoo ~]

Then, on the ~/.debug/.build-id/ hierarchy, sorted by build-id we have:

[root@zoo ~]# ls -la ~/.debug/.build-id/07/f4c7f58a6e7ce9177d45f71d9698e906168096 
lrwxrwxrwx. 1 root root 58 Jul 24 16:48 /root/.debug/.build-id/07/f4c7f58a6e7ce9177d45f71d9698e906168096 -> ../../usr/bin/gcc/07f4c7f58a6e7ce9177d45f71d9698e906168096
[root@zoo ~]# ls -la ~/.debug/.build-id/4f/80f5b2caaa5bf4f7e46b593934399e2ce56702 
lrwxrwxrwx. 1 root root 58 Oct 15 16:54 /root/.debug/.build-id/4f/80f5b2caaa5bf4f7e46b593934399e2ce56702 -> ../../usr/bin/gcc/4f80f5b2caaa5bf4f7e46b593934399e2ce56702
[root@zoo ~]# ls -la ~/.debug/.build-id/f2/466d61bedca2ae3d4ebbaded2bc4e8e5fe95a8 
lrwxrwxrwx. 1 root root 58 Jun  2 12:29 /root/.debug/.build-id/f2/466d61bedca2ae3d4ebbaded2bc4e8e5fe95a8 -> ../../usr/bin/gcc/f2466d61bedca2ae3d4ebbaded2bc4e8e5fe95a8
[root@zoo ~]#

This solves the problem with debuginfo packages where we can't have multiple
debuginfo packages installed, as well as for files that didn't came from
debuginfo files.

[root@zoo ~]# perf buildid-cache --hell
  Error: unknown option `hell'

 usage: perf buildid-cache [<options>]

    -a, --add <file list>
                          file(s) to add
    -k, --kcore <file>    kcore file to add
    -r, --remove <file list>
                          file(s) to remove
    -M, --missing <file>  to find missing build ids in the cache
    -f, --force           don't complain, do it
    -u, --update <file list>
                          file(s) to update
    -v, --verbose         be more verbose

[root@zoo ~]#

Already has support for yet another of content: kcore files, its just a matter of adding
one more:

   perf buildid-cache --probe 

:-)

> > Then, later, one would use 'perf archive' passing some keys (or a
> > perf.data file, like done nowadays to pick the files in ~/.debug for
> > dsos that had hits on the specified perf.data file) to get the cached
> > values to use on some other machine, to avoid having to use the
> > debuginfo files there.
 
> Yeah, querying it from the BUILDID database by using a pair of remote
> build-id and the binary path is a good feature.
 
> > I.e. in summary I think that the format is ok, but we need to have this
> > inside the ~/.debug hierarchy so that we can make sure that we use the
> > right probe definition, one that matches the DSOs being used (the kernel
> > or some other userspace binary).

> OK, perhaps, that is also good to SDT series at last.

Sure thing!

- Arnaldo
