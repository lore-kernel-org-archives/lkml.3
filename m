Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758309Ab3B1XJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 18:09:21 -0500
Received: from mail-ve0-f182.google.com ([209.85.128.182]:39852 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036Ab3B1XJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 18:09:19 -0500
MIME-Version: 1.0
In-Reply-To: <512FDC82.2060606@redhat.com>
References: <20130206150403.006e5294@cuia.bos.redhat.com>
	<511C1204.9040608@redhat.com>
	<CA+55aFwxYK-BLH0crhySHaQvAYHOH-VGUi7WTd1aq-24+WTDYw@mail.gmail.com>
	<511C24A6.8020409@redhat.com>
	<CA+55aFws80EEJQskqiP+a5J-HOGu=M1Fe=uCs50ifedVxPxT1Q@mail.gmail.com>
	<512E376D.70105@redhat.com>
	<CA+55aFzPxJ3rfZvAvrP9LxCXfDU8AAVvhMZnP-OAoe-ycc70aw@mail.gmail.com>
	<512E6443.9050603@redhat.com>
	<CA+55aFwHxv9RH75BoXYcwdKeHx+otOOpg9494TTdFwQe3biOhw@mail.gmail.com>
	<512E80E3.7060800@redhat.com>
	<CA+55aFwa0EjGG2NUDYVLVBmXJa2k81YiuNO2yggk=GLRQxhhUQ@mail.gmail.com>
	<512EC7F0.60103@redhat.com>
	<1362024397.1867.28.camel@buesod1.americas.hpqcorp.net>
	<CA+55aFygzjuNYiG4MTPMzimEjQ92rpS-rNJr7HD4OQCAqze5zg@mail.gmail.com>
	<512F7429.4020103@redhat.com>
	<CA+55aFw3t+sC-zv6njxdJ6hB0arJnZzoGNO9W7o8h=tcUo5P_Q@mail.gmail.com>
	<CA+55aFwEshukBGU5YCtKL=7c-43guMuGSHTnXo02rLxZWGQWTw@mail.gmail.com>
	<512FC89B.6030507@redhat.com>
	<CA+55aFxbm83Oc2g55868HA2xCytsJzTxWGE0w_pMUzKaU5mJMw@mail.gmail.com>
	<512FDC82.2060606@redhat.com>
Date: Thu, 28 Feb 2013 15:09:18 -0800
X-Google-Sender-Auth: RefxldcVVwofQEt7l7-jnpHOOr4
Message-ID: <CA+55aFyitxgooTYq27eK4fO___R4uRrNhoPwDWxULeUkejH0ZA@mail.gmail.com>
Subject: Re: [tip:core/locking] x86/smp: Move waiting on contended ticket lock
 out of line
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Vinod, Chegu" <chegu_vinod@hp.com>, "Low, Jason" <jason.low2@hp.com>,
        linux-tip-commits@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, aquini@redhat.com,
        Michel Lespinasse <walken@google.com>, Ingo Molnar <mingo@kernel.org>,
        Larry Woodman <lwoodman@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 2:38 PM, Rik van Riel <riel@redhat.com> wrote:
>
> I could see doing the permission checks under a seq lock.
>
> If the permissions, or any other aspect of the semaphore
> array changed while we were doing our permission check,
> we can simply jump back to the top of the function and
> try again.

We do the normal file permissions under just the RCU read lock. If
it's good enough for files, them ipc semaphores certainly don't need
anything more.

> The ugliness of using two kinds of protection may be
> necessary, since permissions can be modified in-place,
> and RCU does not seem to do in-place modification...

The selinux AVC code does its stuff by rcu, and for files we don't
even care if there is some uid/gid change going on - we'll  get one or
the other, and live with it. There is no atomic way to change the uid
and gid anyway, so there are no new races. You get old or you get new,
or a mix of the two, any of it is "correct".

So I almost think that *everything* there in the semaphore code could
be done under RCU. The actual spinlock doesn't seem to much matter, at
least for semaphores. The semaphore values themselves seem to be
protected by the atomic operations, but I might be wrong about that, I
didn't even check. I just looked at the ipcperm() part, which
certainly doesn't seem to merit spinlocks.

            Linus
