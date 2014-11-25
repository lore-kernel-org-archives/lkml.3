Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706AbaKYX2z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 18:28:55 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:37481 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbaKYX2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 18:28:54 -0500
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
	<20141125215248.GA7958@redhat.com>
	<1416954967.2509.25.camel@pluto.fritz.box>
Date: Tue, 25 Nov 2014 17:27:36 -0600
In-Reply-To: <1416954967.2509.25.camel@pluto.fritz.box> (Ian Kent's message of
	"Wed, 26 Nov 2014 06:36:07 +0800")
Message-ID: <87egsq6etz.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18+pmptMH/iPwKICmaSWopLcXiXVaWbfoE=
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
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.0 T_TooManySym_04 7+ unique symbols in subject
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Ian Kent <ikent@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 1350 ms - load_scoreonly_sql: 0.03 (0.0%),
	signal_user_changed: 7 (0.5%), b_tie_ro: 5 (0.4%), parse: 0.63 (0.0%),
	extract_message_metadata: 12 (0.9%), get_uri_detail_list: 2.4 (0.2%),
	tests_pri_-1000: 3.9 (0.3%), tests_pri_-950: 1.26 (0.1%), tests_pri_-900:
	1.05 (0.1%), tests_pri_-400: 26 (1.9%), check_bayes: 24 (1.8%), b_tokenize: 7
	(0.5%), b_tok_get_all: 10 (0.7%), b_comp_prob: 2.6 (0.2%), b_tok_touch_all:
	2.5 (0.2%), b_finish: 0.62 (0.0%), tests_pri_0: 320 (23.7%), tests_pri_500:
	975 (72.2%), poll_dns_idle: 965 (71.5%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [RFC PATCH 3/4] kmod - add call_usermodehelper_ns() helper
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Kent <ikent@redhat.com> writes:

> On Tue, 2014-11-25 at 22:52 +0100, Oleg Nesterov wrote:
>> Let me first apologize, I didn't actually read this series yet.
>> 
>> But I have to admit that so far I do not like this approach...
>> probably I am biased.
>
> Oleg, thanks for your comments.
>
>> 
>> On 11/25, Ian Kent wrote:
>> >
>> > The call_usermodehelper() function executes all binaries in the
>> > global "init" root context. This doesn't allow a binary to be run
>> > within the callers namespace (aka. a container).
>> 
>> Please see below.
>> 
>> > Both containerized NFS client and NFS server need the ability to
>> > execute a binary within their container. To do this create a new
>> > nsproxy within the callers' context so it can be used for setup
>> > prior to calling do_execve() from the user mode helper thread
>> > runner.
>> 
>> and probably we also need this for coredump helpers, we want them
>> to be per-namespace.
>
> To save me some time could you point me to some of the related code
> please. I don't normally play in that area.
>
>> 
>> > +static int umh_set_ns(struct subprocess_info *info, struct cred *new)
>> > +{
>> > +	struct nsproxy *ns = info->data;
>> > +
>> > +	mntns_setfs(ns->mnt_ns);
>> 
>> Firstly, it is not clear to me if we should use the caller's ->mnt_ns.
>> Let me remind about the coredump. The dumping task can cloned with
>> CLONE_NEWNS or it cam do unshare(NEWNS)... but OK, I do not understand
>> this enough.
>> 
>> 
>> > +	switch_task_namespaces(current, ns);
>> 
>> This doesn't look sane because this won't switch task_active_pid_ns().
>
> I wondered about that too but I didn't design the open()/setns()
> interface and TBH I've been wondering how he hell it is supposed to work
> because of exactly this.
>
> The statement amounts to saying that the
> fd = open(/proc/<pid in target namespace>/ns/mnt);
> setns(fd);
> won't set the namespace properly but the documentation I've seen so far
> (there's probably more that I need to see, I'll look further) implies
> this is sufficient.

It is but it is a bit peculiar.

> How does one correctly set the namespace in user space since each of
> the /proc/<pid>/ns/<namespace> will use a slightly different
> proc_ns_operations install function? 
>
> Are we saying that, for example, if open(/proc/<pid>/ns/pid)/setns() is
> used then the process must not do path lookups if it expects them to be
> within the namespace and restrict itself to pid related system calls
> only and so on for each of the other namespaces?

In userspace you can only set the pid namespace for new children.  You
can never change your own pid namespace.  Because actually changing a
processes pid is too nasty to contemplate, or implement and because in a
login daemon context having your first child be the initial process of
the pid namespace is actually what is desirable.

> Or is it assumed that userspace will do
> open(/proc/<pid>/ns/<namespace>)/setns()/close() every time it makes
> systems calls that rely on a specific type of namespace?

setns is designed to be the exception, rather thant something you need
to do every time.

But nsproxy is not the one true source of namespaces, nsproxy is simply
a convinient place so we don't bloat struct task.  The primary reference
for the pid namespace is in a struct pid, what is in nsproxy is just
which pid namespace children will be created in.  The user namespace
reference comes from struct cred.

>> And this reminds me another discussion, please look at
>> http://marc.info/?l=linux-kernel&m=138479570926192
>> 
>> Once again, this is just an idea to provoke more discussion. I am starting
>> to think that perhaps we need pid_ns->umh_helper (init by default). And
>> PR_SET_NS_UMH_HELPER.
>
> Yeah, I'll need to digest that for a while.

Eric
