Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733AbaA1ALZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 19:11:25 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:48189 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534AbaA1ALX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 19:11:23 -0500
Message-ID: <52E6F5A4.7070307@gmail.com>
Date: Tue, 28 Jan 2014 11:11:16 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Joe Perches <joe@perches.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Daniel Borkmann <dborkman@redhat.com>
Subject: Re: [PATCH] vsprintf: BUG on %n
References: <20140127230326.GA877@www.outflux.net>	<52E6E786.80301@gmail.com> <CAGXu5j+nyRM+4JbPwtnWpdO9mKTL15FTn0c0+8xK-kr0hJpgag@mail.gmail.com>
In-Reply-To: <CAGXu5j+nyRM+4JbPwtnWpdO9mKTL15FTn0c0+8xK-kr0hJpgag@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/01/14 10:56, Kees Cook wrote:
> On Mon, Jan 27, 2014 at 3:11 PM, Ryan Mallon <rmallon@gmail.com> wrote:
>> On 28/01/14 10:03, Kees Cook wrote:
>>> Now that there has been a full release of the kernel, and all users
>>> of %n have been dropped, switch to %n use triggering a BUG. Ignoring
>>> arguments could be used to assist in information leaks if an arbitrary
>>> format string was under the control of an attacker.
>>
>> Not sure I follow the reasoning. %n no longer does anything in the
>> kernel, so there is no risk if it does manage to find its way into a
>> printed string. BUG() is for unrecoverable errors, which this clearly isn't.
>>
>> Information leaks via injectable strings are still possible if an
>> attacker can insert %x, %d, etc. %n is more problematic since it allows
>> for code injection, which is why it got removed. %n is not however,
>> required to get an infoleak via a format string, so I think the summary
>> is also a bit misleading.
> 
> Yeah, I'm a bit uncomfortable with the BUG() too. The issue with %n is
> that it would produce no output at all to skip arguments. With other
> things, you have to take up output space, which may be limited. How
> about just not skipping the argument? Leave the warn_on, etc?

If you are trying to catch in kernel users of %n, then the warning is
probably fine. I don't think the presense of a %n in a format string,
without any injection vulnerability is going to cause a problem.

If you are trying to catch %n being injected by a malicious user into a
vulnerable string then a warning is fine as long as the string doesn't
allow code injection through some other means. I don't think you can
easily prevent infoleaks at runtime, since any vulnerable can have %x,
%s, or whatever injected to leak information on the stack. There was
some work on detecting potentially vulnerable strings at compile time I
think?

The reason to get rid of %n is to remove the ability to escalate an
infoleak on a vulnerable format string into code execution. Vulnerable
strings and infoleaks via them are really a separate issue, and
detecting %n does nothing to solve them.

%n should probably just be treated the same as any other %FOO which is
not a valid format string directive. Keeping the warning might be useful
for kernel developers who don't know that they shouldn't be using it.
Then again, sparse, checkpatch or code review might be the better place
to do that.

~Ryan

