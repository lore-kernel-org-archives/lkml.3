Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332AbaFCBPj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 21:15:39 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:44992 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058AbaFCBPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 21:15:37 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrXbpiqwY=qyPcNWn2zX=vehXzBbxDG725egM9T2Ox2KTA@mail.gmail.com>
References: <CALCETrXbpiqwY=qyPcNWn2zX=vehXzBbxDG725egM9T2Ox2KTA@mail.gmail.com>
Date: Mon, 2 Jun 2014 18:15:36 -0700
X-Google-Sender-Auth: oCWRqSe1DAOgpgotwJ4I1eflD1c
Message-ID: <CA+55aFz+cijJuUTs6xs6SdGnasmR7uYXKkr7=0YTuPQ+xgjFEA@mail.gmail.com>
Subject: Re: 3.15 regression: wrong cgroup magic
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 2, 2014 at 5:56 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> In particular, this piece:
>
> -       sb->s_magic = CGROUP_SUPER_MAGIC;
>
> The result is that cgroup shows up with the wrong magic number, so my
> code goes "oh crap, cgroupfs isn't mounted" and fails.
>
> I can change my code to hack around this, but I can imagine other
> things getting tripped up.  Is there still time to fix this?

Sure. Send me a tested patch. I'm assuming it's going to look something like

  --- a/kernel/cgroup.c
  +++ b/kernel/cgroup.c
  @@ -54,6 +54,7 @@
   #include <linux/vmalloc.h> /* TODO: replace with more sophisticated array */
   #include <linux/kthread.h>
   #include <linux/delay.h>
  +#include <linux/magic.h>

   #include <linux/atomic.h>

  @@ -1607,6 +1608,8 @@ out_unlock:
          dentry = kernfs_mount(fs_type, flags, root->kf_root, &new_sb);
          if (IS_ERR(dentry) || !new_sb)
                  cgroup_put(&root->cgrp);
  +       else
  +               dentry->d_sb->s_magic = CGROUP_SUPER_MAGIC;
          return dentry;
   }

but somebody definitely needs to test it.

               Linus
