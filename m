Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966253AbaFTSaf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 14:30:35 -0400
Received: from mail.kernel.org ([198.145.19.201]:49779 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966118AbaFTSae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 14:30:34 -0400
Date: Fri, 20 Jun 2014 15:30:28 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, Ingo Molnar <mingo@kernel.org>,
        dsahern@gmail.com, jolsa@redhat.com, xiaoguangrong@linux.vnet.ibm.com,
        yangds.fnst@cn.fujitsu.com, adrian.hunter@intel.com,
        namhyung@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/7] perf trace pagefaults
Message-ID: <20140620183028.GK31524@kernel.org>
References: <1403261389-13423-1-git-send-email-stfomichev@yandex-team.ru>
 <20140620132105.GE31524@kernel.org>
 <20140620150318.GK15620@stfomichev-desktop.yandex.net>
 <20140620152449.GH31524@kernel.org>
 <20140620161859.GN15620@stfomichev-desktop.yandex.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140620161859.GN15620@stfomichev-desktop.yandex.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jun 20, 2014 at 08:18:59PM +0400, Stanislav Fomichev escreveu:
> > Hey, haven't you seen the vfs_getname probe? Idea is to hook on where
> > the relevant copy_from_user is done and insert that into the ring
> > buffer, as we already do for mapping fd -> pathname.

> I saw it but didn't actually try because it needs all the debugging
> stuff enabled and in place.

Touché, more on that below...
 
> > I.e. no need for actual tracepoints from day one, just wannabe
> > tracepoints using whatever probe inserting gizmo the kprobes_tracer used
> > by 'perf probe' now thinks its best to use.

> But we then need to predefine many probes for decoding to work in the form of
> func:offset, and then play catch-up with all the kernel changes.
> Or I miss something important here?

No you don't.

If we want to disturb the system in the least way possible, we need to
tag along the copying from userspace of those pointers, so that we get
them fresh and just stash it in our ring buffer and get out of the way
quickly.
 
> > For now try:
> > 
> >   perf probe 'vfs_getname=getname_flags:65 pathname=result->name:string'
> >   trace
> > 
> > And look at how it manages to decode fds.

> I will try, but does 65 still work after c4ad8f98bef77c7356aa6a9ad9188a6acc6b849d? :-)

Well, when I prototyped this[1] the idea is that in some areas, there is
not that much code flux that before commiting to any kind of new
interface, be it tracepoints or something else, we may well just use
'perf probe' to get what we need, and this was done in...

  commit 75b757ca90469e990e6901f4a9497fe4161f7f5a
  Author: Arnaldo Carvalho de Melo <acme@redhat.com>
  Date:   Tue Sep 24 11:04:32 2013 -0300

Almost a year ago, and it still works, now lets see the cset you mention...

[acme@zoo linux]$ git describe c4ad8f98bef77c7356aa6a9ad9188a6acc6b849d
v3.14-rc1-14-gc4ad8f98bef7
[acme@zoo linux]$
[root@zoo ~]# uname -r
3.15.0-rc8+

Humm, what is the problem?

[root@zoo ~]# perf probe -V getname_flags:65
Available variables at getname_flags:65
        @<getname_flags+227>
                char*   filename
                int     len
                int*    empty
                long int        max
                struct filename*        result
[root@zoo ~]#
[root@zoo ~]# perf probe 'vfs_getname=getname_flags:65 pathname=result->name:string'
Added new event:
  probe:vfs_getname    (on getname_flags:65 with pathname=result->name:string)

You can now use it in all perf tools, such as:

	perf record -e probe:vfs_getname -aR sleep 1

[root@zoo ~]# perf record -e probe:vfs_getname -aR sleep 1
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 1.133 MB perf.data (~49505 samples) ]
[root@zoo ~]# perf evlist
probe:vfs_getname
[root@zoo ~]# perf evlist -v
probe:vfs_getname: sample_freq=1, type: 2, config: 1317, size: 96, sample_type: IP|TID|TIME|CPU|PERIOD|RAW, disabled: 1, inherit: 1, mmap: 1, comm: 1, sample_id_all: 1, exclude_guest: 1
[root@zoo ~]# perf script 
            perf 11255 [003] 156054.623210: probe:vfs_getname: (ffffffff811c2e43) pathname="/home/acme/libexec/perf-core/sleep"
            perf 11255 [003] 156054.624759: probe:vfs_getname: (ffffffff811c2e43) pathname="/usr/lib64/qt-3.3/bin/sleep"
            perf 11255 [003] 156054.624782: probe:vfs_getname: (ffffffff811c2e43) pathname="/usr/lib64/ccache/sleep"
            perf 11255 [003] 156054.624794: probe:vfs_getname: (ffffffff811c2e43) pathname="/usr/local/sbin/sleep"
            perf 11255 [003] 156054.624809: probe:vfs_getname: (ffffffff811c2e43) pathname="/usr/local/bin/sleep"
            perf 11255 [003] 156054.624818: probe:vfs_getname: (ffffffff811c2e43) pathname="/sbin/sleep"
            perf 11255 [003] 156054.625017: probe:vfs_getname: (ffffffff811c2e43) pathname="/bin/sleep"
           sleep 11255 [002] 156054.626093: probe:vfs_getname: (ffffffff811c2e43) pathname="/etc/ld.so.preload"
           sleep 11255 [002] 156054.626114: probe:vfs_getname: (ffffffff811c2e43) pathname="/etc/ld.so.cache"
           sleep 11255 [002] 156054.626159: probe:vfs_getname: (ffffffff811c2e43) pathname="/lib64/libc.so.6"
           sleep 11255 [002] 156054.626751: probe:vfs_getname: (ffffffff811c2e43) pathname="/usr/lib/locale/locale-archive"
      goa-daemon  2082 [003] 156054.955138: probe:vfs_getname: (ffffffff811c2e43) pathname="/etc/localtime"
      goa-daemon  2082 [003] 156054.955573: probe:vfs_getname: (ffffffff811c2e43) pathname="/etc/localtime"
[root@zoo ~]# 

Best possible way to do this? Guess not, but I'm looking from a tooling
perspective, i.e. about using what is available, not about adding requirements
to the kernel or toolchain, that we can do after we prototype in the best way
possible with existing facilities.

- Arnaldo

[1] And I feel like all of tools/perf/ is just that, reference implementations, but hopefully
    done in a such a way that may well be useful as-is :-)
