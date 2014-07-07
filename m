Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbaGHAcM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:32:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55898 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880AbaGGXyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:54:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Xiaoming Gao <newtongao@ppt.dcoin.co>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 3.14 68/94] kvm: fix wrong address when writing Hyper-V tsc page
Date: Mon,  7 Jul 2014 16:57:58 -0700
Message-Id: <20140707235758.792386355@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235756.780319003@linuxfoundation.org>
References: <20140707235756.780319003@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiaoming Gao <newtongao@tencent.com>

commit e1fa108d24697b78348fd4e5a531029a50d0d36d upstream.

When kvm_write_guest writes the tsc_ref structure to the guest, or it will lead
the low HV_X64_MSR_TSC_REFERENCE_ADDRESS_SHIFT bits of the TSC page address
must be cleared, or the guest can see a non-zero sequence number.

Otherwise Windows guests would not be able to get a correct clocksource
(QueryPerformanceCounter will always return 0) which causes serious chaos.

Signed-off-by: Xiaoming Gao <newtongao@tencnet.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/x86.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1866,7 +1866,7 @@ static int set_msr_hyperv_pw(struct kvm_
 		if (!(data & HV_X64_MSR_TSC_REFERENCE_ENABLE))
 			break;
 		gfn = data >> HV_X64_MSR_TSC_REFERENCE_ADDRESS_SHIFT;
-		if (kvm_write_guest(kvm, data,
+		if (kvm_write_guest(kvm, gfn << HV_X64_MSR_TSC_REFERENCE_ADDRESS_SHIFT,
 			&tsc_ref, sizeof(tsc_ref)))
 			return 1;
 		mark_page_dirty(kvm, gfn);


