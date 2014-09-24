Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173AbaIXJMV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 05:12:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39356 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753253AbaIXJMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 05:12:18 -0400
Date: Wed, 24 Sep 2014 11:12:12 +0200
From: Martin Milata <mmilata@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Mark Wielaard <mjw@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] coredump: add %i/%I in core_pattern to report the tid
 of the crashed thread
Message-ID: <20140924091211.GA7034@fe.brq.redhat.com>
References: <20140921175349.GA21585@redhat.com>
 <20140922171525.GA32171@redhat.com>
 <20140923160551.8e93a39f10a818684a514cf2@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140923160551.8e93a39f10a818684a514cf2@linux-foundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 16:05:51 -0700, Andrew Morton wrote:
> On Mon, 22 Sep 2014 19:15:25 +0200 Oleg Nesterov <oleg@redhat.com> wrote:
> 
> > format_corename() can only pass the leader's pid to the core handler, but
> > there is no simple way to figure out which thread originated the coredump.
> > 
> > As Jan explains, this also means that there is no simple way to create the
> > backtrace of the crashed process:
> > 
> > As programs are mostly compiled with implicit gcc -fomit-frame-pointer one
> > needs program's .eh_frame section (equivalently PT_GNU_EH_FRAME segment) or
> > .debug_frame section. .debug_frame usually is present only in separate debug
> > info files usually not even installed on the system.  While .eh_frame is a
> > part of the executable/library (and it is even always mapped for C++
> > exceptions unwinding) it no longer has to be present anywhere on the disk
> > as the program could be upgraded in the meantime and the running instance
> > has its executable file already unlinked from disk.
> > 
> > One possibility is to echo 0x3f >/proc/*/coredump_filter and dump all the
> > file-backed memory including the executable's .eh_frame section. But that
> > can create huge core files, for example even due to mmapped data files.
> > 
> > Other possibility would be to read .eh_frame from /proc/PID/mem at the
> > core_pattern handler time of the core dump.  For the backtrace one needs to
> > read the register state first which can be done from core_pattern handler:
> > 
> > 	ptrace(PTRACE_SEIZE, tid, 0, PTRACE_O_TRACEEXIT)
> > 	close(0);    // close pipe fd to resume the sleeping dumper
> > 	waitpid();   // should report EXIT
> > 	PTRACE_GETREGS or other requests
> > 
> > The remaining problem is how to get the 'tid' value of the crashed thread.
> > It could be read from the first NT_PRSTATUS note of the core file but that
> > makes the core_pattern handler complicated.
> > 
> > Unfortunately %t is already used so this patch uses %i/%I.
> 
> Is any userspace actually going to use this?  If so, details?
> 
> Am wondering what is driving this change...

Automatic Bug Reporting Tool [1] is experimenting with this. It is using
elfutils [2] unwinder for generating the backtraces. Apart from not
needing matching executables as mentioned above, another advantage is
that we can get the backtrace without saving the core (which might be
quite large) to disk.

[1] https://github.com/abrt/abrt/wiki/overview
[2] https://fedorahosted.org/elfutils/
