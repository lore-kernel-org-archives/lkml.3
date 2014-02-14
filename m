Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015AbaBNEue (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 23:50:34 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:57429 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbaBNEud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 23:50:33 -0500
X-AuditID: 9c93017e-b7cf9ae000004b4b-e5-52fda096c1ba
From: Namhyung Kim <namhyung@kernel.org>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH -tip RESEND 2/2] ftrace: Introduce nr_saved_cmdlines I/F
References: <20140213012852.15283.50473.stgit@yunodevel>
	<20140213012858.15283.93302.stgit@yunodevel>
Date: Fri, 14 Feb 2014 13:50:30 +0900
In-Reply-To: <20140213012858.15283.93302.stgit@yunodevel> (Yoshihiro YUNOMAE's
	message of "Thu, 13 Feb 2014 10:28:58 +0900")
Message-ID: <878utez4a1.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yoshihiro,

On Thu, 13 Feb 2014 10:28:58 +0900, Yoshihiro YUNOMAE wrote:
> Introduce nr_saved_cmdlines I/F for changing the number of pid-comm list.
> saved_cmdlines can store 128 command names using SAVED_CMDLINES now, but
> 'no-existing processes' names are often lost in saved_cmdlines when we
> read trace data. So, by introducing nr_saved_cmdlines I/F, the rule storing
> 128 command names is changed to the command numbers defined users.
>
> When we write a value to nr_saved_cmdlines, the number of the value will
> be stored in pid-comm list:
>
> 	# echo 1024 > /sys/kernel/debug/tracing/nr_saved_cmdlines
>
> Here, 1024 command names are stored. The default number is 128 and the maximum
> number is PID_MAX_DEFAULT (=32768 if CONFIG_BASE_SMALL is not set). So, if we
> want to avoid to lose command names, we need to set 32768 to nr_saved_cmdlines.
>
> We can read the maximum number of the list:
>
> 	# cat /sys/kernel/debug/tracing/nr_saved_cmdlines
> 	128

[SNIP]
> @@ -3685,7 +3760,8 @@ static void *saved_cmdlines_next(struct seq_file *m, void *v, loff_t *pos)
>  
>  	(*pos)++;
>  
> -	for (; ptr < &map_cmdline_to_pid[SAVED_CMDLINES]; ptr++) {
> +	for (; ptr < &savedcmd->map_cmdline_to_pid[savedcmd->cmdline_num];
> +	     ptr++) {
>  		if (*ptr == -1 || *ptr == NO_CMDLINE_MAP)
>  			continue;
>  
> @@ -3700,7 +3776,7 @@ static void *saved_cmdlines_start(struct seq_file *m, loff_t *pos)
>  	void *v;
>  	loff_t l = 0;
>  
> -	v = &map_cmdline_to_pid[0];
> +	v = &savedcmd->map_cmdline_to_pid[0];
>  	while (l <= *pos) {
>  		v = saved_cmdlines_next(m, v, &l);
>  		if (!v)

Are you accessing the savecmd without trace_cmdline_lock?

Thanks,
Namhyung
