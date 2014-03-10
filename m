Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbaCJR0R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 13:26:17 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:25388 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754046AbaCJR0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 13:26:09 -0400
Date: Mon, 10 Mar 2014 13:26:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Mike Galbraith <bitbucket@online.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>, tglx@linutronix.de
Subject: Re: [PATCH RT] fs: jbd2: pull your plug when waiting for space
Message-ID: <20140310132602.6d4b0e53@gandalf.local.home>
In-Reply-To: <20140221123253.GA12822@linutronix.de>
References: <20140221123253.GA12822@linutronix.de>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Feb 2014 13:32:53 +0100
Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:

> Two cps in parallel managed to stall the the ext4 fs. It seems that
> journal code is either waiting for locks or sleeping waiting for
> something to happen. This seems similar to what Mike observed on ext3,
> here is his description:
> 
> |With an -rt kernel, and a heavy sync IO load, tasks can jam
> |up on journal locks without unplugging, which can lead to
> |terminal IO starvation.  Unplug and schedule when waiting
> |for space.
> 
> This is on v3.2-RT. This cp testcase triggers about once in four runs.
> It did not trigger once in 20 runs on v3.12-RT.
> This brings me to the question: could it been fixed in the meantime and
> we not need the jbd patches in latest -RT is there a better testcase?

I'm a little confused. Is this only needed for 3.12-rt? I see that you
did not mark it for stable.

-- Steve

> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  fs/jbd2/checkpoint.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
> index 16a698b..c6443c3 100644
> --- a/fs/jbd2/checkpoint.c
> +++ b/fs/jbd2/checkpoint.c
> @@ -129,6 +129,8 @@ void __jbd2_log_wait_for_space(journal_t *journal)
>  		if (journal->j_flags & JBD2_ABORT)
>  			return;
>  		write_unlock(&journal->j_state_lock);
> +		if (current->plug)
> +			io_schedule();
>  		mutex_lock(&journal->j_checkpoint_mutex);
>  
>  		/*

