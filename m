Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400Ab3F0Ln5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 07:43:57 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:53378 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018Ab3F0Lnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 07:43:55 -0400
Message-ID: <51CC2651.507@linux.vnet.ibm.com>
Date: Thu, 27 Jun 2013 17:17:29 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Andrew Jones <drjones@redhat.com>, gleb@redhat.com
CC: mingo@redhat.com, jeremy@goop.org, x86@kernel.org, konrad.wilk@oracle.com,
        hpa@zytor.com, pbonzini@redhat.com, linux-doc@vger.kernel.org,
        habanero@linux.vnet.ibm.com, xen-devel@lists.xensource.com,
        peterz@infradead.org, mtosatti@redhat.com,
        stefano.stabellini@eu.citrix.com, andi@firstfloor.org,
        attilio.rao@citrix.com, ouyang@cs.pitt.edu, gregkh@suse.de,
        agraf@suse.de, chegu_vinod@hp.com, torvalds@linux-foundation.org,
        avi.kivity@gmail.com, tglx@linutronix.de, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stephan.diestelhorst@amd.com,
        riel@redhat.com, virtualization@lists.linux-foundation.org,
        srivatsa.vaddagiri@gmail.com
Subject: Re: [PATCH RFC V10 0/18] Paravirtualized ticket spinlocks
References: <20130624124014.27508.8906.sendpatchset@codeblue.in.ibm.com> <20130624131716.GA11948@hawk.usersys.redhat.com> <51CAA764.7000006@linux.vnet.ibm.com>
In-Reply-To: <51CAA764.7000006@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062711-5816-0000-0000-000008A77354
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2013 02:03 PM, Raghavendra K T wrote:
> On 06/24/2013 06:47 PM, Andrew Jones wrote:
>> On Mon, Jun 24, 2013 at 06:10:14PM +0530, Raghavendra K T wrote:
>>>
>>> Results:
>>> =======
>>> base = 3.10-rc2 kernel
>>> patched = base + this series
>>>
>>> The test was on 32 core (model: Intel(R) Xeon(R) CPU X7560) HT disabled
>>> with 32 KVM guest vcpu 8GB RAM.
>>
>> Have you ever tried to get results with HT enabled?
>>
>>>
>>> +-----------+-----------+-----------+------------+-----------+
>>>                 ebizzy (records/sec) higher is better
>>> +-----------+-----------+-----------+------------+-----------+
>>>      base        stdev        patched    stdev        %improvement
>>> +-----------+-----------+-----------+------------+-----------+
>>> 1x  5574.9000   237.4997    5618.0000    94.0366     0.77311
>>> 2x  2741.5000   561.3090    3332.0000   102.4738    21.53930
>>> 3x  2146.2500   216.7718    2302.3333    76.3870     7.27237
>>> 4x  1663.0000   141.9235    1753.7500    83.5220     5.45701
>>> +-----------+-----------+-----------+------------+-----------+
>>
>> This looks good. Are your ebizzy results consistent run to run
>> though?
>>
>>> +-----------+-----------+-----------+------------+-----------+
>>>                dbench  (Throughput) higher is better
>>> +-----------+-----------+-----------+------------+-----------+
>>>      base        stdev        patched    stdev        %improvement
>>> +-----------+-----------+-----------+------------+-----------+
>>> 1x 14111.5600   754.4525   14645.9900   114.3087     3.78718
>>> 2x  2481.6270    71.2665    2667.1280    73.8193     7.47498
>>> 3x  1510.2483    31.8634    1503.8792    36.0777    -0.42173
>>> 4x  1029.4875    16.9166    1039.7069    43.8840     0.99267
>>> +-----------+-----------+-----------+------------+-----------+
>>
>> Hmm, I wonder what 2.5x looks like. Also, the 3% improvement with
>> no overcommit is interesting. What's happening there? It makes
>> me wonder what < 1x looks like.
>>
>
> Hi Andrew,
>
> I tried 2.5x case sort where I used 3 guests with 27 vcpu each on 32
> core (HT disabled machine) and here is the output. almost no gain there.
>
>               throughput avg    stdev
> base:     1768.7458 MB/sec     54.044221
> patched:  1772.5617 MB/sec     41.227689
> gain %0.226
>
> I am yet to try HT enabled cases that would give 0.5x to 2x performance
> results.
>

I have the result of HT enabled case now.
config: total 64 cpu (HT on) 32 vcpu guests.
I am seeing some inconsistency in ebizzy results in this case (May be 
Drew had tried with HT on and had observed the same in ebizzy runs).

patched-nonple and  base  performance in case of 1.5x and 2x also have 
been little inconsistent for dbench too. Overall I see pvspinlock + ple 
on case more stable.
and overall pvspinlock performance seem to be very impressive in HT 
enabled case.

patched = pvspinv10_hton
+-----------+-----------+-----------+------------+-----------+
                               ebizzy
+----+----------+-----------+-----------+------------+-----------+
         base        stdev       patched   stdev        %improvement
+----+---------+-----------+-----------+------------+-----------+
  0.5x  6925.3000    74.4342	  7317.0000    86.3018	   5.65607
  1.0x  2379.8000   405.3519	  3427.0000   574.8789	  44.00370
  1.5x  1850.8333    97.8114	  2733.4167   459.8016	  47.68573
  2.0x  1477.6250   105.2411	  2525.2500    97.5921	  70.89925
+-----------+-----------+-----------+------------+-----------+
+-----------+-----------+-----------+------------+-----------+
                               dbench
+----+----------+-----------+-----------+------------+-----------+
         base        stdev       patched   stdev        %improvement
+----+---------+-----------+-----------+------------+-----------+
  0.5x 9045.9950   463.1447	 16482.7200    57.6017	  82.21014
  1.0x 6251.1680   543.8219	 11212.7600   380.7542	  79.37064
  1.5x 3095.7475   231.1567	  4308.8583   266.5873	  39.18636
  2.0x 1219.1200    75.4294	  1979.6750   134.6934	  62.38557
+-----------+-----------+-----------+------------+-----------+

patched = pvspinv10_hton_nople
+-----------+-----------+-----------+------------+-----------+
                               ebizzy
+----+----------+-----------+-----------+------------+-----------+
         base        stdev       patched   stdev        %improvement
+----+---------+-----------+-----------+------------+-----------+
  0.5x 6925.3000    74.4342	  7473.8000   224.6344	   7.92023
  1.0x 2379.8000   405.3519	  6176.2000   417.1133	 159.52601
  1.5x 1850.8333    97.8114	  2214.1667   515.6875	  19.63080
  2.0x 1477.6250   105.2411	   758.0000   108.8131	 -48.70146
+-----------+-----------+-----------+------------+-----------+
+-----------+-----------+-----------+------------+-----------+
                               dbench
+----+----------+-----------+-----------+------------+-----------+
         base        stdev       patched   stdev        %improvement
+----+---------+-----------+-----------+------------+-----------+
  0.5x 9045.9950   463.1447	 15195.5000   711.8794	  67.98042
  1.0x 6251.1680   543.8219	 11327.8800   404.7115	  81.21222
  1.5x 3095.7475   231.1567	  4960.2722  3822.6534	  60.22858
  2.0x 1219.1200    75.4294	  1982.2828  1016.4083	  62.59948
+----+-----------+-----------+-----------+------------+-----------+

