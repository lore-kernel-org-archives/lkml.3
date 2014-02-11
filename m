Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642AbaBKTau (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:30:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40400 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164AbaBKTH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:07:57 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3.10 09/79] audit: correct a type mismatch in audit_syscall_exit()
Date: Tue, 11 Feb 2014 11:05:13 -0800
Message-Id: <20140211184721.201717370@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184720.928667275@linuxfoundation.org>
References: <20140211184720.928667275@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: AKASHI Takahiro <takahiro.akashi@linaro.org>

commit 06bdadd7634551cfe8ce071fe44d0311b3033d9e upstream.

audit_syscall_exit() saves a result of regs_return_value() in intermediate
"int" variable and passes it to __audit_syscall_exit(), which expects its
second argument as a "long" value.  This will result in truncating the
value returned by a system call and making a wrong audit record.

I don't know why gcc compiler doesn't complain about this, but anyway it
causes a problem at runtime on arm64 (and probably most 64-bit archs).

Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/audit.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -135,7 +135,7 @@ static inline void audit_syscall_exit(vo
 {
 	if (unlikely(current->audit_context)) {
 		int success = is_syscall_success(pt_regs);
-		int return_code = regs_return_value(pt_regs);
+		long return_code = regs_return_value(pt_regs);
 
 		__audit_syscall_exit(success, return_code);
 	}


