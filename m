Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759885Ab3LHRqR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 12:46:17 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:45586 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754800Ab3LHRqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 12:46:15 -0500
Message-ID: <52A4B065.9080804@gmail.com>
Date: Sun, 08 Dec 2013 10:46:13 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Jiri Olsa <jolsa@redhat.com>
CC: David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH] perf tool: Ensure forward progress unwinding frames
References: <1385942509-11445-1-git-send-email-dsahern@gmail.com>
In-Reply-To: <1385942509-11445-1-git-send-email-dsahern@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping.. Jiri, any thoughts on this?

On 12/1/13, 5:01 PM, David Ahern wrote:
> The dwarf option for callstacks is getting stuck on the unwind and showing
> repeated frames. For example,
>
> qemu-system-x86 13759 [001] 287663.084957: syscalls:sys_enter_futex: uaddr: 0x7f770a958700, op: 0x00000081, val: 0x00000001, utime: 0x7f75ea
>              7f7705fd23ea __lll_unlock_wake (/lib64/libpthread-2.14.90.so)
>              7f7705fcf045 _L_unlock_649 (/lib64/libpthread-2.14.90.so)
>              7f7705fcf045 _L_unlock_649 (/lib64/libpthread-2.14.90.so)
>              7f7705fcf045 _L_unlock_649 (/lib64/libpthread-2.14.90.so)
>              7f7705fcf045 _L_unlock_649 (/lib64/libpthread-2.14.90.so)
>              7f7705fcf045 _L_unlock_649 (/lib64/libpthread-2.14.90.so)
>              ...
>              (Last frame repeats 126 times)
>
> Catch that the same frame is hit multiple times and break out of the loop.
>
> With this patch:
>
> qemu-system-x86 13759 [001] 287663.084967: syscalls:sys_exit_futex: 0x1
>              7f7705fd23ea __lll_unlock_wake (/lib64/libpthread-2.14.90.so)
>              7f7705fcf045 _L_unlock_649 (/lib64/libpthread-2.14.90.so)
>
> Signed-off-by: David Ahern <dsahern@gmail.com>
> Cc: Jiri Olsa <jolsa@redhat.com>
> ---
>   tools/perf/util/unwind.c | 5 +++++
>   1 file changed, 5 insertions(+)
>
> diff --git a/tools/perf/util/unwind.c b/tools/perf/util/unwind.c
> index 0efd5393de85..817ffc1f3a00 100644
> --- a/tools/perf/util/unwind.c
> +++ b/tools/perf/util/unwind.c
> @@ -563,6 +563,7 @@ static int get_entries(struct unwind_info *ui, unwind_entry_cb_t cb,
>   {
>   	unw_addr_space_t addr_space;
>   	unw_cursor_t c;
> +	unw_word_t prev_ip = 0;
>   	int ret;
>
>   	addr_space = unw_create_addr_space(&accessors, 0);
> @@ -579,6 +580,10 @@ static int get_entries(struct unwind_info *ui, unwind_entry_cb_t cb,
>   		unw_word_t ip;
>
>   		unw_get_reg(&c, UNW_REG_IP, &ip);
> +		if (ip == prev_ip)
> +			break;
> +		prev_ip = ip;
> +
>   		ret = entry(ip, ui->thread, ui->machine, cb, arg);
>   	}
>
>

