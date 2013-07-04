Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992Ab3GDHQJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 03:16:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25083 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755168Ab3GDHQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 03:16:07 -0400
Message-ID: <51D52134.8080601@redhat.com>
Date: Thu, 04 Jul 2013 09:16:04 +0200
From: Denys Vlasenko <dvlasenk@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Change SIGPIPE's siginfo.si_code from SI_USER to SI_KERNEL.
References: <1372880335-23755-1-git-send-email-dvlasenk@redhat.com> <20130703195452.GA6930@redhat.com>
In-Reply-To: <20130703195452.GA6930@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2013 09:54 PM, Oleg Nesterov wrote:
> On 07/03, Denys Vlasenko wrote:
>>
>> @@ -514,7 +514,7 @@ pipe_write(struct kiocb *iocb, const struct iovec *_iov,
>>  	__pipe_lock(pipe);
>>
>>  	if (!pipe->readers) {
>> -		send_sig(SIGPIPE, current, 0);
>> +		send_sig(SIGPIPE, current, 1);
> 
> Honestly, I simply have no idea what makes more sense in this case...

I guess I should have explained what prompted me to send this patch.

I am coding up a gdb extension which looks at a process which received
a signal and tries some heuristics on it which sya whether the observed
signal is a crash, and if it is, how likely it to be exploitable.
For example, a SIGSEGV due to smashed stack is more likely to be
a result of exploitable bug than a division by zero.

I want to quickly filter out cases where signal is clearly not a result
of program bug. Say, if program dies from SIGSEGV (or SIGBUS,
or SIGSYS...) which was *sent by the user via kill(2)*,
then it is not a bug in the program.

Naively, it looks like "if (siginfo.si_code <= 0) not_a_bug()"
is what would do that. In particular, si_code == 0 (SI_USER)
is set by kill(2).

But then I discovered that SI_USER is also set by signals
from other sources. SIGPIPE from write(2) is one of them.

This basically makes "si_code == SI_USER" condition non-informative:
userspace can't really draw any useful conclusion from seeing that.
"Maybe it was a kill(2), maybe it was from kernel". Not good.

Note that other similar signals, say, a SIGTTIN received
when backgrounded read(2) attempts to read from a tty,
use SI_KERNEL code. There is no consistency already.

-- 
vda



