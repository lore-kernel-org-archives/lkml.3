Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab3K2U2y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 15:28:54 -0500
Received: from mail-bk0-f48.google.com ([209.85.214.48]:33348 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575Ab3K2U2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 15:28:52 -0500
Message-ID: <5298F900.9000208@linux.com>
Date: Fri, 29 Nov 2013 21:28:48 +0100
From: Levente Kurusa <levex@linux.com>
Reply-To: Levente Kurusa <levex@linux.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: x86@kernel.org, EDAC <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: mcheck: call put_device on device_register failure
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a call to put_device() when the device_register()
call has failed. This is required so that the last reference to the
device is given up.

Signed-off-by: Levente Kurusa <levex@linux.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index b3218cd..a389c1d 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -2272,8 +2272,10 @@ static int mce_device_create(unsigned int cpu)
 	dev->release = &mce_device_release;

 	err = device_register(dev);
-	if (err)
+	if (err) {
+		put_device(dev);
 		return err;
+	}

 	for (i = 0; mce_device_attrs[i]; i++) {
 		err = device_create_file(dev, mce_device_attrs[i]);
-- 
1.8.1.2
