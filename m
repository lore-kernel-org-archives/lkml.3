Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab3KSWVE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 17:21:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41986 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111Ab3KSWVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 17:21:00 -0500
Date: Tue, 19 Nov 2013 14:20:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Alex Kelly <alex.page.kelly@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Kees Cook <keescook@chromium.org>, Petr Matousek <pmatouse@redhat.com>,
        Vasily Kulikov <segoon@openwall.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] set_dumpable: fix the theoretical race with
 itself
Message-Id: <20131119142058.92a85a2aa91b61565f787c99@linux-foundation.org>
In-Reply-To: <20131119144315.GA28862@redhat.com>
References: <20131119144300.GA28842@redhat.com>
	<20131119144315.GA28862@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Nov 2013 15:43:15 +0100 Oleg Nesterov <oleg@redhat.com> wrote:

> set_dumpable() updates MMF_DUMPABLE_MASK in a non-trivial way to
> ensure that get_dumpable() can't observe the intermediate state,
> but this all can't help if multiple threads call set_dumpable()
> at the same time.
> 
> And in theory commit_creds()->set_dumpable(SUID_DUMP_ROOT) racing
> with sys_prctl()->set_dumpable(SUID_DUMP_DISABLE) can result in
> SUID_DUMP_USER.
> 
> Change this code to update both bits atomically via cmpxchg().
> 
> Note: this assumes that it is safe to mix bitops and cmpxchg. IOW,
> if, say, an architecture implements cmpxchg() using the locking
> (like arch/parisc/lib/bitops.c does), then it should use the same
> locks for set_bit/etc.

I suppose that is reasonable - atomic operations on memory should be
atomic wrt other classes of atomic operations on the same memory.  So
set_bit() has to "know" about concurrent cmpxchg().  It *has* to be
this way to fully emulate the hardware-based RMW operations.

parisc got that right.  I wonder if all other architectures did, and
how on earth we can communicate this to future arch developers..

