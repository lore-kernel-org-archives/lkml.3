Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab3EMFSe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 01:18:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:49761 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763Ab3EMFSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 01:18:33 -0400
Message-ID: <1368422306.5774.70.camel@marge.simpson.net>
Subject: Re: EXT4 panic at jbd2_journal_put_journal_head() in 3.9+
From: Mike Galbraith <bitbucket@online.de>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Tony Luck <tony.luck@gmail.com>, eunb.song@samsung.com,
        Dmitry Monakhov <dmonakhov@openvz.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 13 May 2013 07:18:26 +0200
In-Reply-To: <20130513033655.GE25996@thunk.org>
References: <7032562.14371368411664268.JavaMail.weblogic@epml07>
	 <CA+8MBb+51dMaYQd-g-T40+UstbxsSbmewSXiUfNDrVouSA3=Zw@mail.gmail.com>
	 <20130513033655.GE25996@thunk.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:vFRf28Tt6ac/051dHICHigNC5y+QlmeK31sZ/DtMJqD
 KGH4568QszhT8vuj01pWB+twVRjgnUZ5gZKGCPHeL06xLKDvT9
 pJT1GLo3zLJvGR9qy71WgHJKu/l00ccRhKMTKL99fCJRz9a0YS
 ikNioFO37biXd7fknCNO+FpoWvyvCXv8yA9zuRHZQ8m7LeLy4b
 uFli7waJj5BQM4Pnm+Hg9CD2EwaJ6ebU3iAt5mMSXXRk0SSf/X
 cEtvRsb6hEcUgZhBVmTR2eqeyT54W4whUxn9XiuLjRSWnWttgN
 a3+mM9DSw+gnTRFjW0yiIgzODcjJHLztQqoc+SsDii5Io+DXPb
 RYYWAMUiKKJErrN2sMYQ49wRPwS/ycVEQIi+AxmlJUGhHCYCmD
 wvGXjnEYx3TNA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-05-12 at 23:36 -0400, Theodore Ts'o wrote: 
> On Sun, May 12, 2013 at 08:11:59PM -0700, Tony Luck wrote:
> > 
> > My best guess as to why this commit causes problems is that there are places
> > where updates to individual fields in this structure used to be independent
> > because they were to whole words.  Now we have bitfileds there are races
> > between access to different fields in the same word.
> 
> Yeah, except we access the fields while holding a lock.... wait a
> minute.  We're using bit_spinlocks().... and am I missing something?
> 
> Where are the barrier statements to prevent the CPU or the compiler
> from reordering statements around bit_spin_lock()?  But if that's the
> problem, I would have expected lots of other things to be broken.

Those use test_and_set_bit(), which per Paul McMemory-Wizard...

ATOMIC OPERATIONS
-----------------

Whilst they are technically interprocessor interaction considerations, atomic
operations are noted specially as some of them imply full memory barriers and
some don't, but they're very heavily relied on as a group throughout the
kernel.

Any atomic operation that modifies some state in memory and returns information
about the state (old or new) implies an SMP-conditional general memory barrier
(smp_mb()) on each side of the actual operation (with the exception of
explicit lock operations, described later).  These include:

        xchg();
        cmpxchg();
        atomic_xchg();
        atomic_cmpxchg();
        atomic_inc_return();
        atomic_dec_return();
        atomic_add_return();
        atomic_sub_return();
        atomic_inc_and_test();
        atomic_dec_and_test();
        atomic_sub_and_test();
        atomic_add_negative();
        atomic_add_unless();    /* when succeeds (returns 1) */
        test_and_set_bit();
        test_and_clear_bit();
        test_and_change_bit();


