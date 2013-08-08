Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757636Ab3HHCCy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 22:02:54 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:58946 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757571Ab3HHCCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 22:02:52 -0400
Message-ID: <5202FC4B.7040106@hitachi.com>
Date: Thu, 08 Aug 2013 11:02:51 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v4 00/11] tracing: trace event triggers
References: <cover.1375111640.git.tom.zanussi@linux.intel.com>
In-Reply-To: <cover.1375111640.git.tom.zanussi@linux.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(2013/07/30 1:40), Tom Zanussi wrote:
> Hi,
> 
> This is v4 of the trace event triggers patchset, addressing more
> comments from Masami Hiramatsu (thanks for the review and comments).
> 
> One of Masami's comments was on event_trigger_regex_open's use of
> inode->i_private and that the same problem was being worked on by Oleg
> Nesterov in other places.  That still seems to be the case, but in
> order to address that, this patchset is built on top of the current
> linux-trace/for-next but also including v2 of Oleg Nesterov's tracing:
> open/delete fixes (but with v3 of the 6/6 patch). 

Does this patchset supports multibuffer? It seems that setting a
trigger in an event of an instance affects the default event, but not
the instance's event.
e.g.

# mkdir instances/hoge
# echo 'enable_event:mce:mce_record' > instances/hoge/events/syscalls/sys_enter_symlink/trigger
# cat instances/hoge/events/syscalls/sys_enter_symlink/enable
0*
# cat instances/hoge/events/mce/mce_record/enable
0
# cat events/mce/mce_record/enable
0*
# ln -sf /dev/null /tmp
# cat instances/hoge/events/mce/mce_record/enable
0
# cat events/mce/mce_record/enable
1*

This looks odd, I expected enabling mce/mce_record under instances/hoge.

And, there is a bug of ftrace itself (not introduced by this series) I've found.
After the above operation, we can delete the instance "hoge", but the soft-mode
flag of mce_record is not cleared, even though there is no trigger referring
the event.

# rmdir instances/hoge
# cat events/mce/mce_record/enable
1*

This is because the ftrace actually failed to remove(disable) the event trigger
associated with the instance when doing rmdir, but it just removed that interface.

> v4:
>  - made some changes to the soft-disable for syscall patch, according
>    to Masami's suggestions.  Actually, since there's now an array of
>    ftrace_files for syscalls that can serve the same purpose, the
>    enabled_enter/exit_syscalls bit arrays became redundant and were
>    removed.
>  - moved all the remaining common functions out of the
>    traceon/traceoff patch and into the basic trigger framework patch
>    and added comments to all the common functions.
>  - extensively commented the event_trigger_ops and event_command ops.
>  - made the register/unregister_command functions __init.  Since that
>    code was originally inspired by similar ftrace code, a new patch
>    was added to do the same thing for the register/unregister of the
>    ftrace commands (patch 10/11).
>  - fixed the event_trigger_regex_open i_private problem noted by
>    Masami that's currently being addressed by Oleg Nesterov's fixes
>    for this.  Note that that patchset also affects patch 8/11 (update
>    filters for multi-buffer, since it touches event filters as well).
>    Patch 11/11 depends on that patchset and also moves
>    event_file_data() to trace.h.b

OK, but I think the last 2 patches should be merged to 2/11 as updates.

And also, could you rebase your patches on trace/for-next branch?
Since that branch includes most of the latest fixes, it is better to
review with it.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


