Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460AbaJNTTg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 15:19:36 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:33959 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755122AbaJNTTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 15:19:34 -0400
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
To: Prarit Bhargava <prarit@redhat.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
CC: Saravana Kannan <skannan@codeaurora.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        =?utf-8?B?Um9iZXJ0IFNjaMO2bmU=?= <robert.schoene@tu-dresden.de>
Subject: RE: Locking issues with cpufreq and sysfs
Thread-Topic: Locking issues with cpufreq and sysfs
Thread-Index: AQHP534B8BshIiy1I0ya4B2pOpV0SJwv6TEAgAAMgbA=
Date: Tue, 14 Oct 2014 19:18:25 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958CF2E38@G4W3202.americas.hpqcorp.net>
References: <543BCF9A.1060603@redhat.com>
 <CAKohpokBpQ9zhSU3bJQ9pVv68s6cFg8TNsqi+sJK8V1OQUTWzA@mail.gmail.com>
 <543D6A5C.1060809@redhat.com>
In-Reply-To: <543D6A5C.1060809@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.37]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9EJJfoZ026605



> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Prarit Bhargava
> Sent: Tuesday, 14 October, 2014 1:24 PM
> To: Viresh Kumar
> Cc: Saravana Kannan; Rafael J. Wysocki; linux-pm@vger.kernel.org; Linux
> Kernel; Robert SchÃ¶ne
> Subject: Re: Locking issues with cpufreq and sysfs
> 
> On 10/14/2014 03:10 AM, Viresh Kumar wrote:
> > On 13 October 2014 18:41, Prarit Bhargava <prarit@redhat.com> wrote:
> >>
> >> The locking is insufficient here, Viresh.  I no longer believe that fixes
> >> to this locking scheme are the right way to move forward here.  I'm
> wondering
> >> if we can look at other alternatives such as maintaining a refcount or
> >> perhaps using a queuing mechanism for governor and policy related changes.
> >>
...
> So I'm proposing that we move to a single threaded read/write using, if
> possible, a single policy lock for now.  We might transition this back to a
> rwsem later on, however, for the first attempt at cleaning this up I think we
> should just stick with a simple lock.  In doing that, IMO we remove
> cpufreq_rwsem: protects the driver from being unloaded
> cpufreq_governor_lock: protects the current governor
> each policy has a rwsem (policy->rwsem): protects the cpufreq_policy struct
> 
> and potentially
> cpufreq_driver_lock: protects the cpufreq_cpu_data array and cpufreq_driver-
> >boost
> 
> After looking at the way the code would be structured, I'm wondering if
> cpufreq_governor_mutex: protects the cpufreq_governor_list
> is overkill.  The loading of a module should be atomic relative to the
> cpufreq code, so this lock may not be required.  (Admittedly I haven't
> tested that...)
> 
> That would leave:
> global_kobj_lock: protects the "cpufreq" kobject
> each policy has a transition_lock (policy->transition): synchronizes
>                                                         frequency transitions
> and a new lock, perhaps called policy->lock, to serialize all events.
> 

Please keep performance in mind too.  cpufreq_governor_lock
contention is a bit of an issue with heavy IO workloads
as described in:
	http://marc.info/?l=linux-pm&m=140924051503827&w=2


---
Rob Elliott    HP Server Storage



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
