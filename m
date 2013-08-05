Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab3HEXDL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 19:03:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44670 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629Ab3HEXDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 19:03:09 -0400
Date: Mon, 5 Aug 2013 16:03:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alex Thorlton <athorlton@sgi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Jones <davej@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Kees Cook <keescook@chromium.org>, Robin Holt <holt@sgi.com>
Subject: Re: [PATCHv2] Add per-process flag to control thp
Message-Id: <20130805160306.a620c88ba9098b98a0f93665@linux-foundation.org>
In-Reply-To: <20130802205735.GS26476@sgi.com>
References: <20130802205735.GS26476@sgi.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Aug 2013 15:57:35 -0500 Alex Thorlton <athorlton@sgi.com> wrote:

> This patch implements functionality to allow processes to disable the use of
> transparent hugepages through the prctl syscall.
> 
> We've determined that some jobs perform significantly better with thp disabled,
> and we needed a way to control thp on a per-process basis, without relying on
> madvise.

What everyone else said, plus...

I worry about the inherit-across-fork thing.  A scenario we should
think about is where the user doesn't build his own executables.  So he
writes a little wrapper which runs prctl(PR_SET_THP_DISABLED, 0) then
execs the third-party-app.  But what happens if that app execs children
who *do* want THP?  He has to hunt down and wrap those as well?

It all seems a bit unwieldy.  I wonder if controlling it via the ELF
header would be more practical.


