Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932683Ab3IDU6e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 16:58:34 -0400
Received: from a10-13.smtp-out.amazonses.com ([54.240.10.13]:57439 "EHLO
	a10-13.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932400Ab3IDU6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 16:58:33 -0400
Date: Wed, 4 Sep 2013 20:58:31 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Will Deacon <will.deacon@arm.com>
cc: Tejun Heo <tj@kernel.org>,
        "akpm@linuxfoundation.org" <akpm@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Steven Rostedt <srostedt@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [gcv v3 27/35] arm: Replace __get_cpu_var uses
In-Reply-To: <alpine.DEB.2.02.1309041324530.26497@gentwo.org>
Message-ID: <00000140eac4f5fc-9f8c86db-05dd-496f-abf8-63ca3667574f-000000@email.amazonses.com>
References: <20130828193457.140443630@linux.com> <00000140c67834c9-cc2bec76-2d70-48d1-a35b-6e2d5dedf22b-000000@email.amazonses.com> <20130830100105.GF25628@mudshark.cambridge.arm.com> <00000140e4440576-ae4236ee-3073-4f94-b569-d17396e57513-000000@email.amazonses.com>
 <20130904093335.GA8007@mudshark.cambridge.arm.com> <00000140e9557be9-1523eeab-c0f6-45a0-881c-9336a8a6cf85-000000@email.amazonses.com> <20130904142324.GD3643@mudshark.cambridge.arm.com> <00000140e97747d2-ee164a4d-d692-409a-a919-083eff3a41ca-000000@email.amazonses.com>
 <20130904174624.GB5599@mudshark.cambridge.arm.com> <00000140ea29d3c8-5110dd9f-9dcf-470f-9b7e-4e7ff0874052-000000@email.amazonses.com> <20130904182113.GD5599@mudshark.cambridge.arm.com> <alpine.DEB.2.02.1309041324530.26497@gentwo.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.09.04-54.240.10.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a patch to be applied after the earlier one to convert the local_t
use to this_cpu. Not sure if I got the local_dec_and_test conversion
right.


Index: linux/arch/arm64/kernel/debug-monitors.c
===================================================================
--- linux.orig/arch/arm64/kernel/debug-monitors.c	2013-09-04 15:53:53.374943378 -0500
+++ linux/arch/arm64/kernel/debug-monitors.c	2013-09-04 15:57:19.564792739 -0500
@@ -27,7 +27,6 @@
 #include <linux/uaccess.h>

 #include <asm/debug-monitors.h>
-#include <asm/local.h>
 #include <asm/cputype.h>
 #include <asm/system_misc.h>

@@ -89,8 +88,8 @@ early_param("nodebugmon", early_debug_di
  * Keep track of debug users on each core.
  * The ref counts are per-cpu so we use a local_t type.
  */
-static DEFINE_PER_CPU(local_t, mde_ref_count);
-static DEFINE_PER_CPU(local_t, kde_ref_count);
+static DEFINE_PER_CPU(int, mde_ref_count);
+static DEFINE_PER_CPU(int, kde_ref_count);

 void enable_debug_monitors(enum debug_el el)
 {
@@ -98,11 +97,11 @@ void enable_debug_monitors(enum debug_el

 	WARN_ON(preemptible());

-	if (local_inc_return(this_cpu_ptr(&mde_ref_count)) == 1)
+	if (this_cpu_inc_return(mde_ref_count) == 1)
 		enable = DBG_MDSCR_MDE;

 	if (el == DBG_ACTIVE_EL1 &&
-	    local_inc_return(this_cpu_ptr(&kde_ref_count)) == 1)
+	    this_cpu_inc_return(kde_ref_count) == 1)
 		enable |= DBG_MDSCR_KDE;

 	if (enable && debug_enabled) {
@@ -118,11 +117,11 @@ void disable_debug_monitors(enum debug_e

 	WARN_ON(preemptible());

-	if (local_dec_and_test(this_cpu_ptr(&mde_ref_count)))
+	if (this_cpu_dec_return(mde_ref_count))
 		disable = ~DBG_MDSCR_MDE;

 	if (el == DBG_ACTIVE_EL1 &&
-	    local_dec_and_test(this_cpu_ptr(&kde_ref_count)))
+	    this_cpu_dec_return(kde_ref_count))
 		disable &= ~DBG_MDSCR_KDE;

 	if (disable) {
