Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267Ab3K2RPp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 12:15:45 -0500
Received: from oproxy7-pub.mail.unifiedlayer.com ([67.222.55.9]:45800 "HELO
	oproxy7-pub.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755864Ab3K2RPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 12:15:43 -0500
Message-ID: <1385745340.1073.17.camel@Wailaba2>
Subject: Re: [PATCH] Avoid process cputimer state oscillation
From: Olivier Langlois <olivier@olivierlanglois.net>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        kosaki.motohiro@gmail.com
Date: Fri, 29 Nov 2013 12:15:40 -0500
In-Reply-To: <1385407528.29756.41.camel@Wailaba2>
References: <1385407528.29756.41.camel@Wailaba2>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Identified-User: {5686:box610.bluehost.com:olivierl:olivierlanglois.net} {sentby:smtp auth 173.179.63.169 authed with olivier@olivierlanglois.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One more detail useful to note to appreciate this patch is that the call
to posix_cpu_timer_schedule() from cpu_timer_fire() is done
exceptionnaly when the timer signal generation fails.

The normal processing will call posix_cpu_timer_schedule() from a
different context in do_schedule_next_timer() (posix-timers.c)

I believe this misunderstanding may partly explain the current state of
the code.

On Mon, 2013-11-25 at 14:25 -0500, Olivier Langlois wrote:
> When a periodic process timer is fired, a signal is generated.
> Rearming the timer, if necessary, will be performed in a second step
> when the signal will be delivered.
> 
> Hence, checking the list of process timers list to decide to stop to cpu
> timer right after generating the signal is premature and is leading the
> cputimer to oscillate between the on/off states when a single process timer
> is present.
> 
> The following posix-cpu-timers module intrumentation
> 
> In void thread_group_cputimer(struct task_s
> 		raw_spin_lock_irqsave(&cputimer->lock, flags);
>  		cputimer->running = 1;
>  		update_gt_cputime(&cputimer->cputime, &sum);
> +		printk(KERN_DEBUG "cputimer started\n");
>  	} else
>  		raw_spin_lock_irqsave(&cputimer->lock, flags);
>  	*times = cputimer->cputime;
> and in static void stop_process_timers(struct s
> 
>  	raw_spin_lock_irqsave(&cputimer->lock, flags);
>  	cputimer->running = 0;
> +	printk(KERN_DEBUG "cputimer stopped\n");
>  	raw_spin_unlock_irqrestore(&cputimer->lock, flags);
>  }
> 
> with the small program:
> 
> \#include <signal.h>
> \#include <time.h>
> \#include <stddef.h>
> \#include <stdio.h>
> \#include <string.h>
> \#include <fcntl.h>
> \#include <unistd.h>
> 
> static void chew_cpu()
> {
> 	static volatile char buf[4096];
> 	for (size_t i = 0; i < 100; ++i)
> 		for (size_t j = 0; j < sizeof buf; ++j)
> 			buf[j] = 0xaa;
> 	int nullfd = open("/dev/null", O_WRONLY);
> 	for (size_t i = 0; i < 100; ++ i)
> 		for (size_t j = 0; j < sizeof buf; ++j)
> 			buf[j] = 0xbb;
> 	write(nullfd, (char*)buf, sizeof buf);
> 	close(nullfd);
> }
> 
> timer_t t;
> volatile int sig_cnt;
> 
> static void
> sig_handler (int sig, siginfo_t *info, void *ctx)
> {
> 	if (sig_cnt >= 5) {
> 		struct itimerspec it = {};
> 		timer_settime(t, 0, &it, NULL);
> 	}
> 	++sig_cnt;
> }
> 
> int main( int argc, char *argv[] )
> {
> 	clockid_t my_process_clock;
> 	int e;
> 
> 	struct sigaction sa = { .sa_sigaction = sig_handler,
> 				.sa_flags = SA_SIGINFO };
> 	sigemptyset(&sa.sa_mask);
> 	sigaction(SIGRTMIN, &sa, NULL);
> 
> 	struct sigevent ev;
> 	memset( &ev, 0, sizeof (ev));
> 	ev.sigev_notify = SIGEV_SIGNAL;
> 	ev.sigev_signo  = SIGRTMIN;
> 	ev.sigev_value.sival_ptr = &ev;
> 
> 	e = clock_getcpuclockid( 0, &my_process_clock);
> 	if (e) {
> 		printf("clock_getcpuclockid: (%d) %s\n", e, strerror(e));
> 		return 1;
> 	}
> 	if (timer_create(my_process_clock, &ev, &t) != 0) {
> 		printf("timer_create: %m\n");
> 		return 1;
> 	}
> 
> 	struct itimerspec it;
> 	it.it_value.tv_sec    = 0;
> 	it.it_value.tv_nsec   = 100000;
> 	it.it_interval.tv_sec = 0;
> 	it.it_interval.tv_nsec = 100000;
> 
> 	timer_settime(t,0,&it,NULL);
> 
> 	while (sig_cnt < 5)
> 		chew_cpu();
> 
> 	// process timer should stop
> 	struct timespec req = { .tv_sec = 0, .tv_nsec = 400000 };
> 	nanosleep(&req,NULL);
> 
> 	// restart timer.
> 	sig_cnt = 0;
>         timer_settime(t,0,&it,NULL);
> 	while (sig_cnt < 5)
> 		chew_cpu();
> 
> 	timer_delete(t);
> 
> 	return 0;
> }
> 
> demonstrate the issue. Here are the results before and after applying the patch:
> 
> Before:
> 
> [  181.904571] cputimer started
> [  181.905013] cputimer stopped
> [  181.905027] cputimer started
> [  181.906009] cputimer stopped
> [  181.906016] cputimer started
> [  181.907008] cputimer stopped
> [  181.907014] cputimer started
> [  181.908008] cputimer stopped
> [  181.908013] cputimer started
> [  181.909008] cputimer stopped
> [  181.909020] cputimer started
> [  181.910007] cputimer stopped
> [  181.910050] cputimer started
> [  181.911011] cputimer stopped
> [  181.913619] cputimer started
> [  181.914007] cputimer stopped
> [  181.914015] cputimer started
> [  181.915006] cputimer stopped
> [  181.915011] cputimer started
> [  181.916006] cputimer stopped
> [  181.916010] cputimer started
> [  181.917008] cputimer stopped
> [  181.917058] cputimer started
> [  181.918009] cputimer stopped
> [  181.918029] cputimer started
> [  181.919006] cputimer stopped
> [  181.919010] cputimer started
> [  181.920006] cputimer stopped
> 
> After:
> 
> [  859.722119] cputimer started
> [  859.730004] cputimer stopped
> [  859.731354] cputimer started
> [  859.739004] cputimer stopped
> 
> Signed-off-by: Olivier Langlois <olivier@trillion01.com>
> ---
>  kernel/posix-cpu-timers.c | 34 +++++++++++++++-------------------
>  1 file changed, 15 insertions(+), 19 deletions(-)
> 
> diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
> index c7f31aa..972f5cb 100644
> --- a/kernel/posix-cpu-timers.c
> +++ b/kernel/posix-cpu-timers.c
> @@ -1049,8 +1049,6 @@ static void check_process_timers(struct task_struct *tsk,
>  	sig->cputime_expires.prof_exp = expires_to_cputime(prof_expires);
>  	sig->cputime_expires.virt_exp = expires_to_cputime(virt_expires);
>  	sig->cputime_expires.sched_exp = sched_expires;
> -	if (task_cputime_zero(&sig->cputime_expires))
> -		stop_process_timers(sig);
>  }
>  
>  /*
> @@ -1158,34 +1156,32 @@ static inline int task_cputime_expired(const struct task_cputime *sample,
>   */
>  static inline int fastpath_timer_check(struct task_struct *tsk)
>  {
> -	struct signal_struct *sig;
> -	cputime_t utime, stime;
> +	struct signal_struct *sig = tsk->signal;
>  
> -	task_cputime(tsk, &utime, &stime);
> +	if (sig->cputimer.running) {
> +		if (likely(!task_cputime_zero(&sig->cputime_expires))) {
> +			struct task_cputime group_sample;
> +
> +			raw_spin_lock(&sig->cputimer.lock);
> +			group_sample = sig->cputimer.cputime;
> +			raw_spin_unlock(&sig->cputimer.lock);
> +
> +			if (task_cputime_expired(&group_sample, &sig->cputime_expires))
> +				return 1;
> +		} else
> +			stop_process_timers(sig);
> +	}
>  
>  	if (!task_cputime_zero(&tsk->cputime_expires)) {
>  		struct task_cputime task_sample = {
> -			.utime = utime,
> -			.stime = stime,
>  			.sum_exec_runtime = tsk->se.sum_exec_runtime
>  		};
> +		task_cputime(tsk, &task_sample.utime, &task_sample.stime);
>  
>  		if (task_cputime_expired(&task_sample, &tsk->cputime_expires))
>  			return 1;
>  	}
>  
> -	sig = tsk->signal;
> -	if (sig->cputimer.running) {
> -		struct task_cputime group_sample;
> -
> -		raw_spin_lock(&sig->cputimer.lock);
> -		group_sample = sig->cputimer.cputime;
> -		raw_spin_unlock(&sig->cputimer.lock);
> -
> -		if (task_cputime_expired(&group_sample, &sig->cputime_expires))
> -			return 1;
> -	}
> -
>  	return 0;
>  }
>  


