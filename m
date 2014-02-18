Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbaBRXbh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 18:31:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50701 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571AbaBRWqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:46:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stevie Trujillo <stevie.trujillo@gmail.com>,
        Dan Rosenberg <dan.j.rosenberg@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ben Hutchings <ben@decadent.org.uk>, Li Zefan <lizefan@huawei.com>
Subject: [PATCH 3.4 23/24] lib/vsprintf.c: kptr_restrict: fix pK-error in SysRq show-all-timers(Q)
Date: Tue, 18 Feb 2014 14:47:10 -0800
Message-Id: <20140218224550.882493475@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140218224550.221535225@linuxfoundation.org>
References: <20140218224550.221535225@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Rosenberg <drosenberg@vsecurity.com>

commit 3715c5309f6d175c3053672b73fd4f73be16fd07 upstream.

When using ALT+SysRq+Q all the pointers are replaced with "pK-error" like
this:

	[23153.208033]   .base:               pK-error

with echo h > /proc/sysrq-trigger it works:

	[23107.776363]   .base:       ffff88023e60d540

The intent behind this behavior was to return "pK-error" in cases where
the %pK format specifier was used in interrupt context, because the
CAP_SYSLOG check wouldn't be meaningful.  Clearly this should only apply
when kptr_restrict is actually enabled though.

Reported-by: Stevie Trujillo <stevie.trujillo@gmail.com>
Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Li Zefan <lizefan@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 lib/vsprintf.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -926,7 +926,8 @@ char *pointer(const char *fmt, char *buf
 		 * %pK cannot be used in IRQ context because its test
 		 * for CAP_SYSLOG would be meaningless.
 		 */
-		if (in_irq() || in_serving_softirq() || in_nmi()) {
+		if (kptr_restrict && (in_irq() || in_serving_softirq() ||
+				      in_nmi())) {
 			if (spec.field_width == -1)
 				spec.field_width = 2 * sizeof(void *);
 			return string(buf, end, "pK-error", spec);


