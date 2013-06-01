Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab3FAVsE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 17:48:04 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:62916 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590Ab3FAVr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 17:47:59 -0400
MIME-Version: 1.0
From: Frederic Riss <frederic.riss@gmail.com>
Date: Sat, 1 Jun 2013 23:47:37 +0200
Message-ID: <CAKk_3s_P18a3ZUb835ysa-MS3c-_TBT20MVsJLvPrsYKETS_-w@mail.gmail.com>
Subject: mount + pid namespacing broken ?
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I had a little application making use of pid and mount namespaces to
isolate some processes on some machines. This all worked well on 3.7
boxes. A coworker upgraded his machine and noticed that things weren't
working anymore on 3.8. The symptom he noticed is that remounting
/proc inside the namespaced process broke the /proc of the original
namespace. (Remounting /proc is necessary for the pid namespace to be
really effective)

There is a simple way to reproduce the issue if you have a new enough
util-linux where the unshare utility accepts the --pid option. Try
that:

bash-4.2$ unshare --pid --mount
-bash-4.2$ sudo mount -t proc /proc /proc
[sudo] password for friss:
sudo: unable to send audit message: Operation not permitted
-bash-4.2$

[ The audit failure is already a sign of something going wrong more on
that bellow. ]
Then in another terminal running in the root namesapce:

bash-4.2$ ls -l /proc/self
ls: cannot read symbolic link /proc/self: No such file or directory
lrwxrwxrwx 1 root root 0 Jun  1 23:37 /proc/self

As you see, remounting /proc in the private namespace broke the root /proc...

Now the namespace isn't functional anyway even if /proc doesn't get remounted:

bash-4.2$ unshare --pid --mount
-bash-4.2$ id
uid=1001(friss) gid=1001(friss) groups=1001(friss),10(wheel)
-bash-4.2$ id
-bash: fork: Cannot allocate memory
-bash-4.2$

It's able to run one process, but every following invocation will
fail. I suppose the audit issue mentioned above is just another
symptom.

All of this was working fine on 3.7 kernels. I tried it on latest 3.8
and 3.9 and it fails on both. My application didn't make use of
unshare, but instead forked a new process with the namespacing flags.
The symptoms are identical in both cases.

Fred.
