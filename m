Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386AbaJHTY2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 15:24:28 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:50380 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036AbaJHTY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 15:24:26 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andrew Vagin <avagin@parallels.com>, Andrey Vagin <avagin@openvz.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>, Andrey Vagin <avagin@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Rob Landley <rob@landley.net>
References: <1412683977-29543-1-git-send-email-avagin@openvz.org>
	<87mw97wqvx.fsf@x220.int.ebiederm.org>
	<20141008110829.GC24908@paralelels.com>
	<CALCETrX4XrgbQNZZa7=1009KqhJ2gT+VBUkC15+59K9yEiTSbQ@mail.gmail.com>
Date: Wed, 08 Oct 2014 12:23:52 -0700
In-Reply-To: <CALCETrX4XrgbQNZZa7=1009KqhJ2gT+VBUkC15+59K9yEiTSbQ@mail.gmail.com>
	(Andy Lutomirski's message of "Wed, 8 Oct 2014 08:35:22 -0700")
Message-ID: <87vbnue56f.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19nI/Yqyu8hhHaR+OQhi9ZmlblwVnkimfg=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.2337]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andy Lutomirski <luto@amacapital.net>
X-Spam-Relay-Country: 
X-Spam-Timing: total 529 ms - load_scoreonly_sql: 0.03 (0.0%),
	signal_user_changed: 2.8 (0.5%), b_tie_ro: 2.0 (0.4%), parse: 0.60 (0.1%),
	extract_message_metadata: 14 (2.7%), get_uri_detail_list: 1.81 (0.3%),
	tests_pri_-1000: 6 (1.1%), tests_pri_-950: 1.02 (0.2%), tests_pri_-900: 0.89
	(0.2%), tests_pri_-400: 22 (4.2%), check_bayes: 21 (4.0%), b_tokenize: 6
	(1.1%), b_tok_get_all: 8 (1.6%), b_comp_prob: 2.0 (0.4%), b_tok_touch_all:
	3.1 (0.6%), b_finish: 0.62 (0.1%), tests_pri_0: 475 (89.7%), tests_pri_500:
	4.2 (0.8%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH] [RFC] mnt: add ability to clone mntns starting with the current root
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:

> On Wed, Oct 8, 2014 at 4:08 AM, Andrew Vagin <avagin@parallels.com> wrote:
>> On Tue, Oct 07, 2014 at 01:45:22PM -0700, Eric W. Biederman wrote:
>>> Andrey Vagin <avagin@openvz.org> writes:
>>>
>>> > From: Andrey Vagin <avagin@gmail.com>
>>> >
>>> > Currently when we create a new container with a separate root,
>>> > we need to clone the current mount namespace with all mounts and then
>>> > clean up it by using pivot_root(). A big part of mountpoints are cloned
>>> > only to be umounted.
>>>
>>> Is the motivation performance?  Because if that is the motivation we
>>> need numbers.
>>
>> The major motivation to create a clean mount namespace which contains
>> only required mounts.
>>
>> Now you want to convince us that there is nothing wrong if we use
>> userns, because all inherited mounts are locked. My point is that all
>> useless mounts should be umounted.  If the current root isn't on rootfs,
>> pivot_root() allows us to umount all useless points. But pivot_root()
>> doesn't work, if the current root is on rootfs. How can we umount
>> useless points in this case?

One of your justifications for a new system call was so you could do
less.  Doing less to get to where you want to go is only justified when
your doing less to get better performance.

It sounds like your actual concern is about sandboxing and security
audits.  That is a very legitimate concern.  That isn't however the core
concern of containers, so it was not clear that is what you meant.

>> Maybe we want to say that rootfs should not be used if we are going to
>> create containers...

Today it is an assumption of the vfs that rootfs is mounted.  With
rootfs mounted and pivot_root at the base of the mount stack you can
make as minimal of a set of mounts as the vfs allows.

Removing rootfs from the vfs requires an audit of everything that
manipulates mounts.  It is not remotely a local excercise.

One of the things that needs to be considered is that if you really want
to audit mounts is the code that needs manipulates them needs to be
audited every bit as much as the mounts themselves.

> Could we have an extra rootfs-like fs that is always completely empty,
> doesn't allow any writes, and can sit at the bottom of container
> namespace hierarchies?  If so, and if we add a new syscall that's like
> pivot_root (or unshare) but prunes the hierarchy, then we could switch
> to that rootfs then.

Or equally have something that guarantees that rootfs is empty and
read-only at the time the normal root filesystem is mounted.  That is
certainly a much more localized change if we want to go there.

I am half tempted to suggest that mount --move /some/path / be updated
to make the old / just go away (perhaps to be replaced with a read-only
empty rootfs).  That gets us into figuring out if we break userspace
which is a big challenge.

Eric
