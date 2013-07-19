Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759567Ab3GSA0f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 20:26:35 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:51986 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759208Ab3GSA0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 20:26:33 -0400
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 18 Jul 2013 17:26:12 -0700
Message-ID: <CALCETrVioVM=pdCU3WhU6qDtGQyqML=btBRZ5+aV6bASj9GkOQ@mail.gmail.com>
Subject: [RFC / musing] Scoped exception handling in Linux userspace?
To: linux-kernel@vger.kernel.org
Cc: gcc@gcc.gnu.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Windows has a feature that I've wanted on Linux forever: stack-based
(i.e. scoped) exception handling.  The upshot is that you can do,
roughly, this (pseudocode):

int callback(...)
{
  /* Called if code_that_may_fault faults.  May return "unwind to
landing pad", "propagate the fault", or "fixup and retry" */
}

void my_function()
{
  __hideous_try_thing(callback) {
    code_that_may_fault();
  } blahblahblah {
    landing_pad_code();
  }
}

Windows calls it SEH (structured exception handling), and the
implementation on 32-bit Windows is rather gnarly.  I don't really
know how it works on 64-bit windows, but I think it's saner.

This has two really nice properties:

1. It works in libraries!

2. It's localized.  So you can mmap something, read from it *and
handle SIGBUS*, and unmap.

Could Linux support such a thing?  Here's a sketch of a way:

 - The kernel would need to have a fairly well-defined concept of
synchronous faults that can be handled with this mechanism.  Calls to
force_sig_info are probably the right thing to hook in to.

 - The userspace runtime optionally registers (via a new syscall or
prctl, say) a handler for synchronous faults.

 - When a synchronous fault happens, if the process (struct
sighand_struct) has a synchronous fault handler registered, the signal
is delivered to that handler, on the thread that faulted, instead of
via the normal signal handling mechanism.

 - The userspace runtime walks the chain of personality handlers and
gives them a chance to respond.

 - If no handler claims the fault, then the user code somehow* causes
ordinary signal delivery to happen.

* This may need kernel help, too -- if the process is going to die, it
should die for the right reason, so perhaps there should be a syscall
to redeliver the signal.  If the runtime wants to be fancy and a
signal handler is installed, then there could be a fast path.  Maybe
if we got really fancy, it could live in the vdso.

Now everyone wins!  After someone writes the libgcc support for this
(ugh!), then you can write CFI-based exception handlers in assembly!
Presumably you could write them in C++, too, if you don't care about
restarting, like this:

try {
   code_that_may_fault();
} catch (cxxabi::synchronous_kernel_fault &) {
   amazingly_dont_crash();
}

Is this worth persuing?  I'm not touching the gcc part with a ten-foot
pole, but I could probably do some of the kernel work.  I'm a bit
scared of libgcc, too.

It's worth noting that SIGBUS isn't the only interesting signal here.
SIGFPE could work, too.  I'm not sure whether SIGPIPE would make
sense.  SIGSEGV would clearly work, but anyone using this mechanism
for SIGSEGV is probably asking for trouble.


--Andy

P.S.  Just because you can probably get away with throwing a C++
exception from a signal handler right now does not mean it's a good
idea.  Especially in a library.
