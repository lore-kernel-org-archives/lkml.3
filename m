Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046AbaKYXVq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 18:21:46 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:53529 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbaKYXVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 18:21:44 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Ian Kent <ikent@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        David Howells <dhowells@redhat.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
References: <20141125005255.4974.54193.stgit@pluto.fritz.box>
	<20141125010734.4974.85347.stgit@pluto.fritz.box>
	<20141125215248.GA7958@redhat.com> <20141125220637.GA10008@redhat.com>
	<87y4qy7wci.fsf@x220.int.ebiederm.org>
	<1416956845.2509.38.camel@pluto.fritz.box>
Date: Tue, 25 Nov 2014 17:19:57 -0600
In-Reply-To: <1416956845.2509.38.camel@pluto.fritz.box> (Ian Kent's message of
	"Wed, 26 Nov 2014 07:07:25 +0800")
Message-ID: <871toq7tr6.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18vy/T9lt7ut5c4Kpo9s/VPM9RMS4tKWzg=
X-SA-Exim-Connect-IP: 97.121.92.161
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_04 7+ unique symbols in subject
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Ian Kent <ikent@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 411 ms - load_scoreonly_sql: 0.06 (0.0%),
	signal_user_changed: 3.9 (1.0%), b_tie_ro: 2.7 (0.7%), parse: 1.16 (0.3%),
	extract_message_metadata: 5 (1.2%), get_uri_detail_list: 2.5 (0.6%),
	tests_pri_-1000: 3.8 (0.9%), tests_pri_-950: 1.36 (0.3%), tests_pri_-900:
	1.15 (0.3%), tests_pri_-400: 27 (6.6%), check_bayes: 26 (6.3%), b_tokenize: 8
	(1.8%), b_tok_get_all: 9 (2.2%), b_comp_prob: 3.9 (1.0%), b_tok_touch_all:
	2.8 (0.7%), b_finish: 0.78 (0.2%), tests_pri_0: 351 (85.4%), tests_pri_500: 6
	(1.4%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [RFC PATCH 3/4] kmod - add call_usermodehelper_ns() helper
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Kent <ikent@redhat.com> writes:

> On Tue, 2014-11-25 at 16:23 -0600, Eric W. Biederman wrote:
>> Oleg Nesterov <oleg@redhat.com> writes:
>> 
>> > On 11/25, Oleg Nesterov wrote:
>> >>
>> >> Let me first apologize, I didn't actually read this series yet.
>> >>
>> >> But I have to admit that so far I do not like this approach...
>> >> probably I am biased.
>> >
>> > Yes.
>> >
>> > And I have another concern... this is mostly a feeling, I can be
>> > easily wrong but:
>> >
>> >> On 11/25, Ian Kent wrote:
>> >> >
>> >> > +static int umh_set_ns(struct subprocess_info *info, struct cred *new)
>> >> > +{
>> >> > +	struct nsproxy *ns = info->data;
>> >> > +
>> >> > +	mntns_setfs(ns->mnt_ns);
>> >>
>> >> Firstly, it is not clear to me if we should use the caller's ->mnt_ns.
>> >> Let me remind about the coredump. The dumping task can cloned with
>> >> CLONE_NEWNS or it cam do unshare(NEWNS)... but OK, I do not understand
>> >> this enough.
>> >
>> > And otoh. If we actually want to use the caller's mnt_ns/namespaces we
>> > could simply fork/reparent a child which will do execve ?
>> 
>> That would certainly be a better approach, and roughly equivalent to
>> what exists here.  That would even ensure we remain in the proper
>> cgroups, and lsm context.
>> 
>> The practical problem with the approach presented here is that I can
>> hijack any user mode helper I wish, and make it run in any executable I
>> wish as the global root user.
>> 
>> Ian if we were to merge this I believe you would win the award for
>> easiest path to a root shell.
>
> LOL, OK, so there's a problem with this.
>
> But, how should a user mode helper execute within a namespace (or more
> specifically within a container)?
>
> Suppose a user mode helper program scans through the pid list and
> somehow picks the correct process pid and then does an
> open()/setns()/execve().
>
> Does that then satisfy the requirements?
> What needs to be done to safely do that in kernel?
>
> The other approach I've considered is doing a full open()/setns() in
> kernel (since the caller already knows its pid) but it sounds like
> that's not right either.

The approach we agreed upon with the core dump helper was to provide
enough information that userspace could figure out what was the
appropriate policy and call nsenter/setns.

The only sane approach I can think of in the context of nfs is to fork
a kernel thread at mount time that has all of the appropriate context
because it was captured from the privileged mounting process, and use
that kernel as the equivalent of kthreadd.

There may be some intermediate ground where we capture things or we use
the init process of the pid namespace (captured at mount time) as our
template/reference process.

If we are going to set this stuff up in the kernel we need a reference
process that we can create children of because what is possible with
respect to containers keeps changing, and it is extremely error prone to
figure out what all othe crazy little bits are, and to update everything
every time someone tweaks the kernel's capabilities.  We have kthreadd
because it was too error prone to scrub a userspace thread of all of the
userspace bits and make it the equivalent of what kthreadd is today.

Of course it is also rather nice to have something to hang everything
else on.

In summary we need a reference struct task that is all setup properly
so that we can create an appropriate kernel thread.

Eric
