Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924AbaKYWZU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 17:25:20 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:45801 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbaKYWZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 17:25:15 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ian Kent <ikent@redhat.com>,
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
Date: Tue, 25 Nov 2014 16:23:57 -0600
In-Reply-To: <20141125220637.GA10008@redhat.com> (Oleg Nesterov's message of
	"Tue, 25 Nov 2014 23:06:37 +0100")
Message-ID: <87y4qy7wci.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/XuBUCRl9J3lnNiXw95t6wHNqp/hZ3pFY=
X-SA-Exim-Connect-IP: 97.121.92.161
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  0.7 XMSubLong Long Subject
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4998]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.0 T_TooManySym_04 7+ unique symbols in subject
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 232 ms - load_scoreonly_sql: 0.03 (0.0%),
	signal_user_changed: 2.8 (1.2%), b_tie_ro: 2.0 (0.9%), parse: 0.56 (0.2%),
	extract_message_metadata: 2.2 (0.9%), get_uri_detail_list: 0.90 (0.4%),
	tests_pri_-1000: 3.0 (1.3%), tests_pri_-950: 1.04 (0.4%), tests_pri_-900:
	0.85 (0.4%), tests_pri_-400: 17 (7.4%), check_bayes: 16 (7.0%), b_tokenize:
	4.4 (1.9%), b_tok_get_all: 6 (2.6%), b_comp_prob: 1.54 (0.7%),
	b_tok_touch_all: 2.4 (1.0%), b_finish: 0.63 (0.3%), tests_pri_0: 193 (83.1%),
	tests_pri_500: 4.1 (1.7%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [RFC PATCH 3/4] kmod - add call_usermodehelper_ns() helper
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> On 11/25, Oleg Nesterov wrote:
>>
>> Let me first apologize, I didn't actually read this series yet.
>>
>> But I have to admit that so far I do not like this approach...
>> probably I am biased.
>
> Yes.
>
> And I have another concern... this is mostly a feeling, I can be
> easily wrong but:
>
>> On 11/25, Ian Kent wrote:
>> >
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
>
> And otoh. If we actually want to use the caller's mnt_ns/namespaces we
> could simply fork/reparent a child which will do execve ?

That would certainly be a better approach, and roughly equivalent to
what exists here.  That would even ensure we remain in the proper
cgroups, and lsm context.

The practical problem with the approach presented here is that I can
hijack any user mode helper I wish, and make it run in any executable I
wish as the global root user.

Ian if we were to merge this I believe you would win the award for
easiest path to a root shell.

Eric

