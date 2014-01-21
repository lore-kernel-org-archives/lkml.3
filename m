Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114AbaAUQQJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 11:16:09 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:10480 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087AbaAUQQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 11:16:07 -0500
Message-ID: <52DE9D43.1020305@hp.com>
Date: Tue, 21 Jan 2014 11:16:03 -0500
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: paulmck@linux.vnet.ibm.com, Linus Torvalds <torvalds@linux-foundation.org>,
        Matt Turner <mattst88@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Daniel J Blueman <daniel@numascale.com>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [PATCH v8 4/4] qrwlock: Use smp_store_release() in write_unlock()
References: <CA+55aFydYLQeBq=4AQQp_4dAnq09ocLmde1LFaXiNAJ=wJzfFA@mail.gmail.com> <20140116103659.GO7572@laptop.programming.kicks-ass.net> <20140118100105.GV10038@linux.vnet.ibm.com> <20140118113406.GY30183@twins.programming.kicks-ass.net> <20140118122548.GX10038@linux.vnet.ibm.com> <20140118124136.GZ30183@twins.programming.kicks-ass.net> <20140118212227.GA10038@linux.vnet.ibm.com> <CA+55aFww9F7DA2V611OjkDyf8nfBVFZkLCu1M243mcj7DKqekA@mail.gmail.com> <20140119080405.GB10038@linux.vnet.ibm.com> <52DE8BEE.4040303@hp.com> <20140121154113.GB31570@twins.programming.kicks-ass.net>
In-Reply-To: <20140121154113.GB31570@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2014 10:41 AM, Peter Zijlstra wrote:
> On Tue, Jan 21, 2014 at 10:02:06AM -0500, Waiman Long wrote:
>> My latest v9 series of qrwlock patch will automatically adapt to the lack of
>> atomic byte access by using an atomic integer instruction instead. So the
>> new series should work for pre-EV56 Alpha, it is just a bit less efficient
>> in this case.
> See my other email; I don't think you can do that without also changing
> the implementation of the queue_read_{try}lock() functions.
>
> Without those changes you can have transient values in your 'read-count'
> part of the word and a full word write will wreck things.

I don't see any problem with my current logic. If a writer has the write 
lock, the writer byte has to have a value of 0xff. So atomically 
subtracting 0xff from it will guarantee that the writer byte will become 
zero, which is the same as assigning a zero value to that byte. The only 
difference is that an atomic subtract instruction will need to be used 
instead of a simple byte assignment.

Please let me know if there is any flaw in my logic.

-Longman
