Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750878Ab3FGEHW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 00:07:22 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:53169 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695Ab3FGEHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 00:07:21 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Chris Webb <chris@arachsys.com>
Cc: linux-kernel@vger.kernel.org
References: <20130606215150.GG17158@arachsys.com>
Date: Thu, 06 Jun 2013 21:06:08 -0700
In-Reply-To: <20130606215150.GG17158@arachsys.com> (Chris Webb's message of
	"Thu, 6 Jun 2013 22:51:52 +0100")
Message-ID: <87a9n24lan.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18w6o2fjwsdbw+WV6dhvjW6JU/kob5V4A0=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: Building a BSD-jail clone out of namespaces
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Webb <chris@arachsys.com> writes:

> "Eric W. Biederman" <ebiederm@xmission.com> writes:
>
>> Hmm.  I guess it depends on how your VM is reading them.  If it is
>> blocked based access to the filesystem you have a problem.   If the VM
>> is effectively NFS mounting the filesystem you can do all kinds of
>> things.
>> 
>> It is possible to just change the user namespace and setup your mapping,
>> effectively running your VM in the user namespace, and that would allow
>> the VM to see your mapped uids.
>
> In some cases I was thinking of mounting a filesystem directly from a block
> device, but more often it would be directories in a local host filesystem.
> I use qemu's built in virtio 9p-over-pci to pass these in at present.

Interesting.  I hadn't seen that feature.  That makes 9p much more
interesting that I thought it was.

> So in principle, that does mean I could store UIDs translated and wrap
> everything else I do at host level in a userns translation layer as well,
> but it's quite an intrusive thing to do and I imagine it would preclude
> lightweight throwaway containers where I share the host filesystem read-only
> into a container.

Not being able to share the host filesystem into a container is a
downside of the current implementation.  In principle you can have an
overlay style filesystem that munges the uids and removes this
limitation, but that doesn't currently exist.

> This is why I was quite keen to avoid mangled ownerships in the host
> filesystems at all, but from what you say, that goal sounds like this might
> be rather tricky to achieve.

If you don't try to share the host root filesystem you can achieve the
sharing pretty easily by just running qemu in a user namespace.  So that
qemu or whatever else serves the 9p protocol sees the filesystem with all
of the uids and gids translated.

>> There are too many things in /proc and /sys and similar that
>> grant access to uid == 0.
>
> Ah yes, I can see why this is a thorny one. Is it just the synthetic
> filesystems like /proc and /sys that are the problem, or are there loads of
> other places in the kernel that assume uid == 0 implies privilege? I.e. is
> it 'just' a matter of somehow securing access to procfs and sysfs, or a much
> wider issue?

It is a wider issue. Capabilities cover most of places in the kernel
where the kernel tests if you have privilege but there are other
filesystems like devtmpsfs, and the occasional silly piece of kernel
code that should be using capabilities but is not.  Beyond the kernel
there are files like /etc/shadow that only root is allowed to read.

Which all boils down to the fact that for the inconvience of using a
separate range of uids a lot of other problems just go away.

Eric
