Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbaE1VoO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 17:44:14 -0400
Received: from mail.kernel.org ([198.145.19.201]:41996 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755428AbaE1VoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 17:44:12 -0400
Date: Wed, 28 May 2014 18:44:06 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [BUG] perf probe segfaulting when asked for variable it doesn't find
Message-ID: <20140528214406.GE2764@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami-san,

	While trying:

[root@zoo ~]# perf probe 'vfs_getname=getname_flags:65 pathname=result->name:string'
Failed to find the location of result at this address.
 Perhaps, it has been optimized out.
Failed to find 'result' in this function.
  Error: Failed to add events. (-2)
[root@zoo ~]# perf probe 'vfs_getname=getname_flags:65 pathname=result->name:string'
Added new event:
Segmentation fault (core dumped)

I got segfaulted while in the past I would get the much nicer:

[root@zoo ~]# perf probe 'vfs_getname=getname_flags:65 pathname=result->name:string'
Failed to find the location of result at this address.
 Perhaps, it has been optimized out.
Failed to find 'result' in this function.
  Error: Failed to add events. (-2)
[root@zoo ~]#

The "Error:"  part can and should be trimmed, just the two middle ones should
be enough, but I'm digressing, I bisected it down to the cset at the bottom of this
message.

In the past there was a 'result' variable at getname_flags, but now 'probe'
isn't finding any, as it seems to have been optimized away, still haven't checked
thoroughly:

[root@zoo ~]# perf probe -V getname_flags
Available variables at getname_flags
        @<getname_flags+0>
                char*   filename
                int     flags
                int*    empty
        @<getname+18>
                (No matched variables)
        @<user_path_create+37>
                (No matched variables)
        @<user_path_parent+37>
                (No matched variables)
        @<user_path_at_empty+50>
                (No matched variables)
        @<user_path_mountpoint_at+37>
                (No matched variables)
        @<sys_symlinkat+38>
                (No matched variables)
        @<sys_symlink+34>
                (No matched variables)
[root@zoo ~]

3d918a12a1b3088ac16ff37fa52760639d6e2403 is the first bad commit
commit 3d918a12a1b3088ac16ff37fa52760639d6e2403
Author: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date:   Fri Oct 11 16:10:26 2013 +0900

    perf probe: Find fentry mcount fuzzed parameter location
    
    At this point, --fentry (mcount function entry) option for gcc fuzzes
    the debuginfo variable locations by skipping the mcount instruction
    offset (on x86, this is a 5 byte call instruction).
    
    This makes variable searching fail at the entry of functions which
    are mcount'ed.
    
    e.g.)
    Available variables at vfs_read
            @<vfs_read+0>
                    (No matched variables)
    
    This patch adds additional location search at the function entry point
    to solve this issue, which tries to find the earliest address for the
    variable location.
    
    Note that this only works with function parameters (formal parameters)
    because any local variables should not exist on the function entry
    address (those are not initialized yet).
    
    With this patch, perf probe shows correct parameters if possible;
     # perf probe --vars vfs_read
     Available variables at vfs_read
             @<vfs_read+0>
                     char*   buf
                     loff_t* pos
                     size_t  count
                     struct file*    file
    
    Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
    Cc: Ingo Molnar <mingo@redhat.com>
    Cc: Paul Mackerras <paulus@samba.org>
    Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Link: http://lkml.kernel.org/r/20131011071025.15557.13275.stgit@udc4-manage.rcp.hitachi.co.jp
    Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

:040000 040000 4c416906285aa1488ed2badbaf3b3feee86f9578 978c6b47f442845e6e93a79a24aeb36bbca0b7da M	tools
[acme@zoo linux]$
