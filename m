Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932525AbaDBQx6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 12:53:58 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:42523 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932401AbaDBQx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 12:53:57 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Matthew Dempsky <mdempsky@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Julien Tinnes <jln@chromium.org>,
        Roland McGrath <mcgrathr@chromium.org>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org
References: <CAF52+S6Y40K-sRPf4YAb8ceAmtgBzZ9OUbyhPTOc_AcOWuQ=Ng@mail.gmail.com>
	<1396391358-22367-1-git-send-email-mdempsky@chromium.org>
	<20140402145850.GB7332@redhat.com> <20140402154447.GA29857@redhat.com>
	<20140402154505.GB29857@redhat.com>
Date: Wed, 02 Apr 2014 09:53:33 -0700
In-Reply-To: <20140402154505.GB29857@redhat.com> (Oleg Nesterov's message of
	"Wed, 2 Apr 2014 17:45:05 +0200")
Message-ID: <87eh1fisfm.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19jvFdjvzhAeB5wE2wyDiFsHa1bSJ5In7w=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.5 XMGappySubj_01 Very gappy subject
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4980]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_04 7+ unique symbols in subject
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_05 8+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 1/1] pid_namespace: pidns_get() should check task_active_pid_ns() != NULL
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> pidns_get()->get_pid_ns() can hit ns == NULL. This task_struct can't
> go away, but task_active_pid_ns(task) is NULL if release_task(task)
> was already called. Alternatively we could change get_pid_ns(ns) to
> check ns != NULL, but it seems that other callers are fine.

get_pid_ns already has a ns == NULL check, so no code changes should be
needed.

Eric

>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
>
> --- x/kernel/pid_namespace.c
> +++ x/kernel/pid_namespace.c
> @@ -318,7 +318,9 @@ static void *pidns_get(struct task_struct *task)
>  	struct pid_namespace *ns;
>  
>  	rcu_read_lock();
> -	ns = get_pid_ns(task_active_pid_ns(task));
> +	ns = task_active_pid_ns(task);
> +	if (ns)
> +		get_pid_ns(ns);
>  	rcu_read_unlock();
>  
>  	return ns;
