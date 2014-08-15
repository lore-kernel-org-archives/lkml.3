Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519AbaHOTRM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 15:17:12 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:48906 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243AbaHOTRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 15:17:09 -0400
MIME-Version: 1.0
In-Reply-To: <20140815190552.GA11476@ubuntumail>
References: <CALCETrWT_p1-5nkiAjWoeta19fkO3rDiJe9_mhRVqF8x1zXv2A@mail.gmail.com>
 <2686c32f00b14148379e8cfee9c028c794d4aa1a.1407974494.git.luto@amacapital.net> <20140815190552.GA11476@ubuntumail>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 15 Aug 2014 12:16:47 -0700
Message-ID: <CALCETrVKq1Fxnsd9jKDi5_fcKfCJxBZ1w-zGXD3FR-pF-jLsmQ@mail.gmail.com>
Subject: Re: [PATCH] fs: Remove implicit nodev for new mounts in non-root userns
To: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kenton Varda <kenton@sandstorm.io>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2014 at 12:05 PM, Serge Hallyn <serge.hallyn@ubuntu.com> wrote:
> Quoting Andy Lutomirski (luto@amacapital.net):
>> Currently, creating a new mount (as opposed to bindmount) in a
>> non-root userns will implicitly set nodev unless the fs is devpts.
>> Something like this will be necessary for file systems that allow
>> the mounter to create device nodes without using mknod (e.g. FUSE
>> if/when that is allowed), but none of the currently allowed
>> filesystems do this.
>
> Hi,
>
> Sorry, I'm probably thinking stupidly, but I don't see this restriction
> being the case
>
> serge@sl:~$ mount | grep tmp
> [...]
> tmpfs on /run type tmpfs (rw,noexec,nosuid,size=10%,mode=0755)
> serge@sl:~$ sudo mknod /run/kvm c 10 232
> [sudo] password for serge:
> serge@sl:~$ echo $?
> 0
> serge@sl:~$ ls -l /run/kvm
> crw-r--r-- 1 root root 10, 232 Aug 15 14:04 /run/kvm
>
> But you seem to be saying I shouldn't be allowed to create a device inside
> a tmpfs.  What am I overlooking?

I assume you're in the root userns.  This patch is unnecessary, and
has no effect, if you're in the root userns.

The code in Sandstorm that's currently broken in Linus' tree runs in a
new userns with a matching mount ns.  It does (copied verbatim):

      KJ_SYSCALL(mount("sandstorm-dev", "dev", "tmpfs", MS_NOSUID | MS_NOEXEC,
                       "size=1m,nr_inodes=16,mode=755"));
      makeCharDeviceNode("null", "null", 1, 3);
      makeCharDeviceNode("zero", "zero", 1, 5);
      makeCharDeviceNode("random", "urandom", 1, 9);
      makeCharDeviceNode("urandom", "urandom", 1, 9);
      KJ_SYSCALL(mount("dev", "dev", nullptr,
                       MS_REMOUNT | MS_BIND | MS_NOSUID | MS_NOEXEC |
MS_RDONLY, nullptr));

makeCharDeviceNode is a helper that creates an empty file and mounts a
device node over it.  This code needs the fs to be read/write, but
Sandstorm wants to make /dev read-only when it's done.

In Linus' tree, the remount fails with -EPERM because the mount is
secretly nodev.  It was always secretly nodev, but no one noticed
because of CVE-2014-5207, which caused that remount to succeed.

(Yay for programs that inadvertently exploited a serious security
vulnerability for their normal function.)

--Andy
