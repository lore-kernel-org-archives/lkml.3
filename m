Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab3A0GJ6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 01:09:58 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:58288 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755727Ab3A0GJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 01:09:56 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <87ehh8it9s.fsf@xmission.com> <87ip6khe7w.fsf@xmission.com>
	<20130126212918.GG11274@mail.hallyn.com>
Date: Sat, 26 Jan 2013 22:09:41 -0800
In-Reply-To: <20130126212918.GG11274@mail.hallyn.com> (Serge E. Hallyn's
	message of "Sat, 26 Jan 2013 21:29:18 +0000")
Message-ID: <87bocb5f8a.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18iRggN/FRWHLKphEWJo9d6SCfX1brpi4s=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0072]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Serge E. Hallyn" <serge@hallyn.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH review 5/6] userns: Allow the userns root to mount ramfs.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serge@hallyn.com> writes:

> Quoting Eric W. Biederman (ebiederm@xmission.com):
>> 
>> There is no backing store to ramfs and file creation
>> rules are the same as for any other filesystem so
>> it is semantically safe to allow unprivileged users
>> to mount it.
>> 
>> The memory control group successfully limits how much
>> memory ramfs can consume on any system that cares about
>> a user namespace root using ramfs to exhaust memory
>> the memory control group can be deployed.
>
> But that does mean that to avoid this new type of attack, when handed a
> new kernel (i.e. by one's distro) one has to explicitly (know about and)
> configure those limits.  The "your distro should do this for you"
> argument doesn't seem right.  And I'd really prefer there not be
> barriers to user namespaces being compiled in when there don't have to
> be.

The thing is this really isn't a new type of attack.  There are a lot of
existing methods to exhaust memory with the default configuration on
most distros.  All this is is a new method to method to implement such
an attack.

Most distros allow a large number or processes and allow those processes
to consume a large if not unlimited amount of ram.

The OOM killer still will recover your system from a ramfs or a tmpfs
mounted in a mount namespace created with user namespace permissions.
It works because the OOM killer will kill all of the processes in the
mount namespace.  At which point all of the mounts have their reference
counts go to 0 the filesystems are unmounted.  When a ramfs or 
tmpfs is unmounted all of the files in a ramfs or tmpfs are freed.

On the flip side every resource has historically come with it's own new
knob.  The new knob in this case is memory control groups.  It isn't an
rlimit, and it isn't global limit tunable with a sysctl.  It is a much
more general knob than that.

> What was your thought on the suggestion to only allow FS_USERNS_MOUNT
> mounts by users confined in a non-init memory cgroup?

Over design.

But more than that there are a lot of other ways to get into trouble if
you don't enable memory control groups with user namespaces.   tmpfs is
just the first one I identified.

for (;;) unshare(CLONE_NEWUSER) is equally as bad, and if I look I can
find a bunch of others.

The practical fact is that allowing userspace to exhaust memory and get
the system into an OOM condition happens today.   There are lots of lots
of resources that it would take a lot of time to individually limit, or
put a knob on and even then we would miss some.  The memory control group
limits all of those now, and isn't particularly hard to configure.

So for the people who care I recommend using the tools that are
available now and work now the memory control group.

Personally I don't think distros care.

> Alternatively, what about a simple sysctl knob to turn on
> FS_USERNS_MOUNTs?  Then if I've got no untrusted users I can just turn
> that on without the system second-guessing me for not having extra
> configuration...

I suppose we could do something like what happens on terminals where
scheduler control groups are automatically created by the kernel.  Or
perhaps have an on/off sysctl knob for user namespaces themselves.  I
don't think anything more fine grained is worth it at this point.

Not that I will oppose more fine grained patches if someone writes else
writes them, I just don't see the bang for the buck.

I understand about not wanting to introduce limits on people enabling
user namespaces.  Most distro's don't appear to limit users memory today
so enabling user namespaces won't change anything.  For people who do
want to limit a users memory consumption it looks like all you need
to do is something like:

$ apt-get install cgroup-bin libcgroup1 libpam-cgroup

$ cat >> /etc/cgconfig <<EOF
group eric {
      perm {
		task {
			uid = root;
			gid = root;
		}
		admin {
			uid = root;
			gid = root;
		}
	}
	memory {
		memory.limit_in_bytes = 1073741824;
		memory.kmem.limit_in_bytes = 1073741824;
	}
}
mount {
	memory = /mnt/cgroups/memory;
}
EOF

$ cat >> /etc/cgrules <<EOF
eric		memory		eric/
EOF

So shrug.  The mechanisms that I am suggesting people use already exist,
and appear to have been present long enough to have made it into debian
stable release February of 2011.

My apologies for not having done that part of my homework earlier to
know that libpam-cgroup and friends are well established and 
have existed for quite a long time.

Eric
