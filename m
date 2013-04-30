Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760718Ab3D3OAP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 10:00:15 -0400
Received: from tex.lwn.net ([70.33.254.29]:36869 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760687Ab3D3OAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 10:00:14 -0400
X-Greylist: delayed 1916 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Apr 2013 10:00:14 EDT
Date: Tue, 30 Apr 2013 07:28:17 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: dummy irq trace 'Flags mismatch'
Message-ID: <20130430072817.61d3ca9f@lwn.net>
In-Reply-To: <alpine.LNX.2.00.1304300651080.20139@pobox.suse.cz>
References: <20130429211605.GA4102@redhat.com>
	<alpine.LNX.2.00.1304300651080.20139@pobox.suse.cz>
Organization: LWN.net
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Apr 2013 06:59:22 +0200 (CEST)
Jiri Kosina <jkosina@suse.cz> wrote:

> Or have it depend on CONFIG_EXPERT would probably make most sense ... ?

We could also just have it tell you when you screwed up?  Something like
the following (compile tested only)?

jon
---
dummy-irq: require the user to specify an IRQ number

Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>

diff --git a/drivers/misc/dummy-irq.c b/drivers/misc/dummy-irq.c
index 7014167..c37eeed 100644
--- a/drivers/misc/dummy-irq.c
+++ b/drivers/misc/dummy-irq.c
@@ -19,7 +19,7 @@
 #include <linux/irq.h>
 #include <linux/interrupt.h>
 
-static int irq;
+static int irq = -1;
 
 static irqreturn_t dummy_interrupt(int irq, void *dev_id)
 {
@@ -36,6 +36,10 @@ static irqreturn_t dummy_interrupt(int irq, void *dev_id)
 
 static int __init dummy_irq_init(void)
 {
+	if (irq < 0) {
+		printk(KERN_ERR "dummy-irq: no IRQ given.  Use irq=N\n");
+		return -EIO;
+	}
 	if (request_irq(irq, &dummy_interrupt, IRQF_SHARED, "dummy_irq", &irq)) {
 		printk(KERN_ERR "dummy-irq: cannot register IRQ %d\n", irq);
 		return -EIO;
