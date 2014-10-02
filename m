Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363AbaJBMbz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 08:31:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:56239 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbaJBMby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 08:31:54 -0400
Date: Thu, 2 Oct 2014 14:31:50 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: Re: [rfcomm_run] WARNING: CPU: 1 PID: 79 at kernel/sched/core.c:7156
 __might_sleep()
Message-ID: <20141002123150.GC6324@worktop.programming.kicks-ass.net>
References: <20140930080228.GD9561@wfg-t540p.sh.intel.com>
 <20141002110927.GE2849@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141002110927.GE2849@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2014 at 01:09:27PM +0200, Peter Zijlstra wrote:
> On Tue, Sep 30, 2014 at 04:02:28PM +0800, Fengguang Wu wrote:
> > Hi Peter,
> > 
> > We possibly find a rfcomm bug (maintainers CCed) exposed by your debug patch
> > 
> > [    1.861895] NET: Registered protocol family 5
> > [    1.862978] Bluetooth: RFCOMM TTY layer initialized
> > [    1.863099] ------------[ cut here ]------------
> > [    1.863105] WARNING: CPU: 1 PID: 79 at kernel/sched/core.c:7156 __might_sleep+0x17d/0x1a1()
> > [    1.863112] do not call blocking ops when !TASK_RUNNING; state=1 set at [<c14dc381>] rfcomm_run+0xdf/0x130e
> > [    1.863591]  [<c1058b73>] ? kthread_stop+0x53/0x53
> > [    1.864906]  [<c155a411>] dump_stack+0x48/0x60
> > [    1.866298]  [<c14dc381>] ? rfcomm_run+0xdf/0x130e
> 
> Ha yes, rfcomm_run is a complete buggy mess indeed. Lemme go see what I
> can make of it.

---
Subject: rfcomm: Fix broken wait construct

rfcomm_run() is a tad broken in that is has a nested wait loop. One
cannot rely on p->state for the outer wait because the inner wait will
overwrite it.

While at it, rename rfcomm_schedule to rfcomm_wake, since that is what
it actually does.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 net/bluetooth/rfcomm/core.c |   46 +++++++++++++++++++++-----------------------
 1 file changed, 22 insertions(+), 24 deletions(-)

--- a/net/bluetooth/rfcomm/core.c
+++ b/net/bluetooth/rfcomm/core.c
@@ -101,11 +101,11 @@ static struct rfcomm_session *rfcomm_ses
 #define __get_rpn_stop_bits(line) (((line) >> 2) & 0x1)
 #define __get_rpn_parity(line)    (((line) >> 3) & 0x7)
 
-static void rfcomm_schedule(void)
+static DECLARE_WAIT_QUEUE_HEAD(rfcomm_wq);
+
+static void rfcomm_wake(void)
 {
-	if (!rfcomm_thread)
-		return;
-	wake_up_process(rfcomm_thread);
+	wake_up_all(&rfcomm_wq);
 }
 
 /* ---- RFCOMM FCS computation ---- */
