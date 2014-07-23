Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581AbaGWJHw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 05:07:52 -0400
Received: from mail.orcon.net.nz ([219.88.242.62]:33082 "EHLO
	mail.orcon.net.nz" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757115AbaGWJHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 05:07:50 -0400
X-Greylist: delayed 895 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Jul 2014 05:07:49 EDT
Date: Wed, 23 Jul 2014 20:52:44 +1200
From: Michael Cree <mcree@orcon.net.nz>
To: linux-alpha@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Richard Henderson <rth@twiddle.net>
Subject: Bug: retry of clone() on Alpha can result in zeroed process thread
 pointer
Message-ID: <20140723085244.GB4799@omega>
Mail-Followup-To: Michael Cree <mcree@orcon.net.nz>,
	linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
	Richard Henderson <rth@twiddle.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Bayes-Prob: 0.0001 (Score 0: No Bayes scoring rules defined, tokens from: outbound)
X-Spam-Score: -2.62 () [Hold at 3.00] FREEMAIL_FROM:0.001,FSL_HELO_NON_FQDN_1:0.001,HELO_NO_DOMAIN:0.001,RDNS_DYNAMIC:0.363,T_TO_NO_BRKTS_FREEMAIL:0.01,CC(NZ:-3)
X-CanIt-Geo: ip=60.234.221.162; country=NZ; latitude=-41.0000; longitude=174.0000; http://maps.google.com/maps?q=-41.0000,174.0000&z=6
X-CanItPRO-Stream: base:outbound
X-Canit-Stats-ID: 02MtIQKIi - 8357b29e0eb7 - 20140723
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am seeing a bug in clone() on the Alpha architecture.  Reported to
Debian as https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=755397

The test suite of glibc sometimes fails in the nptl/tst-eintr3 test
with a segmentation fault.  I have tracked it down to the thread
pointer returned by the rduniq PALcall is occasionally zero when
it should point to the TLS.  I have only ever seen this occur when
running a SMP kernel.

Running strace on nptl/tst-eintr3 reveals that the clone() syscall
is retried by the kernel if an ERESTARTNOINTR error occurs.  At
$syscall_error in arch/alpha/kernel/entry.S the kernel handles the
error and in doing that it writes to 72(sp) which is where the value
of the a3 CPU register on entry to the kernel is stored.  Then the
kernel retries the clone() function.  But the alpha specific code
for copy_thread() in arch/alpha/kernel/process.c does not use the
passed a3 cpu register (the argument tls), instead it goes to the
saved stack to get the value of the a3 register, which on the
second call to clone() has been modified to no longer be the value
of the a3 cpu register on entry to the kernel.  And a latent bomb
is laid for userspace in the form of an incorrect process unique
value (which is the thread pointer) in the PCB.

Am I correct in my analysis and, if so, can we get a fix for this
please.

Cheers
Michael.
