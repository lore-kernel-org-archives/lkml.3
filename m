Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578Ab3FDUv2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 16:51:28 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:57265 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab3FDUv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 16:51:27 -0400
Date: Tue, 4 Jun 2013 22:51:20 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Frederic Riss <frederic.riss@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: mount + pid namespacing broken ?
Message-ID: <20130604225120.34e11ac4@neptune.home>
In-Reply-To: <CAKk_3s_P18a3ZUb835ysa-MS3c-_TBT20MVsJLvPrsYKETS_-w@mail.gmail.com>
References: <CAKk_3s_P18a3ZUb835ysa-MS3c-_TBT20MVsJLvPrsYKETS_-w@mail.gmail.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.17; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, 01 June 2013 Frederic Riss <frederic.riss@gmail.com> wrote:
> I had a little application making use of pid and mount namespaces to
> isolate some processes on some machines. This all worked well on 3.7
> boxes. A coworker upgraded his machine and noticed that things weren't
> working anymore on 3.8. The symptom he noticed is that remounting
> /proc inside the namespaced process broke the /proc of the original
> namespace. (Remounting /proc is necessary for the pid namespace to be
> really effective)
> 
> There is a simple way to reproduce the issue if you have a new enough
> util-linux where the unshare utility accepts the --pid option. Try
> that:
> 
> bash-4.2$ unshare --pid --mount
> -bash-4.2$ sudo mount -t proc /proc /proc
> [sudo] password for friss:
> sudo: unable to send audit message: Operation not permitted
> -bash-4.2$
> 
> [ The audit failure is already a sign of something going wrong more on
> that bellow. ]
> Then in another terminal running in the root namesapce:
> 
> bash-4.2$ ls -l /proc/self
> ls: cannot read symbolic link /proc/self: No such file or directory
> lrwxrwxrwx 1 root root 0 Jun  1 23:37 /proc/self
> 
> As you see, remounting /proc in the private namespace broke the root /proc...

If your coworker updated more than the kernel it might just be that
your filesystem is `mount / --make-rshared` on the root mount namespace.
E.g. the systmed started doing that some time ago (about a year or so)

With `mount --make-rprivate` inside the new namespace before doing
anything else mount+pid+ipc+uts(+net) is working fine for me (though
I'm changing namespaces using them clone() rather than unshare())

Bruno

> Now the namespace isn't functional anyway even if /proc doesn't get remounted:
> 
> bash-4.2$ unshare --pid --mount
> -bash-4.2$ id
> uid=1001(friss) gid=1001(friss) groups=1001(friss),10(wheel)
> -bash-4.2$ id
> -bash: fork: Cannot allocate memory
> -bash-4.2$
> 
> It's able to run one process, but every following invocation will
> fail. I suppose the audit issue mentioned above is just another
> symptom.
> 
> All of this was working fine on 3.7 kernels. I tried it on latest 3.8
> and 3.9 and it fails on both. My application didn't make use of
> unshare, but instead forked a new process with the namespacing flags.
> The symptoms are identical in both cases.
> 
> Fred.
