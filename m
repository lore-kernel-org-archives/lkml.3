Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285Ab3FRQJg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 12:09:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33531 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755410Ab3FRQJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 12:09:35 -0400
Date: Tue, 18 Jun 2013 12:09:11 -0400
From: Dave Jones <davej@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: [x86][v2] only print out DR registers if they are not power-on
 defaults.
Message-ID: <20130618160911.GA24487@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org
References: <20130618041132.GA23492@redhat.com>
 <20130618084356.GA13123@pd.tnic>
 <20130618140730.GA1313@redhat.com>
 <20130618155919.GC13123@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130618155919.GC13123@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DR registers are rarely useful when decoding oopses.
With screen real estate during oopses at a premium, we can save two lines
by only printing out these registers when they are set to something other
than they power-on state.

[v2: incorporate D6 change suggested by Borislav Petkov <bp@alien8.de>]

Signed-off-by: Dave Jones <davej@redhat.com>

diff -durpN '--exclude-from=/home/davej/.exclude' /home/davej/src/kernel/git-trees/linux/arch/x86/kernel/process_64.c linux-dj/arch/x86/kernel/process_64.c
--- linux/arch/x86/kernel/process_64.c	2013-05-01 10:02:52.064151923 -0400
+++ linux-dj/arch/x86/kernel/process_64.c	2013-05-06 20:35:09.219868881 -0400
@@ -105,11 +105,18 @@ void __show_regs(struct pt_regs *regs, i
 	get_debugreg(d0, 0);
 	get_debugreg(d1, 1);
 	get_debugreg(d2, 2);
-	printk(KERN_DEFAULT "DR0: %016lx DR1: %016lx DR2: %016lx\n", d0, d1, d2);
 	get_debugreg(d3, 3);
 	get_debugreg(d6, 6);
 	get_debugreg(d7, 7);
+
+	/* Only print out debug registers if they are in their non-default state. */
+	if ((d0 == 0) && (d1 == 0) && (d2 == 0) && (d3 == 0) &&
+	    (d6 == DR6_RESERVED) && (d7 == 0x400))
+		return;
+
+	printk(KERN_DEFAULT "DR0: %016lx DR1: %016lx DR2: %016lx\n", d0, d1, d2);
 	printk(KERN_DEFAULT "DR3: %016lx DR6: %016lx DR7: %016lx\n", d3, d6, d7);
+
 }
 
 void release_thread(struct task_struct *dead_task)

diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 7305f7d..5905dc5 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -110,11 +110,16 @@ void __show_regs(struct pt_regs *regs, int all)
 	get_debugreg(d1, 1);
 	get_debugreg(d2, 2);
 	get_debugreg(d3, 3);
-	printk(KERN_DEFAULT "DR0: %08lx DR1: %08lx DR2: %08lx DR3: %08lx\n",
-			d0, d1, d2, d3);
-
 	get_debugreg(d6, 6);
 	get_debugreg(d7, 7);
+
+	/* Only print out debug registers if they are in their non-default state. */
+	if ((d0 == 0) && (d1 == 0) && (d2 == 0) && (d3 == 0) &&
+	    (d6 == DR6_RESERVED) && (d7 == 0x400))
+		return;
+
+	printk(KERN_DEFAULT "DR0: %08lx DR1: %08lx DR2: %08lx DR3: %08lx\n",
+			d0, d1, d2, d3);
 	printk(KERN_DEFAULT "DR6: %08lx DR7: %08lx\n",
 			d6, d7);
 }

