Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788Ab3G0GnU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 02:43:20 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:37265 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268Ab3G0GnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 02:43:18 -0400
Message-ID: <51F36C03.2050303@linaro.org>
Date: Sat, 27 Jul 2013 08:43:15 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jeremy Eder <jeder@redhat.com>
CC: linux-kernel@vger.kernel.org, rafael.j.wysocki@intel.com, riel@redhat.com,
        youquan.song@intel.com, paulmck@linux.vnet.ibm.com,
        arjan@linux.intel.com, len.brown@intel.com
Subject: Re: RFC:  revert request for cpuidle patches e11538d1 and 69a37bea
References: <20130726173306.GB17985@jeder.rdu.redhat.com>
In-Reply-To: <20130726173306.GB17985@jeder.rdu.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2013 07:33 PM, Jeremy Eder wrote:
> Hello,
> 
> We believe we've identified a particular commit to the cpuidle code that
> seems to be impacting performance of variety of workloads.  The simplest way to
> reproduce is using netperf TCP_RR test, so we're using that, on a pair of
> Sandy Bridge based servers.  We also have data from a large database setup
> where performance is also measurably/positively impacted, though that test
> data isn't easily share-able.
> 
> Included below are test results from 3 test kernels:

Is the system tickless or with a periodic tick ?



