Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423137Ab3FUQNB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 12:13:01 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:36971 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422821Ab3FUQNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 12:13:00 -0400
Date: Fri, 21 Jun 2013 18:12:41 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: David Daney <ddaney.cavm@gmail.com>
Cc: James Hogan <james.hogan@imgtec.com>, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Kees Cook <keescook@chromium.org>,
        David Daney <david.daney@cavium.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        linux-mips@linux-mips.org
Subject: Re: [PATCH v3] kernel/signal.c: fix BUG_ON with SIG128 (MIPS)
Message-ID: <20130621161241.GC17626@linux-mips.org>
References: <1371821962-9151-1-git-send-email-james.hogan@imgtec.com>
 <51C47864.9030200@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51C47864.9030200@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 08:59:32AM -0700, David Daney wrote:

> On 06/21/2013 06:39 AM, James Hogan wrote:
> >MIPS has 128 signals, the highest of which has the number 128 (they
> >start from 1). The following command causes get_signal_to_deliver() to
> >pass this signal number straight through to do_group_exit() as the exit
> >code:
> >
> >   strace sleep 10 & sleep 1 && kill -128 `pidof sleep`
> >
> >However do_group_exit() checks for the core dump bit (0x80) in the exit
> >code which matches in this particular case and the kernel panics:
> >
> >   BUG_ON(exit_code & 0x80); /* core dumps don't get here */
> >
> >Fundamentally the exit / wait status code cannot represent SIG128. In
> >fact it cannot represent SIG127 either as 0x7f represents a stopped
> >child.
> >
> >Therefore add sig_to_exitcode() and exitcode_to_sig() functions which
> >map signal numbers > 126 to exit code 126 and puts the remainder (i.e.
> >sig - 126) in higher bits. This allows WIFSIGNALED() to return true for
> >both SIG127 and SIG128, and allows WTERMSIG to be later updated to read
> >the correct signal number for SIG127 and SIG128.
> 
> I really hate this approach.
> 
> Can we just change the ABI to reduce the number of signals so that
> all the standard C library wait related macros don't have to be
> changed?

Changing the ABI is a very strong medicine that wants to be used very
carefully.

> Think about it, any user space program using signal numbers 127 and
> 128 doesn't work correctly as things exist today, so removing those
> two will be no great loss.

Glibc has it's own sigset_t of 1024 signals.  I wonder if it will even
use more than 64 signals.  Similar for other libcs.

  Ralf
