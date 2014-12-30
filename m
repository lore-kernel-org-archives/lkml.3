Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408AbaL3EVz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 23:21:55 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:45897 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbaL3EVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 23:21:54 -0500
Message-ID: <54A2285F.3040200@gmail.com>
Date: Mon, 29 Dec 2014 21:21:51 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: Arnaldo Carvalho de Melo <acme@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: problems with perf probe and system libraries
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masami:

I have been looking at perf-probe again and having a number of problems 
with top of tree.

Here's the first one I have isolated:

$ perf probe -x /lib64/libc-2.18.so -a 'malloc  size=%di'
Probe point 'malloc' not found.
   Error: Failed to add events.

$ perf probe -x /lib64/libc-2.18.so -F | grep malloc
malloc
malloc@plt
malloc_atfork
malloc_check
malloc_consolidate
malloc_hook_ini
malloc_info
malloc_printerr
mallochook
ptmalloc_init
ptmalloc_init.part.8
ptmalloc_lock_all
ptmalloc_unlock_all
ptmalloc_unlock_all2
tr_mallochook

$ perf probe -x /lib64/libc-2.18.so -a 'malloc=malloc size=%di'
Probe point 'malloc' not found.
   Error: Failed to add events.

A year ago (v3.12) this worked fine so I did a git bisect which points to:

commit fb7345bbf7fad9bf72ef63a19c707970b9685812
Author: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date:   Thu Dec 26 05:41:53 2013 +0000

     perf probe: Support basic dwarf-based operations on uprobe events

I have tried top of tree on Fedora 16, 18 and 20 with a variety of 
kernels - and a variety of results. Reverting to 
8a613d40e389b723fd5889ac8d4033ed4030be31 which is the commit before this 
one and it works again.

David
