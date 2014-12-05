Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbaLEXuR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:50:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53755 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbaLEWp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:45:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paul Burton <paul.burton@imgtec.com>, linux-mips@linux-mips.org,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 3.17 008/122] MIPS: fix EVA & non-SMP non-FPU FP context signal handling
Date: Fri,  5 Dec 2014 14:43:02 -0800
Message-Id: <20141205223306.740952173@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205223305.514276242@linuxfoundation.org>
References: <20141205223305.514276242@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Burton <paul.burton@imgtec.com>

commit 14fa12df1d6bc1d3389a0fa842e0ebd8e8a9af26 upstream.

The save_fp_context & restore_fp_context pointers were being assigned
to the wrong variables if either:

  - The kernel is configured for UP & runs on a system without an FPU,
    since b2ead5282885 "MIPS: Move & rename
    fpu_emulator_{save,restore}_context".

  - The kernel is configured for EVA, since ca750649e08c "MIPS: kernel:
    signal: Prevent save/restore FPU context in user memory".

This would lead to FP context being clobbered incorrectly when setting
up a sigcontext, then the garbage values being saved uselessly when
returning from the signal.

Fix by swapping the pointer assignments appropriately.

Signed-off-by: Paul Burton <paul.burton@imgtec.com>
Cc: linux-mips@linux-mips.org
Patchwork: https://patchwork.linux-mips.org/patch/8230/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/kernel/signal.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/mips/kernel/signal.c
+++ b/arch/mips/kernel/signal.c
@@ -658,13 +658,13 @@ static int signal_setup(void)
 		save_fp_context = _save_fp_context;
 		restore_fp_context = _restore_fp_context;
 	} else {
-		save_fp_context = copy_fp_from_sigcontext;
-		restore_fp_context = copy_fp_to_sigcontext;
+		save_fp_context = copy_fp_to_sigcontext;
+		restore_fp_context = copy_fp_from_sigcontext;
 	}
 #endif /* CONFIG_SMP */
 #else
-	save_fp_context = copy_fp_from_sigcontext;;
-	restore_fp_context = copy_fp_to_sigcontext;
+	save_fp_context = copy_fp_to_sigcontext;
+	restore_fp_context = copy_fp_from_sigcontext;
 #endif
 
 	return 0;


