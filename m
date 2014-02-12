Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751511AbaBLEpi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 23:45:38 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:28820 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750922AbaBLEph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 23:45:37 -0500
Date: Tue, 11 Feb 2014 23:45:34 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Rusty Russell <rusty@rustcorp.com.au>,
        David Howells <dhowells@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [RFC PATCH] Fix: module signature vs tracepoints: add new
 TAINT_UNSIGNED_MODULE
Message-ID: <20140211234534.6bc34e57@gandalf.local.home>
In-Reply-To: <20140211072738.GA24232@gmail.com>
References: <1392074600-21977-1-git-send-email-mathieu.desnoyers@efficios.com>
	<20140211072738.GA24232@gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Feb 2014 08:27:38 +0100
Ingo Molnar <mingo@kernel.org> wrote:

> 
> * Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> 
> > Users have reported being unable to trace non-signed modules loaded 
> > within a kernel supporting module signature.
> 
> External modules should strive to get out of the 'crap' and
> 'felony law breaker' categories and we should not make it
> easier for them to linger in a broken state.
> 
> Nacked-by: Ingo Molnar <mingo@kernel.org>

I'm not sure how great this idea is, but it isn't the same as the
"crap" and "fenony law breaker" categories. Having a non-signed module
doesn't mean that it isn't fully GPL compliant, it just means that it
hasn't been signed. There's several things that can taint the kernel
when loading a module. Being non GPL compliant is just one of them, and
that will never be allowed to accept tracepoints.

Forcing a module that was built for a different kernel version gives us
another taint, which we don't add tracepoints for, not because it is
not compliant, but because that could corrupt the kernel as we can
not guarantee the binary structure layout of those modules would be the
same as what the kernel was built with. We don't want people
complaining about tracepoint failures due to forcing an older module
into a newer kernel with different tracepoint structures.

But if the kernel expects to have signed modules, and you force a
module to be loaded that is not signed, then you still get that
"forced" module taint, which is the same one as loading a module from
an older kernel into a newer kernel. It's a different problem, and I
can see having a different taint flag be more informative to kernel
developers in general. I would welcome that change with or without
letting tracepoints be set for that module.

But I have to ask Mathieu, what exactly is the use case here? If you
have a kernel that expects to only load signed modules, why would you
want to force non signed ones? That basically breaks the whole purpose
of signing modules. Once you allow a non signed module to be loaded
then the kernel can be considered compromised. That is, you just gave
kernel access to an untrusted source.

-- Steve
