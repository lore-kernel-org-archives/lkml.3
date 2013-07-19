Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761137Ab3GSTHx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 15:07:53 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:42456 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab3GSTHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 15:07:52 -0400
MIME-Version: 1.0
In-Reply-To: <51E967B6.8010305@gmail.com>
References: <CALCETrVioVM=pdCU3WhU6qDtGQyqML=btBRZ5+aV6bASj9GkOQ@mail.gmail.com>
 <51E88AEF.8040701@gmail.com> <CALCETrXnVBPNGGTQQoXnpEmjXHxbhiWx+4RuMVQLRG5sfMpofA@mail.gmail.com>
 <51E893BC.6070400@gmail.com> <CALCETrX2vU0aWdVKjOPGkVt1OzLp96xw9=PNaM1XaTEU8Y-HXg@mail.gmail.com>
 <51E967B6.8010305@gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 19 Jul 2013 12:07:31 -0700
Message-ID: <CALCETrUgOURSxEdXdyOQpdEfEVnxqw5oGq5aaHhzwj+osVh6DA@mail.gmail.com>
Subject: Re: [RFC / musing] Scoped exception handling in Linux userspace?
To: David Daney <ddaney.cavm@gmail.com>
Cc: linux-kernel@vger.kernel.org, gcc@gcc.gnu.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 9:22 AM, David Daney <ddaney.cavm@gmail.com> wrote:
> On 07/18/2013 08:29 PM, Andy Lutomirski wrote:
>>
>> Other way around: a *library* that wants to use exception handling
>> can't do so safely without the cooperation, or at least understanding,
>> of the main program and every other library that wants to do something
>> similar.  Suppose my library installs a SIGFPE handler and throws
>> my_sigfpe_exception and your library installs a SIGFPE handler and
>> throws your_sigfpe_exception.  The result: one wins and the other
>> crashes due to an unhandled exception.
>>
>> In my particular usecase, I have code (known to the main program) that
>> catches all kinds of fatal signals to log nice error messages before
>> dying.  That means that I can't use a library that handles signals for
>> any other purpose.  Right now I want to have a small snippet of code
>> handle SIGBUS, but now I need to coordinate it with everything else.
>>
>> If this stuff were unified, then everything would just work.
>
>
> That's right.  But I think the Linux kernel already supplies all the needed
> functionality to do this.  It is really a matter of choosing a userspace
> implementation and standardizing your entire system around it.  In the realm
> of GNU/GLibc/Linux, it is really more of social/political exercise rather
> than a technical problem.
>

The social problem could be solved by glibc (or maybe ld.so)
installing the relevant handlers automatically and taking advantage of
its sigaction wrapper to keep everything working.  But this has
technical problems:

1. Semantic changes: things like kill(pid, SIGSEGV) will no longer
result in a fatal signal, which would be a regression (albeit probably
harmless).  The results from /proc/pid/status might look a bit odd.
Separating out signals resulting from faulting instructions (vs other
causes) might be tricky.  I'm also not sure whether the ignored states
of SIGSEGV and SIGFPE are preserved across exec, but, if they are,
glibc will have trouble emulating this.

2. Unhandled signals: if SIGSEGV is handled (by, say, glibc) but there
is no exception handler that claims the signal, then there's currently
no way to tell the kernel to do everything it normally does on an
unhandled fatal signal (e.g. logging, dumping core correctly,
notifying ptracers, sending the right failure code to waitid).

--Andy
