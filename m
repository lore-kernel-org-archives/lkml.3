Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333AbaIBH6w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 03:58:52 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:41531 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbaIBH6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 03:58:51 -0400
Message-ID: <540578AE.8090000@linaro.org>
Date: Tue, 02 Sep 2014 16:58:38 +0900
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Kees Cook <keescook@chromium.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Deepak Saxena <dsaxena@linaro.org>, "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 2/6] arm64: ptrace: allow tracer to skip a system call
References: <1408611405-8943-1-git-send-email-takahiro.akashi@linaro.org> <1408611405-8943-3-git-send-email-takahiro.akashi@linaro.org> <CAGXu5jJCyqpXkdvNDCu+eMr0qnqwbqUUo4u+2p_7DvFMzfKoEw@mail.gmail.com> <53F69045.7010301@linaro.org> <20140826175128.GD23445@arm.com> <53FD72E2.4020103@linaro.org> <20140901113755.GA24594@arm.com>
In-Reply-To: <20140901113755.GA24594@arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2014 08:37 PM, Will Deacon wrote:
> On Wed, Aug 27, 2014 at 06:55:46AM +0100, AKASHI Takahiro wrote:
>> On 08/27/2014 02:51 AM, Will Deacon wrote:
>>> On Fri, Aug 22, 2014 at 01:35:17AM +0100, AKASHI Takahiro wrote:
>>>> Oops, you're absolutely right. I didn't think of this case.
>>>> syscall_trace_enter() should not return a syscallno directly, but always
>>>> return -1 if syscallno < 0. (except when secure_computing() returns with -1)
>>>> This also implies that tracehook_report_syscall() should also have a return value.
>>>>
>>>> Will, is this fine with you?
>>>
>>> Well, the first thing that jumps out at me is why this is being done
>>> completely differently for arm64 and arm. I thought adding the new ptrace
>>> requests would reconcile the differences?
>>
>> I'm not sure what portion of my code you mentioned as "completely different", but
>>
>> 1)
>> setting x0 to -ENOSYS is necessary because, otherwise, user-issued syscall(-1) will
>> return a bogus value when audit tracing is on.
>>
>> Please note that, on arm,
>>                    not traced      traced
>>                    ------          ------
>> syscall(-1)      aborted         OOPs(BUG_ON)
>> syscall(-3000)   aborted         aborted
>> syscall(1000)    ENOSYS          ENOSYS
>>
>> So, anyhow, its a bit difficult and meaningless to mimic these invalid cases.
>
> I'm not suggesting we make ourselves bug-compatible with ARM. Instead, I'd
> rather see a series of patches getting the ARM code working correctly,
> before we go off doing something different for arm64.

I see.

>> 2)
>> branching a new label, syscall_trace_return_skip (see entry.S), after syscall_trace_enter()
>> is necessary in order to avoid OOPS in audit_syscall_enter() as we discussed.
>>
>> Did I make it clear?
>
> Sure. So let's fix ARM, then look at the arm64 port after that. I really
> want to avoid divergence in this area.

Okey, I will start with fixing the issue on arm.

-Takahiro AKASHI

> Will
>
