Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751063AbaJSFYY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 01:24:24 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:49422 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbaJSFYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 01:24:20 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Aditya Kali <adityakali@google.com>, Linux API <linux-api@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Tejun Heo <tj@kernel.org>,
        cgroups@vger.kernel.org, Ingo Molnar <mingo@redhat.com>
References: <1413235430-22944-1-git-send-email-adityakali@google.com>
	<1413235430-22944-8-git-send-email-adityakali@google.com>
	<20141016211236.GA4308@mail.hallyn.com>
	<CAGr1F2EH0ynfFihTh1dv=n1faxUh0zS3ggk303bwGnDnW2PUCw@mail.gmail.com>
	<20141016214710.GA4759@mail.hallyn.com>
Date: Sat, 18 Oct 2014 22:23:39 -0700
In-Reply-To: <20141016214710.GA4759@mail.hallyn.com> (Serge E. Hallyn's
	message of "Thu, 16 Oct 2014 23:47:10 +0200")
Message-ID: <87iojgmy3o.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+JJc3qjzYHtecwRXaUgE8JWv58L54AO50=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Serge E. Hallyn" <serge@hallyn.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 565 ms - load_scoreonly_sql: 0.67 (0.1%),
	signal_user_changed: 8 (1.4%), b_tie_ro: 5 (0.9%), parse: 3.0 (0.5%),
	extract_message_metadata: 18 (3.2%), get_uri_detail_list: 2.2 (0.4%),
	tests_pri_-1000: 8 (1.4%), tests_pri_-950: 2.7 (0.5%), tests_pri_-900: 1.37
	(0.2%), tests_pri_-400: 23 (4.1%), check_bayes: 22 (3.9%), b_tokenize: 7
	(1.3%), b_tok_get_all: 7 (1.3%), b_comp_prob: 2.2 (0.4%), b_tok_touch_all:
	2.6 (0.5%), b_finish: 0.80 (0.1%), tests_pri_0: 467 (82.7%), tests_pri_500:
	23 (4.1%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCHv1 7/8] cgroup: cgroup namespace setns support
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serge@hallyn.com> writes:

> Quoting Aditya Kali (adityakali@google.com):
>> On Thu, Oct 16, 2014 at 2:12 PM, Serge E. Hallyn <serge@hallyn.com> wrote:
>> > Quoting Aditya Kali (adityakali@google.com):
>> >> setns on a cgroup namespace is allowed only if
>> >> * task has CAP_SYS_ADMIN in its current user-namespace and
>> >>   over the user-namespace associated with target cgroupns.
>> >> * task's current cgroup is descendent of the target cgroupns-root
>> >>   cgroup.
>> >
>> > What is the point of this?
>> >
>> > If I'm a user logged into
>> > /lxc/c1/user.slice/user-1000.slice/session-c12.scope and I start
>> > a container which is in
>> > /lxc/c1/user.slice/user-1000.slice/session-c12.scope/x1
>> > then I will want to be able to enter the container's cgroup.
>> > The container's cgroup root is under my own (satisfying the
>> > below condition0 but my cgroup is not a descendent of the
>> > container's cgroup.
>> >
>> This condition is there because we don't want to do implicit cgroup
>> changes when a process attaches to another cgroupns. cgroupns tries to
>> preserve the invariant that at any point, your current cgroup is
>> always under the cgroupns-root of your cgroup namespace. But in your
>> example, if we allow a process in "session-c12.scope" container to
>> attach to cgroupns root'ed at "session-c12.scope/x1" container
>> (without implicitly moving its cgroup), then this invariant won't
>> hold.
>
> Oh, I see.  Guess that should be workable.  Thanks.

Which has me looking at what the rules are for moving through
the cgroup hierarchy.

As long as we have write access to cgroup.procs and are allowed
to open the file for write, we can move any of our own tasks
into the cgroup.  So the cgroup namespace rules don't seem
to be a problem.

Andy can you please take a look at the permission checks in
__cgroup_procs_write.  

As I read the code I see 3 security gaffaws in the permssion check.
- Using current->cred instead of file->f_cred.
- Not checking tcred->euid.
- Checking GLOBAL_ROOT_UID instead of having a capable call.

The file permission on cgroup.procs seem just sufficient to keep
to keep those bugs from being easily exploitable.

Eric
