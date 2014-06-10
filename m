Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934501AbaFJHuj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 03:50:39 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:42742 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933692AbaFJHuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 03:50:37 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: acme@kernel.org, artagnon@gmail.com, jolsa@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] perf timechart: implement IO mode
References: <1402305672-2630-1-git-send-email-stfomichev@yandex-team.ru>
	<1402305672-2630-3-git-send-email-stfomichev@yandex-team.ru>
Date: Tue, 10 Jun 2014 16:50:35 +0900
In-Reply-To: <1402305672-2630-3-git-send-email-stfomichev@yandex-team.ru>
	(Stanislav Fomichev's message of "Mon, 9 Jun 2014 13:21:12 +0400")
Message-ID: <8738fdb3uc.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  9 Jun 2014 13:21:12 +0400, Stanislav Fomichev wrote:
>  TIMECHART OPTIONS
>  -----------------
> @@ -54,6 +64,15 @@ TIMECHART OPTIONS
>  	duration or tasks with given name. If number is given it's interpreted
>  	as number of nanoseconds. If non-numeric string is given it's
>  	interpreted as task name.
> +--io-skip-eagain::
> +	Don't draw EAGAIN IO events.
> +--io-min-time::
> +	Draw small events as if they lasted min-time. Useful when you need
> +	to see very small and fast IO. Default value is 1ms.
> +--io-merge-dist::
> +	Merge events that are merge-dist nanoseconds apart.
> +	Reduces number of figures on the SVG and makes it more render-friendly.
> +	Default value is 1us.

Looks like these are advanced options.  If so, I think it's better to
split them to a different changeset so that the main change remains
simpler, smaller and easier to review.


>  
>  EXAMPLES
>  --------
> @@ -75,6 +94,14 @@ Record system-wide timechart:
>  
>    $ perf timechart --highlight gcc
>  
> +Record system-wide IO events:
> +
> +  $ perf timechart record -I

I think it's not working currently..  Even with massaging of the decl
shadow errors, I still wasn't able to run it due to some errors.  Please
see below..


> +
> +  then generate timechart:
> +
> +  $ perf timechart


[SNIP]
> +static int timechart__io_record(int argc, const char **argv)
> +{
> +	unsigned int rec_argc, i;
> +	const char **rec_argv;
> +	const char **p;
> +	char *filter = NULL;
> +
> +	const char * const common_args[] = {
> +		"record", "-a", "-R", "-c", "1",
> +	};
> +	unsigned int common_args_nr = ARRAY_SIZE(common_args);
> +
> +	const char * const disk_events[] = {
> +		"-e", "syscalls:sys_enter_read",

I guess you need to get rid of all "-e" part in the arrays as you add it
automatically below, otherwise I saw following errors:

  $ perf timechart record -I
  invalid or unsupported event: '-e'
  Run 'perf list' for a list of valid events
  
   usage: perf record [<options>] [<command>]
      or: perf record [<options>] -- <command> [<options>]
  
      -e, --event <event>   event selector. use 'perf list' to list available events



> +		"-e", "syscalls:sys_enter_pread64",

And even with above change, it still failed to run since it seems my
system doesn't have the pread64 syscall:

  $ perf timechart record -I
  invalid or unsupported event: 'syscalls:sys_enter_pread64'
  Run 'perf list' for a list of valid events
  
   usage: perf record [<options>] [<command>]
      or: perf record [<options>] -- <command> [<options>]
  
      -e, --event <event>   event selector. use 'perf list' to list available events


Then I stopped to test/review.  I'll review if you send v2 with fixes.

Thanks,
Namhyung


> +		"-e", "syscalls:sys_enter_readv",
> +		"-e", "syscalls:sys_enter_preadv",
> +		"-e", "syscalls:sys_enter_write",
> +		"-e", "syscalls:sys_enter_pwrite64",
> +		"-e", "syscalls:sys_enter_writev",
> +		"-e", "syscalls:sys_enter_pwritev",
> +		"-e", "syscalls:sys_enter_sync",
> +		"-e", "syscalls:sys_enter_sync_file_range",
> +		"-e", "syscalls:sys_enter_fsync",
> +		"-e", "syscalls:sys_enter_msync",
> +
> +		"-e", "syscalls:sys_exit_read",
> +		"-e", "syscalls:sys_exit_pread64",
> +		"-e", "syscalls:sys_exit_readv",
> +		"-e", "syscalls:sys_exit_preadv",
> +		"-e", "syscalls:sys_exit_write",
> +		"-e", "syscalls:sys_exit_pwrite64",
> +		"-e", "syscalls:sys_exit_writev",
> +		"-e", "syscalls:sys_exit_pwritev",
> +		"-e", "syscalls:sys_exit_sync",
> +		"-e", "syscalls:sys_exit_sync_file_range",
> +		"-e", "syscalls:sys_exit_fsync",
> +		"-e", "syscalls:sys_exit_msync",
> +	};
> +	unsigned int disk_events_nr = ARRAY_SIZE(disk_events);
> +
> +	const char * const net_events[] = {
> +		"-e", "syscalls:sys_enter_recvfrom",
> +		"-e", "syscalls:sys_enter_recvmmsg",
> +		"-e", "syscalls:sys_enter_recvmsg",
> +		"-e", "syscalls:sys_enter_sendto",
> +		"-e", "syscalls:sys_enter_sendmsg",
> +		"-e", "syscalls:sys_enter_sendmmsg",
> +
> +		"-e", "syscalls:sys_exit_recvfrom",
> +		"-e", "syscalls:sys_exit_recvmmsg",
> +		"-e", "syscalls:sys_exit_recvmsg",
> +		"-e", "syscalls:sys_exit_sendto",
> +		"-e", "syscalls:sys_exit_sendmsg",
> +		"-e", "syscalls:sys_exit_sendmmsg",
> +	};
> +	unsigned int net_events_nr = ARRAY_SIZE(net_events);
> +
> +	const char * const poll_events[] = {
> +		"-e", "syscalls:sys_enter_epoll_pwait",
> +		"-e", "syscalls:sys_enter_epoll_wait",
> +		"-e", "syscalls:sys_enter_poll",
> +		"-e", "syscalls:sys_enter_ppoll",
> +		"-e", "syscalls:sys_enter_pselect6",
> +		"-e", "syscalls:sys_enter_select",
> +
> +		"-e", "syscalls:sys_exit_epoll_pwait",
> +		"-e", "syscalls:sys_exit_epoll_wait",
> +		"-e", "syscalls:sys_exit_poll",
> +		"-e", "syscalls:sys_exit_ppoll",
> +		"-e", "syscalls:sys_exit_pselect6",
> +		"-e", "syscalls:sys_exit_select",
> +	};
> +	unsigned int poll_events_nr = ARRAY_SIZE(poll_events);
> +
> +	rec_argc = common_args_nr +
> +		disk_events_nr * 4 +
> +		net_events_nr * 4 +
> +		poll_events_nr * 4 +
> +		argc + 1;
> +	rec_argv = calloc(rec_argc + 1, sizeof(char *));
> +
> +	if (rec_argv == NULL)
> +		return -ENOMEM;
> +
> +	if (asprintf(&filter, "common_pid != %d", getpid()) < 0)
> +		return -ENOMEM;
> +
> +	p = rec_argv;
> +	for (i = 0; i < common_args_nr; i++)
> +		*p++ = strdup(common_args[i]);
> +	for (i = 0; i < disk_events_nr; i++) {
> +		*p++ = "-e";
> +		*p++ = strdup(disk_events[i]);
> +		*p++ = "--filter";
> +		*p++ = filter;
> +	}
> +	for (i = 0; i < net_events_nr; i++) {
> +		*p++ = "-e";
> +		*p++ = strdup(net_events[i]);
> +		*p++ = "--filter";
> +		*p++ = filter;
> +	}
> +	for (i = 0; i < poll_events_nr; i++) {
> +		*p++ = "-e";
> +		*p++ = strdup(poll_events[i]);
> +		*p++ = "--filter";
> +		*p++ = filter;
> +	}
> +
> +	for (i = 0; i < (unsigned int)argc; i++)
> +		*p++ = argv[i];
> +
> +	return cmd_record(rec_argc, rec_argv, NULL);
> +}
