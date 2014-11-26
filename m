Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978AbaKZPBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 10:01:34 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:41974 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbaKZPBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 10:01:32 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: David Howells <dhowells@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Ian Kent <ikent@redhat.com>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
References: <87y4qy7wci.fsf@x220.int.ebiederm.org>
	<20141125005255.4974.54193.stgit@pluto.fritz.box>
	<20141125010734.4974.85347.stgit@pluto.fritz.box>
	<20141125215248.GA7958@redhat.com> <20141125220637.GA10008@redhat.com>
	<1369.1417002382@warthog.procyon.org.uk>
Date: Wed, 26 Nov 2014 09:00:11 -0600
In-Reply-To: <1369.1417002382@warthog.procyon.org.uk> (David Howells's message
	of "Wed, 26 Nov 2014 11:46:22 +0000")
Message-ID: <87k32i0zyc.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18U07soYfm+bdxmWetv+gVuGfwEXCFS5E8=
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
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.0 T_TooManySym_04 7+ unique symbols in subject
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;David Howells <dhowells@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 429 ms - load_scoreonly_sql: 0.04 (0.0%),
	signal_user_changed: 2.9 (0.7%), b_tie_ro: 2.0 (0.5%), parse: 0.60 (0.1%),
	extract_message_metadata: 15 (3.4%), get_uri_detail_list: 1.35 (0.3%),
	tests_pri_-1000: 4.3 (1.0%), tests_pri_-950: 1.72 (0.4%), tests_pri_-900:
	1.45 (0.3%), tests_pri_-400: 27 (6.4%), check_bayes: 26 (6.0%), b_tokenize: 8
	(1.8%), b_tok_get_all: 9 (2.0%), b_comp_prob: 2.7 (0.6%), b_tok_touch_all:
	2.2 (0.5%), b_finish: 0.68 (0.2%), tests_pri_0: 368 (85.8%), tests_pri_500:
	4.8 (1.1%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [RFC PATCH 3/4] kmod - add call_usermodehelper_ns() helper
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> writes:

> Eric W. Biederman <ebiederm@xmission.com> wrote:
>
>> Ian if we were to merge this I believe you would win the award for
>> easiest path to a root shell.
>
> Is there any particular reason the upcalled program has to be run as root?
> Could the kernel not run it as something else - perhaps the caller's UID,GID
> or even something anonymous?
>
> Also, call_sbin_request_key() could be given a parameter to call something
> other than /sbin/request-key, and key_type::request_key could be used.

Fundamentally the upcall needs to happen with enough privileges to do
the job, and that means running in practice running as root in the
appropriate context.  If we didn't need to gain privileges we wouldn't
need an upcall.

In the code I was critisizing struct cred was not being changed because
of what I believe was an ignorance of what task->nsproxy was about and
is for.

It is straight forward to save off a for a kernel thread from the
process calling mount and make it responsible for the upcall and use
that as the parent for all of the containerized upcalls, and we could
easily run with that threads permissions.

We can't use the context of the triggering user but we instead need to
use the context of the mounter of the filesystem.  As otherwise the
triggering user can control what is /sbin/request-key and cause problems
that way.

Eric
