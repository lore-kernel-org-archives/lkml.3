Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891Ab3I0GvV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 02:51:21 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:59517 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab3I0GvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 02:51:20 -0400
Date: Fri, 27 Sep 2013 08:51:15 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, huawei.libin@huawei.com,
        wangyijing@huawei.com, fenghua.yu@intel.com, tglx@linutronix.de,
        guohanjun@huawei.com, paul.gortmaker@windriver.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86/smpboot: Fix announce_cpu() to printk() the
 last "OK" properly
Message-ID: <20130927065115.GA6852@gmail.com>
References: <1378378676-18276-1-git-send-email-huawei.libin@huawei.com>
 <tip-52239484bf8aec031afa84ae08aa88224d819b93@git.kernel.org>
 <20130925100722.GB3433@nazgul.tnic>
 <20130925182936.GD16693@gmail.com>
 <20130926231545.GD10123@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130926231545.GD10123@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@alien8.de> wrote:

> On Wed, Sep 25, 2013 at 08:29:36PM +0200, Ingo Molnar wrote:
> > Indeed, that should be fixed.
> 
> Ok, how does a right alighment look like:
> 
> [    0.072399] smpboot: Booting Node   0, Processors   #1   #2   #3   #4   #5   #6   #7 OK
> [    0.617005] smpboot: Booting Node   1, Processors   #8   #9  #10  #11  #12  #13  #14  #15 OK
> [    1.230005] smpboot: Booting Node   2, Processors  #16  #17  #18  #19  #20  #21  #22  #23 OK
> [    1.835005] smpboot: Booting Node   3, Processors  #24  #25  #26  #27  #28  #29  #30  #31 OK
> [    2.437005] smpboot: Booting Node   4, Processors  #32  #33  #34  #35  #36  #37  #38  #39 OK
> [    3.053005] smpboot: Booting Node   5, Processors  #40  #41  #42  #43  #44  #45  #46  #47 OK
> [    3.657009] smpboot: Booting Node   6, Processors  #48  #49  #50  #51  #52  #53  #54  #55 OK
> [    4.256005] smpboot: Booting Node   7, Processors  #56  #57  #58  #59  #60  #61  #62  #63 OK
> 
> ?

Looks cool. The perfectionist in me would love to skip CPU0's space so 
that we get:

[    0.072399] smpboot: Booting Node   0, Processors        #1   #2   #3   #4   #5   #6   #7 OK
[    0.617005] smpboot: Booting Node   1, Processors   #8   #9  #10  #11  #12  #13  #14  #15 OK
[    1.230005] smpboot: Booting Node   2, Processors  #16  #17  #18  #19  #20  #21  #22  #23 OK
[    1.835005] smpboot: Booting Node   3, Processors  #24  #25  #26  #27  #28  #29  #30  #31 OK
[    2.437005] smpboot: Booting Node   4, Processors  #32  #33  #34  #35  #36  #37  #38  #39 OK

Pretty please? :-)

> With lockdep butting in-between it is still readable:
> 
> [    0.063330] SMP alternatives: lockdep: fixing up alternatives
> [    0.064032] smpboot: Booting Node   0, Processors   #1
> [    0.141231] SMP alternatives: lockdep: fixing up alternatives
> [    0.142007]    #2
> [    0.230210] SMP alternatives: lockdep: fixing up alternatives
> [    0.231007]    #3
> [    0.307237] SMP alternatives: lockdep: fixing up alternatives
> [    0.308007]    #4
> [    0.384231] SMP alternatives: lockdep: fixing up alternatives
> [    0.385006]    #5
> [    0.468237] SMP alternatives: lockdep: fixing up alternatives
> [    0.469007]    #6
> [    0.545230] SMP alternatives: lockdep: fixing up alternatives
> [    0.546006]    #7 OK
> [    0.626323] Brought up 8 CPUs
> [    0.627004] smpboot: Total of 8 processors activated (64217.00 BogoMIPS)


Hm, I realize that this was a nice test for the printout robustness, but 
could you please also remove the alternatives message in another patch?

That message was cool and interesting back in the days when we wrote 
lockdep ('hey, look ma, it really works!!'), but there hasn't been any 
breakage in that area for a long time and it definitely does not deserve 
one line of log spam per CPU! Especially if it messes up such a nice CPU 
bootup table.

> I admit the digits calculation is a bit clumsy but I didn't want to do 
> any log_10 crazy jumps through hoops and besides, it should be faster 
> this way:

> -		pr_cont(" #%4d%s", cpu, cpu == max_cpu_present ? " OK\n" : "");
> +		num_digits = 1 + 1 * (cpu > 9) + 1 * (cpu > 99);
> +
> +		pr_cont("%*s#%d", 4 - num_digits, " ", cpu);
> +
> +		if (cpu == num_present_cpus() - 1)
> +			pr_cont(" OK\n");

So how about taking log10(num_possible_cpus()) as the width of the 
printout? (If it wraps out of the screen on 4K CPU systems then those 
lucky people can resize their terminals or so.)

There's absolutely no speed consideration here, and people do keep staring 
at the CPU bootup printout frequently. A small helper function can 
construct a fixed-width entry into a string, which can be printed using %s.

Width only has to be calculated once:

static int num_digits(val)
{
	int digits = 0;

	while (val) {
		val /= 10;
		digits++;
	}

	return digits;
}

...
	width = num_digits(num_possible_cpus());
...

And the beauty of it is that small, slow systems will naturally spend a 
few cycles less time in num_digits() than large, fast systems.

(and I hope you learned the lesson about sending improvement patches 
against long-bitrotten code, as the new x86 CPU bootup printout format 
code maintainer!)

Thanks,

	Ingo
