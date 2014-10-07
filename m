Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073AbaJGV0f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 17:26:35 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:43060 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172AbaJGV0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 17:26:33 -0400
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
Date: Tue, 07 Oct 2014 14:26:00 -0700
In-Reply-To: <CALCETrXgssZfi3BirQ=K7-vrPyEh5AzFX2pF+yj76Ngi0sf7Yw@mail.gmail.com>
	(Andy Lutomirski's message of "Tue, 7 Oct 2014 14:02:53 -0700")
Message-ID: <87siizshav.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18y7jht3ZYUD6EuBq0BPwBLZj8FToq0u9g=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3124]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andy Lutomirski <luto@amacapital.net>
X-Spam-Relay-Country: 
X-Spam-Timing: total 187 ms - load_scoreonly_sql: 0.06 (0.0%),
	signal_user_changed: 3.0 (1.6%), b_tie_ro: 2.1 (1.1%), parse: 0.76 (0.4%),
	extract_message_metadata: 11 (5.8%), get_uri_detail_list: 0.91 (0.5%),
	tests_pri_-1000: 5 (2.9%), tests_pri_-950: 1.13 (0.6%), tests_pri_-900: 0.91
	(0.5%), tests_pri_-400: 16 (8.8%), check_bayes: 16 (8.3%), b_tokenize: 4.5
	(2.4%), b_tok_get_all: 6 (3.1%), b_comp_prob: 1.56 (0.8%), b_tok_touch_all:
	1.74 (0.9%), b_finish: 0.60 (0.3%), tests_pri_0: 140 (75.1%), tests_pri_500:
	4.9 (2.6%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH] [RFC] mnt: add ability to clone mntns starting with the current root
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:

> Why should MNT_LOCKED on submounts be enforced?
>
> Is it because, if you retain a reference to the detached tree, then
> you can see under the submounts?  

Yes. MNT_DETACH is a recursive operation that detaches all of the mount
and all of it's submounts.  Which means you can see under the submounts
if you have a reference to a detached mount.

> If so, let's fix *that*.  Because
> otherwise the whole model of pivot_root + detach will break.

I am not certain what you are referring to.  pivot_root doesn't
manipulate the mount tree so you can see under anything.

What I believe is the appropriate fix is to fail umount2(...,MNT_DETACH)
if there are any referenced mount points being detached that have a
locked submount.

> Also, damn it, we need change_the_ns_root instead of pivot_root.  I
> doubt that any container programs actually want to keep the old root
> attached after pivot_root.

Shrug.  Except for chroot_fs_refs() pivot_root is a cheap.

I'm not particularly in favor of merging pivot_root and umount2.  The
number of weird cases in the current api are high.  A merged piece of
code would just make them higher.

I am hoping that one more round of bug fixing will at least get the bugs
for having unprivileged mounts fixed in the current API.

Eric
