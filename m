Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662AbaFCRzf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 13:55:35 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:37792 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845AbaFCRzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 13:55:33 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: Pavel Emelyanov <xemul@parallels.com>, Marian Marinov <mm@1h.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        LXC development mailing-list 
	<lxc-devel@lists.linuxcontainers.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <5386D58D.2080809@1h.com> <87tx88nbko.fsf@x220.int.ebiederm.org>
	<53870EAA.4060101@1h.com> <20140529153232.GB9714@ubuntumail>
	<538DFF72.7000209@parallels.com> <20140603172631.GL9714@ubuntumail>
Date: Tue, 03 Jun 2014 10:54:27 -0700
In-Reply-To: <20140603172631.GL9714@ubuntumail> (Serge Hallyn's message of
	"Tue, 3 Jun 2014 17:26:31 +0000")
Message-ID: <8738flkhf0.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+hj/zGNt8NHREsb9KkLxEiSVoB2zhcneU=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Serge Hallyn <serge.hallyn@ubuntu.com>
X-Spam-Relay-Country: 
Subject: Re: [RFC] Per-user namespace process accounting
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge Hallyn <serge.hallyn@ubuntu.com> writes:

> Quoting Pavel Emelyanov (xemul@parallels.com):
>> On 05/29/2014 07:32 PM, Serge Hallyn wrote:
>> > Quoting Marian Marinov (mm@1h.com):
>> >> We are not using NFS. We are using a shared block storage that offers us snapshots. So provisioning new containers is
>> >> extremely cheep and fast. Comparing that with untar is comparing a race car with Smart. Yes it can be done and no, I
>> >> do not believe we should go backwards.
>> >>
>> >> We do not share filesystems between containers, we offer them block devices.
>> > 
>> > Yes, this is a real nuisance for openstack style deployments.
>> > 
>> > One nice solution to this imo would be a very thin stackable filesystem
>> > which does uid shifting, or, better yet, a non-stackable way of shifting
>> > uids at mount.
>> 
>> I vote for non-stackable way too. Maybe on generic VFS level so that filesystems 
>> don't bother with it. From what I've seen, even simple stacking is quite a challenge.
>
> Do you have any ideas for how to go about it?  It seems like we'd have
> to have separate inodes per mapping for each file, which is why of
> course stacking seems "natural" here.
>
> Trying to catch the uid/gid at every kernel-userspace crossing seems
> like a design regression from the current userns approach.  I suppose we
> could continue in the kuid theme and introduce a iiud/igid for the
> in-kernel inode uid/gid owners.  Then allow a user privileged in some
> ns to create a new mount associated with a different mapping for any
> ids over which he is privileged.

There is a simple solution.

We pick the filesystems we choose to support.
We add privileged mounting in a user namespace.
We create the user and mount namespace.
Global root goes into the target mount namespace with setns and performs
the mounts.

90% of that work is already done.

As long as we don't plan to support XFS (as it XFS likes to expose it's
implementation details to userspace) it should be quite straight
forward.

The permission check change would probably only need to be:


@@ -2180,6 +2245,10 @@ static int do_new_mount(struct path *path, const char *fstype, int flags,
                return -ENODEV;
 
        if (user_ns != &init_user_ns) {
+               if (!(type->fs_flags & FS_UNPRIV_MOUNT) && !capable(CAP_SYS_ADMIN)) {
+                       put_filesystem(type);
+                       return -EPERM;
+               }
                if (!(type->fs_flags & FS_USERNS_MOUNT)) {
                        put_filesystem(type);
                        return -EPERM;


There are also a few funnies with capturing the user namespace of the
filesystem when we perform the mount (in the superblock?), and not
allowing a mount of that same filesystem in a different user namespace.

But as long as the kuid conversions don't measurably slow down the
filesystem when mounted in the initial mount and user namespaces I don't
see how this would be a problem for anyone, and is very little code.


Eric
