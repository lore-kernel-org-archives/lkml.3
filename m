Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965268AbaFCVjl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 17:39:41 -0400
Received: from mail.siteground.com ([67.19.240.234]:43328 "EHLO
	mail.siteground.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965076AbaFCVjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 17:39:36 -0400
Message-ID: <538E4088.7010605@1h.com>
Date: Wed, 04 Jun 2014 00:39:20 +0300
From: Marian Marinov <mm@1h.com>
Organization: 1H Ltd.
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>
CC: Pavel Emelyanov <xemul@parallels.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        LXC development mailing-list 
	<lxc-devel@lists.linuxcontainers.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Per-user namespace process accounting
References: <5386D58D.2080809@1h.com> <87tx88nbko.fsf@x220.int.ebiederm.org>	<53870EAA.4060101@1h.com> <20140529153232.GB9714@ubuntumail>	<538DFF72.7000209@parallels.com> <20140603172631.GL9714@ubuntumail> <8738flkhf0.fsf@x220.int.ebiederm.org>
In-Reply-To: <8738flkhf0.fsf@x220.int.ebiederm.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - mail.siteground.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - 1h.com
X-Get-Message-Sender-Via: mail.siteground.com: none
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 06/03/2014 08:54 PM, Eric W. Biederman wrote:
> Serge Hallyn <serge.hallyn@ubuntu.com> writes:
> 
>> Quoting Pavel Emelyanov (xemul@parallels.com):
>>> On 05/29/2014 07:32 PM, Serge Hallyn wrote:
>>>> Quoting Marian Marinov (mm@1h.com):
>>>>> We are not using NFS. We are using a shared block storage that offers us snapshots. So provisioning new
>>>>> containers is extremely cheep and fast. Comparing that with untar is comparing a race car with Smart. Yes
>>>>> it can be done and no, I do not believe we should go backwards.
>>>>> 
>>>>> We do not share filesystems between containers, we offer them block devices.
>>>> 
>>>> Yes, this is a real nuisance for openstack style deployments.
>>>> 
>>>> One nice solution to this imo would be a very thin stackable filesystem which does uid shifting, or, better
>>>> yet, a non-stackable way of shifting uids at mount.
>>> 
>>> I vote for non-stackable way too. Maybe on generic VFS level so that filesystems don't bother with it. From
>>> what I've seen, even simple stacking is quite a challenge.
>> 
>> Do you have any ideas for how to go about it?  It seems like we'd have to have separate inodes per mapping for
>> each file, which is why of course stacking seems "natural" here.
>> 
>> Trying to catch the uid/gid at every kernel-userspace crossing seems like a design regression from the current
>> userns approach.  I suppose we could continue in the kuid theme and introduce a iiud/igid for the in-kernel inode
>> uid/gid owners.  Then allow a user privileged in some ns to create a new mount associated with a different
>> mapping for any ids over which he is privileged.
> 
> There is a simple solution.
> 
> We pick the filesystems we choose to support. We add privileged mounting in a user namespace. We create the user
> and mount namespace. Global root goes into the target mount namespace with setns and performs the mounts.
> 
> 90% of that work is already done.
> 
> As long as we don't plan to support XFS (as it XFS likes to expose it's implementation details to userspace) it
> should be quite straight forward.
> 
> The permission check change would probably only need to be:
> 
> 
> @@ -2180,6 +2245,10 @@ static int do_new_mount(struct path *path, const char *fstype, int flags, return -ENODEV;
> 
> if (user_ns != &init_user_ns) { +               if (!(type->fs_flags & FS_UNPRIV_MOUNT) && !capable(CAP_SYS_ADMIN))
> { +                       put_filesystem(type); +                       return -EPERM; +               } if
> (!(type->fs_flags & FS_USERNS_MOUNT)) { put_filesystem(type); return -EPERM;
> 
> 
> There are also a few funnies with capturing the user namespace of the filesystem when we perform the mount (in the
> superblock?), and not allowing a mount of that same filesystem in a different user namespace.
> 
> But as long as the kuid conversions don't measurably slow down the filesystem when mounted in the initial mount and
> user namespaces I don't see how this would be a problem for anyone, and is very little code.
> 

This may solve one of the problems, but it does not solve the issue with UID/GID maps that overlap in different user
namespaces.
In our cases, this means breaking container migration mechanisms.

Will this at all be addressed or I'm the only one here that has this sort of requirement?

Marian


> 
> Eric
> 


- -- 
Marian Marinov
Founder & CEO of 1H Ltd.
Jabber/GTalk: hackman@jabber.org
ICQ: 7556201
Mobile: +359 886 660 270
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlOOQIgACgkQ4mt9JeIbjJRUWQCgsp/dN0WBy9iLJmsjO8KB+Bin
HiIAoIkm8TlcJr4UnbJOAHoYgPVHhg4P
=B9xA
-----END PGP SIGNATURE-----
