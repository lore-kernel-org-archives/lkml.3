Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461AbaJHR4Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 13:56:24 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:45571 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaJHR4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 13:56:23 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <1412759587-21320-1-git-send-email-chenhanxiao@cn.fujitsu.com>
	<20141008145740.GD30569@ubuntumail>
Date: Wed, 08 Oct 2014 10:55:49 -0700
In-Reply-To: <20141008145740.GD30569@ubuntumail> (Serge Hallyn's message of
	"Wed, 8 Oct 2014 14:57:40 +0000")
Message-ID: <87r3yih2e2.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19VdMJN2WNR21vQumZIvyIPK7T5IySXUbk=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.2217]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Serge Hallyn <serge.hallyn@ubuntu.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 274 ms - load_scoreonly_sql: 0.62 (0.2%),
	signal_user_changed: 6 (2.1%), b_tie_ro: 3.7 (1.4%), parse: 1.56 (0.6%),
	extract_message_metadata: 19 (7.1%), get_uri_detail_list: 1.45 (0.5%),
	tests_pri_-1000: 10 (3.7%), tests_pri_-950: 1.47 (0.5%), tests_pri_-900: 1.16
	(0.4%), tests_pri_-400: 19 (6.8%), check_bayes: 17 (6.3%), b_tokenize: 4.9
	(1.8%), b_tok_get_all: 6 (2.2%), b_comp_prob: 1.99 (0.7%), b_tok_touch_all:
	2.2 (0.8%), b_finish: 0.75 (0.3%), tests_pri_0: 199 (72.7%), tests_pri_500:
	11 (4.1%), poll_dns_idle: 0.35 (0.1%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH RFC] setns: return 0 directly if try to reassociate with current namespace
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge Hallyn <serge.hallyn@ubuntu.com> writes:

> Quoting Chen Hanxiao (chenhanxiao@cn.fujitsu.com):
>> We could use setns to join the current ns,
>> which did a lot of unnecessary work.
>> This patch will check this senario and
>> return 0 directly.
>> 
>> Signed-off-by: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
>
> Plus it's just asking for trouble.
>
> I would ack this, except you need to fclose(file) on the
> return paths.  So just set err = 0 and goto out.

I completely disagree.

Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>

This patch adds a new code path to test, and gets that new code path
wrong.  So unless there is a performance advantage for some real world
case I don't see the point.  Is there real software that is rejoining
the a current namespace.

This patch changes the behavior of CLONE_NEWNS (which always does a
chdir and chroot) when you change into the current namespace.

This patch changes the behavior of CLONE_NEWUSER which current errors
out.

This code adds a big switch statement to code that is otherwise table
driven.  With the result that two pieces of code must be looked at
and modified whenever we want to tweak the behavior of setns for a
namespace.

So in general I think this piece of code is a maintenance disaster,
with no apparent redeem virtues.

Eric
