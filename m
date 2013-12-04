Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932573Ab3LDPP7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 10:15:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932542Ab3LDPP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 10:15:56 -0500
Message-ID: <529F4728.20500@redhat.com>
Date: Wed, 04 Dec 2013 10:15:52 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Yu, Fenghua" <fenghua.yu@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH] x86: Add check for number of available vectors before
 CPU down
References: <1384878243-5086-1-git-send-email-prarit@redhat.com> <3E5A0FA7E9CA944F9D5414FEC6C712205A59505E@ORSMSX106.amr.corp.intel.com>
In-Reply-To: <3E5A0FA7E9CA944F9D5414FEC6C712205A59505E@ORSMSX106.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/03/2013 06:42 PM, Yu, Fenghua wrote:
> 
> 
>> -----Original Message-----
>> From: Prarit Bhargava [mailto:prarit@redhat.com]
>>
>> Second try at this ...
>>
>> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=64791
>>
>> When a cpu is downed on a system, the irqs on the cpu are assigned to
>> other cpus.  It is possible, however, that when a cpu is downed there
>> aren't enough free vectors on the remaining cpus to account for the
>> vectors from the cpu that is being downed.
>>
>> This results in an interesting "overflow" condition where irqs are
>> "assigned" to a CPU but are not handled.
>>
>> For example, when downing cpus on a 1-64 logical processor system:
>>
>> +			if (per_cpu(vector_irq, cpu)[vector] < 0)
>> +				count++;
> 
> But later on fixup_irqs will set some of vector_irq vector as -1 on this
> to-be-disabled cpu. That will release vectors assigned to this cpu. So
> checking vector_irq at this point before fixup_irqs doesn't make sense, right?
> 

Fenghua, IIUC the purpose of fixup_irqs() is to migrate irqs from the
to-be-disabled cpu to other cpus by using affinity, etc..  The to-be-disabled
cpus' irqs are set to -1, however, only after they are migrated off to an
enabled cpu.

This check I'm introducing is well before that stage in effort to determine
whether or not the system has "room" for the irqs on the remaining cpus.

So I think that the check is in the right spot.  We should do it early.  I
suppose an argument could be made to do the check in fixup_irqs(), however, my
feeling is by then it is very late in the process of downing the cpu.

I noticed a subtle bug in my patch that I will send with a [v2].  I'm not taking
into account per-cpu interrupts in the check_vectors() function.

P.

> Thanks.
> 
> -Fenghua
> 
