Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965473AbaFQQcf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:32:35 -0400
Received: from blu004-omc2s21.hotmail.com ([65.55.111.96]:51289 "EHLO
	BLU004-OMC2S21.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964771AbaFQQcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:32:33 -0400
X-TMN: [lKYfO6odi1irHJrTIujvzviQ/1+ULpGW]
X-Originating-Email: [registosites@hotmail.com]
Message-ID: <BLU436-SMTP1654CD288024E13F3E9027EC6110@phx.gbl>
Date: Tue, 17 Jun 2014 17:32:26 +0100
From: Mauro <registosites@hotmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
CC: Arjan van de Ven <arjan@linux.intel.com>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        Zhang Rui <rui.zhang@intel.com>, jacob.jun.pan@linux.intel.com,
        Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@amacapital.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa@mit.edu>
Subject: Re: [PATCH 11/15] x86: Rewrite cyc2ns to avoid the need to disable
 IRQs
References: <20131212140835.729222186@infradead.org>	<20131212141655.238445339@infradead.org>	<CAOh2x=mgeozUMGYQubQ4GKPEB6k_TkcV3CSTzNLqjKok-gROQg@mail.gmail.com>	<20140617121535.GY6758@twins.programming.kicks-ass.net> <CAKohpo=6t-VHgJfrq7wz35y_zKfL+wb8amgj0ZV9cezb39r=uA@mail.gmail.com>
In-Reply-To: <CAKohpo=6t-VHgJfrq7wz35y_zKfL+wb8amgj0ZV9cezb39r=uA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Jun 2014 16:32:31.0566 (UTC) FILETIME=[BC6ED6E0:01CF8A49]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17-06-2014 13:42, Viresh Kumar wrote:
>> So what you can try is force a cyc2ns read before the write in
>> set_cyc2ns_scale(). I think its possible that if we do not do the read,
>> the write will wait for a 'free' slot indefinitely.
> 
> Hmm, I see. Thanks for your quick response.
> 
> Are you suggesting something like this ? :
> 
> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> index 57e5ce1..290ac03 100644
> --- a/arch/x86/kernel/tsc.c
> +++ b/arch/x86/kernel/tsc.c
> @@ -249,6 +249,9 @@ static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
>         if (!cpu_khz)
>                 goto done;
> 
> +       data = cyc2ns_read_begin();
> +       cyc2ns_read_end(data);
> +
>         data = cyc2ns_write_begin(cpu);
> 
>         rdtscll(tsc_now);
> 
> 
> @Mauro: Please try this once Peter confirms.

I have tried this and it doesn't solve the problem, the machine still
hangs after the second frequency change after cpu offline/online.
