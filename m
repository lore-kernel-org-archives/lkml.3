Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbaDCSLX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 14:11:23 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:41099 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbaDCSLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 14:11:21 -0400
MIME-Version: 1.0
In-Reply-To: <20140403164911.GE24119@htj.dyndns.org>
References: <20140403164911.GE24119@htj.dyndns.org>
Date: Thu, 3 Apr 2014 11:11:20 -0700
X-Google-Sender-Auth: BY_iyA6iMUG6_TmZGWFsRvlj_UQ
Message-ID: <CA+55aFy1dm_CoTv+tihQ+m54G3gR9siOngurHsuKf9W3k1sKKw@mail.gmail.com>
Subject: Re: [GIT PULL] cgroup changes for v3.15-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        cgroups@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 3, 2014 at 9:49 AM, Tejun Heo <tj@kernel.org> wrote:
>
> C3. fed95bab8d29 ("sysfs: fix namespace refcnt leak") added an
>     argument to kernfs_mount() and was routed through driver-core-next
>     after cgroup pulled the tree.  cgroup's usage needs to be updated
>     accordingly.

This one I find very annoying. There's exactly *one* user of that
interface (back in fed95bab8d29 there were none), and it doesn't want
that dummy argument.

WTF? Why did the driver-core-next development add that argument at
all, rather than just pass in NULL directly? Do we expect to grow more
users of kernfs_mount?

And the "bool *new_sb_created" argument really makes *zero* sense to
kernfs_mount(). It was added to fix a namespace refcount leak, BUT
kernfs_mount() DOES NOT TAKE A NAMESPACE PARAMETER!

So quite frankly, that kernfs_mount() calling convention change looks
completely f*cked up.

I think I'm going to resolve that conflict differently from your
suggested one - I'm going to just remove the broken stupid
"new_sb_created" argument from the kernfs_mount() helper function.

(It obviously stays around for kernfs_mount_ns() that *does* take a
namespace pointer).

People, holler if you disagree, I'll hold off pushing out my
resolution for a while anyway (do all the normal build tests and
reboot into it).

                      Linus
