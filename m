Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754AbaBQJBM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 04:01:12 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:58001 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230AbaBQJBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 04:01:09 -0500
Message-ID: <5301CE86.9020105@linux.vnet.ibm.com>
Date: Mon, 17 Feb 2014 14:25:34 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pierre Ossman <pierre-list@ossman.eu>
Subject: Re: [PATCH 1/2] cpufreq: Return error if ->get() failed in cpufreq_update_policy()
References: <15ccc0609cb9ee3db0ad3a95b29bf69d11ea197c.1392375504.git.viresh.kumar@linaro.org> <4772234.6D4cUIJHX4@vostro.rjw.lan> <CAKohpo=uPbqMcDEHYEMahRF0rCO8KYscj2nocz81_OTKyU+Tfw@mail.gmail.com> <5301C605.3030205@linux.vnet.ibm.com> <CAKohpo=mQWxoKTduR8FrrB4Qz45qXQrJjSudq=FkCJtHBTbo2Q@mail.gmail.com>
In-Reply-To: <CAKohpo=mQWxoKTduR8FrrB4Qz45qXQrJjSudq=FkCJtHBTbo2Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021709-9574-0000-0000-00000BFD200B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2014 02:09 PM, Viresh Kumar wrote:
> On 17 February 2014 13:49, Srivatsa S. Bhat
> <srivatsa.bhat@linux.vnet.ibm.com> wrote:
>> Quick question: Looking at cpufreq_update_policy() and cpufreq_out_of_sync(),
>> I understand that if the cpufreq subsystem's notion of the current frequency
>> does not match with the actual frequency of the CPU, it tries to adjust and
>> notify everyone that the current frequency is so-and-so, as read from the
>> hardware. Instead, why can't we simply set the frequency to the value that
>> we _want_ it to be at? I mean, if cpufreq subsystem thinks it is X KHz and
>> the actual frequency is Y KHz, we can as well fix the anomaly by setting the
>> frequency immediately to X KHz right?
>>
>> The reason I ask this is that, if we follow this approach, then we can avoid
>> ambiguities in dealing with the out-of-sync situation. That is, it becomes
>> very straightforward to decide _what_ to do, when we detect scenarios where
>> the frequency goes out of sync.
> 
> Hmm, it is just about doing all that stuff in a single line, like:
> __cpufreq_driver_target(...) ??
> 
> There are few problems here:
> - If we simply call above routine with X, then it will simply return as
> X == policy->cur. And I don't want to hack this code in a bad way now :)
> 
> - So, probably the way it is implemented is right, as we do that the most
> efficient way. We just broadcast the new freq in case there is a difference
> otherwise nothing.

Specifically, I'm referring to the problem where there _is_ a difference,
but the ->get() is not reporting it properly, like returning a 0 for example.
In such a case, instead of erroring out (and thereby perhaps opening the doors
to more problems down the line), won't it be better to simply set the CPU's
frequency to what we want it to be?

That is, I'm concerned about this part of your patch:

 	if (cpufreq_driver->get) {
 		new_policy.cur = cpufreq_driver->get(cpu);
+
+		if (!new_policy.cur) {
+			pr_err("%s: ->get() returned 0 KHz\n", __func__);
+			ret = -EINVAL;
+			goto no_policy;
+		}
+

Why go to no_policy when we can actually set things right?

Anyway, I am not arguing against this strongly. I just wanted to share my
thoughts, since this is the approach that made more sense to me.

Regards,
Srivatsa S. Bhat

