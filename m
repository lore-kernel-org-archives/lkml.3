Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113AbaEZSRr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 14:17:47 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:50527 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbaEZSRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 14:17:43 -0400
MIME-Version: 1.0
In-Reply-To: <20140526152703.GN18016@ZenIV.linux.org.uk>
References: <20140526093741.GA1765@lahna.fi.intel.com>
	<20140526135746.GM18016@ZenIV.linux.org.uk>
	<20140526142948.GA1685@lahna.fi.intel.com>
	<20140526152703.GN18016@ZenIV.linux.org.uk>
Date: Mon, 26 May 2014 11:17:42 -0700
X-Google-Sender-Auth: donhJg6VYvtl4ah72dT2xPc5KqE
Message-ID: <CA+55aFyz1oQQ+uz9DPSEmYBBby1VKTRFz81mTt3mVSLN+tMK+A@mail.gmail.com>
Subject: Re: fs/dcache.c - BUG: soft lockup - CPU#5 stuck for 22s! [systemd-udevd:1667]
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=089e013a062c60014804fa5198ad
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e013a062c60014804fa5198ad
Content-Type: text/plain; charset=UTF-8

On Mon, May 26, 2014 at 8:27 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> That's the livelock.  OK.

Hmm. Is there any reason we don't have some exclusion around
"check_submounts_and_drop()"?

That would seem to be the simplest way to avoid any livelock: just
don't allow concurrent calls (we could make the lock per-filesystem or
whatever). This whole case should all be for just exceptional cases
anyway.

We already sleep in that thing (well, "cond_resched()"), so taking a
mutex should be fine.

The attached (TOTALLY UNTESTED!) patch as an example. Avert your eyes.
Mika, does this make any difference?

              Linus

--089e013a062c60014804fa5198ad
Content-Type: text/plain; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hvo3k2ix0

IGZzL2RjYWNoZS5jIHwgMyArKysKIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKykKCmRp
ZmYgLS1naXQgYS9mcy9kY2FjaGUuYyBiL2ZzL2RjYWNoZS5jCmluZGV4IDQyYWUwMWVlZmMwNy4u
NjYzZmQwNDYxNGNjIDEwMDY0NAotLS0gYS9mcy9kY2FjaGUuYworKysgYi9mcy9kY2FjaGUuYwpA
QCAtMTMzMywxNiArMTMzMywxOSBAQCBpbnQgY2hlY2tfc3VibW91bnRzX2FuZF9kcm9wKHN0cnVj
dCBkZW50cnkgKmRlbnRyeSkKIAogCWZvciAoOzspIHsKIAkJc3RydWN0IHNlbGVjdF9kYXRhIGRh
dGE7CisJCXN0YXRpYyBERUZJTkVfTVVURVgobXV0ZXgpOwogCiAJCUlOSVRfTElTVF9IRUFEKCZk
YXRhLmRpc3Bvc2UpOwogCQlkYXRhLnN0YXJ0ID0gZGVudHJ5OwogCQlkYXRhLmZvdW5kID0gMDsK
IAorCQltdXRleF9sb2NrKCZtdXRleCk7CiAJCWRfd2FsayhkZW50cnksICZkYXRhLCBjaGVja19h
bmRfY29sbGVjdCwgY2hlY2tfYW5kX2Ryb3ApOwogCQlyZXQgPSBkYXRhLmZvdW5kOwogCiAJCWlm
ICghbGlzdF9lbXB0eSgmZGF0YS5kaXNwb3NlKSkKIAkJCXNocmlua19kZW50cnlfbGlzdCgmZGF0
YS5kaXNwb3NlKTsKKwkJbXV0ZXhfdW5sb2NrKCZtdXRleCk7CiAKIAkJaWYgKHJldCA8PSAwKQog
CQkJYnJlYWs7Cg==
--089e013a062c60014804fa5198ad--