> kernel       reverts
> -----------------------------------------------------------
> 1) vanilla   upstream (no reverts)
> 
> 2) perfteam2 reverts e11538d1f03914eb92af5a1a378375c05ae8520c
> 
> 3) test      reverts 69a37beabf1f0a6705c08e879bdd5d82ff6486c4
>                      e11538d1f03914eb92af5a1a378375c05ae8520c
> 
> In summary, netperf TCP_RR numbers improve by approximately 4% after
> reverting 69a37beabf1f0a6705c08e879bdd5d82ff6486c4.  When
> 69a37beabf1f0a6705c08e879bdd5d82ff6486c4 is included, C0 residency never
> seems to get above 40%.  Taking that patch out gets C0 near 100% quite
> often, and performance increases.
> 
> The below data are histograms representing the %c0 residency @ 1-second
> sample rates (using turbostat), while under netperf test.
> 
> - If you look at the first 4 histograms, you can see %c0 residency almost
>   entirely in the 30,40% bin.
> - The last pair, which reverts 69a37beabf1f0a6705c08e879bdd5d82ff6486c4,
>   shows %c0 in the 80,90,100% bins.
> 
> Below each kernel name are netperf TCP_RR trans/s numbers for the
> particular kernel that can be disclosed publicly, comparing the 3 test
> kernels.  We ran a 4th test with the vanilla kernel where we've also set
> /dev/cpu_dma_latency=0 to show overall impact boosting single-threaded
> TCP_RR performance over 11% above baseline.
> 
> 3.10-rc2 vanilla RX + c0 lock (/dev/cpu_dma_latency=0):  
> TCP_RR trans/s 54323.78
> 
> -----------------------------------------------------------
> 3.10-rc2 vanilla RX (no reverts)
> TCP_RR trans/s 48192.47
> 
> Receiver %c0 
>     0.0000 -    10.0000 [     1]: *
>    10.0000 -    20.0000 [     0]: 
>    20.0000 -    30.0000 [     0]: 
>    30.0000 -    40.0000 [    59]: 
> ***********************************************************
>    40.0000 -    50.0000 [     1]: *
>    50.0000 -    60.0000 [     0]: 
>    60.0000 -    70.0000 [     0]: 
>    70.0000 -    80.0000 [     0]: 
>    80.0000 -    90.0000 [     0]: 
>    90.0000 -   100.0000 [     0]: 
> 
> Sender %c0
>     0.0000 -    10.0000 [     1]: *
>    10.0000 -    20.0000 [     0]: 
>    20.0000 -    30.0000 [     0]: 
>    30.0000 -    40.0000 [    11]: ***********
>    40.0000 -    50.0000 [    49]:
> *************************************************
>    50.0000 -    60.0000 [     0]: 
>    60.0000 -    70.0000 [     0]: 
>    70.0000 -    80.0000 [     0]: 
>    80.0000 -    90.0000 [     0]: 
>    90.0000 -   100.0000 [     0]: 
> 
> -----------------------------------------------------------
> 3.10-rc2 perfteam2 RX (reverts commit
> e11538d1f03914eb92af5a1a378375c05ae8520c)
> TCP_RR trans/s 49698.69
> 
> Receiver %c0 
>     0.0000 -    10.0000 [     1]: *
>    10.0000 -    20.0000 [     1]: *
>    20.0000 -    30.0000 [     0]: 
>    30.0000 -    40.0000 [    59]:
> ***********************************************************
>    40.0000 -    50.0000 [     0]: 
>    50.0000 -    60.0000 [     0]: 
>    60.0000 -    70.0000 [     0]: 
>    70.0000 -    80.0000 [     0]: 
>    80.0000 -    90.0000 [     0]: 
>    90.0000 -   100.0000 [     0]: 
> 
> Sender %c0 
>     0.0000 -    10.0000 [     1]: *
>    10.0000 -    20.0000 [     0]: 
>    20.0000 -    30.0000 [     0]: 
>    30.0000 -    40.0000 [     2]: **
>    40.0000 -    50.0000 [    58]:
> **********************************************************
>    50.0000 -    60.0000 [     0]: 
>    60.0000 -    70.0000 [     0]: 
>    70.0000 -    80.0000 [     0]: 
>    80.0000 -    90.0000 [     0]: 
>    90.0000 -   100.0000 [     0]: 
> 
> -----------------------------------------------------------
> 3.10-rc2 test RX (reverts 69a37beabf1f0a6705c08e879bdd5d82ff6486c4 and
> e11538d1f03914eb92af5a1a378375c05ae8520c)
> TCP_RR trans/s 47766.95
> 
> Receiver %c0
>     0.0000 -    10.0000 [     1]: *
>    10.0000 -    20.0000 [     1]: *
>    20.0000 -    30.0000 [     0]: 
>    30.0000 -    40.0000 [    27]: ***************************
>    40.0000 -    50.0000 [     2]: **
>    50.0000 -    60.0000 [     0]: 
>    60.0000 -    70.0000 [     2]: **
>    70.0000 -    80.0000 [     0]: 
>    80.0000 -    90.0000 [     0]: 
>    90.0000 -   100.0000 [    28]: ****************************
> 
> Sender:
>     0.0000 -    10.0000 [     1]: *
>    10.0000 -    20.0000 [     0]: 
>    20.0000 -    30.0000 [     0]: 
>    30.0000 -    40.0000 [    11]: ***********
>    40.0000 -    50.0000 [     0]: 
>    50.0000 -    60.0000 [     1]: *
>    60.0000 -    70.0000 [     0]: 
>    70.0000 -    80.0000 [     3]: ***
>    80.0000 -    90.0000 [     7]: *******
>    90.0000 -   100.0000 [    38]: **************************************
> 
> These results demonstrate gaining back the tendency of the CPU to stay in
> more responsive, performant C-states (and thus yield measurably better
> performance), by reverting commit 69a37beabf1f0a6705c08e879bdd5d82ff6486c4.
> 
> While taking into account the changing landscape with regards to CPU
> governors, and both P- and C-states, we think that a single-thread should
> still be able to achieve maximum performance.  With the current upstream
> code base, workloads with a low number of "hot" threads are not able to
> achieve maximum performance "out of the box".
> 
> Also recently, Intel's LAD has posted upstream performance results that
> include an interesting column with their table of results.  See upstream
> commit 0a4db187a999, column #3 within the "Performance numbers" table.  It
> seems known, even within Intel, that the deeper C-states incur a cost too
> high to bear, as they've explicitly tested restricting the CPU to higher
> c-states of C0,1.
> 
> -- Jeremy Eder
> 


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

