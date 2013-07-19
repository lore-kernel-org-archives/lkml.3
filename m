Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759621Ab3GSDaQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 23:30:16 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:54108 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754951Ab3GSDaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 23:30:15 -0400
MIME-Version: 1.0
In-Reply-To: <51E893BC.6070400@gmail.com>
References: <CALCETrVioVM=pdCU3WhU6qDtGQyqML=btBRZ5+aV6bASj9GkOQ@mail.gmail.com>
 <51E88AEF.8040701@gmail.com> <CALCETrXnVBPNGGTQQoXnpEmjXHxbhiWx+4RuMVQLRG5sfMpofA@mail.gmail.com>
 <51E893BC.6070400@gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 18 Jul 2013 20:29:52 -0700
Message-ID: <CALCETrX2vU0aWdVKjOPGkVt1OzLp96xw9=PNaM1XaTEU8Y-HXg@mail.gmail.com>
Subject: Re: [RFC / musing] Scoped exception handling in Linux userspace?
To: David Daney <ddaney.cavm@gmail.com>
Cc: linux-kernel@vger.kernel.org, gcc@gcc.gnu.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 6:17 PM, David Daney <ddaney.cavm@gmail.com> wrote:
> On 07/18/2013 05:50 PM, Andy Lutomirski wrote:
>>
>> On Thu, Jul 18, 2013 at 5:40 PM, David Daney <ddaney.cavm@gmail.com>
>> wrote:
>>>
>>> On 07/18/2013 05:26 PM, Andy Lutomirski wrote:
>>>
>>>
>>> How is this different than throwing exceptions from a signal handler?
>>
>>
>> Two ways.  First, exceptions thrown from a signal handler can't be
>> retries.
>
>
> ??

s/retries/retried, by which I mean that you can't do things like
implementing virtual memory in userspace by catching SIGSEGV, calling
mmap, and resuming.

>
>
>> Second, and more importantly, installing a signal handler in
>> a library is a terrible idea.
>
>
> The signal handler would be installed by main() before calling into the
> library.  You have to have a small amount of boiler plate code to set it up,
> but the libraries wouldn't have to be modified if they were already
> exception safe.
>
> FWIW the libgcj java runtime environment uses this strategy for handling
> NullPointerExceptions and DivideByZeroError(sp?).  Since all that code for
> the most part follows the standard C++ ABIs, it is an example of this
> technique that has been deployed in many environments.

Other way around: a *library* that wants to use exception handling
can't do so safely without the cooperation, or at least understanding,
of the main program and every other library that wants to do something
similar.  Suppose my library installs a SIGFPE handler and throws
my_sigfpe_exception and your library installs a SIGFPE handler and
throws your_sigfpe_exception.  The result: one wins and the other
crashes due to an unhandled exception.

In my particular usecase, I have code (known to the main program) that
catches all kinds of fatal signals to log nice error messages before
dying.  That means that I can't use a library that handles signals for
any other purpose.  Right now I want to have a small snippet of code
handle SIGBUS, but now I need to coordinate it with everything else.

If this stuff were unified, then everything would just work.

--Andy
