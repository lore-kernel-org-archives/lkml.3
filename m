Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035AbaANHnK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 02:43:10 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:45107 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982AbaANHnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 02:43:06 -0500
Message-ID: <52D4E93C.3050503@linux.vnet.ibm.com>
Date: Tue, 14 Jan 2014 13:07:32 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
CC: deepthi@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, benh@kernel.crashing.org,
        daniel.lezcano@linaro.org, rjw@rjwysocki.net,
        linux-kernel@vger.kernel.org, svaidy@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org, tuukka.tikkanen@linaro.org
Subject: Re: [PATCH] cpuidle/menu: Fail cpuidle_idle_call() if no idle state
 is acceptable
References: <20140114060516.6109.14901.stgit@preeti.in.ibm.com> <52D4E07E.204@linux.vnet.ibm.com>
In-Reply-To: <52D4E07E.204@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011407-5490-0000-0000-000004C774CC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2014 12:30 PM, Srivatsa S. Bhat wrote:
> On 01/14/2014 11:35 AM, Preeti U Murthy wrote:
>> On PowerPC, in a particular test scenario, all the cpu idle states were disabled.
>> Inspite of this it was observed that the idle state count of the shallowest
>> idle state, snooze, was increasing.
>>
>> This is because the governor returns the idle state index as 0 even in
>> scenarios when no idle state can be chosen. These scenarios could be when the
>> latency requirement is 0 or as mentioned above when the user wants to disable
>> certain cpu idle states at runtime. In the latter case, its possible that no
>> cpu idle state is valid because the suitable states were disabled
>> and the rest did not match the menu governor criteria to be chosen as the
>> next idle state.
>>
>> This patch adds the code to indicate that a valid cpu idle state could not be
>> chosen by the menu governor and reports back to arch so that it can take some
>> default action.
>>
> 
> That sounds fair enough. However, the "default" action of pseries idle loop
> (pseries_lpar_idle()) surprises me. It enters Cede, which is _deeper_ than doing
> a snooze! IOW, a user might "disable" cpuidle or set the PM_QOS_CPU_DMA_LATENCY
> to 0 hoping to prevent the CPUs from going to deep idle states, but then the
> machine would still end up going to Cede, even though that wont get reflected
> in the idle state counts. IMHO that scenario needs some thought as well...
> 

I checked the git history and found that the default idle was changed (on purpose)
to cede the processor, in order to speed up booting.. Hmm..

commit 363edbe2614aa90df706c0f19ccfa2a6c06af0be
Author: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date:   Fri Sep 6 00:25:06 2013 +0530

    powerpc: Default arch idle could cede processor on pseries


Regards,
Srivatsa S. Bhat

