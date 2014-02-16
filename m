Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbaBPX6W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 18:58:22 -0500
Received: from mail.efficios.com ([78.47.125.74]:52511 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbaBPX6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 18:58:21 -0500
Date: Sun, 16 Feb 2014 23:58:21 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Howells <dhowells@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Message-ID: <1459243542.25793.1392595101293.JavaMail.zimbra@efficios.com>
In-Reply-To: <878uteecu0.fsf@rustcorp.com.au>
References: <1392074600-21977-1-git-send-email-mathieu.desnoyers@efficios.com> <20140211072738.GA24232@gmail.com> <20140211234534.6bc34e57@gandalf.local.home> <877g8zg0ed.fsf@rustcorp.com.au> <20140213161156.3548df43@gandalf.local.home> <878uteecu0.fsf@rustcorp.com.au>
Subject: Re: [RFC PATCH] Fix: module signature vs tracepoints: add new
 TAINT_UNSIGNED_MODULE
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [206.248.138.119]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF27 (Linux)/8.0.5_GA_5839)
Thread-Topic: module signature vs tracepoints: add new TAINT_UNSIGNED_MODULE
Thread-Index: LTdzGWYE83Hmr/o2mXD/Xu772q6pXg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Rusty Russell" <rusty@rustcorp.com.au>
> To: "Steven Rostedt" <rostedt@goodmis.org>
> Cc: "Ingo Molnar" <mingo@kernel.org>, "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>,
> linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@redhat.com>, "Thomas Gleixner" <tglx@linutronix.de>, "David
> Howells" <dhowells@redhat.com>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
> Sent: Thursday, February 13, 2014 7:51:19 PM
> Subject: Re: [RFC PATCH] Fix: module signature vs tracepoints: add new TAINT_UNSIGNED_MODULE
> 
> Steven Rostedt <rostedt@goodmis.org> writes:
> > On Thu, 13 Feb 2014 13:54:42 +1030
> > Rusty Russell <rusty@rustcorp.com.au> wrote:
> >
> >
> >> I'm ambivalent towards out-of-tree modules, so not tempted unless I see
> >> a bug report indicating a concrete problem.  Then we can discuss...
> >
> > As I replied in another email, this is a concrete problem, and affects
> > in-tree kernel modules.
> >
> > If you have the following in your .config:
> >
> > CONFIG_MODULE_SIG=y
> > # CONFIG_MODULE_SIG_FORCE is not set
> > # CONFIG_MODULE_SIG_ALL is not set
> 
> This means you've set the "I will arrange my own module signing" config
> option:
> 
> 	  Sign all modules during make modules_install. Without this option,
> 	  modules must be signed manually, using the scripts/sign-file tool.
> 
> comment "Do not forget to sign required modules with scripts/sign-file"
> 	depends on MODULE_SIG_FORCE && !MODULE_SIG_ALL
> 
> Then you didn't do that.  You broke it, you get to keep both pieces.
> 
> Again: is there an actual valid use case?

One use-case where this is biting us for in-tree modules is when a user or
developer recompile modules against a distribution kernel which has
CONFIG_MODULE_SIG set (and possibly CONFIG_MODULE_SIG_ALL), but do not
recompile the kernel per se. That user/developer might want to try out a
local modification to one of his modules (which is something within the
user's rights given by the GPL), or want to add tracepoints to a module to
figure out what is going wrong. It is then not possible to sign the
recompiled modules, since it makes no sense to expect distribution vendors
to ever distribute their private signing keys; that would defeat the whole
point of signing.

In those cases, when loaded in a kernel that is not enforcing module
signature, the recompiled modules will taint the kernel and modules with
"TAINT_FORCED_MODULE" (which is a lie: the modules can be loaded without
--force), and the tracepoints sitting in that module are silently ignored
(which is a bug).

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
