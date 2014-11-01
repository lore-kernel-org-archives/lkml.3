Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317AbaKAWv1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 18:51:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60173 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751618AbaKAWj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:39:29 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "John David Anglin" <dave.anglin@bell.net>,
        "Helge Deller" <deller@gmx.de>
Date: Sat, 01 Nov 2014 22:28:03 +0000
Message-ID: <lsq.1414880883.511919029@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 068/102] parisc: Only use -mfast-indirect-calls option
 for 32-bit kernel builds
In-Reply-To: <lsq.1414880882.522510247@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.64-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: John David Anglin <dave.anglin@bell.net>

commit d26a7730b5874a5fa6779c62f4ad7c5065a94723 upstream.

In spite of what the GCC manual says, the -mfast-indirect-calls has
never been supported in the 64-bit parisc compiler. Indirect calls have
always been done using function descriptors irrespective of the
-mfast-indirect-calls option.

Recently, it was noticed that a function descriptor was always requested
when the -mfast-indirect-calls option was specified. This caused
problems when the option was used in  application code and doesn't make
any sense because the whole point of the option is to avoid using a
function descriptor for indirect calls.

Fixing this broke 64-bit kernel builds.

I will fix GCC but for now we need the attached change. This results in
the same kernel code as before.

Signed-off-by: John David Anglin <dave.anglin@bell.net>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/parisc/Makefile | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/arch/parisc/Makefile
+++ b/arch/parisc/Makefile
@@ -47,7 +47,12 @@ cflags-y	:= -pipe
 
 # These flags should be implied by an hppa-linux configuration, but they
 # are not in gcc 3.2.
-cflags-y	+= -mno-space-regs -mfast-indirect-calls
+cflags-y	+= -mno-space-regs
+
+# -mfast-indirect-calls is only relevant for 32-bit kernels.
+ifndef CONFIG_64BIT
+cflags-y	+= -mfast-indirect-calls
+endif
 
 # Currently we save and restore fpregs on all kernel entry/interruption paths.
 # If that gets optimized, we might need to disable the use of fpregs in the

