Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932358Ab3IPLfV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 07:35:21 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:37008 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756658Ab3IPLfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 07:35:17 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org
References: <20130915172648.GA16131@redhat.com>
Date: Mon, 16 Sep 2013 04:35:08 -0700
In-Reply-To: <20130915172648.GA16131@redhat.com> (Oleg Nesterov's message of
	"Sun, 15 Sep 2013 19:26:48 +0200")
Message-ID: <87eh8pknir.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+NDjqjos1Jcv9H0C+VyfnmyLHFmJ/A73w=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3120]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH RESEND] pidns: fix free_pid() to handle the first fork failure
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> "case 0" in free_pid() assumes that disable_pid_allocation() should
> clear PIDNS_HASH_ADDING before the last pid goes away. However this
> doesn't happen if the 1st fork() fails to create the child reaper
> which should call disable_pid_allocation().

Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---

I am not really setup to do deal with bug fixes, inbetween releases but
if Andrew doesn't grab this I will toss this in my tree for 3.13.

Eric

>  kernel/pid.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
>
> diff --git a/kernel/pid.c b/kernel/pid.c
> index 66505c1..606a212 100644
> --- a/kernel/pid.c
> +++ b/kernel/pid.c
> @@ -272,6 +272,11 @@ void free_pid(struct pid *pid)
>  			 */
>  			wake_up_process(ns->child_reaper);
>  			break;
> +		case PIDNS_HASH_ADDING:
> +			/* Handle a fork failure of the first process */
> +			WARN_ON(ns->child_reaper);
> +			ns->nr_hashed = 0;
> +			/* fall through */
>  		case 0:
>  			schedule_work(&ns->proc_work);
>  			break;
