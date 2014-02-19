Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559AbaBSHtq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 02:49:46 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:55064 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763AbaBSHtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 02:49:45 -0500
Date: Tue, 18 Feb 2014 23:49:42 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Xishi Qiu <qiuxishi@huawei.com>
cc: Vegard Nossum <vegard.nossum@gmail.com>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: mm: OS boot failed when set command-line kmemcheck=1
In-Reply-To: <5304558F.9050605@huawei.com>
Message-ID: <alpine.DEB.2.02.1402182344001.3551@chino.kir.corp.google.com>
References: <5304558F.9050605@huawei.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Feb 2014, Xishi Qiu wrote:

> Hi all,
> 
> CONFIG_KMEMCHECK=y and set command-line "kmemcheck=1", I find OS 
> boot failed. The kernel is v3.14.0-rc3
> 
> If set "kmemcheck=1 nowatchdog", OS will boot successfully.
> 

I have automated kernel boots that have both "kmemcheck=0" and 
"kmemcheck=1" as the last parameter in the kernel command line every 
night and I've never seen it fail on tip or linux-next before.

So I'm sure I won't be able to reproduce your issue, but it may have 
something to do with your bootloader that isn't described above.  The 
sscanf() really wants to be replaced with kstrtoint().

Could you try this out?

diff --git a/arch/x86/mm/kmemcheck/kmemcheck.c b/arch/x86/mm/kmemcheck/kmemcheck.c
--- a/arch/x86/mm/kmemcheck/kmemcheck.c
+++ b/arch/x86/mm/kmemcheck/kmemcheck.c
@@ -78,10 +78,16 @@ early_initcall(kmemcheck_init);
  */
 static int __init param_kmemcheck(char *str)
 {
+	int val;
+	int ret;
+
 	if (!str)
 		return -EINVAL;
 
-	sscanf(str, "%d", &kmemcheck_enabled);
+	ret = kstrtoint(str, 0, &val);
+	if (ret)
+		return ret;
+	kmemcheck_enabled = val;
 	return 0;
 }
 
