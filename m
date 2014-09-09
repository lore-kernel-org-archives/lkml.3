Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740AbaIIEtA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 00:49:00 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:39593 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbaIIEs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 00:48:59 -0400
Message-ID: <540E86B3.7080700@linaro.org>
Date: Tue, 09 Sep 2014 13:48:51 +0900
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: will.deacon@arm.com, viro@zeniv.linux.org.uk, eparis@redhat.com,
        rgb@redhat.com, dsaxena@linaro.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com
Subject: Re: [PATCH] arm: prevent BUG_ON in audit_syscall_entry()
References: <1409910393-30896-1-git-send-email-takahiro.akashi@linaro.org> <20140905095252.GF30401@n2100.arm.linux.org.uk>
In-Reply-To: <20140905095252.GF30401@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell,

On 09/05/2014 06:52 PM, Russell King - ARM Linux wrote:
> On Fri, Sep 05, 2014 at 06:46:33PM +0900, AKASHI Takahiro wrote:
>> BUG_ON() in audit_syscall_entry() will be hit if user issues syscall(-1)
>> while syscall auditing is enabled (that is, by starting auditd).
>> In fact, syscall(-1) just fails (not signaled despite the expectation,
>> this is another minor bug), but the succeeding syscall hits BUG_ON.
>>
>> When auditing syscall(-1), audit_syscall_entry() is called anyway, but
>> audit_syscall_exit() is not called and then 'in_syscall' flag in thread's
>> audit context is kept on. In this way, audit_syscall_entry() against
>> the succeeding syscall will see BUG_ON(in_syscall).
>>
>> This patch fixes this bug by
>> 1) enforcing syscall exit tracing, including audit_syscall_exit(), to be
>>     executed in all cases,
>
> Really, no.  That adds additional overhead to every syscall, and that
> matters for system performance.  We want to have as little as possible
> overhead here.

My words might have confused you, but this issue exists, in the current
mainline kernel, not only against syscall(-1), but any invalid or pseudo syscalls.
(And other archs seem to behave in the same way AFAIK.)
But if you want, I can fix it.
See my next version.

-Takahiro AKASHI

> The second issue here is that you haven't explained where the oops
> occurs.  It's seen as a good practice to include the oops dump for the
> bug you're fixing in the commit changelog, so that others can see the
> starting point for the investigation, and see exactly where things are
> going wrong.
>
