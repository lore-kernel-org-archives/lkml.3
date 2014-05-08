Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328AbaEHQQf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 12:16:35 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:58587 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754882AbaEHQQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 12:16:33 -0400
Date: Thu, 8 May 2014 12:16:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: tracing: NULL ptr deref in ring_buffer_wait
Message-ID: <20140508121624.4ca87b2c@gandalf.local.home>
In-Reply-To: <536BA35D.50807@oracle.com>
References: <5366DFBF.6090204@oracle.com>
	<20140505104712.11c63a5d@gandalf.local.home>
	<5367B248.2010804@oracle.com>
	<536BA35D.50807@oracle.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 May 2014 11:31:41 -0400
Sasha Levin <sasha.levin@oracle.com> wrote:

> On 05/05/2014 11:46 AM, Sasha Levin wrote:
> >>> >> [ 3589.407670] vfs_read (fs/read_write.c:430)
> >>> >> [ 3589.407670] SyS_read (fs/read_write.c:568 fs/read_write.c:560)
> >>> >> [ 3589.407670] tracesys (arch/x86/kernel/entry_64.S:746)
> >>> >> [ 3589.407670] Code: 85 cd 0c 00 00 48 c7 c1 5c e1 6d ac 48 c7 c2 af 89 6d ac 31 c0 be fa 0b 00 00 48 c7 c7 16 e1 6d ac e8 3c 68 f9 ff e9 a7 0c 00 00 <49> 81 7d 00 80 81 76 ae b8 00 00 00 00 44 0f 44 c0 eb 07 0f 1f
> >>> >> [ 3589.407670] RIP __lock_acquire (kernel/locking/lockdep.c:3070 (discriminator 1))
> >>> >> [ 3589.407670]  RSP <ffff88005c9d1c18>
> >>> >> [ 3589.407670] CR2: 00000000000001f0
> >> > 
> >> > Is this easily reproducible?
> > Nope, only saw it once.
> 
> And a second time today, I guess I could put a debug patch and see if that
> helps, if you had something in mind...
> 

All I can think of is to try this:

-- Steve

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index c634868..7cacbad 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -558,6 +558,10 @@ void ring_buffer_wait(struct ring_buffer *buffer, int cpu)
 		work = &buffer->irq_work;
 	else {
 		cpu_buffer = buffer->buffers[cpu];
+		if (unlikely(!cpu_buffer)) {
+			printk("null cpu buffer, %d\n", cpu);
+			BUG();
+		}
 		work = &cpu_buffer->irq_work;
 	}
 
