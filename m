Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249AbaE2CT5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 22:19:57 -0400
Received: from icp-osb-irony-out5.external.iinet.net.au ([203.59.1.221]:52262
	"EHLO icp-osb-irony-out5.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751952AbaE2CT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 22:19:56 -0400
X-Greylist: delayed 669 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 May 2014 22:19:55 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArwBACiVhlOVhxBY/2dsb2JhbAANTa5AAQEBAQEBBpUHhECDR1EpFBYYAwIBAgFLAQwIAQEXug6mGReFVY1EBJVzixaPXQ
X-IronPort-AV: E=Sophos;i="4.98,932,1392134400"; 
   d="scan'208";a="196962849"
Message-ID: <538696A0.5090601@uclinux.org>
Date: Thu, 29 May 2014 12:08:32 +1000
From: Greg Ungerer <gerg@uclinux.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>
Subject: rcu alignment warning tripping on m68k
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Inside kernel/rcy/tree.c in __call_rcu() it does an alignment check on
the head pointer passed in. This trips on m68k systems, because they only
need alignment of 32bit quantities to 16bit boundaries.

...
UDP hash table entries: 512 (order: 0, 8192 bytes)
UDP-Lite hash table entries: 512 (order: 0, 8192 bytes)
NET: Registered protocol family 1
ROMFS MTD (C) 2007 Red Hat, Inc.
------------[ cut here ]------------
WARNING: CPU: 0 PID: 18 at kernel/rcu/tree.c:2470 0x400577e0()
Modules linked in:
CPU: 0 PID: 18 Comm: kworker/u2:0 Not tainted 3.15.0-rc4-00013-g1c07b64-dirty #14
Stack from 418ada9c:
        418ada9c 401e8336 400258e0 401c69c4 418ac000 418a86f6 4003bc0a 418a8390
        418a86f6 4002590e 401e176b 000009a6 400577e0 00000009 00000000 400577e0
        401e176b 000009a6 401c69c4 418ac000 418a8390 418a8390 418ac000 40057928
        418a86f6 40025bcc 40218fe0 00000000 401ddb56 401e17ad 000002af 400261c2
        418a86f6 40025bcc 00000013 00000030 00000010 00000013 418ac000 418adf88
        418a8390 418adf70 400263f0 418a8000 418adf18 41885950 00000000 00000000
Call Trace:
        [<400258e0>] 0x400258e0
 [<401c69c4>] 0x401c69c4
 [<4003bc0a>] 0x4003bc0a
 [<4002590e>] 0x4002590e
 [<400577e0>] 0x400577e0


What is the best solution to fix?
Make the alignment check be only 16bits?

--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -2467,7 +2467,7 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_
        unsigned long flags;
        struct rcu_data *rdp;
 
-       WARN_ON_ONCE((unsigned long)head & 0x3); /* Misaligned rcu_head! */
+       WARN_ON_ONCE((unsigned long)head & 0x1); /* Misaligned rcu_head! */
        if (debug_rcu_head_queue(head)) {
                /* Probable double call_rcu(), so leak the callback. */
                ACCESS_ONCE(head->func) = rcu_leak_callback;


Or should we just get rid of this check altogether?

Regards
Greg

