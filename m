Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751606Ab3FVTOg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 15:14:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60682 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751086Ab3FVTOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 15:14:34 -0400
Date: Sat, 22 Jun 2013 21:09:40 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Daney <ddaney@caviumnetworks.com>
Cc: David Daney <ddaney.cavm@gmail.com>, James Hogan <james.hogan@imgtec.com>,
        linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        David Daney <david.daney@cavium.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        linux-mips@linux-mips.org
Subject: Re: [PATCH v3] kernel/signal.c: fix BUG_ON with SIG128 (MIPS)
Message-ID: <20130622190940.GA14150@redhat.com>
References: <1371821962-9151-1-git-send-email-james.hogan@imgtec.com> <51C47864.9030200@gmail.com> <20130621202244.GA16610@redhat.com> <51C4BB86.1020004@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51C4BB86.1020004@caviumnetworks.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21, David Daney wrote:
>
> On 06/21/2013 01:22 PM, Oleg Nesterov wrote:
>> On 06/21, David Daney wrote:
>>>
>>> On 06/21/2013 06:39 AM, James Hogan wrote:
>>>> Therefore add sig_to_exitcode() and exitcode_to_sig() functions which
>>>> map signal numbers > 126 to exit code 126 and puts the remainder (i.e.
>>>> sig - 126) in higher bits. This allows WIFSIGNALED() to return true for
>>>> both SIG127 and SIG128, and allows WTERMSIG to be later updated to read
>>>> the correct signal number for SIG127 and SIG128.
>>>
>>> I really hate this approach.
>>>
>>> Can we just change the ABI to reduce the number of signals so that all
>>> the standard C library wait related macros don't have to be changed?
>>>
>>> Think about it, any user space program using signal numbers 127 and 128
>>> doesn't work correctly as things exist today, so removing those two will
>>> be no great loss.
>>
>> Oh, I agree.
>>
>> Besides, this changes ABI anyway. And if we change it we can do this in
>> a more clean way, afaics. MIPS should simply use 2 bytes in exit_code for
>> signal number.
>
> Wouldn't that break *all* existing programs that use signals?  Perhaps I
> misunderstand what you are suggesting.

Of course this will break the userspace more than the original patch,
that is why I said "And yes, this means that WIFSIGNALED/etc should
be updated".

> I am proposing that we just reduce the number of usable signals such
> that existing libc status checking macros/functions don't change in any
> way.

And I fully agree! Absolutely, sorry for confusion.


What I tried to say, _if_ we change the ABI instead, lets make this
change sane.

To me this hack is not sane. And btw, the patch doesn't look complete.
Say, wait_task_zombie() should do exitcode_to_sig() for ->si_status.

Oleg.

