Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965630Ab3E2KwX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 06:52:23 -0400
Received: from intranet.asianux.com ([58.214.24.6]:63790 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965467Ab3E2KwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 06:52:21 -0400
X-Spam-Score: -100.8
Message-ID: <51A5DDB0.50504@asianux.com>
Date: Wed, 29 May 2013 18:51:28 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: rth@twiddle.net, ink@jurassic.park.msu.ru, mattst88@gmail.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>, josh@joshtriplett.org,
        srivatsa.bhat@linux.vnet.ibm.com
CC: Greg KH <gregkh@linuxfoundation.org>, linux-alpha@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: [PATCH] arch: alpha: kernel: using memcpy() instead of strcpy()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When sending message in send_secondary_console_msg(), the length is not
include the NUL byte, and also not copy NUL to 'ipc_buffer'.

When receive message in recv_secondary_console_msg(), the 'cnt' also
excludes NUL.

So when get string from ipc_buffer, it may not be NUL terminated.

Then use memcpy() instead of strcpy(), and set last byte NUL.


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/alpha/kernel/smp.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
index 7b60834..d3d2040 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -266,7 +266,8 @@ recv_secondary_console_msg(void)
 		else {
 			cp1 = (char *) &cpu->ipc_buffer[11];
 			cp2 = buf;
-			strcpy(cp2, cp1);
+			memcpy(cp2, cp1, cnt);
+			cp2[cnt] = '\0';
 			
 			while ((cp2 = strchr(cp2, '\r')) != 0) {
 				*cp2 = ' ';
-- 
1.7.7.6
