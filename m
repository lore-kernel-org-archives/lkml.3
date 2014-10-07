Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744AbaJGVvV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 17:51:21 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:45310 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbaJGVvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 17:51:18 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andy Lutomirski <luto@amacapital.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Andrey Vagin <avagin@openvz.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>, Andrey Vagin <avagin@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Rob Landley <rob@landley.net>
References: <1412683977-29543-1-git-send-email-avagin@openvz.org>
	<20141007133039.GG7996@ZenIV.linux.org.uk>
	<20141007133339.GH7996@ZenIV.linux.org.uk>
	<87r3yjy64e.fsf@x220.int.ebiederm.org>
	<CALCETrXgssZfi3BirQ=K7-vrPyEh5AzFX2pF+yj76Ngi0sf7Yw@mail.gmail.com>
	<87siizshav.fsf@x220.int.ebiederm.org>
	<CALCETrWfZwbGCxnUAg0PnM=tN8MGRQkHrJVC42bVF7sdJKXLmw@mail.gmail.com>
Date: Tue, 07 Oct 2014 14:50:47 -0700
In-Reply-To: <CALCETrWfZwbGCxnUAg0PnM=tN8MGRQkHrJVC42bVF7sdJKXLmw@mail.gmail.com>
	(Andy Lutomirski's message of "Tue, 7 Oct 2014 14:38:06 -0700")
Message-ID: <87zjd7pn0o.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18TydKcCLpdpDOx7aTeRVzMFUGaLOaTixw=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4163]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andy Lutomirski <luto@amacapital.net>
X-Spam-Relay-Country: 
X-Spam-Timing: total 240 ms - load_scoreonly_sql: 0.03 (0.0%),
	signal_user_changed: 2.9 (1.2%), b_tie_ro: 2.1 (0.9%), parse: 0.66 (0.3%),
	extract_message_metadata: 14 (5.6%), get_uri_detail_list: 1.30 (0.5%),
	tests_pri_-1000: 8 (3.3%), tests_pri_-950: 1.22 (0.5%), tests_pri_-900: 0.98
	(0.4%), tests_pri_-400: 25 (10.5%), check_bayes: 24 (10.0%), b_tokenize: 5
	(2.3%), b_tok_get_all: 13 (5.2%), b_comp_prob: 1.78 (0.7%), b_tok_touch_all:
	2.2 (0.9%), b_finish: 0.73 (0.3%), tests_pri_0: 179 (74.8%), tests_pri_500: 5
	(2.2%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH] [RFC] mnt: add ability to clone mntns starting with the current root
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:

> On Tue, Oct 7, 2014 at 2:26 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>> Andy Lutomirski <luto@amacapital.net> writes:
>>
>>> Why should MNT_LOCKED on submounts be enforced?
>>>
>>> Is it because, if you retain a reference to the detached tree, then
>>> you can see under the submounts?
>>
>> Yes. MNT_DETACH is a recursive operation that detaches all of the mount
>> and all of it's submounts.  Which means you can see under the submounts
>> if you have a reference to a detached mount.
>>
>>> If so, let's fix *that*.  Because
>>> otherwise the whole model of pivot_root + detach will break.
>>
>> I am not certain what you are referring to.  pivot_root doesn't
>> manipulate the mount tree so you can see under anything.
>>
>> What I believe is the appropriate fix is to fail umount2(...,MNT_DETACH)
>> if there are any referenced mount points being detached that have a
>> locked submount.
>
> Most of the container-using things do, roughly:
>
> Unshare userns and mountns
> Mount some new stuff
> pivot_root to the new stuff
> MNT_DETACH the old.
>
> That last step will almost always fail if you make this change.

I don't think so.

I expect I could add full busy detection of normal umounts and those
applications would not fail.

What I am proposing is a more targeted version of busy detection that
looks at each mount in the set that detach will unmount.  For each mount
if it is busy with non-submount references and it has at least one
locked submount fail the detach with -EBUSY.

Do you really think we have userspace references to the one or more of the
mounts under old?

Eric
