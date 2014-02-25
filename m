Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873AbaBYCbE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 21:31:04 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:37274 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbaBYCbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 21:31:02 -0500
MIME-Version: 1.0
In-Reply-To: <20140224161315.GI816@phenom.dumpdata.com>
References: <20140219071605.GA25092@falcon.amazon.com> <20140219174153.GH11365@phenom.dumpdata.com>
 <CAKbGBLjYWggnVeggj-d3-jTUqgFFwWyiih4VNM5yyuakd6yamg@mail.gmail.com>
 <CAKbGBLhm2krqjn98p1QGGPq=oNMpKNXUOKYZ9D9GRYLfEHCm-A@mail.gmail.com>
 <20140221200725.GA19733@phenom.dumpdata.com> <CAKbGBLjYQmty-YY+exiQ0wb-5==gMBY6qAz4a6tTvxSirJYEpQ@mail.gmail.com>
 <20140224161315.GI816@phenom.dumpdata.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Mon, 24 Feb 2014 21:30:41 -0500
X-Google-Sender-Auth: QDGo1F60t53ricNLxS1q7HRrISM
Message-ID: <CAHGf_=oEPYzemw1-n4BxVhBTtFkTukOm=gfuuMf8p5nZF_5b4g@mail.gmail.com>
Subject: Re: Is: 'mm: __set_page_dirty_nobuffers() uses spin_lock_irqsave()
 instead of spin_lock_irq()' fixed it.Was:Re: [BISECTED] Xen HVM guest hangs
 since 3.12-rc5
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Steven Noonan <steven@uplinklabs.net>, Mel Gorman <mgorman@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 11:13 AM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> On Sat, Feb 22, 2014 at 11:53:31PM -0800, Steven Noonan wrote:
>> On Fri, Feb 21, 2014 at 12:07 PM, Konrad Rzeszutek Wilk
>> <konrad.wilk@oracle.com> wrote:
>> > On Thu, Feb 20, 2014 at 12:44:15PM -0800, Steven Noonan wrote:
>> >> On Wed, Feb 19, 2014 at 1:01 PM, Steven Noonan <steven@uplinklabs.net> wrote:
>> >> > On Wed, Feb 19, 2014 at 9:41 AM, Konrad Rzeszutek Wilk
>> >> > <konrad.wilk@oracle.com> wrote:
>> >> >> On Tue, Feb 18, 2014 at 11:16:05PM -0800, Steven Noonan wrote:
>> >> >>> I've been running into problems on an Xen HVM domU. I've got a guest with NUMA
>> >> >>> enabled, 60GB of RAM, and 3 disks attached (including root volume). 2 of the
>> >> >>> disks are in an MD RAID0 in the guest, with an ext4 filesystem on top of that.
>> >> >>> I was running the fio 'iometer-file-access-server.fio' example config against
>> >> >>> that fs. During this workload, it would eventually cause a soft lockup, like
>> >> >>> the below:
>> >> >>
>> >> >> I presume since you mention NUMA and Mel is CC-ed that if you boot without
>> >> >> NUMA enabled (either via the toolstack or via Linux command line) - the issue
>> >> >> is not present?
>> >> >
>> >> > I mentioned NUMA because the bisected commit is sched/numa, and the
>> >> > guest is NUMA-enabled. I hadn't attempted booting with NUMA off. I
>> >> > just tried with numa=off, and the workload has run in a loop for 20
>> >> > minutes so far with no issues (normally the issue would repro in less
>> >> > than 5).
>> >>
>> >> The subject line is actually incorrect -- I did a 'git describe' on
>> >> the result of the bisection when writing the subject line, but the
>> >> '3.12-rc5' tag was just the base on which the code was originally
>> >> developed. As far as what tags actually contain the commit:
>> >>
>> >> $ git tag --contains b795854b1fa70f6aee923ae5df74ff7afeaddcaa
>> >> v3.13
>> >> v3.13-rc1
>> >> v3.13-rc2
>> >> v3.13-rc3
>> >> v3.13-rc4
>> >> v3.13-rc5
>> >> v3.13-rc6
>> >> v3.13-rc7
>> >> v3.13-rc8
>> >> v3.13.1
>> >> v3.13.2
>> >> v3.13.3
>> >> v3.14-rc1
>> >> v3.14-rc2
>> >>
>> >> So it's more accurate to say it was introduced in the v3.13 merge window.
>> >>
>> >> In any case, does anyone have any ideas?
>> >
>> > There is nothing in that git commit that gives that 'AHA' feeling.
>> >
>> > If you revert that patch on top of the latest Linux kernel does the problem
>> > go away? This is more of a double-check to see if the commit
>> > is really the fault or if it exposed some latent issue.
>>
>> I just tried out 3.13.5 and the problem went away. Looking through the
>> commit logs, it appears this commit (added as part of 3.13.4) resolved
>> the issue:
>
> Excellent! Problem solved :-)

Thanks. I don't wonder this result because it fixed very fundamental
mistake. :-)
