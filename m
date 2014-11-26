Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204AbaKZBjg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 20:39:36 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:39967 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbaKZBjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 20:39:35 -0500
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
	<871toq7tr6.fsf@x220.int.ebiederm.org>
	<1416959452.2509.52.camel@pluto.fritz.box>
Date: Tue, 25 Nov 2014 19:38:17 -0600
In-Reply-To: <1416959452.2509.52.camel@pluto.fritz.box> (Ian Kent's message of
	"Wed, 26 Nov 2014 07:50:52 +0800")
Message-ID: <87egsq3fna.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19o6KbBlBjllwR2Jiv7YAxj0XedLTeJ9Tg=
X-SA-Exim-Connect-IP: 97.121.92.161
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  0.7 XMSubLong Long Subject
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.0 T_TooManySym_04 7+ unique symbols in subject
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Ian Kent <ikent@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 471 ms - load_scoreonly_sql: 0.06 (0.0%),
	signal_user_changed: 4.5 (0.9%), b_tie_ro: 3.2 (0.7%), parse: 1.49 (0.3%),
	extract_message_metadata: 10 (2.2%), get_uri_detail_list: 7 (1.6%),
	tests_pri_-1000: 3.6 (0.8%), tests_pri_-950: 1.24 (0.3%), tests_pri_-900:
	1.02 (0.2%), tests_pri_-400: 34 (7.2%), check_bayes: 32 (6.9%), b_tokenize:
	10 (2.1%), b_tok_get_all: 12 (2.5%), b_comp_prob: 5 (1.1%), b_tok_touch_all:
	3.0 (0.6%), b_finish: 0.88 (0.2%), tests_pri_0: 397 (84.2%), tests_pri_500:
	4.9 (1.0%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [RFC PATCH 3/4] kmod - add call_usermodehelper_ns() helper
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Kent <ikent@redhat.com> writes:

> On Tue, 2014-11-25 at 17:19 -0600, Eric W. Biederman wrote:
>> Ian Kent <ikent@redhat.com> writes:
>> 
>> > On Tue, 2014-11-25 at 16:23 -0600, Eric W. Biederman wrote:
>> >> Oleg Nesterov <oleg@redhat.com> writes:
>> >> 
>> >> > On 11/25, Oleg Nesterov wrote:
>> >> >>
>> >> >> Let me first apologize, I didn't actually read this series yet.
>> >> >>
>> >> >> But I have to admit that so far I do not like this approach...
>> >> >> probably I am biased.
>> >> >
>> >> > Yes.
>> >> >
>> >> > And I have another concern... this is mostly a feeling, I can be
>> >> > easily wrong but:
>> >> >
>> >> >> On 11/25, Ian Kent wrote:
>> >> >> >
>> >> >> > +static int umh_set_ns(struct subprocess_info *info, struct cred *new)
>> >> >> > +{
>> >> >> > +	struct nsproxy *ns = info->data;
>> >> >> > +
>> >> >> > +	mntns_setfs(ns->mnt_ns);
>> >> >>
>> >> >> Firstly, it is not clear to me if we should use the caller's ->mnt_ns.
>> >> >> Let me remind about the coredump. The dumping task can cloned with
>> >> >> CLONE_NEWNS or it cam do unshare(NEWNS)... but OK, I do not understand
>> >> >> this enough.
>> >> >
>> >> > And otoh. If we actually want to use the caller's mnt_ns/namespaces we
>> >> > could simply fork/reparent a child which will do execve ?
>> >> 
>> >> That would certainly be a better approach, and roughly equivalent to
>> >> what exists here.  That would even ensure we remain in the proper
>> >> cgroups, and lsm context.
>> >> 
>> >> The practical problem with the approach presented here is that I can
>> >> hijack any user mode helper I wish, and make it run in any executable I
>> >> wish as the global root user.
>> >> 
>> >> Ian if we were to merge this I believe you would win the award for
>> >> easiest path to a root shell.
>> >
>> > LOL, OK, so there's a problem with this.
>> >
>> > But, how should a user mode helper execute within a namespace (or more
>> > specifically within a container)?
>> >
>> > Suppose a user mode helper program scans through the pid list and
>> > somehow picks the correct process pid and then does an
>> > open()/setns()/execve().
>> >
>> > Does that then satisfy the requirements?
>> > What needs to be done to safely do that in kernel?
>> >
>> > The other approach I've considered is doing a full open()/setns() in
>> > kernel (since the caller already knows its pid) but it sounds like
>> > that's not right either.
>> 
>> The approach we agreed upon with the core dump helper was to provide
>> enough information that userspace could figure out what was the
>> appropriate policy and call nsenter/setns.
>
> Your recommending I have a look at the core dump helper, that's fine,
> I'll do that.

I am just describing it because it came up.  Core dumps are a much
easier case than nfs.

Frankly if we can figure out how to run the user mode helpers from the
kernel with an appropriate context and not involve userspace I think
that will be better for everyone, as it involves fewer moving parts at
the end of the day.

>> The only sane approach I can think of in the context of nfs is to fork
>> a kernel thread at mount time that has all of the appropriate context
>> because it was captured from the privileged mounting process, and use
>> that kernel as the equivalent of kthreadd.
>> 
>> There may be some intermediate ground where we capture things or we use
>> the init process of the pid namespace (captured at mount time) as our
>> template/reference process.
>> 
>> If we are going to set this stuff up in the kernel we need a reference
>> process that we can create children of because what is possible with
>> respect to containers keeps changing, and it is extremely error prone to
>> figure out what all othe crazy little bits are, and to update everything
>> every time someone tweaks the kernel's capabilities.  We have kthreadd
>> because it was too error prone to scrub a userspace thread of all of the
>> userspace bits and make it the equivalent of what kthreadd is today.
>> 
>> Of course it is also rather nice to have something to hang everything
>> else on.
>> 
>> In summary we need a reference struct task that is all setup properly
>> so that we can create an appropriate kernel thread.
>
> I'm having trouble understanding what your getting at here but I'm not
> that sharp so bear with me.
>
> When call_usermodehelper() is called it's called from a process that is
> within the context within which the execution is required.

No it is not.  That is precisely why we have call_usermodehelper instead
of just forking and exec'ing something.  The context which triggers the
call can be completely different from where you want to run.

> So what information do we not have available for setup?
>
> Are you saying that the problem is that when the user mode helper run
> thread is invoked we don't have the information available that was
> present when call_usermodehelper() was called and that's where the
> challenge lies?

That is part of it.

However in the context of nfs the correct context is determined at mount
time, and so when call_usermodehelper() is invoked the only link to that
correct context that we have is the nfs super block.

In a pathological case a userspace application can create a new user
namespace, and a new mount namespace and completely rearrange the
mounts, and deliberately trigger an nfs user mode helper.  If we were to
use that applications context it could control which userspace
application the kernel invoked.

So deeply and fundamentally for the case of nfs you need to capture the
context at nfs mount time.  The easiest way would be to fork a kernel
thread when nfs is mounted, that captures the entire context.

We might be able to do something a little more sophisticated and a
little less resource intensive, like pick on the init process that
exists when nfs is mounted.

Those are the general parameters.

Eric
