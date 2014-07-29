Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbaG2Gut (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 02:50:49 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:43301 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbaG2Gus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 02:50:48 -0400
Message-ID: <53D7440B.10006@linaro.org>
Date: Tue, 29 Jul 2014 15:49:47 +0900
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Andy Lutomirski <luto@amacapital.net>, Deepak Saxena <dsaxena@linaro.org>,
        Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 1/3] arm64: ptrace: reload a syscall number after ptrace
 operations
References: <1406020499-5537-1-git-send-email-takahiro.akashi@linaro.org> <1406020499-5537-2-git-send-email-takahiro.akashi@linaro.org> <53D08358.4020902@amacapital.net> <53D0A037.2060308@linaro.org> <CALCETrU9_sdODRz-xZ4bouq+anHhmfx2tkr7hg00RVf_bBBJwg@mail.gmail.com> <53D23341.4040403@linaro.org> <20140725110342.GD5269@arm.com>
In-Reply-To: <20140725110342.GD5269@arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2014 08:03 PM, Will Deacon wrote:
> On Fri, Jul 25, 2014 at 11:36:49AM +0100, AKASHI Takahiro wrote:
>> On 07/25/2014 12:01 AM, Andy Lutomirski wrote:
>>>>> If so, then you risk (at least) introducing
>>>>>
>>>>> a nice user-triggerable OOPS if audit is enabled.
>>>>
>>>>
>>>> Can you please elaborate this?
>>>> Since I didn't find any definition of audit's behavior when syscall is
>>>> rewritten to -1, I thought it is reasonable to skip "exit tracing" of
>>>> "skipped" syscall.
>>>> (otherwise, "fake" seems to be more appropriate :)
>>>
>>> The audit entry hook will oops if you call it twice in a row without
>>> calling the exit hook in between.
>>
>> Thank you, I could reproduce this problem which hits BUG(in_syscall) in
>> audit_syscall_entry(). Really bad, and I fixed it in my next version and
>> now a "skipped" system call is also traced by audit.
>
> Can you reproduce this on arch/arm/ too? If so, we should also fix the code
> there.

As far as I tried on arm with syscall auditing enabled,

1) Changing a syscall number to -1 under seccomp doesn't hit BUG_ON(in_syscall).
2) But, in fact, audit_syscall_entry() is NOT called in this case because
    __secure_computing() returns -1 and then it causes the succeeding tracing
    in syscall_trace_enter(), including audit_syscall_entry(), skipped.
3) On the other hand, calling syscall(-1) from userspace hits BUG_ON because
    the return path, ret_slow_syscall, doesn't contain syscall_trace_exit().
4) When we re-write a syscall number to -1 without seccomp, we will also see
    BUG_ON hit, although I didn't try yet.

Fixing case 3 is easy, but should we also fix case 2?

Please note that, even if we call audit_syscall_exit() in case 2 or 3, no log against
syscall -1 will be recorded because audit_filter_syscall() doesn't allow logging
for any syscall number which is greater than 2048.
This behavior was introduced by Andy's patch, a3c54931, in v3.16-rc.
If the intention of "-1" is to fake a system call, this behavior seems to be a bit odd.

Thanks,
-Takahiro AKASHI


> Will
>
