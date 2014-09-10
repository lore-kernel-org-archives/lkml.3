Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751452AbaIJG6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 02:58:18 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:47416 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbaIJG6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 02:58:16 -0400
Message-ID: <540FF649.2090901@linux.vnet.ibm.com>
Date: Wed, 10 Sep 2014 12:27:13 +0530
From: shilpa <shilpa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: David Laight <David.Laight@ACULAB.COM>,
        Viresh Kumar <viresh.kumar@linaro.org>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH v2] cpufreq: powernv: Set the cpus to nominal frequency
 during reboot/kexec
References: <1409234816-10802-1-git-send-email-shilpa.bhat@linux.vnet.ibm.com> <CAKohpokbYkL=cYQ+9-59vPhBmbAWqhrEz7RBPj5-edDB25DPgw@mail.gmail.com> <1409548719.13507.13.camel@localhost.localdomain> <063D6719AE5E284EB5DD2968C1650D6D174849AD@AcuExch.aculab.com>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D174849AD@AcuExch.aculab.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14091006-7014-0000-0000-0000002E12AD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2014 02:42 PM, David Laight wrote:
>> Yes unlikely() should cover the whole if statement...
> 
> Actually it probably shouldn't.
> You need to look at the generated code with each different set of 'unlikely()'
> to see how gcc processes them.
> In this case, if 'rebooting' is false you want to 'fall through' on a statically
> predicted 'not taken' branch. You don't ever care about the second clause.
> With an 'unlikely' covering the entire statement gcc could easily add a
> forwards conditional branch (that will be mis-predicted) for the 'rebooting' test.
> 
> (Yes, I spent a lot of time getting gcc to generate branches that were
> correctly statically predicted for some code where every cycle mattered.)
> 
> 	David
> 
Hi David,

The objdup with an 'unlikely()' covering the entire if statement is as follows:

 if (unlikely(rebooting && new_index != get_nominal_index()))
	return -EBUSY;

 1ac:   2f 89 00 00     cmpwi   cr7,r9,0   /* compare rebooting,0 */
 1b0:   40 de 00 4c     bne-    cr7,1fc <.powernv_cpufreq_target_index+0x7c>

 The '-' in the instruction bne- specifies an unlikely branch. So gcc has
 processed the first clause to be identified as an unlikely branch i.e,
 branch to <1fc> (to test the second clause) is unlikely on 'rebooting' not
 equal to 0.


 1b4:   1f ff 00 0c     mulli   r31,r31,12
 .
 . <--- Set the frequency and return --->
 .
 .
 1fc:   3d 22 00 00     addis   r9,r2,0  /* test the second clause */
 200:   3d 02 00 00     addis   r8,r2,0
 204:   81 49 00 00     lwz     r10,0(r9)
 208:   81 28 00 00     lwz     r9,0(r8)
 20c:   7d 29 50 50     subf    r9,r9,r10
 210:   7f 89 f8 00     cmpw    cr7,r9,r31 /* compare new_index,nominal_index */
 214:   41 9e ff a0     beq+     cr7,1b4 <.powernv_cpufreq_target_index+0x34>

 The '+' in the instruction beq+ specifies a likely branch. The second clause
 unlikely(new_index != get_nominal_index()) is processed to
 likely(new_index == get_nominal_index()).

 218:   38 60 ff f0     li      r3,-16  /* return -EBUSY */
 21c:   4b ff ff cc     b       1e8 <.powernv_cpufreq_target_index+0x68>

So unlikely() covering the entire statement will not lead to a branch mis-prediction
for the 'rebooting' test. Having unlikely to cover both 'rebooting' and  the second
clause we can avoid the branch miss prediction for the second clause. This is
advantageous for the code path powernv_cpufreq_target_index(policy,nominal_index)
which will be invoked by the reboot_notifier.

Thanks and Regards,
Shilpa

