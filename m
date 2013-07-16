Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932739Ab3GPOWX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 10:22:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4636 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734Ab3GPOWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 10:22:17 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=eRJnZ1Cvc-AA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=JXBETSoqokoA:10 a=8Ikjl5a-bAzbjcH_nWMA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1373984532.17876.276.camel@gandalf.local.home>
Subject: [PATCH] nohz: Do not warn about unstable tsc unless user uses
 nohz_full
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 16 Jul 2013 10:22:12 -0400
In-Reply-To: <20130716010538.GD13562@somewhere>
References: <20130715170859.GA25570@redhat.com>
	 <20130715171800.GD6442@somewhere> <20130715172423.GA27745@redhat.com>
	 <20130715173848.GA1066@redhat.com>
	 <1373914182.17876.165.camel@gandalf.local.home>
	 <20130716010538.GD13562@somewhere>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the user enables CONFIG_NO_HZ_FULL and runs the kernel on a machine
with an unstable TSC, it will produce a WARN_ON dump as well as taint
the kernel. This is a bit extreme for a kernel that just enables a
feature but doesn't use it.

The warning should only happen if the user tries to use the feature by
either adding nohz_full to the kernel command line, or by enabling
CONFIG_NO_HZ_FULL_ALL that makes nohz used on all CPUs at boot up. Note,
this second feature should not (yet) be used by distros or anyone that
doesn't care if NO_HZ is used or not.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 6960172..6f47049 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -182,7 +182,8 @@ static bool can_stop_full_tick(void)
 		 * Don't allow the user to think they can get
 		 * full NO_HZ with this machine.
 		 */
-		WARN_ONCE(1, "NO_HZ FULL will not work with unstable sched clock");
+		WARN_ONCE(have_nohz_full_mask,
+			  "NO_HZ FULL will not work with unstable sched clock");
 		return false;
 	}
 #endif


