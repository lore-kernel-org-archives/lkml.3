Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab3KGR0R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 12:26:17 -0500
Received: from smarthost01c.mail.zen.net.uk ([212.23.1.5]:37855 "EHLO
	smarthost01c.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752474Ab3KGR0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 12:26:15 -0500
Message-ID: <1383845166.3401.77.camel@linaro1.home>
Subject: Re: [PATCH v2 09/13] ARM: Disable jprobe selftests in thumb kernels
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: David Long <dave.long@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Rabin Vincent <rabin@rab.in>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Dave Martin <dave.martin@linaro.org>
Date: Thu, 07 Nov 2013 17:26:06 +0000
In-Reply-To: <1381871068-27660-10-git-send-email-dave.long@linaro.org>
References: <1381871068-27660-1-git-send-email-dave.long@linaro.org>
	 <1381871068-27660-10-git-send-email-dave.long@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01c-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-15 at 17:04 -0400, David Long wrote:
> From: "David A. Long" <dave.long@linaro.org>
> 
> jprobe kernel selftests are not supported for thumb kernels. Conditionally
> disable them in the kernel kprobes-test module.

I don't think it's fair to say they aren't supported, it's just that the
implementation of jprobes and/or symbol lookup has bugs on Thumb kernels
which the test code is finding, see
http://lists.infradead.org/pipermail/linux-arm-kernel/2011-August/063026.html

Note, the current code works OK if the function being probed is in a
loadable module (which is why I didn't spot the problem when doing the
original Thumb kprobes work).

Now I admit that having the tests always bombing out because of this
hinders testing of kprobes, but simply disabling the test is just
burying this long standing problem even more. So what do people think
about something like the change below, to let other tests get run but
make the overall test still fail...?

--- a/arch/arm/kernel/kprobes-test.c
+++ b/arch/arm/kernel/kprobes-test.c
@@ -221,6 +221,7 @@ static int pre_handler_called;
 static int post_handler_called;
 static int jprobe_func_called;
 static int kretprobe_handler_called;
+static int tests_failed;
 
 #define FUNC_ARG1 0x12345678
 #define FUNC_ARG2 0xabcdef
@@ -457,6 +458,13 @@ static int run_api_tests(long (*func)(long, long))
 
 	pr_info("    jprobe\n");
 	ret = test_jprobe(func);
+#if defined(CONFIG_THUMB2_KERNEL) && !defined(MODULE)
+	if (ret == -EINVAL) {
+		pr_err("FAIL: Known longtime bug with jprobe on Thumb kernels");
+		tests_failed = ret;
+		ret = 0;
+	}
+#endif
 	if (ret < 0)
 		return ret;
 
@@ -1667,6 +1675,8 @@ static int __init run_all_tests(void)
 
 out:
 	if (ret == 0)
+		ret = tests_failed;
+	if (ret == 0)
 		pr_info("Finished kprobe tests OK\n");
 	else
 		pr_err("kprobe tests failed\n");




-- 
Tixy




