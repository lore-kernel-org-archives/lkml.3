Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbaD2Ezq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 00:55:46 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:39865 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbaD2Ezo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 00:55:44 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpomaJ0ubnzzQ7AwAd6z+Zm085i+UwB7XMa=si7qthZdgZg@mail.gmail.com>
References: <20140428185331.28755.899.stgit@srivatsabhat.in.ibm.com>
	<20140428185507.28755.6483.stgit@srivatsabhat.in.ibm.com>
	<CAKohpomaJ0ubnzzQ7AwAd6z+Zm085i+UwB7XMa=si7qthZdgZg@mail.gmail.com>
Date: Tue, 29 Apr 2014 10:25:43 +0530
Message-ID: <CAKohpokiy2Fvry=uTVnOCymH7Co1ka+JCFT3ndtPQBSD94Mnew@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] cpufreq: Catch double invocations of cpufreq_freq_transition_begin/end
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Meelis Roos <mroos@linux.ee>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 April 2014 10:21, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> Nice effort.
>
> On 29 April 2014 00:25, Srivatsa S. Bhat
> <srivatsa.bhat@linux.vnet.ibm.com> wrote:
>> Now all such drivers have been fixed, but debugging this issue was not
>> very straight-forward (even lockdep didn't catch this). So let us add a
>> debug infrastructure to the cpufreq core to catch such issues more easily
>> in the future.
>
> BUT, I am not sure if we really need it :(
>
> I think we just got into the 'barrier' stuff as we had some doubts about it
> earlier and were quite sure that nothing else could go wrong. Otherwise
> the only problem could have been present was the second queuing
> from the same thread. And we will surely get stuck if that happens and
> we can't just miss that error..
>
>> Scenario 1: (Deadlock-free)
>> ----------
>>
>>          Task A                                         Task B
>>
>>     /* 1st freq transition */
>>     Invoke _begin() {
>>             ...
>>             ...
>>     }
>>
>>     Change the frequency
>>
>>                                                 Got interrupt for successful
>>                                                 change of frequency.
>>
>>                                                 /* 1st freq transition */
>>                                                 Invoke _end() {
>>                                                         ...
>>                                                         ...
>>     /* 2nd freq transition */                           ...
>>     Invoke _begin() {                                   ...
>>             ... //waiting for B                         ...
>>             ... //to finish _end()              }
>>             ...
>>             ...
>>     }
>>
>>
>> This scenario is actually deadlock-free because Task A can wait inside the
>> second call to _begin() without self-deadlocking, because it is the
>> responsibility of Task B to finish the first sequence by invoking the
>> corresponding _end().

WTF, I was writing my mail and it just got send due to some stupid combination
of keys :( .. Sorry.

Also, this might not work as expected. Consider this scenario:

     /* 1st freq transition */
     Invoke _begin() {
             ...
             ...
     }

     Start Change of frequency and return
     back as there is no end from same thread.

     /* 2nd freq transition as there is nobody stopping us */
     Invoke _begin() {
             ... //waiting for B
             ... //to finish _end()
             ...
             ...
     }

                                                              Got
interrupt for successful
                                                              change
of frequency.

                                                              /* 1st
freq transition */
                                                              Invoke _end() {
                                                                     ...
                                                                     ...
                                                             }

And your patch will probably break this ?
