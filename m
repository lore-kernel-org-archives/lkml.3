Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444Ab3FYSdw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:33:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40904 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252Ab3FYSdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:33:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Igor Mammedov <imammedo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [ 31/95] x86: kvmclock: zero initialize pvclock shared memory area
Date: Tue, 25 Jun 2013 11:32:18 -0700
Message-Id: <20130625182157.154126570@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625182153.605455184@linuxfoundation.org>
References: <20130625182153.605455184@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Igor Mammedov <imammedo@redhat.com>

commit 07868fc6aaf57847b0f3a3d53086b7556eb83f4a upstream.

kernel might hung in pvclock_clocksource_read() due to
uninitialized memory might contain odd version value in
following cycle:

        do {
                version = __pvclock_read_cycles(src, &ret, &flags);
        } while ((src->version & 1) || version != src->version);

if secondary kvmclock is accessed before it's registered with kvm.

Clear garbage in pvclock shared memory area right after it's
allocated to avoid this issue.

Ref: https://bugzilla.kernel.org/show_bug.cgi?id=59521
Signed-off-by: Igor Mammedov <imammedo@redhat.com>
[See BZ for analysis.  We may want a different fix for 3.11, but
 this is the safest for now - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/kvmclock.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -238,6 +238,7 @@ void __init kvmclock_init(void)
 	if (!mem)
 		return;
 	hv_clock = __va(mem);
+	memset(hv_clock, 0, size);
 
 	if (kvm_register_clock("boot clock")) {
 		hv_clock = NULL;


