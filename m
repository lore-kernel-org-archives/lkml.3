Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761964Ab3DCXap (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 19:30:45 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:36743 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760953Ab3DCXan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 19:30:43 -0400
Message-ID: <515CBB98.4020607@semaphore.gr>
Date: Thu, 04 Apr 2013 02:30:32 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Viresh Kumar <viresh.kumar@linaro.org>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 linux-next] cpufreq: ondemand: Calculate gradient of
 CPU load to early increase frequency
References: <ore61p9gvaic2j0fc083dpbd.1364970699079@email.android.com> <CAKohponUuwiQ9EiKq66Mgf7zZxonxHs=DNbhx=uydDVB5bed6w@mail.gmail.com> <3060957.HxB12olH3c@vostro.rjw.lan>
In-Reply-To: <3060957.HxB12olH3c@vostro.rjw.lan>
Content-Type: multipart/mixed;
 boundary="------------020504000702030900090901"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020504000702030900090901
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 04/03/2013 02:14 PM, Rafael J. Wysocki wrote:
> On Wednesday, April 03, 2013 12:13:56 PM Viresh Kumar wrote:
>> On 3 April 2013 12:01, stratosk <stratosk@semaphore.gr> wrote:
>>> I'm sorry, I don't understand.
>>> The goal of this patch is not energy saving.
>>
>> He probably misunderstood it...
>>
>>> The goal is to detect CPU load as soon as possible to increase frequency.
>>>
>>> Could you please clarify this?
>>
>> But he is looking for some numbers to prove your patch. Some numbers
>> that shows performance is better with your changes...
> 
> Yes.  If the goal of the patch is to improve performance, it would be good to
> know that it does meet the goal. IOW, *something* is supposed to be better with
> the patch and if so, numbers in support of this should be provided.
> 
> Thanks,
> Rafael

I tried to do some measurements simulating a CPU load with a loop that simply counts
an integer. The first test simulates a CPU load that lasts 2 x sampling_rate = ~ 20000us.
The second ~40000us and the third ~60000us.
There are 5 runs in each test. In each run the benchmark program counts 20 times with
early_demand off and 20 times with early_demand on and takes the average times.

I run the benchmark program on 3.9-rc5 + early_demand patch. My CPU is the i7-3770 @ 3.40 GHz

Please find below the results, and the benchmark code attached.
Please note, that the idea of this patch is to push the CPU to max frequency few sampling
periods (1 in most cases) earlier for a more responsive system. 

Thanks for your time,
Stratos

--------

counter 10,000,000
run	early_demand off	early_demand on		diff
1	20183us			20100us			0.41%
2	20127us			20091us			0.18%
3	20121us			20034us			0.43%
4	20262us			20043us			1.08%
5	20192us			20101us			0.45%

counter 20,000,000
run	early_demand off	early_demand on		diff
1	40037us			39846us			0.47%
2	40051us			39829us			0.55%
3	39996us			39845us			0.38%
4	40104us			39876us			0.57%
5	40090us			39841us			0.62%

counter 30,000,000
run	early_demand off	early_demand on		diff
1	60010us			59834us			0.29%
2	59560us			59854us			-0.491%
3	60006us			59827us			0.29%
4	59998us			59828us			0.28%
5	60012us			59866us			0.24%


--------------020504000702030900090901
Content-Type: text/x-csrc;
 name="bench.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="bench.c"

#include <stdio.h>
#include <sys/time.h>
#include <unistd.h>


struct timeval start, end;
unsigned long long i, cnt;
long utime, seconds, useconds;

void enable_early() {
	system("echo 1 > /sys/devices/system/cpu/cpufreq/ondemand/early_demand");
}

void disable_early() {
        system("echo 0 > /sys/devices/system/cpu/cpufreq/ondemand/early_demand");
}

void calibrate()
{
	sleep(1);

	gettimeofday(&start, NULL);

	for (i = 0; i < 1000000000; i++);

	gettimeofday(&end, NULL);
	seconds = end.tv_sec - start.tv_sec;
	useconds = end.tv_usec - start.tv_usec;
	utime = seconds * 1000000 + useconds;
	
	printf("Calibrating\n");
	printf("Elapsed time: %ld microseconds\n", utime);

	/* find the counter for 10ms */
	cnt = i * 10000 / utime;

	printf("cnt: %ld\n", cnt);
}

long do_bench()
{
	gettimeofday(&start, NULL);

	for (i = 0; i < cnt; i++);

	gettimeofday(&end, NULL);
	seconds = end.tv_sec - start.tv_sec;
	useconds = end.tv_usec - start.tv_usec;
	utime = seconds * 1000000 + useconds;
	
	printf("Elapsed time: %ld microseconds\n", utime);

	return utime;
}

void benchmark()
{
	const int iter = 20;
	long total_off = 0;
	long total_on = 0;
	int diff_perc;
	unsigned int i;

	/* calibrate(); */
	cnt = 10000000;

	disable_early();
	do_bench(); /* do a first benchmark but do not count in total */	
	sleep(5);

	for (i = 0; i < iter; i++) {
		total_off += do_bench();
		
		usleep(500000);
	}
	total_off /= iter;

	printf("early_demand off - average time: %ld microseconds\n", total_off);

	enable_early();
	do_bench(); /* do a first benchmark but do not count in total */
	sleep(5);

	for (i = 0; i < iter; i++) {
                total_on += do_bench();

                usleep(500000);
        }
        total_on /= iter;

	diff_perc = total_off - total_on;

        printf("early_demand on - average time: %ld microseconds\n", total_on);
	printf("diff: %d\n", diff_perc);
}

main ()
{
	printf("Starting benchmark\n");
	benchmark();

}

--------------020504000702030900090901--
