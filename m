Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751201AbaHJSL6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 14:11:58 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:58408 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbaHJSL5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 14:11:57 -0400
MIME-Version: 1.0
In-Reply-To: <CADDKRnDD_W5yJLo2otWXH8oEgmGdMP0N_p7wenBQbh17xKGZJg@mail.gmail.com>
References: <CADDKRnDD_W5yJLo2otWXH8oEgmGdMP0N_p7wenBQbh17xKGZJg@mail.gmail.com>
Date: Sun, 10 Aug 2014 11:11:56 -0700
X-Google-Sender-Auth: AsrcaeCLTNjMFfXYN0ElZfCkpcI
Message-ID: <CA+55aFzDpH8ntPO=JMdJ4Pu-SFV=9HQsXBcPakrZZq2mE9rJsA@mail.gmail.com>
Subject: Re: [proc:] 3.16.0-10436-g9138475: access denied to /proc/1540/task/1540/net/dev
From: Linus Torvalds <torvalds@linux-foundation.org>
To: =?UTF-8?Q?J=C3=B6rg_Otte?= <jrg.otte@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 10, 2014 at 10:25 AM, Jörg Otte <jrg.otte@gmail.com> wrote:
> My network interface eth0 doesn't come up in 3.16.0-10436-g9138475
> I am seeing following "security problem" in dmesg:
>
> audit: type=1400 audit(1407684227.003:28): apparmor="DENIED"
>   operation="open" profile="/sbin/dhclient"
>   name="/proc/1540/task/1540/net/dev" pid=1540 comm="dhclient"
>   requested_mask="r" denied_mask="r" fsuid=0 ouid=0
>
> I think the problem is introduced by the following commits, especially
> 6ba8ed7:

Ok.  Just to be sure, can you verify by reverting or bisecting exactly
which one breaks for you? I suspect it's commits 344470cac42e and
e81324407269 (commit 6ba8ed79a3cc just adds a "net" entry to the
thread case too, not just the task). Well, only e81324407269 will
matter for *this* case, but the /proc/mounts issue is basically
identical.

Eric, some or all of those need to be reverted, and regardless you
need to stop thinking you can just change things.

I realize that you knew about this possibility, but you now need to
not just realize that "it is possible that this breaks things" to
really stop doing crap like this. If you realize you are changing
semantics or moving files around, you need to go "I must not do that".

This crazy namespace disease of trying to "fix" things by breaking
existing code MUST STOP. I'm growing really tired of this.

It does sound like the problem may be specific to the fact that
apparmor cares about the exact path we're using, and thus what
*should* be harmless changes to the symlink from "current task" to
"current thread" exposes things. Admittedly apparmor is a bit crazy if
so, but I'm guessing your base apparmor config currently special-cases
"/proc/<pid>" but _not_ "/proc/<pid>/task/<pid>"

I'm wondering if we could/should make /proc/mount and /proc/net point
to /proc/<pid> at _least_ when current->namespace ==
current->thread_leader->namespace.

            Linus
