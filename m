Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbaIYSGF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 14:06:05 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:46538 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbaIYSGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 14:06:02 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        fuse-devel <fuse-devel@lists.sourceforge.net>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>
References: <1409672696-15847-1-git-send-email-seth.forshee@canonical.com>
	<20140910123525.GA29064@ubuntu-hedt>
	<20140910162155.GA7748@mail.hallyn.com>
	<20140910164212.GA32587@ubuntu-hedt>
	<20140911181034.GA58733@ubuntu-hedt>
	<87d2am3r8a.fsf@x220.int.ebiederm.org>
	<20140924132925.GA48721@ubuntu-hedt>
	<87y4t9ndw5.fsf@x220.int.ebiederm.org>
	<CAJfpegs3QNdKMZWmN324OqHFw+e2qwU9kfkQ491==yP_JRrcWw@mail.gmail.com>
Date: Thu, 25 Sep 2014 11:05:36 -0700
In-Reply-To: <CAJfpegs3QNdKMZWmN324OqHFw+e2qwU9kfkQ491==yP_JRrcWw@mail.gmail.com>
	(Miklos Szeredi's message of "Thu, 25 Sep 2014 17:04:04 +0200")
Message-ID: <87wq8reftb.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19SadiGJxFI5bF4DHpEsq/4tqDY2zVfwJA=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.4 XM_Superlative01 Best-rated language
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4924]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Miklos Szeredi <miklos@szeredi.hu>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v2 0/3] fuse: Add support for mounts from pid/user namespaces
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> writes:

> On Wed, Sep 24, 2014 at 7:10 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>
>
>> So in summary I see:
>> - Low utility in being able to manipulate files with bad uids.
>> - Bad uids are mostly likely malicious action.
>> - make_bad_inode is trivial to analyze.
>> - No impediments to change if I am wrong.
>>
>> So unless there is a compelling case, right now I would recommend
>> returning -EIO initially.   That allows us to concentrate on the easier
>> parts of this and it leaves the changes only in fuse.
>
> The problem with marking the inode bad is that it will mark it bad for
> all instances of this filesystem.  Including ones which are in a
> namespace where the UIDs make perfect sense.

There are two cases:
app <-> fuse
fuse <-> server

I proposed mark_bad_inode for "userspace server -> fuse".
Where we have one superblock and one server so and one namespace that
they decide to talk in when the filesystem was mounted.

I think bad_inode is a reasonable response when the filesystem server
starts spewing non-sense.

> So that really doesn't look like a good solution.
>
> Doing the check in inode_permission() might be too heavyweight, but
> it's still the only one that looks sane.

For the "app <-> fuse" case we already have checks in inode_permision
that are kuid based that handle that case.  We use kuids not for
performance (although there is a small advatnage) but to much more to
keep the logic simple and maintainable.


For the "app -> fuse" case in .setattr we do need a check to verify
that the uid and gid are valid.  However that check was added with
the basic user namespace support and fuse current returns -EOVERFLOW
when that happens.

Eric
