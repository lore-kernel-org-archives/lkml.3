Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187AbaGJXEl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 19:04:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51250 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbaGJXEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 19:04:39 -0400
Date: Thu, 10 Jul 2014 16:04:16 -0700
From: tip-bot for Jan Beulich <tipbot@zytor.com>
Message-ID: <tip-9f88b906b4455465d60ac18b8c95904f320038d5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        boris.ostrovsky@oracle.com, jbeulich@suse.com, luto@amacapital.net,
        akpm@linux-foundation.org, JBeulich@suse.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        boris.ostrovsky@oracle.com, jbeulich@suse.com, luto@amacapital.net,
        akpm@linux-foundation.org, JBeulich@suse.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <53B5861E02000078000204D1@mail.emea.novell.com>
References: <53B5861E02000078000204D1@mail.emea.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86-64, vdso:
  Fix vDSO build breakage due to empty .rela.dyn
Git-Commit-ID: 9f88b906b4455465d60ac18b8c95904f320038d5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9f88b906b4455465d60ac18b8c95904f320038d5
Gitweb:     http://git.kernel.org/tip/9f88b906b4455465d60ac18b8c95904f320038d5
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Thu, 3 Jul 2014 15:34:38 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 10 Jul 2014 15:59:56 -0700

x86-64, vdso: Fix vDSO build breakage due to empty .rela.dyn

Certain ld versions (observed with 2.20.0) put an empty .rela.dyn
section into shared object files, breaking the assumption on the number
of sections to be copied to the final output. Simply discard any empty
SHT_REL and SHT_RELA sections to address this.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Link: http://lkml.kernel.org/r/53B5861E02000078000204D1@mail.emea.novell.com
Acked-by: Andy Lutomirski <luto@amacapital.net>
Tested-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/vdso/vdso2c.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/vdso/vdso2c.h b/arch/x86/vdso/vdso2c.h
index df95a2f..11b65d4 100644
--- a/arch/x86/vdso/vdso2c.h
+++ b/arch/x86/vdso/vdso2c.h
@@ -93,6 +93,9 @@ static void BITSFUNC(copy_section)(struct BITSFUNC(fake_sections) *out,
 	uint64_t flags = GET_LE(&in->sh_flags);
 
 	bool copy = flags & SHF_ALLOC &&
+		(GET_LE(&in->sh_size) ||
+		 (GET_LE(&in->sh_type) != SHT_RELA &&
+		  GET_LE(&in->sh_type) != SHT_REL)) &&
 		strcmp(name, ".altinstructions") &&
 		strcmp(name, ".altinstr_replacement");
 
