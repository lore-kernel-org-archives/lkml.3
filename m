Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358AbaBCQo3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 11:44:29 -0500
Received: from mail-ve0-f170.google.com ([209.85.128.170]:41788 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249AbaBCQo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 11:44:28 -0500
MIME-Version: 1.0
In-Reply-To: <1583474.SDnjg18Qf7@x2>
References: <CALCETrUEZiqQ7be5E7cBEmFEKqvwJ_eCxpE-hiGZ94Hkd4Q54Q@mail.gmail.com>
 <CALCETrX+crm9ubMqimSdzfALEniefKcAWZz3AhZ7zioy7dVKzQ@mail.gmail.com> <1583474.SDnjg18Qf7@x2>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 3 Feb 2014 08:44:07 -0800
Message-ID: <CALCETrUTn1ie+cFHRT58W_MrjJUwP2S31kBZm1-t0BKYewZWAA@mail.gmail.com>
Subject: Re: Why is syscall auditing on with no rules?
To: Steve Grubb <sgrubb@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Eric Paris <eparis@redhat.com>,
        linux-audit@redhat.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 3, 2014 at 6:49 AM, Steve Grubb <sgrubb@redhat.com> wrote:
> On Saturday, February 01, 2014 06:51:56 PM Andy Lutomirski wrote:
>> On Sat, Feb 1, 2014 at 6:32 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> > On a stock Fedora installation:
>> >
>> > $ sudo auditctl -l
>> > No rules
>
> What rules would you want? The audit package ships with several which affects
> performance to varying degrees. The default one affects it the least. If you
> don't want auditing, don't install the audit package.

Actually, 'task,never' is lower overhead on 3.13, but I'm fine with
"No rules".  However...

>> > How hard would it be to arrange for TIF_SYSCALL_AUDIT to be cleared
>> > when there are no syscall rules?
>
> This only gets set if auditing is enabled. What if in the future someone loads
> rules? For example, what if you reload audit rules? The first thing that
> happens is it clears any previous rules. If we did what you suggested, then
> any process that runs between the time the rules were deleted and a rule gets
> loaded will never be auditable. We can't have that. Sometimes admins stop the
> audit daemon to do some looking around. Usually audit rules are cleared when
> its stopped. Once again you have a window where processes will become
> inauditable.
>
> We take the point of view that if you want auditing and all that it brings
> with it, this will be setup by the audit daemon. If you want no auditing and
> no performance hit, simply don't install it or disable it from starting and
> all will be fine.

I actually do want auditing -- I need it if I want to see AVC denials.
 But I don't want syscall auditing, nor do most people, which is
entirely consistent with the default rules.

It's permissible to set and clear TIF_SYSCALL_AUDIT from a different
thread.  Given that changing the list of syscall audit rules is
probably *much* rarer than calling a syscall and that
TIF_SYSCALL_AUDIT appears to more than double total syscall latency on
Sandy Bridge (and it quite possible even worse on newer hardware), it
seems to me that a much better solution would be to dynamically turn
TIF_SYSCALL_AUDIT on and off.

I wouldn't hesitate to implement this, except that I'm a bit scared of
the code.  (e.g. why is audit_context in task_struct still there even
if syscsall auditing is configured out.  What happens if a task enters
a syscall w/ TIF_SYSCALL_AUDIT clear and returns with it set or vice
versa?)

I'd go even farther and allow auditing to be globally turned on after
processes are created (removing the need for audit=1 or whatever), but
that would require a lot more familiarity with the code.

--Andy
