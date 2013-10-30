Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687Ab3J3Obg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 10:31:36 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:52461 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899Ab3J3Obe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 10:31:34 -0400
Message-ID: <52711842.8080402@gmail.com>
Date: Wed, 30 Oct 2013 08:31:30 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>,
        yoshihiro.yunomae.ez@hitachi.com
Subject: Re: RFC: paravirtualizing perf_clock
References: <526DBD7F.1010807@gmail.com> <20131028131556.GN19466@laptop.lan> <526F2440.9030607@gmail.com> <20131030142013.GH4651@redhat.com>
In-Reply-To: <20131030142013.GH4651@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/13 8:20 AM, Gleb Natapov wrote:
> So can you explain a little bit more about how this will work? You run
> perf on a host and get both host and guest events? How do you pass
> events from guest to host in this case?

The intent is to allow data capture to occur in both contexts (host and 
guest) completely independently (e.g., record events in the guest to a 
file and in the host to a separate file). The files are then made 
available to a single post processing command (e.g., copy off box to an 
analysis server or copy guest file to host or vice versa).

 From there perf needs some tweaks to read 2 different data files and 
sort. From an address to symbol perspective, perf already has the notion 
of independent machines -- work that was done for perf-kvm. There has 
already been a lot of discussion on writing perf events to mmap-specific 
files which are then merged at analysis time (versus today where all 
mmap's are scanned and dumped to the same file). This use case is not 
much of an extension beyond those two concepts.

Right now, as a proof of concept, I am dumping events in the guest to a 
file (perf-script) and in the host to a file, merging the two files 
together and then time sorting. For example running, 'ls' in the guest 
causes disk I/O which causes a VMEXIT, .... you can see this action end 
to end.

>
>> And then for the cherry on top a design that works across
>> architectures (e.g., x86 now, but arm later).
>>
> MSR is x86 thing.

Sure the implementation of pv_perf_clock for x86 is an MSR read (open to 
suggestions on other options). ARM would have some other means of a fast 
access to host, no?

David
