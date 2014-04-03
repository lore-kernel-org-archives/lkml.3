Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758934AbaDCI73 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 04:59:29 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:56784 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755796AbaDCI7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 04:59:25 -0400
Message-ID: <533D22E6.4000607@hitachi.com>
Date: Thu, 03 Apr 2014 17:59:18 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] tracing: Add 'hash' event trigger command
References: <cover.1395894625.git.tom.zanussi@linux.intel.com> <b81b0860d2915c0b562863fce889249dad080922.1395894625.git.tom.zanussi@linux.intel.com>
In-Reply-To: <b81b0860d2915c0b562863fce889249dad080922.1395894625.git.tom.zanussi@linux.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tom,

(2014/03/27 13:54), Tom Zanussi wrote:
> Hash triggers allow users to continually hash events which can then be
> dumped later by simply reading the trigger file.  This is done
> strictly via one-liners and without any kind of programming language.
> 
> The syntax follows the existing trigger syntax:
> 
>   # echo hash:key(s):value(s)[:sort_keys()][ if filter] > event/trigger
> 
> The values used as keys and values are just the fields that define the
> trace event and available in the event's 'format' file.  For example,
> the kmalloc event:
> 
> root@ie:/sys/kernel/debug/tracing/events/kmem/kmalloc# cat format
> name: kmalloc
> ID: 370
> format:
>         field:unsigned short common_type;       offset:0;       size:2; signed:0;
>         field:unsigned char common_flags;       offset:2;       size:1; signed:0;
>         field:unsigned char common_preempt_count;       offset:3;       size:1;signed:0;
>         field:int common_pid;   offset:4;       size:4; signed:1;
> 
>         field:unsigned long call_site;  offset:8;       size:4; signed:0;
>         field:const void * ptr; offset:12;      size:4; signed:0;
>         field:size_t bytes_req; offset:16;      size:4; signed:0;
>         field:size_t bytes_alloc;       offset:20;      size:4; signed:0;
>         field:gfp_t gfp_flags;  offset:24;      size:4; signed:0;
> 
> The key can be made up of one or more of these fields and any number of
> values can specified - these are automatically tallied in the hash entry
> any time the event is hit.  Stacktraces can also be used as keys.
> 
> For example, the following uses the stacktrace leading up to a kmalloc
> as the key for hashing kmalloc events.  For each hash entry a tally of
> the bytes_alloc field is kept.  Dumping out the trigger shows the sum
> of bytes allocated for each execution path that led to a kmalloc:
> 
>   # echo 'hash:call_site:bytes_alloc' > /sys/kernel/debug/tracing/events/kmem/kmalloc/trigger
>   # cat /sys/kernel/debug/tracing/events/kmem/kmalloc/trigger

I like the basic idea :) but I'm confused the interface what you're introduced.
I suppose that the "trigger" file is for control triggers on the event, so that
user can check what trigger rules are set on the event and remove it.
But in this patch, that is also used for a data path.

I'd like to suggest adding new "hash" file under events/GROUP/EVENT/, which is
only for dumping the hash data, and keep the "trigger" as a control path.
This makes users easier to build their own tools on the ftrace facility.

Thank you,


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


