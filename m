Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760897AbbA1CDo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 21:03:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41026 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932817AbbA1B23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:28:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Subject: [PATCH 3.18 09/61] libata: prevent HSM state change race between ISR and PIO
Date: Tue, 27 Jan 2015 17:26:21 -0800
Message-Id: <20150128012637.960179244@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012636.936333725@linuxfoundation.org>
References: <20150128012636.936333725@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Jeffery <djeffery@redhat.com>

commit ce7514526742c0898b837d4395f515b79dfb5a12 upstream.

It is possible for ata_sff_flush_pio_task() to set ap->hsm_task_state to
HSM_ST_IDLE in between the time __ata_sff_port_intr() checks for HSM_ST_IDLE
and before it calls ata_sff_hsm_move() causing ata_sff_hsm_move() to BUG().

This problem is hard to reproduce making this patch hard to verify, but this
fix will prevent the race.

I have not been able to reproduce the problem, but here is a crash dump from
a 2.6.32 kernel.

On examining the ata port's state, its hsm_task_state field has a value of HSM_ST_IDLE:

crash> struct ata_port.hsm_task_state ffff881c1121c000
  hsm_task_state = 0

Normally, this should not be possible as ata_sff_hsm_move() was called from ata_sff_host_intr(),
which checks hsm_task_state and won't call ata_sff_hsm_move() if it has a HSM_ST_IDLE value.

PID: 11053  TASK: ffff8816e846cae0  CPU: 0   COMMAND: "sshd"
 #0 [ffff88008ba03960] machine_kexec at ffffffff81038f3b
 #1 [ffff88008ba039c0] crash_kexec at ffffffff810c5d92
 #2 [ffff88008ba03a90] oops_end at ffffffff8152b510
 #3 [ffff88008ba03ac0] die at ffffffff81010e0b
 #4 [ffff88008ba03af0] do_trap at ffffffff8152ad74
 #5 [ffff88008ba03b50] do_invalid_op at ffffffff8100cf95
 #6 [ffff88008ba03bf0] invalid_op at ffffffff8100bf9b
    [exception RIP: ata_sff_hsm_move+317]
    RIP: ffffffff813a77ad  RSP: ffff88008ba03ca0  RFLAGS: 00010097
    RAX: 0000000000000000  RBX: ffff881c1121dc60  RCX: 0000000000000000
    RDX: ffff881c1121dd10  RSI: ffff881c1121dc60  RDI: ffff881c1121c000
    RBP: ffff88008ba03d00   R8: 0000000000000000   R9: 000000000000002e
    R10: 000000000001003f  R11: 000000000000009b  R12: ffff881c1121c000
    R13: 0000000000000000  R14: 0000000000000050  R15: ffff881c1121dd78
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
 #7 [ffff88008ba03d08] ata_sff_host_intr at ffffffff813a7fbd
 #8 [ffff88008ba03d38] ata_sff_interrupt at ffffffff813a821e
 #9 [ffff88008ba03d78] handle_IRQ_event at ffffffff810e6ec0
---
 drivers/ata/libata-sff.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -1333,7 +1333,19 @@ void ata_sff_flush_pio_task(struct ata_p
 	DPRINTK("ENTER\n");
 
 	cancel_delayed_work_sync(&ap->sff_pio_task);
+
+	/*
+	 * We wanna reset the HSM state to IDLE.  If we do so without
+	 * grabbing the port lock, critical sections protected by it which
+	 * expect the HSM state to stay stable may get surprised.  For
+	 * example, we may set IDLE in between the time
+	 * __ata_sff_port_intr() checks for HSM_ST_IDLE and before it calls
+	 * ata_sff_hsm_move() causing ata_sff_hsm_move() to BUG().
+	 */
+	spin_lock_irq(ap->lock);
 	ap->hsm_task_state = HSM_ST_IDLE;
+	spin_unlock_irq(ap->lock);
+
 	ap->sff_pio_task_link = NULL;
 
 	if (ata_msg_ctl(ap))


