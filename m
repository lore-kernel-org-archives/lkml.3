Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab3IKLSi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 07:18:38 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:47160 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484Ab3IKLSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 07:18:35 -0400
Message-ID: <5230509D.6040205@linux.vnet.ibm.com>
Date: Wed, 11 Sep 2013 16:44:37 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Stephen Warren <swarren@wwwdotorg.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cpufreq <cpufreq@vger.kernel.org>
Subject: Re: cpufreq_stats NULL deref on second system suspend
References: <522E1FEF.6080803@wwwdotorg.org> <1775778.MeiRhuYy7o@vostro.rjw.lan>	<522F86AD.6010603@wwwdotorg.org> <2521560.SfeNbV74nj@vostro.rjw.lan>	<52304439.3030301@linux.vnet.ibm.com> <CAKohpokTVzikxunqSdUYmLjTOkfhWFJ=N4TTa4rdbj2euCFY-g@mail.gmail.com> <CAKohpomzQ8Yzk+OU0btQM6DGm4xsY1RR9uYFrZD3ZHO-bhrwKQ@mail.gmail.com>
In-Reply-To: <CAKohpomzQ8Yzk+OU0btQM6DGm4xsY1RR9uYFrZD3ZHO-bhrwKQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091111-2000-0000-0000-00000DADA8DD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2013 04:15 PM, Viresh Kumar wrote:
> On 11 September 2013 16:14, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>> But I would have solved it differently :)
>>
>> We don't really need to call update_policy_cpu() again and again
>> as we don't really need to update policy->cpu...
>>
>> Rather it would be better to just move following inside
>> cpufreq_policy_alloc():
> 
> Half written mail sent :(
> 
> What about moving following to cpufreq_policy_alloc():
> 
> policy->cpu = cpu;
> 
> ??
> 

Hmm? The problem is not about merely updating the policy->cpu field; the
main issue is that the existing code was not letting the cpufreq-stats
code know that we updated the policy->cpu under the hood. It is important
for cpufreq-stats to know this because it maintains the reference to its
stats structure by associating it with the policy->cpu. So if policy->cpu
changes under the hood, it loses track of its reference. So we need to
keep that code informed about changes to policy->cpu. Thus, we need to call
update_policy_cpu() in the CPU online path (during resume). I don't see
how we can skip that.

Regards,
Srivatsa S. Bhat

