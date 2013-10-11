Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932557Ab3JKTlc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 15:41:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46210 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757310Ab3JKTl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:41:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Gabor Juhos <juhosg@openwrt.org>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
Subject: [ 050/135] avr32: fix clockevents kernel warning
Date: Fri, 11 Oct 2013 12:38:51 -0700
Message-Id: <20131011193950.713601961@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193945.181603934@linuxfoundation.org>
References: <20131011193945.181603934@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabor Juhos <juhosg@openwrt.org>

commit 1b0135b5e20c56b2edae29e92b91c0b12c983432 upstream.

Since commit 01426478df3a8791ff5c8b6b82d409e699cfaf38
(avr32: Use generic idle loop) the kernel throws the
following warning on avr32:

  WARNING: at 900322e4 [verbose debug info unavailable]
  Modules linked in:
  CPU: 0 PID: 0 Comm: swapper Not tainted 3.12.0-rc2 #117
  task: 901c3ecc ti: 901c0000 task.ti: 901c0000
  PC is at cpu_idle_poll_ctrl+0x1c/0x38
  LR is at comparator_mode+0x3e/0x40
  pc : [<900322e4>]    lr : [<90014882>]    Not tainted
  sp : 901c1f74  r12: 00000000  r11: 901c74a0
  r10: 901d2510  r9 : 00000001  r8 : 901db4de
  r7 : 901c74a0  r6 : 00000001  r5 : 00410020  r4 : 901db574
  r3 : 00410024  r2 : 90206fe0  r1 : 00000000  r0 : 007f0000
  Flags: qvnzc
  Mode bits: hjmde....G
  CPU Mode: Supervisor
  Call trace:
   [<90039ede>] clockevents_set_mode+0x16/0x2e
   [<90039f00>] clockevents_shutdown+0xa/0x1e
   [<9003a078>] clockevents_exchange_device+0x58/0x70
   [<9003a78c>] tick_check_new_device+0x38/0x54
   [<9003a1a2>] clockevents_register_device+0x32/0x90
   [<900035c4>] time_init+0xa8/0x108
   [<90000520>] start_kernel+0x128/0x23c

When the 'avr32_comparator' clockevent device is registered,
the clockevent core sets the mode of that clockevent device
to CLOCK_EVT_MODE_SHUTDOWN. Due to this, the 'comparator_mode'
function calls the 'cpu_idle_poll_ctrl' to disables idle poll.
This results in the aforementioned warning because the polling
is not enabled yet.

Change the code to only disable idle poll if it is enabled by
the same function to avoid the warning.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/avr32/kernel/time.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/arch/avr32/kernel/time.c
+++ b/arch/avr32/kernel/time.c
@@ -98,7 +98,14 @@ static void comparator_mode(enum clock_e
 	case CLOCK_EVT_MODE_SHUTDOWN:
 		sysreg_write(COMPARE, 0);
 		pr_debug("%s: stop\n", evdev->name);
-		cpu_idle_poll_ctrl(false);
+		if (evdev->mode == CLOCK_EVT_MODE_ONESHOT ||
+		    evdev->mode == CLOCK_EVT_MODE_RESUME) {
+			/*
+			 * Only disable idle poll if we have forced that
+			 * in a previous call.
+			 */
+			cpu_idle_poll_ctrl(false);
+		}
 		break;
 	default:
 		BUG();


