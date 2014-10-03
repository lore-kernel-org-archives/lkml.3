Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527AbaJCWgp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:36:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47852 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758531AbaJCWeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:34:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        John David Anglin <dave.anglin@bell.net>, Helge Deller <deller@gmx.de>
Subject: [PATCH 3.10 120/143] parisc: Only use -mfast-indirect-calls option for 32-bit kernel builds
Date: Fri,  3 Oct 2014 14:35:15 -0700
Message-Id: <20141003213318.090603283@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003213314.470709810@linuxfoundation.org>
References: <20141003213314.470709810@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/parisc/Makefile |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/arch/parisc/Makefile
+++ b/arch/parisc/Makefile
@@ -46,7 +46,12 @@ cflags-y	:= -pipe
 
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


