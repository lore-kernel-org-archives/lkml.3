Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751126AbaJIFxH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 01:53:07 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:46420 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbaJIFw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 01:52:59 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Chen\, Hanxiao" <chenhanxiao@cn.fujitsu.com>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>,
        "containers\@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1412759587-21320-1-git-send-email-chenhanxiao@cn.fujitsu.com>
	<20141008145740.GD30569@ubuntumail>
	<87r3yih2e2.fsf@x220.int.ebiederm.org>
	<5871495633F38949900D2BF2DC04883E5E0FAC@G08CNEXMBPEKD02.g08.fujitsu.local>
Date: Wed, 08 Oct 2014 22:52:26 -0700
In-Reply-To: <5871495633F38949900D2BF2DC04883E5E0FAC@G08CNEXMBPEKD02.g08.fujitsu.local>
	(Hanxiao Chen's message of "Thu, 9 Oct 2014 04:14:23 +0000")
Message-ID: <871tqheqn9.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19LGR8wTf1rBh+XmtSQrys8rV2WmWo2m7A=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3398]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Chen\, Hanxiao" <chenhanxiao@cn.fujitsu.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 318 ms - load_scoreonly_sql: 0.04 (0.0%),
	signal_user_changed: 3.6 (1.1%), b_tie_ro: 2.6 (0.8%), parse: 0.73 (0.2%),
	extract_message_metadata: 17 (5.5%), get_uri_detail_list: 1.96 (0.6%),
	tests_pri_-1000: 8 (2.6%), tests_pri_-950: 1.29 (0.4%), tests_pri_-900: 1.09
	(0.3%), tests_pri_-400: 21 (6.7%), check_bayes: 20 (6.3%), b_tokenize: 6
	(1.9%), b_tok_get_all: 7 (2.3%), b_comp_prob: 2.4 (0.7%), b_tok_touch_all:
	2.3 (0.7%), b_finish: 0.72 (0.2%), tests_pri_0: 256 (80.7%), tests_pri_500:
	4.8 (1.5%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH RFC] setns: return 0 directly if try to reassociate with current namespace
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Chen, Hanxiao" <chenhanxiao@cn.fujitsu.com> writes:

>> -----Original Message-----
>> From: Eric W. Biederman [mailto:ebiederm@xmission.com]
>> Sent: Thursday, October 09, 2014 1:56 AM
>> 
>> Serge Hallyn <serge.hallyn@ubuntu.com> writes:
>> 
>> > Quoting Chen Hanxiao (chenhanxiao@cn.fujitsu.com):
>> >> We could use setns to join the current ns,
>> >> which did a lot of unnecessary work.
>> >> This patch will check this senario and
>> >> return 0 directly.
>> >>
>> >> Signed-off-by: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
>> >
>> > Plus it's just asking for trouble.
>> >
>> > I would ack this, except you need to fclose(file) on the
>> > return paths.  So just set err = 0 and goto out.
>> 
>> I completely disagree.
>> 
>> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
>> 
>> This patch adds a new code path to test, and gets that new code path
>> wrong.  So unless there is a performance advantage for some real world
>> case I don't see the point.  Is there real software that is rejoining
>> the a current namespace.
>> 
>> This patch changes the behavior of CLONE_NEWNS (which always does a
>> chdir and chroot) when you change into the current namespace.
>> 
>> This patch changes the behavior of CLONE_NEWUSER which current errors
>> out.
>> 
>
> As reentering the same namespace looks meaningless,
> and handling reentering same ns we behaved differently,

It is not meaningless in the case of CLONE_NEWNS.  It is weird but not
meaningless.  Further return -EINVAL won't make the weird semantics go
away it just makes them more expensive to take advantage of.

> How about just *reject* the behaviour of setns to current namespace?

Because we don't break userspace applications without a darn good reason.

> +	switch (ops->type) {
> +	case CLONE_NEWIPC:
> +		if (ei->ns == tsk->nsproxy->ipc_ns) {
> +            err = -EINVAL;
> +			goto out;
> +        }
> ...
>
> And things became easy, 6 simply cases could cover the whole scenario
> and will not bring troubles to users.

Since you are cavalierly suggesting changing the semantics presented to
user space I don't belive the assertion that it will not bring trouble
to users.

Maybe on a day when I am not up to my neck in weird breakage in the
mount namespace.  Because people now care because unprivileged users can
use it we are starting to see bugs as old as 2.4 and they are a pain to
deal with.

Eric
