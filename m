Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254Ab3IEEah (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 00:30:37 -0400
Received: from science.horizon.com ([71.41.210.146]:51056 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753798Ab3IEEag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 00:30:36 -0400
Date: 5 Sep 2013 00:30:33 -0400
Message-ID: <20130905043033.20292.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: waiman.long@hp.com
Subject: Re: [PATCH] dcache: Translating dentry into pathname without taking rename_lock
Cc: linux@horizon.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        viro@ZenIV.linux.org.uk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As long as you're removing locks from prepend_name and complicating its
innards, I notice that each and every call site follows it by prepending
"/".  How about moving that into prepend_name as well?

Also, if you happen to feel like it, you can delete the slash flag
and replace it with "bptr != *buffer".

Another small tweak would be to the global_root part of the code.
You could move the is_mounted(vfsmnt) test up, and combine the tail of
that code path with the regular exit.  All you have to do is change
the !slash test to:

	if (error >= 0 && bptr == *buffer) {	/* Root directory */
		if (--blen < 0)
			error = -ENAMETOOLONG;
		else
			*--bptr = '/';
	}

This modified form is no more code than an inlined copy of prepend(),
so we haven't actually slowed the fast path, but it avoids corrupting
the return value of 0/1/2 if possible.
