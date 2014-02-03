Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643AbaBCOtH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 09:49:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26427 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072AbaBCOtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 09:49:04 -0500
From: Steve Grubb <sgrubb@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Oleg Nesterov <oleg@redhat.com>, Eric Paris <eparis@redhat.com>,
        linux-audit@redhat.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Why is syscall auditing on with no rules?
Date: Mon, 03 Feb 2014 09:49:02 -0500
Message-ID: <1583474.SDnjg18Qf7@x2>
Organization: Red Hat
User-Agent: KMail/4.11.5 (Linux/3.12.9-301.fc20.x86_64; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CALCETrX+crm9ubMqimSdzfALEniefKcAWZz3AhZ7zioy7dVKzQ@mail.gmail.com>
References: <CALCETrUEZiqQ7be5E7cBEmFEKqvwJ_eCxpE-hiGZ94Hkd4Q54Q@mail.gmail.com> <CALCETrX+crm9ubMqimSdzfALEniefKcAWZz3AhZ7zioy7dVKzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, February 01, 2014 06:51:56 PM Andy Lutomirski wrote:
> On Sat, Feb 1, 2014 at 6:32 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> > On a stock Fedora installation:
> > 
> > $ sudo auditctl -l
> > No rules

What rules would you want? The audit package ships with several which affects 
performance to varying degrees. The default one affects it the least. If you 
don't want auditing, don't install the audit package.


> > Nonetheless TIF_SYSCALL_AUDIT is set and the __audit_syscall_entry and
> > __audit_syscall_exit account for >20% of syscall overhead according to
> > perf.
> > 
> > This sucks.  Unless I'm missing something, syscall auditing is *off*.

The audit daemon enables auditing unless you add -s=nochange to the daemon's 
commandline parameters. The rules are loaded by a separate process so the 
deamon just enables auditing so that any selinux AVCs have more information 
and in case auditctl loads rules. If you don't want auditing, simply don't 
install it and things will be OK.


> > How hard would it be to arrange for TIF_SYSCALL_AUDIT to be cleared
> > when there are no syscall rules?

This only gets set if auditing is enabled. What if in the future someone loads 
rules? For example, what if you reload audit rules? The first thing that 
happens is it clears any previous rules. If we did what you suggested, then 
any process that runs between the time the rules were deleted and a rule gets 
loaded will never be auditable. We can't have that. Sometimes admins stop the 
audit daemon to do some looking around. Usually audit rules are cleared when 
its stopped. Once again you have a window where processes will become 
inauditable. 

We take the point of view that if you want auditing and all that it brings 
with it, this will be setup by the audit daemon. If you want no auditing and 
no performance hit, simply don't install it or disable it from starting and 
all will be fine.


> > (This is extra bad in kernels before 3.13, where the clear call for
> > TIF_SYSCALL_AUDIT was completely missing.)
> 
> The current code seems to have really odd effects.  For example,
> processes that are created before the very first auditctl -e 1 (or
> auditd) invocation will never be subject to syscall auditing.

This is correct. Its also why we have a audit=1 boot command. Anyone needing 
audit must have that boot configuration or they will have inauditable 
processes. This is documented in the auditd man page.


> But auditctl -e 1; auditctl -e 0 will cause all subsequently started
> processes to have audit contexts allocated and therefore to be subject
> to syscall auditing.
> 
> I doubt that this behavior is considered desirable.

What you are describing is the compromise between no performance hit and 
auditing. If you want it to work right, you have to set it up right. The 
audit=1 commandline prompt is in security docs like the NSA SNAC guide and 
encoded into security scanners that process STIG or USGCB content. I also 
believe its mentioned in Common criteria docs that any distribution that has 
been certified publishes.

HTH...

-Steve
