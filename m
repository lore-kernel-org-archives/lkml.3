Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933979Ab3BMNBI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 08:01:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933816Ab3BMNBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 08:01:05 -0500
Message-ID: <511B8E65.5020507@redhat.com>
Date: Wed, 13 Feb 2013 14:00:21 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Alex Bligh <alex@alex.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        nbd-general@lists.sf.net, Paul Clements <Paul.Clements@steeleye.com>
Subject: Re: [PATCH 1/3] nbd: support FLUSH requests
References: <1360685171-3792-1-git-send-email-pbonzini@redhat.com> <1360685171-3792-2-git-send-email-pbonzini@redhat.com> <115932E2-48BE-406E-9E75-61D12EB5937A@alex.org.uk> <511A8491.5030407@redhat.com> <20130212133207.ef6b24f5.akpm@linux-foundation.org> <FF1216D8-C4B3-405E-A4F6-82196A796A94@alex.org.uk>
In-Reply-To: <FF1216D8-C4B3-405E-A4F6-82196A796A94@alex.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 13/02/2013 01:03, Alex Bligh ha scritto:
>> > Obviously the changelog was inadequate.  Please send along a new one
>> > which fully describes the reasons for this change.
> To be clear I have no complaints about the rest of the patch being
> merged. Supporting FLUSH but not FUA is far better than supporting
> neither. I just didn't understand dropping FUA given the semantics
> of nbd is in essence 'linux bios over tcp'.

Not really bios, since it expects FLUSH requests to include no I/O, but
yes the semantics of NBD (and virtio-blk) are quite close to those of
the Linux block layer.

But as far as I can test with free servers, the FUA bits have no
advantage over flush.  Also, I wasn't sure if SEND_FUA without
SEND_FLUSH is valid, and if so how to handle this combination (treat it
as writethrough and add FUA to all requests? warn and do nothing?).

Andrew, here is a better commit message:

------------ 8< ---------------
From: Alex Bligh <alex@alex.org.uk>
Subject: nbd: support FLUSH requests

Currently, the NBD device does not accept flush requests from the Linux
block layer.  If the NBD server opened the target with neither O_SYNC
nor O_DSYNC, however, the device will be effectively backed by a
writeback cache.  Without issuing flushes properly, operation of the NBD
device will not be safe against power losses.

The NBD protocol has support for both a cache flush command and a FUA
command flag; the server will also pass a flag to note its support for
these features.  This patch adds support for the cache flush command and
flag.  In the kernel, we receive the flags via the NBD_SET_FLAGS ioctl,
and map NBD_FLAG_SEND_FLUSH to the argument of blk_queue_flush.  When
the flag is active the block layer will send REQ_FLUSH requests, which
we translate to NBD_CMD_FLUSH commands.

FUA support is not included in this patch because all free software
servers implement it with a full fdatasync; thus it has no advantage
over supporting flush only.  Because I [Paolo] cannot really benchmark
it in a realistic scenario, I cannot tell if it is a good idea or not.
It is also not clear if it is valid for an NBD server to support FUA but
not flush.  The Linux block layer gives a warning for this combination,
the NBD protocol documentation says nothing about it.

The patch also fixes a small problem in the handling of flags:
nbd->flags must be cleared at the end of NBD_DO_IT, but the driver was
not doing that.  The bug manifests itself as follows.  Suppose you two
different client/server pairs to start the NBD device.  Suppose also
that the first client supports NBD_SET_FLAGS, and the first server sends
NBD_FLAG_SEND_FLUSH; the second pair instead does neither of these two
things.  Before this patch, the second invocation of NBD_DO_IT will use
a stale value of nbd->flags, and the second server will issue an error
every time it receives an NBD_CMD_FLUSH command.

This bug is pre-existing, but it becomes much more important after this
patch; flush failures make the device pretty much unusable, unlike
discard failures.

Signed-off-by: Alex Bligh <alex@alex.org.uk>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Cc: Paul Clements <Paul.Clements@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

Paolo
