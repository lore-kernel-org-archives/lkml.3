Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760842Ab3LIKCS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 05:02:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60051 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754449Ab3LIKCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 05:02:14 -0500
Date: Mon, 9 Dec 2013 11:02:05 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tool: Ensure forward progress unwinding frames
Message-ID: <20131209100205.GA1242@krava.brq.redhat.com>
References: <1385942509-11445-1-git-send-email-dsahern@gmail.com>
 <52A4B065.9080804@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52A4B065.9080804@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 08, 2013 at 10:46:13AM -0700, David Ahern wrote:
> ping.. Jiri, any thoughts on this?

oops, missed that.. sry

> 
> On 12/1/13, 5:01 PM, David Ahern wrote:
> >The dwarf option for callstacks is getting stuck on the unwind and showing
> >repeated frames. For example,
> >
> >qemu-system-x86 13759 [001] 287663.084957: syscalls:sys_enter_futex: uaddr: 0x7f770a958700, op: 0x00000081, val: 0x00000001, utime: 0x7f75ea
> >             7f7705fd23ea __lll_unlock_wake (/lib64/libpthread-2.14.90.so)
> >             7f7705fcf045 _L_unlock_649 (/lib64/libpthread-2.14.90.so)
> >             7f7705fcf045 _L_unlock_649 (/lib64/libpthread-2.14.90.so)
> >             7f7705fcf045 _L_unlock_649 (/lib64/libpthread-2.14.90.so)
> >             7f7705fcf045 _L_unlock_649 (/lib64/libpthread-2.14.90.so)
> >             7f7705fcf045 _L_unlock_649 (/lib64/libpthread-2.14.90.so)
> >             ...

I wonder this is us or libunwind bug (or cfi code) ;-)

looks like you can reproduce..? are you using the latest libunwind?


> >             (Last frame repeats 126 times)
> >
> >Catch that the same frame is hit multiple times and break out of the loop.
> >
> >With this patch:
> >
> >qemu-system-x86 13759 [001] 287663.084967: syscalls:sys_exit_futex: 0x1
> >             7f7705fd23ea __lll_unlock_wake (/lib64/libpthread-2.14.90.so)
> >             7f7705fcf045 _L_unlock_649 (/lib64/libpthread-2.14.90.so)
> >
> >Signed-off-by: David Ahern <dsahern@gmail.com>
> >Cc: Jiri Olsa <jolsa@redhat.com>
> >---
> >  tools/perf/util/unwind.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> >diff --git a/tools/perf/util/unwind.c b/tools/perf/util/unwind.c
> >index 0efd5393de85..817ffc1f3a00 100644
> >--- a/tools/perf/util/unwind.c
> >+++ b/tools/perf/util/unwind.c
> >@@ -563,6 +563,7 @@ static int get_entries(struct unwind_info *ui, unwind_entry_cb_t cb,
> >  {
> >  	unw_addr_space_t addr_space;
> >  	unw_cursor_t c;
> >+	unw_word_t prev_ip = 0;
> >  	int ret;
> >
> >  	addr_space = unw_create_addr_space(&accessors, 0);
> >@@ -579,6 +580,10 @@ static int get_entries(struct unwind_info *ui, unwind_entry_cb_t cb,
> >  		unw_word_t ip;
> >
> >  		unw_get_reg(&c, UNW_REG_IP, &ip);
> >+		if (ip == prev_ip)
> >+			break;
> >+		prev_ip = ip;

hum, how about recursion?

how about some counter and break after some insane value
and maybe display some warning..

  qemu-system-x86 13759 [001] 287663.084967: syscalls:sys_exit_futex: 0x1
             7f7705fd23ea __lll_unlock_wake (/lib64/libpthread-2.14.90.so)
             7f7705fcf045 _L_unlock_649 (/lib64/libpthread-2.14.90.so)
             warning: unwind broken

jirka
