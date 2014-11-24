Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751483AbaKXVt4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 16:49:56 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:34540 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbaKXVtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 16:49:55 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Aaron Tomlin <atomlin@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Sterling Alexander <stalexan@redhat.com>, linux-kernel@vger.kernel.org
References: <20141107201424.GA22209@redhat.com>
	<20141124200602.GA20575@redhat.com>
Date: Mon, 24 Nov 2014 15:48:38 -0600
In-Reply-To: <20141124200602.GA20575@redhat.com> (Oleg Nesterov's message of
	"Mon, 24 Nov 2014 21:06:02 +0100")
Message-ID: <87ioi4fex5.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+IEB4WuPHhlJMr3FJaPo+0E151SccSQWs=
X-SA-Exim-Connect-IP: 97.121.92.161
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  2.0 XMPhish11 BODY: Confirm email account/addy
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 238 ms - load_scoreonly_sql: 0.06 (0.0%),
	signal_user_changed: 3.3 (1.4%), b_tie_ro: 2.4 (1.0%), parse: 0.69 (0.3%),
	extract_message_metadata: 3.8 (1.6%), get_uri_detail_list: 1.78 (0.7%),
	tests_pri_-1000: 3.5 (1.5%), tests_pri_-950: 1.27 (0.5%), tests_pri_-900:
	1.13 (0.5%), tests_pri_-400: 21 (8.7%), check_bayes: 20 (8.2%), b_tokenize: 5
	(2.1%), b_tok_get_all: 6 (2.7%), b_comp_prob: 2.0 (0.9%), b_tok_touch_all:
	2.3 (1.0%), b_finish: 2.1 (0.9%), tests_pri_0: 187 (78.5%), tests_pri_500: 5
	(2.1%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 0/2] exit/pid_ns: comments + simple fix
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> Eric, Pavel, could you review 1/2 ? (documentation only). It is based on the
> code inspection, I didn't bother to verify that my understanding matches the
> reality ;)
>
> On 11/20, Oleg Nesterov wrote:
>>
>>
>> Probably this is not the last series... in particular it seems that we
>> have some problems with sys_setns() in this area, but I need to recheck.
>
> So far only the documentation fix. I'll write another email (hopefully with the
> patch), afaics at least setns() doesn't play well with PR_SET_CHILD_SUBREAPER.
>
> Contrary to what I thought zap_pid_ns_processes() looks fine, but it seems only
> by accident. Unless I am totally confused, wait for "nr_hashed == init_pids"
> could be removed after 0a01f2cc390e10633a "pidns: Make the pidns proc mount/
> umount logic obvious". However, now that setns() + fork() can inject a task
> into a child namespace, we need this code again for another reason.
>
> I _think_ we can actually remove it and simplify free_pid() as well, but lets
> discuss this later and fix the wrong/confusing documentation first.

At the very least there is the issue of rusage being wrong if we allow
the init process to be reaped before all of it's children are reaped.

There is also a huge level of weird non-intuitive behavior that would
require some substantial benefits to justify an optimization of letting
a child exist longer than init.

Eric


> 2/2 looks "obviously correct", but I'll appreciate your review anyway.
>
> Oleg.
>
>  kernel/pid.c           |    7 +++----
>  kernel/pid_namespace.c |   23 +++++++++++++++++++----
>  2 files changed, 22 insertions(+), 8 deletions(-)
