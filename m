Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207AbaD3ANO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 20:13:14 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:62505 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757038AbaD3ANM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 20:13:12 -0400
Date: Tue, 29 Apr 2014 20:13:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Nicholas Mc Guire <der.herr@hofr.at>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>,
        Clark Williams <williams@redhat.com>
Subject: Re: [ANNOUNCE] 3.14-rt1
Message-ID: <20140429201308.63292691@gandalf.local.home>
In-Reply-To: <1398748869.5514.81.camel@marge.simpson.net>
References: <20140411185739.GA6644@linutronix.de>
	<1397918766.5436.16.camel@marge.simpson.net>
	<1398411635.11930.45.camel@marge.simpson.net>
	<1398501491.12941.5.camel@marge.simpson.net>
	<1398520699.28726.22.camel@marge.simpson.net>
	<1398661784.30930.33.camel@marge.simpson.net>
	<1398676186.30930.49.camel@marge.simpson.net>
	<20140428101805.75032f45@gandalf.local.home>
	<1398695832.14475.10.camel@marge.simpson.net>
	<1398748869.5514.81.camel@marge.simpson.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2014 07:21:09 +0200
Mike Galbraith <umgwanakikbuti@gmail.com> wrote:

> On Mon, 2014-04-28 at 16:37 +0200, Mike Galbraith wrote: 
> 
> > > Seems that migrate_disable() must be called before taking the lock as
> > > it is done in every other location.
> > 
> > And for tasklist_lock, seems you also MUST do that prior to trylock as
> > well, else you'll run afoul of the hotplug beast.
> 
> Bah.  Futzing with dmesg while stress script is running is either a very
> bad idea, or a very good test.  Both virgin 3.10-rt and 3.12-rt with new
> bugs squashed will deadlock.
> 
> Too bad I kept on testing, I liked the notion that hotplug was solid ;-)

I was able to stress cpu hotplug on 3.12-rt after applying the
following patch.

If there's no complaints about it. I'm going to add this to the 3.12-rt
stable tree. As without it, it fails horribly with the cpu hotplug
stress test, and I wont release a stable kernel that does that.

-- Steve

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/rt.c b/kernel/rt.c
index bb72347..4f2a613 100644
--- a/kernel/rt.c
+++ b/kernel/rt.c
@@ -180,12 +180,15 @@ EXPORT_SYMBOL(_mutex_unlock);
  */
 int __lockfunc rt_write_trylock(rwlock_t *rwlock)
 {
-	int ret = rt_mutex_trylock(&rwlock->lock);
+	int ret;
+
+	migrate_disable();
+	ret = rt_mutex_trylock(&rwlock->lock);
 
-	if (ret) {
+	if (ret)
 		rwlock_acquire(&rwlock->dep_map, 0, 1, _RET_IP_);
-		migrate_disable();
-	}
+	else
+		migrate_enable();
 
 	return ret;
 }
@@ -212,11 +215,12 @@ int __lockfunc rt_read_trylock(rwlock_t *rwlock)
 	 * write locked.
 	 */
 	if (rt_mutex_owner(lock) != current) {
+		migrate_disable();
 		ret = rt_mutex_trylock(lock);
-		if (ret) {
+		if (ret)
 			rwlock_acquire(&rwlock->dep_map, 0, 1, _RET_IP_);
-			migrate_disable();
-		}
+		else
+			migrate_enable();
 	} else if (!rwlock->read_depth) {
 		ret = 0;
 	}
@@ -245,8 +249,8 @@ void __lockfunc rt_read_lock(rwlock_t *rwlock)
 	 */
 	if (rt_mutex_owner(lock) != current) {
 		rwlock_acquire(&rwlock->dep_map, 0, 0, _RET_IP_);
-		__rt_spin_lock(lock);
 		migrate_disable();
+		__rt_spin_lock(lock);
 	}
 	rwlock->read_depth++;
 }

