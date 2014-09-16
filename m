Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbaIPITZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 04:19:25 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:52199 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbaIPITW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 04:19:22 -0400
MIME-Version: 1.0
X-Originating-IP: [46.139.80.5]
In-Reply-To: <5411CA4F.7040006@parallels.com>
References: <20140821160304.11005.15166.stgit@localhost.localdomain>
	<20140821160916.11005.37344.stgit@localhost.localdomain>
	<CAJfpegsWoaqR1vQRq8QpYdwUX9Ace9XTe77eOkOUy2VyHUeEdQ@mail.gmail.com>
	<5411CA4F.7040006@parallels.com>
Date: Tue, 16 Sep 2014 10:19:21 +0200
Message-ID: <CAJfpegs3v9EVzoPMgX9_JV+-Y3qy7oWD8tceSi+tnmo=_b=a7A@mail.gmail.com>
Subject: Re: [PATCH 5/6] fuse: fix synchronous case of fuse_file_put()
From: Miklos Szeredi <miklos@szeredi.hu>
To: Maxim Patlasov <mpatlasov@parallels.com>
Cc: fuse-devel <fuse-devel@lists.sourceforge.net>,
        Anand Avati <avati@gluster.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 6:14 PM, Maxim Patlasov <mpatlasov@parallels.com> wrote:

> I really need your help to proceed with this patch. Could you please explain
> what those places are where we should allow interruption.
>
> BTW, as for "just an optimization", I've recently noticed that __fput()
> calls locks_remove_file(). So guarantees provided by the patch-set are on
> the same level as flock(2) behaviour.

SIGKILL trumps that.  At least that's what I think, and that's what
NFS currently does as well, AFAICS.

>
>>
>> Also fuse really should distinguish fatal and non-fatal interruptions
>> and handle them accordingly...
>
>
> And elaborate on this concern, please.

Requests have two states where they stay for any significant amount of
time: PENDING (queued to userspace) and SENT (in userspace).

Currently we do the following for interrupted requests:

PENDING:
   - non-fatal signal: do nothing
   - fatal signal: dequeue and return -EINTR, unless force is set

SENT:
   - send INTERRUPT request to userspace

This is fine, but fatal interrupts should be able to abort SENT and
forced requests as well without having to wait for the userspace
reply.  This is what I was referring to.

This would not be difficult, were it not for i_mutex and
s_vfs_rename_mutex being held by some operations.   For correctness,
we can't release these while a reply is not received, since the
locking expecations of the userspace filesystem would not be met.
This can be solved by adding shadow locks to fuse that we hold onto
even after the request is interrupted.

Thanks,
Miklos
