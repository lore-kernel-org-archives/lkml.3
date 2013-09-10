Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205Ab3IJAkY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 20:40:24 -0400
Received: from science.horizon.com ([71.41.210.146]:21702 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755756Ab3IJAkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 20:40:23 -0400
Date: 9 Sep 2013 20:40:20 -0400
Message-ID: <20130910004020.29299.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: torvalds@linux-foundation.org, viro@ZenIV.linux.org.uk
Subject: Re: [PATCH v4 1/1] dcache: Translating dentry into pathname without taking rename_lock
Cc: aswin@hp.com, john@stoffel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@horizon.com, scott.norton@hp.com,
        Waiman.Long@hp.com
In-Reply-To: <20130909182111.GQ13318@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm really wondering about only trying once before taking the write lock.
Yes, using the lsbit is a cute hack, but are we using it for its cuteness
rather than its effectiveness?

Renames happen occasionally.  If that causes all the current pathname
translations to fall back to the write lock, that is fairly heavy.
Worse, all of those translations will (unnecessarily) bump the write
seqcount, triggering *other* translations to fail back to the write-lock
path.

One patch to fix this would be to have the fallback read algorithm take
sl->lock but *not* touch sl->seqcount, so it wouldn't break concurrent
readers.

But another is to simply retry at least once (two attempts) on the
non-exclusive path before falling back to the exclusive one,  This means
that the count lsbit is no longer enough space for a retry counter, but
oh, well.

(If you really want to use one word, perhaps a better heuristic
as to how to retry would be to examine the *number* of writes
to the seqlock during the read.  If there was only one, there's a fair
chance that another read will succeed.  If there was more than one
(i.e. the seqlock has incremented by 3 or more), then forcing the
writers to stop is probably necessary.)
