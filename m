Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618Ab3AOVfA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 16:35:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18614 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756361Ab3AOVe6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 16:34:58 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: ebiederm@xmission.com, zohar@linux.vnet.ibm.com, pjones@redhat.com,
        hpa@zytor.com, dhowells@redhat.com, jwboyer@redhat.com,
        vgoyal@redhat.com
Subject: [PATCH 3/3] binfmt_elf: Do not allow exec() if signed binary has intepreter
Date: Tue, 15 Jan 2013 16:34:55 -0500
Message-Id: <1358285695-26173-4-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1358285695-26173-1-git-send-email-vgoyal@redhat.com>
References: <1358285695-26173-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not allow execution if signed binary has interpreter. We don't have
a way to verify the signature of libraries interpreter can map. So do not
allow exec() of such binary.

Currently this signing process works only for statically linked binaries.

Well it does not prevent an application to use dlopen(). In that case,
these binaries should not be signed.

If a method to verify signature of shared libraries comes along, then
I think we can verify the signature of interpreter and allow launching
interpreter.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/binfmt_elf.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 80da13c..d2fcb47 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1170,6 +1170,16 @@ static int load_elf_binary(struct linux_binprm *bprm)
 		goto out_free_dentry;
 	}
 
+	/*
+	 * Signed binary. If there is an interpreter specified, deny
+	 * execution
+	 */
+	if (esd && elf_interpreter) {
+		retval = -EINVAL;
+		send_sig(SIGKILL, current, 0);
+		goto out_free_dentry;
+	}
+
 	/* Now we do a little grungy work by mmapping the ELF image into
 	   the correct location in memory. */
 	for(i = 0, elf_ppnt = elf_phdata;
-- 
1.7.7.6

