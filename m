Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759251Ab3EWOus (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 10:50:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24892 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758360Ab3EWOup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 10:50:45 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: torvalds@linux-foundation.org, mingo@kernel.org
cc: dhowells@redhat.com, milosz@adfin.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Is spin_is_locked() safe to use with BUG_ON()/WARN_ON()?
Date: Thu, 23 May 2013 15:50:36 +0100
Message-ID: <6402.1369320636@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We are using spin_is_locked() in a few places to give a warning or an oops if
either a spinlock is not held or if it is held.  I'm not sure all of these are
safe.

Take uas_try_complete() in drivers/usb/storage/uas.c which does:

	WARN_ON(!spin_is_locked(&devinfo->lock));

or fscache_start_operations() which does:

	ASSERT(spin_is_locked(&object->lock));

These will unconditionally fail under sometimes because under certain
conditions spin_is_locked() is hardwired to 0 (ie. not locked) when actually
we're in a place where the spinlock _should_ be locked, and we should get a
non-zero return.


Would it be reasonable to add a spin_is_not_locked() function for use when we
expect it not to be locked and then use spin_is_locked() only when we expect it
to be locked?

Thanks to Milosz Tanski for spotting this one.

David
