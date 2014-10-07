Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244AbaJGUbi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 16:31:38 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:50084 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbaJGUbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 16:31:35 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrey Vagin <avagin@openvz.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        Andrey Vagin <avagin@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Rob Landley <rob@landley.net>
References: <1412683977-29543-1-git-send-email-avagin@openvz.org>
	<20141007133039.GG7996@ZenIV.linux.org.uk>
	<20141007133339.GH7996@ZenIV.linux.org.uk>
Date: Tue, 07 Oct 2014 13:30:57 -0700
In-Reply-To: <20141007133339.GH7996@ZenIV.linux.org.uk> (Al Viro's message of
	"Tue, 7 Oct 2014 14:33:39 +0100")
Message-ID: <87r3yjy64e.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/CLgHjiz3Hw2rvAdm4lgqgfL7KaKzwIrg=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.2582]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Al Viro <viro@ZenIV.linux.org.uk>
X-Spam-Relay-Country: 
X-Spam-Timing: total 248 ms - load_scoreonly_sql: 0.04 (0.0%),
	signal_user_changed: 2.8 (1.1%), b_tie_ro: 2.1 (0.9%), parse: 0.66 (0.3%),
	extract_message_metadata: 11 (4.4%), get_uri_detail_list: 1.61 (0.7%),
	tests_pri_-1000: 5.0 (2.0%), tests_pri_-950: 1.09 (0.4%), tests_pri_-900:
	0.91 (0.4%), tests_pri_-400: 22 (8.7%), check_bayes: 21 (8.3%), b_tokenize: 6
	(2.4%), b_tok_get_all: 9 (3.4%), b_comp_prob: 2.0 (0.8%), b_tok_touch_all:
	2.3 (0.9%), b_finish: 0.62 (0.3%), tests_pri_0: 199 (80.1%), tests_pri_500:
	3.7 (1.5%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH] [RFC] mnt: add ability to clone mntns starting with the current root
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

2> On Tue, Oct 07, 2014 at 02:30:40PM +0100, Al Viro wrote:
>> On Tue, Oct 07, 2014 at 04:12:57PM +0400, Andrey Vagin wrote:
>> > Another problem is that rootfs can't be hidden from a container, because
>> > rootfs can't be moved or umounted.
>> 
>> ... which is a bug in mntns_install(), AFAICS.
>
> Ability to get to exposed rootfs, that is.

The container side of this argument is pretty bogus.  It only applies
if user namespaces are not used for the container.

So it is only root (and not root in a container) who can get to the
exposed rootfs.

I have a vague memory someone actually had a real use in miminal systems
for being able to get back to the rootfs and being able to use rootfs as
the rootfs.  There was even a patch at that time that Andrew Morton was
carrying for a time to allow unmounting root and get at rootfs, and to
prevent the oops on rootfs unmount in some way.

So not only do I not think it is a bug to get back too rootfs, I think
it is a feature that some people have expressed at least half-way sane
uses for.

>> > Here is an example how to get access to rootfs:
>> > fd = open("/proc/self/ns/mnt", O_RDONLY)
>> > umount2("/", MNT_DETACH);
>> > setns(fd, CLONE_NEWNS)
>> > 
>> > rootfs may contain data, which should not be avaliable in CT-s.
>> 
>> Indeed.
>
> ... and it looks like the above is what your mangled reproducer in previous
> patch had been made of -
> 	fd = open("/proc/self/ns/mnt", O_RDONLY)
> 	umount2("/", MNT_DETACH);
> 	setns(fd, CLONE_NEWNS)
> 	umount2("/", MNT_DETACH);
>
> IMO what it shows is setns() bug.  This "switch root/cwd, no matter what"
> is wrong.

IMO the bug is allowing us to unmount things that should never be unmounted.

In a mount namespace created with just user namespace permissions we
can't get at rootfs because MNT_LOCKED is set on the root directory
and thus it can not be mounted.

Further if anyone has permission to call chroot and chdir on any mount
in a mount namespace (that isn't currently covered) they can get at all
of them that are not currently covered.  A mount namespace where no one
can get at any uncovered filesystem seems to be the definition of
useless and ridiculous.


Now there is a bug in that MNT_DETACH today does not currently enforce
MNT_LOCKED on submounts of the mount point that is detached. I am
currently looking at how to construct the appropriate permission check
to prevent that.  Unfortunately I can not disallow MNT_DETACH with
submounts all together as that breaks too many legitimate uses.

That failure to enforce MNT_LOCKED is my mistake. I had a naive notion
that submounts would remain mounted after a mount detach and I misread
the code when I did the original work.  My mistake. 

Eric
