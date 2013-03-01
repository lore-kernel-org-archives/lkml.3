Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830Ab3CATq6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 14:46:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52080 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669Ab3CATqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:46:53 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>
Subject: [ 27/30] s390/kvm: Fix store status for ACRS/FPRS fix
Date: Fri,  1 Mar 2013 11:45:48 -0800
Message-Id: <20130301194530.949984251@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130301194527.988540148@linuxfoundation.org>
References: <20130301194527.988540148@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

In 3.0.67, commit 58c9ce6fad8e00d9726447f939fe7e78e2aec891 (s390/kvm:
Fix store status for ACRS/FPRS), upstream commit
15bc8d8457875f495c59d933b05770ba88d1eacb, added a call to
save_access_regs to save ACRS. But we do not have ARCS in kvm_run in
3.0 yet, so this results in:
arch/s390/kvm/kvm-s390.c: In function 'kvm_s390_vcpu_store_status':
arch/s390/kvm/kvm-s390.c:593: error: 'struct kvm_run' has no member named 's'

Fix it by saving guest_acrs which is where ARCS are in 3.0.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kvm/kvm-s390.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -590,7 +590,7 @@ int kvm_s390_vcpu_store_status(struct kv
 	 * it into the save area
 	 */
 	save_fp_regs(&vcpu->arch.guest_fpregs);
-	save_access_regs(vcpu->run->s.regs.acrs);
+	save_access_regs(vcpu->arch.guest_acrs);
 
 	if (__guestcopy(vcpu, addr + offsetof(struct save_area, fp_regs),
 			vcpu->arch.guest_fpregs.fprs, 128, prefix))


