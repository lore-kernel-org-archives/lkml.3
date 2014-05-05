Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223AbaEECUG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 22:20:06 -0400
Received: from ozlabs.org ([103.22.144.67]:39676 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754018AbaEECUC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 22:20:02 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Mateusz Guzik <mguzik@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Kay Sievers <kay@vrfy.org>
Subject: Re: [RFC PATCH] cmdline: Hide "debug" from /proc/cmdline
In-Reply-To: <20140502153409.329d3b5b426275e8197251a2@linux-foundation.org>
References: <20140402144219.4cafbe37@gandalf.local.home> <20140402221212.GD16570@mguzik.redhat.com> <CA+55aFyZSr4G2a1X5+EeSgKGtZvzBfBg0D0L39g-DB9TLi+ZEw@mail.gmail.com> <87wqf1oi22.fsf@rustcorp.com.au> <20140502153409.329d3b5b426275e8197251a2@linux-foundation.org>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 05 May 2014 11:47:22 +0930
Message-ID: <871tw9c6kt.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:
> On Mon, 07 Apr 2014 14:24:45 +0930 Rusty Russell <rusty@rustcorp.com.au> wrote:
>
>> Subject: param: hand arguments after -- straight to init
>> 
>> The kernel passes any args it doesn't need through to init, except it
>> assumes anything containing '.' belongs to the kernel (for a module).
>> This change means all users can clearly distinguish which arguments
>> are for init.
>> 
>> For example, the kernel uses debug ("dee-bug") to mean log everything to
>> the console, where systemd uses the debug from the Scandinavian "day-boog"
>> meaning "fail to boot".  If a future versions uses argv[] instead of
>> reading /proc/cmdline, this confusion will be avoided.
>> 
>> eg: test 'FOO="this is --foo"' -- 'systemd.debug="true true true"'
>> 
>> Gives:
>> argv[0] = '/debug-init'
>> argv[1] = 'test'
>> argv[2] = 'systemd.debug=true true true'
>> envp[0] = 'HOME=/'
>> envp[1] = 'TERM=linux'
>> envp[2] = 'FOO=this is --foo'
>
> This (user-facing) feature doesn't seem to have been documented
> anywhere.  Documentation/kernel-parameters.txt, I guess.

That document does need some love.  How's this?

1) __setup() is messy, prefer module_param and core_param.
2) Document --
3) Document modprobe scraping /proc/cmdline.
4) Document handing of leftover parameters to init.
5) Document use of quotes to protect whitespace.

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 43842177b771..56a4c2d0c741 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1,27 +1,37 @@
                           Kernel Parameters
                           ~~~~~~~~~~~~~~~~~
 
-The following is a consolidated list of the kernel parameters as implemented
-(mostly) by the __setup() macro and sorted into English Dictionary order
-(defined as ignoring all punctuation and sorting digits before letters in a
-case insensitive manner), and with descriptions where known.
-
-Module parameters for loadable modules are specified only as the
-parameter name with optional '=' and value as appropriate, such as:
-
-	modprobe usbcore blinkenlights=1
-
-Module parameters for modules that are built into the kernel image
-are specified on the kernel command line with the module name plus
-'.' plus parameter name, with '=' and value if appropriate, such as:
-
-	usbcore.blinkenlights=1
+The following is a consolidated list of the kernel parameters as
+implemented by the __setup(), core_param() and module_param() macros
+and sorted into English Dictionary order (defined as ignoring all
+punctuation and sorting digits before letters in a case insensitive
+manner), and with descriptions where known.
+
+The kernel parses parameters from the kernel command line up to "--";
+if it doesn't recognize a parameter and it doesn't contain a '.', the
+parameter gets passed to init: parameters with '=' go into init's
+environment, others are passed as command line arguments to init.
+Everything after "--" is passed as an argument to init.
+
+Module parameters can be specified in two ways: via the kernel command
+line with a module name prefix, or via modprobe, eg:
+
+	(kernel command line) usbcore.blinkenlights=1
+	(modprobe command line) modprobe usbcore blinkenlights=1
+
+Parameters for modules which are built into the kernel need to be
+specified on the kernel command line.  modprobe looks through the
+kernel command line (/proc/cmdline) and collects module parameters
+when it loads a module, so the kernel command line can be used for
+loadable modules too.
 
 Hyphens (dashes) and underscores are equivalent in parameter names, so
 	log_buf_len=1M print-fatal-signals=1
 can also be entered as
 	log-buf-len=1M print_fatal_signals=1
 
+Double-quotes can be used to protect spaces in values, eg:
+	param="spaces in here"
 
 This document may not be entirely up to date and comprehensive. The command
 "modinfo -p ${modulename}" shows a current list of all parameters of a loadable
