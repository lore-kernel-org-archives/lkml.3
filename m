Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927Ab3JVXy5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 19:54:57 -0400
Received: from ozlabs.org ([203.10.76.45]:39372 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753648Ab3JVXy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 19:54:56 -0400
From: Michael Neuling <mikey@neuling.org>
To: Frederic Weisbecker <fweisbec@gmail.com>, benh@kernel.crashing.org,
        anton@samba.org, linux-kernel@vger.kernel.org,
        Linux PPC dev <linuxppc-dev@ozlabs.org>,
        Victor Kaplansky <VICTORK@il.ibm.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        michael@ellerman.id.au
X-GPG-Fingerprint: 9B25 DC2A C58D 2C8D 47C2  457E 0887 E86F 32E6 BE16
X-GPG-Fingerprint: 9365 87D7 A7EF 4721 420B  91D9 CD5B 874B EAC1 B3F5
MIME-Version: 1.0
Subject: perf events ring buffer memory barrier on powerpc
X-Mailer: MH-E 8.2; nmh 1.5; GNU Emacs 23.4.1
Date: Wed, 23 Oct 2013 10:54:54 +1100
Message-ID: <12083.1382486094@ale.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic,

In the perf ring buffer code we have this in perf_output_get_handle():

	if (!local_dec_and_test(&rb->nest))
		goto out;

	/*
	 * Publish the known good head. Rely on the full barrier implied
	 * by atomic_dec_and_test() order the rb->head read and this
	 * write.
	 */
	rb->user_page->data_head = head;

The comment says atomic_dec_and_test() but the code is
local_dec_and_test().

On powerpc, local_dec_and_test() doesn't have a memory barrier but
atomic_dec_and_test() does.  Is the comment wrong, or is
local_dec_and_test() suppose to imply a memory barrier too and we have
it wrongly implemented in powerpc?

My guess is that local_dec_and_test() is correct but we to add an
explicit memory barrier like below:

(Kudos to Victor Kaplansky for finding this)

Mikey

diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index cd55144..95768c6 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -87,10 +87,10 @@ again:
 		goto out;
 
 	/*
-	 * Publish the known good head. Rely on the full barrier implied
-	 * by atomic_dec_and_test() order the rb->head read and this
-	 * write.
+	 * Publish the known good head. We need a memory barrier to order the
+	 * order the rb->head read and this write.
 	 */
+	smp_mb ();
 	rb->user_page->data_head = head;
 
 	/*
