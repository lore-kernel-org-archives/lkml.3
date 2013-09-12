Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638Ab3ILRaT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 13:30:19 -0400
Received: from mail-vb0-f45.google.com ([209.85.212.45]:39333 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755591Ab3ILRaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:30:15 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwsqHJE1D-z8_kU+1VEpUTB=EU57kqmKao580gYZVOjrw@mail.gmail.com>
References: <1378997735-22844-1-git-send-email-Waiman.Long@hp.com>
	<CA+55aFwsqHJE1D-z8_kU+1VEpUTB=EU57kqmKao580gYZVOjrw@mail.gmail.com>
Date: Thu, 12 Sep 2013 10:30:14 -0700
X-Google-Sender-Auth: vQcJ6YfjHlPMeHaSx2AsB9w9_ic
Message-ID: <CA+55aFy8Nq7yf9CJwFuyfSmkUzFKRHHOE6O8=4HjmaWpku3fhw@mail.gmail.com>
Subject: Re: [PATCH 0/2 v2] dcache: get/release read lock in
 read_seqbegin_or_lock() & friend
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 9:38 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Sep 12, 2013 at 7:55 AM, Waiman Long <Waiman.Long@hp.com> wrote:
>> Change log
>> ----------
>> v1->v2:
>>   - Rename the new seqlock primitives to read_seqexcl_lock* and
>>     read_seqexcl_unlock*.
>
> Applied.

Btw, when I tried to benchmark this, I failed miserably.

Why?

If you do a threaded benchmark of "getcwd()", you end up spending all
your time in a spinlock anyway: get_fs_root_and_pwd() takes the
fs->lock to get the root/pwd.

Now, AIM7 probably uses processes, not threads, so you don't see this,
and maybe I shouldn't care. But looking at it, it annoys me
enormously, because the whole get_fs_root_and_pwd() is just stupid.

Putting it all under the RCU lock and then changing it to use
get_fs_root_and_pwd_rcu() that just uses the fs->seq sequence
read-lock looks absolutely trivial.

              Linus
