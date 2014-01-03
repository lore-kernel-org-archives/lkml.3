Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986AbaACREm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 12:04:42 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:50593 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbaACREl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 12:04:41 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm/smp: Make boot_secondary() static
Date: Fri, 3 Jan 2014 18:04:33 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Russell King <linux@arm.linux.org.uk>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        linux-kernel@vger.kernel.org
References: <1388763959-27491-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1388763959-27491-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201401031804.34124.arnd@arndb.de>
X-Provags-ID: V02:K0:I21i5NV0q4AQTOYKkEH1g7oByZBLwGp+riocjS+fudF
 J9zU7ywNP9BXbBXw84AVnlRGmaxdm+3CdRSNLtEYU1oJIRT/Fx
 YA5BXN7QgA6EeoIqLy/F3ZLKdROyWtcYzfZYPRa1GXa72Z7pXG
 APm2ZUjVXEjHQmEgemYu/yWn8F+IZtWNp7uxo9UhMtTTI1d5P/
 NRxR1KLzhp8tW3fMVTqF6SJAgn92gjGjNQUbhiz3WVmJwjUVHg
 /vBBM09ItTuPIu0pLx5VY7unOSzwSxZdV6bEn1Io6jr2kxJwQQ
 NPaDotbADhpGy1+j2LUMnanTLcoMghQV8Xwhpbt6cg0jnr2aVM
 7GhTMQXHvux1f+mfxIBI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 January 2014, Geert Uytterhoeven wrote:
> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
> 
> After becoming a mandatory function, boot_secondary() is no longer used
> outside arch/arm/kernel/smp.c. Hence make it static.
> The code is reshuffled a bit to avoid a forward declaration.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

How about taking it one step further by removing the function entirely?
Like this:

@@ -92,6 +92,9 @@ int __cpu_up(unsigned int cpu, struct task_struct *idle)
 {
 	int ret;
 
+	if (!smp_ops.smp_boot_secondary)
+		return -ENOSYS;
+
 	/*
 	 * We need to tell the secondary core where to find
 	 * its stack and the page tables.
@@ -111,7 +114,7 @@ int __cpu_up(unsigned int cpu, struct task_struct *idle)
 	/*
 	 * Now bring the CPU into our world.
 	 */
-	ret = boot_secondary(cpu, idle);
+	ret = smp_ops.smp_boot_secondary(cpu, idle);
 	if (ret == 0) {
 		/*
 		 * CPU was successfully started, wait for it


I guess we could do the same for some of the other operations as well
if everyone likes the approach.

	Arnd
