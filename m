Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbaBJVj6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 16:39:58 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:42130 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223AbaBJVjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 16:39:54 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: lkml <linux-kernel@vger.kernel.org>, stgraber@ubuntu.com,
        apw@canonical.com
References: <20140210195133.GA10107@mail.hallyn.com>
Date: Mon, 10 Feb 2014 13:39:44 -0800
In-Reply-To: <20140210195133.GA10107@mail.hallyn.com> (Serge E. Hallyn's
	message of "Mon, 10 Feb 2014 20:51:33 +0100")
Message-ID: <8738jqbqan.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18PAvN1ReJv2VaICZ4GGX7Wvb6BKh6r9t0=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4975]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Serge E. Hallyn" <serge@hallyn.com>
X-Spam-Relay-Country: 
Subject: Re: overlayfs mounts in user namespaces
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serge@hallyn.com> writes:

> Hi Eric,
>
> most filesystems cannot be mounted in a non-init user namespace because we
> don't trust the superblock parsers to DTRT when handed garbage.

Correct, and mostly this is plain conservatism and not a real
limitation.  As most distro's and thus most users of linux do trust
filesystem superblock parsers to not behave incorrectly when handed
garbage.  At least for the common linux filesystems.  And filesystems
like ext4 already handle bug reports from this case.

The larger practical issue is acl handling, and uid/gid translation when
not mounted in the initial user namespace.

> I was
> wondering if you had any ideas on ways that allowing root in a non-init userns
> to mount an overlayfs fs would be dangerous?  There's no superblock parsing in
> that case at all;  writes end up being allowed if and only if the userid owning
> the 'upper' (writeable) layer is mapped into the userns.  Near as I can tell
> it should be quite safe.  But my imagination isn't the most active.

Other than overlayfs not being mature enough to merge into the kernel at
this point.  I would expect anyone hostile would read one of Al Viro's
scathing reviews and go ah-ha that is how I can exploit overlay fs.

> I assume there would be concerns about memory usage if the system is not
> configured to place all logged-in users into configured cgroups? 

Yes.  And I am not yet certain if the memory cgroup is stable in cgroup
OOM conditions especially when limiting kernel memory.

> Is there
> anything else you can think of that could be abused?

Not off the top of my head.  My preference would be to look at fuse
first, and sort that out.  It would be silly be doable to implement
overlay in userspace if we had a fuse filesystem we could trust.

And fuse is mostly trustable.  There are just silly technical details
that haven't been worked through, and I am conservative enough to not
rush those details.

> (I realize overlayfs isn't upstream yet so the question may not be all that
> interesting to most people...)

There is a lot of work to get the vfs where it closer to the point where
it can reasonably support overlayfs.

Eric

p.s.  You might have a little more luck with this question if you
included  linux-fsdevel@vger.kernel.org, or possibly the container lists.
