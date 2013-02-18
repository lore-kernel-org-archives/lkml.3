Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781Ab3BRTLw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 14:11:52 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:37693 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755746Ab3BRTLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 14:11:51 -0500
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.4-dev
To: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: kernel/signal.c - fix suboptimal printk usage
From: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1361214676_2799P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 18 Feb 2013 14:11:16 -0500
Message-ID: <14949.1361214676@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020202.51227CD5.00CA,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1361214676_2799P
Content-Type: text/plain; charset=us-ascii

Several printk's were missing KERN_INFO and KERN_CONT flags.
In addition, a printk that was outside a #if/#endif should have
been inside, which would result in stray blank line on non-x86 boxes.

Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>

--- linux-next/kernel/signal.c.orig	2013-02-15 19:09:29.451843219 -0500
+++ linux-next/kernel/signal.c	2013-02-18 14:04:33.423065822 -0500
@@ -1157,11 +1157,11 @@ static int send_signal(int sig, struct s
 static void print_fatal_signal(int signr)
 {
 	struct pt_regs *regs = signal_pt_regs();
-	printk("%s/%d: potentially unexpected fatal signal %d.\n",
+	printk(KERN_INFO "%s/%d: potentially unexpected fatal signal %d.\n",
 		current->comm, task_pid_nr(current), signr);

 #if defined(__i386__) && !defined(__arch_um__)
-	printk("code at %08lx: ", regs->ip);
+	printk(KERN_INFO "code at %08lx: ", regs->ip);
 	{
 		int i;
 		for (i = 0; i < 16; i++) {
@@ -1169,11 +1169,11 @@ static void print_fatal_signal(int signr

 			if (get_user(insn, (unsigned char *)(regs->ip + i)))
 				break;
-			printk("%02x ", insn);
+			printk(KERN_CONT "%02x ", insn);
 		}
 	}
+	printk(KERN_CONT "\n");
 #endif
-	printk("\n");
 	preempt_disable();
 	show_regs(regs);
 	preempt_enable();


--==_Exmh_1361214676_2799P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUSJ81AdmEQWDXROgAQIGqQ//XJSDaO312bvg9qLIJJYYeOhdW5egZCHH
jXEeg05o9UtBapgE+6diKlCIfdJ7cWvhs0WsLuC5jbK+fdSmKxpTUIO9/N9ZstNY
EvCd7QgMGLkis4ixotgwiwTGV5q71OwX11MvA7lA99CnyhV61SsG7oti1qSmipo/
HkZwFJZa3snMv6pJoZedvp/ggWx9Toef01947+LWDKoALN0ZEUSz0lT17rSktJhP
uTmjf/kxem/mKx45C551M8m7gPqhWt7Ak0qkKs2dPee7Dm4oSbYT2K7R72DskKtE
g6rguvPUM326QwvTRmRaRY+O7jHFXMBxDMRqAqfPLFFukY1SFxyCN4APvPXf5JjO
wribddkP6O70uI2JbopZm7TUalsvg9zzOgnAfRrRVK1qgiqKMR7dMj3nlAeMqabs
Rg9LUGjQx9LLWvKKQLIawo3y8v/GyCDaP/56Kb0CeUidJr6VchpZeKxEmNbsq+17
wPBITwQhTvkKSNSUt3gxwEuphLtzCsGZBsPff1IxBJO9uDkGJ84oos1eYyllsZB4
YE276q5yqlNEjfZ6MBXlJFVj38SS7FYyGJG93P7THcrT8ldvCaTQo0my1S5FPUTI
gGoZJFG7ISttasFz2Ey+F+VqDKwST+hHJUdUR/Ku94VBjGhORxEp1sellgtzJmVi
SyhVlcV+f0w=
=YkZS
-----END PGP SIGNATURE-----

--==_Exmh_1361214676_2799P--

