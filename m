Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561Ab3I0G4I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 02:56:08 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:56682 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869Ab3I0G4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 02:56:05 -0400
Message-ID: <52452C00.1000505@hitachi.com>
Date: Fri, 27 Sep 2013 15:56:00 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH -tip ] [BUGFIX] perf probe: Fix to probe on symbols with
 optimization suffix
References: <20130925131616.31632.46658.stgit@udc4-manage.rcp.hitachi.co.jp> <20130925153838.GE2634@ghostprotocols.net>
In-Reply-To: <20130925153838.GE2634@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

BTW, I also found another issue which the perf probe -l showed
incorrect line number and file name for probes on such inline
functions. :(
I found the root causes (the line info is not correct and
perf probe failed to handle nested inline functions). I'll send
the bugfix patch soon.

Thank you,

(2013/09/26 0:38), Arnaldo Carvalho de Melo wrote:
> Em Wed, Sep 25, 2013 at 10:16:16PM +0900, Masami Hiramatsu escreveu:
>> Fix perf probe to probe on some symbols which have some
>> optimzation suffixes, e.g. ".part", ".isra", and ".constprop".
>> To fix this issue, instead of using DIE name, perf probe
>> uses symbol name found by dwfl_module_addrsym().
> 
> Thanks Masami! Now it behaves _exactly_ as I expected and need:
> 
> [root@zoo linux]# perf probe -L getname_flags:65
> <getname_flags@/home/git/linux/fs/namei.c:65>
>      65         result->uptr = filename;
>      66         audit_getname(result);
>                 return result;
>          
>          error:
>      70         final_putname(result);
>      71         return err;
>      72  }
>          
>          struct filename *
>          getname(const char __user * filename)
> 
> [root@zoo linux]# perf probe -V getname_flags:65
> Available variables at getname_flags:65
>         @<getname_flags.part.35+178>
>                 char*   filename
>                 int*    empty
>                 long int        max
>                 struct filename*        result
> [root@zoo linux]# perf probe 'getname_flags:66 pathname=result->name:string'
> Added new event:
>   probe:getname_flags  (on getname_flags:66 with pathname=result->name:string)
> 
> You can now use it in all perf tools, such as:
> 
> 	perf record -e probe:getname_flags -aR sleep 1
> 
> [root@zoo linux]# perf record -a -e probe:getname_flags
> ^C[ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 1.252 MB perf.data (~54692 samples) ]
> [root@zoo linux]# perf script | grep -v '# | head -5
>> ^C
> [root@zoo linux]# perf script | grep -v '^#' | head -5
>         libvirtd  1163 [001] 100606.469450: probe:getname_flags: (ffffffff811a2f89) pathname="/proc/cpuinfo"
>         libvirtd  1163 [001] 100606.469563: probe:getname_flags: (ffffffff811a2f89) pathname="/sys/devices/system/node"
>         libvirtd  1163 [001] 100606.469596: probe:getname_flags: (ffffffff811a2f89) pathname="/sys/devices/system/node/node0"
>         libvirtd  1163 [001] 100606.469612: probe:getname_flags: (ffffffff811a2f89) pathname="/sys/devices/system/node/node0/cpu0/online"
>         libvirtd  1163 [001] 100606.469628: probe:getname_flags: (ffffffff811a2f89) pathname="/sys/devices/system/node/node0/cpu0/topology/physical_package_id"
> [root@zoo linux]#
> 
> Thanks a lot, applied to my perf/urgent branch,
> 
> - Arnaldo
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


