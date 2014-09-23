Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756969AbaIWVrQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 17:47:16 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:58559 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755694AbaIWVrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 17:47:14 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        fuse-devel <fuse-devel@lists.sourceforge.net>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>
References: <1409672696-15847-1-git-send-email-seth.forshee@canonical.com>
	<CAJfpegv4RJzWV7=oHvyUWqUnJYk8JHrQsiKfJ5AMRFRaN3frxw@mail.gmail.com>
	<20140923162622.GA28059@ubuntu-hedt>
	<CAJfpeguw9LhU4Zf0iE3_ZbeYM=-F61rFpWp=FebngrMgdTCwng@mail.gmail.com>
Date: Tue, 23 Sep 2014 14:46:52 -0700
In-Reply-To: <CAJfpeguw9LhU4Zf0iE3_ZbeYM=-F61rFpWp=FebngrMgdTCwng@mail.gmail.com>
	(Miklos Szeredi's message of "Tue, 23 Sep 2014 19:03:47 +0200")
Message-ID: <87egv26mcz.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1954UEs9P4Vt0771OJwCKFJ5h5qywcIfpQ=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.4 XM_Superlative01 Best-rated language
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3924]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Miklos Szeredi <miklos@szeredi.hu>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v2 0/3] fuse: Add support for mounts from pid/user namespaces
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> writes:

> On Tue, Sep 23, 2014 at 6:26 PM, Seth Forshee
> <seth.forshee@canonical.com> wrote:
>> On Tue, Sep 23, 2014 at 06:07:35PM +0200, Miklos Szeredi wrote:
>>> On Tue, Sep 2, 2014 at 5:44 PM, Seth Forshee <seth.forshee@canonical.com> wrote:
>>> > Here's an updated set of patches for allowing fuse mounts from pid and
>>> > user namespaces. I discussed some of the issues we debated with the last
>>> > patch set (and a few others) with Eric at LinuxCon, and the updates here
>>> > mainly reflect the outcome of those discussions.
>>> >
>>> > The stickiest issue in the v1 patches was the question of where to get
>>> > the user and pid namespaces from that are used for translating ids for
>>> > communication with userspace. Eric told me that for user namespaces at
>>> > least we need to grab a namespace at open or mount time and use only
>>> > that namespace to prevent certain types of attacks.
>>>
>>> I'm not convinced.  Let us have the gory details, please.
>>
>> I'll do my best, and hopefully Eric will fill in any details I miss.
>>
>> I think there may have been more than one possible scenario that Eric
>> was describing to me, but this is the one I remember. A user could
>> create a namespace and mount a fuse filesystem without nosuid. It could
>> then pass the /dev/fuse fd to a process in init_user_ns, which could
>> expose a suid file owned by root (or any other user) and use it to gain
>> elevated privileges.
>>
>> On the other hand, if file ownership is always interpreted in the
>> context of the namespace from which the filesystem is mounted then suid
>> can only be used to become another uid already under that user's
>> control.
>
> Much simpler solution: don't allow SUID in unprivileged namespaces.
> SUID is a really ugly hack with many problems, just get rid of it.

Except that doesn't solve the problem.

The core problem is how do we avoid allowing letting a processes
implementing a fuse filesystem to manipulate a process with privileges
that it does not.

The classic fuse solution to this is to only allow a single uid to
access the fuse filesystem.

With user namespaces we can relax that restriction when mounted with
just user namespace root permissions to allow a filesystem to use any
uids mapped into the user namespace, as the mounter of the filesystem.
The user namespace root that is mounting the filesystem already has
privileges to manipulate those users already.

Which means the simple straight forward and understandable restriction
to enforce is:

- The user namespace of the opener of /dev/fuse is the same as
  the user namespace the fuse filesystem is mounted in is the same as
  the user namespace we translate any uids in and out of.

By forbidding all uid s and gids not mapped into a user namespace from
being used you can not manipulate processes you would not be able to
manipulate before.

As a nice side effect that happens to make having the setuid bit set
something of a fuse filesystem something that is uninteresting.  At
that point the setuid bit being set is no more dangerous than the setuid
being being set on any file you own.

Eric
