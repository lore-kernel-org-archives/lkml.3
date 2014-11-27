Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706AbaK0PpW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 10:45:22 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:52155 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbaK0PpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 10:45:20 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Aaron Tomlin <atomlin@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Sterling Alexander <stalexan@redhat.com>, linux-kernel@vger.kernel.org
References: <20141126235434.GA378@redhat.com>
Date: Thu, 27 Nov 2014 09:44:03 -0600
In-Reply-To: <20141126235434.GA378@redhat.com> (Oleg Nesterov's message of
	"Thu, 27 Nov 2014 00:54:34 +0100")
Message-ID: <877fygzm0s.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18UPTADqi/n0+HVAxncigdNqYpH464GnO8=
X-SA-Exim-Connect-IP: 97.121.92.161
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 348 ms - load_scoreonly_sql: 0.04 (0.0%),
	signal_user_changed: 3.7 (1.1%), b_tie_ro: 2.6 (0.8%), parse: 0.90 (0.3%),
	extract_message_metadata: 14 (4.1%), get_uri_detail_list: 1.39 (0.4%),
	tests_pri_-1000: 6 (1.6%), tests_pri_-950: 1.27 (0.4%), tests_pri_-900: 1.08
	(0.3%), tests_pri_-400: 16 (4.7%), check_bayes: 15 (4.4%), b_tokenize: 4.3
	(1.2%), b_tok_get_all: 5 (1.5%), b_comp_prob: 1.48 (0.4%), b_tok_touch_all:
	2.3 (0.7%), b_finish: 0.67 (0.2%), tests_pri_0: 292 (84.0%), tests_pri_500: 9
	(2.6%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH v2 1/2] exit: pidns: alloc_pid() leaks pid_namespace if child_reaper is exiting
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> alloc_pid() does get_pid_ns() beforehand but forgets to put_pid_ns()
> if it fails because disable_pid_allocation() was called by the exiting
> child_reaper.
>
> We could simply move get_pid_ns() down to successful return, but this
> fix tries to be as trivial as possible.
>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Cc: stable@vger.kernel.org
Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
>  kernel/pid.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/kernel/pid.c b/kernel/pid.c
> index 9b9a266..82430c8 100644
> --- a/kernel/pid.c
> +++ b/kernel/pid.c
> @@ -341,6 +341,8 @@ out:
>  
>  out_unlock:
>  	spin_unlock_irq(&pidmap_lock);
> +	put_pid_ns(ns);
> +
>  out_free:
>  	while (++i <= ns->level)
>  		free_pidmap(pid->numbers + i);
