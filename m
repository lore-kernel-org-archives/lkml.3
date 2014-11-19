Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685AbaKSD41 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 22:56:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51319 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754023AbaKSD4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 22:56:25 -0500
Date: Tue, 18 Nov 2014 22:56:10 -0500
From: Dave Jones <davej@redhat.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Subject: Re: mm: shmem: freeing mlocked page
Message-ID: <20141119035610.GA14468@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hugh Dickins <hughd@google.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
References: <545C4A36.9050702@oracle.com>
 <5466142C.60100@oracle.com>
 <20141118135843.bd711e95d3977c74cf51d803@linux-foundation.org>
 <546C1202.1020502@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546C1202.1020502@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 10:44:02PM -0500, Sasha Levin wrote:
 > On 11/18/2014 04:58 PM, Andrew Morton wrote:
 
 > >> [ 1027.012856] ? pipe_lock (fs/pipe.c:69)
 > >> [ 1027.013728] ? write_pipe_buf (fs/splice.c:1534)
 > >> [ 1027.014756] vmsplice_to_user (fs/splice.c:1574)
 > >> [ 1027.015725] ? rcu_read_lock_held (kernel/rcu/update.c:169)
 > >> [ 1027.016757] ? __fget_light (include/linux/fdtable.h:80 fs/file.c:684)
 > >> [ 1027.017782] SyS_vmsplice (fs/splice.c:1656 fs/splice.c:1639)
 > >> [ 1027.018863] tracesys_phase2 (arch/x86/kernel/entry_64.S:529)
 > > 
 > > So what happened here?  Userspace fed some mlocked memory into splice()
 > > and then, while splice() was running, userspace dropped its reference
 > > to the memory, leaving splice() with the last reference.  Yet somehow,
 > > that page was still marked as being mlocked.  I wouldn't expect the
 > > kernel to permit userspace to drop its reference to the memory without
 > > first clearing the mlocked state.
 > > 
 > > Is it possible to work out from trinity sources what the exact sequence
 > > was?  Which syscalls are being used, for example?
 > 
 > Trinity can't really log anything because attempts to log syscalls slow everything
 > down to a crawl to the point nothing reproduces.

If the machine is still alive after /proc/sys/kernel/tainted changes,
trinity will dump a trinity-post-mortem.log somewhere[*] that should
contain the last two syscalls each process did. (Even if logging
is disabled).

It's not perfect however, and knowing that we passed a pointer to
a syscall isn't always useful unless we also dump the data that pointer
pointed at.  It's a work in progress. I don't know if I'm going to
get time to improve it any time soon though.

	Dave

[*] wherever cwd happened to be when the main process exited.