@@ -183,13 +183,13 @@ static inline int __check_fcs(u8 *data,
 static void rfcomm_l2state_change(struct sock *sk)
 {
 	BT_DBG("%p state %d", sk, sk->sk_state);
-	rfcomm_schedule();
+	rfcomm_wake();
 }
 
 static void rfcomm_l2data_ready(struct sock *sk)
 {
 	BT_DBG("%p", sk);
-	rfcomm_schedule();
+	rfcomm_wake();
 }
 
 static int rfcomm_l2sock_create(struct socket **sock)
@@ -238,7 +238,7 @@ static void rfcomm_session_timeout(unsig
 	BT_DBG("session %p state %ld", s, s->state);
 
 	set_bit(RFCOMM_TIMED_OUT, &s->flags);
-	rfcomm_schedule();
+	rfcomm_wake();
 }
 
 static void rfcomm_session_set_timer(struct rfcomm_session *s, long timeout)
@@ -264,7 +264,7 @@ static void rfcomm_dlc_timeout(unsigned
 
 	set_bit(RFCOMM_TIMED_OUT, &d->flags);
 	rfcomm_dlc_put(d);
-	rfcomm_schedule();
+	rfcomm_wake();
 }
 
 static void rfcomm_dlc_set_timer(struct rfcomm_dlc *d, long timeout)
@@ -462,7 +462,7 @@ static int __rfcomm_dlc_close(struct rfc
 	case BT_CONNECT2:
 		if (test_and_clear_bit(RFCOMM_DEFER_SETUP, &d->flags)) {
 			set_bit(RFCOMM_AUTH_REJECT, &d->flags);
-			rfcomm_schedule();
+			rfcomm_wake();
 			return 0;
 		}
 	}
@@ -566,7 +566,7 @@ int rfcomm_dlc_send(struct rfcomm_dlc *d
 	skb_queue_tail(&d->tx_queue, skb);
 
 	if (!test_bit(RFCOMM_TX_THROTTLED, &d->flags))
-		rfcomm_schedule();
+		rfcomm_wake();
 	return len;
 }
 
@@ -581,7 +581,7 @@ void rfcomm_dlc_send_noerror(struct rfco
 
 	if (d->state == BT_CONNECTED &&
 	    !test_bit(RFCOMM_TX_THROTTLED, &d->flags))
-		rfcomm_schedule();
+		rfcomm_wake();
 }
 
 void __rfcomm_dlc_throttle(struct rfcomm_dlc *d)
@@ -592,7 +592,7 @@ void __rfcomm_dlc_throttle(struct rfcomm
 		d->v24_sig |= RFCOMM_V24_FC;
 		set_bit(RFCOMM_MSC_PENDING, &d->flags);
 	}
-	rfcomm_schedule();
+	rfcomm_wake();
 }
 
 void __rfcomm_dlc_unthrottle(struct rfcomm_dlc *d)
@@ -603,7 +603,7 @@ void __rfcomm_dlc_unthrottle(struct rfco
 		d->v24_sig &= ~RFCOMM_V24_FC;
 		set_bit(RFCOMM_MSC_PENDING, &d->flags);
 	}
-	rfcomm_schedule();
+	rfcomm_wake();
 }
 
 /*
@@ -624,7 +624,7 @@ int rfcomm_dlc_set_modem_status(struct r
 	d->v24_sig = v24_sig;
 
 	if (!test_and_set_bit(RFCOMM_MSC_PENDING, &d->flags))
-		rfcomm_schedule();
+		rfcomm_wake();
 
 	return 0;
 }
@@ -872,7 +872,7 @@ static int rfcomm_queue_disc(struct rfco
 	cmd->fcs  = __fcs2((u8 *) cmd);
 
 	skb_queue_tail(&d->tx_queue, skb);
-	rfcomm_schedule();
+	rfcomm_wake();
 	return 0;
 }
 
@@ -1952,7 +1952,7 @@ static void rfcomm_accept_connection(str
 		s->mtu = min(l2cap_pi(nsock->sk)->chan->omtu,
 				l2cap_pi(nsock->sk)->chan->imtu) - 5;
 
-		rfcomm_schedule();
+		rfcomm_wake();
 	} else
 		sock_release(nsock);
 }
@@ -2086,24 +2086,22 @@ static void rfcomm_kill_listener(void)
 
 static int rfcomm_run(void *unused)
 {
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 	BT_DBG("");
 
 	set_user_nice(current, -10);
 
 	rfcomm_add_listener(BDADDR_ANY);
 
-	while (1) {
-		set_current_state(TASK_INTERRUPTIBLE);
-
-		if (kthread_should_stop())
-			break;
+	add_wait_queue(&rfcomm_wq, &wait);
+	while (!kthread_should_stop()) {
 
 		/* Process stuff */
 		rfcomm_process_sessions();
 
-		schedule();
+		wait_woken(&wait, TASK_INTERRUPTIBLE, MAX_SCHEDULE_TIMEOUT);
 	}
-	__set_current_state(TASK_RUNNING);
+	remove_wait_queue(&rfcomm_wq, &wait);
 
 	rfcomm_kill_listener();
 
@@ -2154,7 +2152,7 @@ static void rfcomm_security_cfm(struct h
 			set_bit(RFCOMM_AUTH_REJECT, &d->flags);
 	}
 
-	rfcomm_schedule();
+	rfcomm_wake();
 }
 
 static struct hci_cb rfcomm_cb = {
