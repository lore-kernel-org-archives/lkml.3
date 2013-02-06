Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283Ab3BFLXp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 06:23:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38954 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752105Ab3BFLWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 06:22:54 -0500
Date: Wed, 6 Feb 2013 12:23:27 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Oleg Nesterov <oleg@redhat.com>, Tommi Rantala <tt.rantala@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: clock_nanosleep() task_struct leak
Message-ID: <20130206112327.GA1824@redhat.com>
References: <CA+ydwtqUUAR9zf3dp+N1JRW+if88EZ73i+5BQtuggVPDFVdCBg@mail.gmail.com>
 <alpine.LFD.2.02.1302011450160.11905@ionos>
 <20130204193223.GA11910@redhat.com>
 <20130205103455.GB18313@redhat.com>
 <alpine.LFD.2.02.1302051155000.11905@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1302051155000.11905@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 11:55:19AM +0100, Thomas Gleixner wrote:
> On Tue, 5 Feb 2013, Stanislaw Gruszka wrote:
> > On Mon, Feb 04, 2013 at 08:32:23PM +0100, Oleg Nesterov wrote:
> > > On 02/01, Thomas Gleixner wrote:
> > > >
> > > > B1;2601;0cOn Fri, 1 Feb 2013, Tommi Rantala wrote:
> > > >
> > > > > Hello,
> > > > >
> > > > > Trinity discovered a task_struct leak with clock_nanosleep(), reproducible with:
> > > > >
> > > > > -----8<-----8<-----8<-----
> > > > > #include <time.h>
> > > > >
> > > > > static const struct timespec req;
> > > > >
> > > > > int main(void) {
> > > > >         return clock_nanosleep(CLOCK_PROCESS_CPUTIME_ID,
> > > > >                         TIMER_ABSTIME, &req, NULL);
> > > > > }
> > > > > -----8<-----8<-----8<-----
> > > 
> > > posix_cpu_timer_create()->get_task_struct() I guess...
> > > 
> > > Cough. I am not sure I ever understood this code, but now it certainly
> > > looks as if I never saw it before.
> > 
> > Looks on do_cpu_nanosleep() we call posix_cpu_timer_create(), but we do
> > not call posix_cpu_timer_del() at the end. Fix will not be super simple,
> > since we need to care about error cases. I can cook a patch if nobody
> > else want to do this.
> 
> Would be much appreciated!

Below is proposed fix. Error cases wasn't that bad since there are
various limitations when timer could be fired (i.e. timer which
already fired can not be fired again).

Tommi, please check if patch really fixes the problem. I tested it
with signal interrupt and timeout scenarios, but I don't know how
to confirm if it fix the leak or not.

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 125cb67..07a38b6 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -1424,6 +1424,7 @@ static int do_cpu_nanosleep(const clockid_t which_clock, int flags,
 				/*
 				 * Our timer fired and was reset.
 				 */
+				posix_cpu_timer_del(&timer);
 				spin_unlock_irq(&timer.it_lock);
 				return 0;
 			}
@@ -1441,9 +1442,17 @@ static int do_cpu_nanosleep(const clockid_t which_clock, int flags,
 		 * We were interrupted by a signal.
 		 */
 		sample_to_timespec(which_clock, timer.it.cpu.expires, rqtp);
-		posix_cpu_timer_set(&timer, 0, &zero_it, it);
+		error = posix_cpu_timer_set(&timer, 0, &zero_it, it);
+		if (!error)
+			posix_cpu_timer_del(&timer);
 		spin_unlock_irq(&timer.it_lock);
 
+		while (error == TIMER_RETRY) {
+			spin_lock_irq(&timer.it_lock);
+			error = posix_cpu_timer_del(&timer);
+			spin_unlock_irq(&timer.it_lock);
+		}
+
 		if ((it->it_value.tv_sec | it->it_value.tv_nsec) == 0) {
 			/*
 			 * It actually did fire already.
