Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751327AbaAJEeR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 23:34:17 -0500
Received: from mail.efficios.com ([78.47.125.74]:49259 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702AbaAJEeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 23:34:14 -0500
Date: Fri, 10 Jan 2014 04:34:12 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <40484806.5780.1389328452206.JavaMail.zimbra@efficios.com>
In-Reply-To: <607356267.5770.1389328173087.JavaMail.zimbra@efficios.com>
Subject: powerpc: possible access beyond TASK_SIZE in start_thread
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [206.248.138.119]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF26 (Linux)/8.0.5_GA_5839)
Thread-Topic: powerpc: possible access beyond TASK_SIZE in start_thread
Thread-Index: I0QZQyMoQ9+tiPdpVvLF+/QTSIxN8Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

I was looking at the diff between kernel v3.12 and recent master (after 3.13-rc7),
and noticed that in the following commit:

commit 94af3abf995b17f6a008b00152c94841242ec6c7
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Wed Nov 20 22:15:02 2013 +1100

    powerpc: ELF2 binaries launched directly.

on powerpc, those lines appear in start_thread():

+                       /* start is a relocated pointer to the function
+                        * descriptor for the elf _start routine.  The first
+                        * entry in the function descriptor is the entry
+                        * address of _start and the second entry is the TOC
+                        * value we need to use.
+                        */
+                       __get_user(entry, (unsigned long __user *)start);
+                       __get_user(toc, (unsigned long __user *)start+1);

Note the "__" before get_user(), which bypass any kind of validation on the
addresses.

Amongst the callers, if we look at fs/binfmt_elf.c:load_elf_binary(), we see:

                elf_entry = loc->elf_ex.e_entry;
                if (BAD_ADDR(elf_entry)) {
                        force_sig(SIGSEGV, current);
                        retval = -EINVAL;
                        goto out_free_dentry;
                }

and the elf_entry gets passed to start_thread().

If we craft a binary with elf_entry address of

TASK_SIZE - 1  (1 byte before TASK_SIZE), then I think we could make both
__get_user() calls access data beyond TASK_SIZE, because elf_entry address
is verified, but there is no validation on its range AFAIU. Is it expected ?
Am I missing something ?

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
