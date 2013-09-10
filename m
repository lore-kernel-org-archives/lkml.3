Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663Ab3IJVpO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 17:45:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65503 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752411Ab3IJVpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 17:45:05 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        kexec@lists.infradead.org
Cc: akpm@linux-foundation.org, zohar@linux.vnet.ibm.com,
        d.kasatkin@samsung.com, ebiederm@xmission.com, hpa@zytor.com,
        matthew.garrett@nebula.com, vgoyal@redhat.com
Subject: [PATCH 12/16] binfmt_elf: Do not mark process signed if binary has elf interpreter
Date: Tue, 10 Sep 2013 17:44:27 -0400
Message-Id: <1378849471-10521-13-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1378849471-10521-1-git-send-email-vgoyal@redhat.com>
References: <1378849471-10521-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently one can write to shared libraries while these are mapped.
That means shared library code can not be trusted as after signature
verification, one can overwrite the code.

Till we find a way to take care of that issue, do not mark a process
signed if it has interpreter which in turn will load shared librareis.

This does not take care of application doing dlopen(). Just that be
careful while signing applications and don't sign anything which does
dlopen().

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/binfmt_elf.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 8f2286e..52f8bd2 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -995,8 +995,16 @@ static int load_elf_binary(struct linux_binprm *bprm)
 		 * not signed, do not set proc_signed, otherwise unsigned
 		 * tracer could change signed tracee's address space,
 		 * effectively nullifying singature checking.
+		 *
+		 * Also set proc_signed only if there is no elf interpreter.
+		 * We don't have a way to avoid writes to shared libraries
+		 * after they have been mapped. That means anybody can
+		 * write to library after signature verification. So don't
+		 * trust executables which are dynamically linked. This
+		 * does not cover dlopen() and friends. So don't sign
+		 * applications using dlopen().
 		 */
-		if (!ptraced_by_unsafe_tracer())
+		if (!ptraced_by_unsafe_tracer() && !elf_interpreter)
 			bprm->cred->proc_signed = true;
 	}
 #endif
-- 
1.8.3.1

