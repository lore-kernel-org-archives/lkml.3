Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937Ab3IYPip (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 11:38:45 -0400
Received: from mail-yh0-f54.google.com ([209.85.213.54]:59387 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827Ab3IYPio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 11:38:44 -0400
Date: Wed, 25 Sep 2013 12:38:38 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH -tip ] [BUGFIX] perf probe: Fix to probe on symbols with
 optimization suffix
Message-ID: <20130925153838.GE2634@ghostprotocols.net>
References: <20130925131616.31632.46658.stgit@udc4-manage.rcp.hitachi.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130925131616.31632.46658.stgit@udc4-manage.rcp.hitachi.co.jp>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Sep 25, 2013 at 10:16:16PM +0900, Masami Hiramatsu escreveu:
> Fix perf probe to probe on some symbols which have some
> optimzation suffixes, e.g. ".part", ".isra", and ".constprop".
> To fix this issue, instead of using DIE name, perf probe
> uses symbol name found by dwfl_module_addrsym().

Thanks Masami! Now it behaves _exactly_ as I expected and need:

[root@zoo linux]# perf probe -L getname_flags:65
<getname_flags@/home/git/linux/fs/namei.c:65>
     65         result->uptr = filename;
     66         audit_getname(result);
                return result;
         
         error:
     70         final_putname(result);
     71         return err;
     72  }
         
         struct filename *
         getname(const char __user * filename)

[root@zoo linux]# perf probe -V getname_flags:65
Available variables at getname_flags:65
        @<getname_flags.part.35+178>
                char*   filename
                int*    empty
                long int        max
                struct filename*        result
[root@zoo linux]# perf probe 'getname_flags:66 pathname=result->name:string'
Added new event:
  probe:getname_flags  (on getname_flags:66 with pathname=result->name:string)

You can now use it in all perf tools, such as:

	perf record -e probe:getname_flags -aR sleep 1

[root@zoo linux]# perf record -a -e probe:getname_flags
^C[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 1.252 MB perf.data (~54692 samples) ]
[root@zoo linux]# perf script | grep -v '# | head -5
> ^C
[root@zoo linux]# perf script | grep -v '^#' | head -5
        libvirtd  1163 [001] 100606.469450: probe:getname_flags: (ffffffff811a2f89) pathname="/proc/cpuinfo"
        libvirtd  1163 [001] 100606.469563: probe:getname_flags: (ffffffff811a2f89) pathname="/sys/devices/system/node"
        libvirtd  1163 [001] 100606.469596: probe:getname_flags: (ffffffff811a2f89) pathname="/sys/devices/system/node/node0"
        libvirtd  1163 [001] 100606.469612: probe:getname_flags: (ffffffff811a2f89) pathname="/sys/devices/system/node/node0/cpu0/online"
        libvirtd  1163 [001] 100606.469628: probe:getname_flags: (ffffffff811a2f89) pathname="/sys/devices/system/node/node0/cpu0/topology/physical_package_id"
[root@zoo linux]#

Thanks a lot, applied to my perf/urgent branch,

- Arnaldo
