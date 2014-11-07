Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685AbaKGLF5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 06:05:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47296 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278AbaKGLFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 06:05:52 -0500
Message-ID: <545CA765.8010403@redhat.com>
Date: Fri, 07 Nov 2014 06:05:09 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131028 Thunderbird/17.0.10
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Fabian Frederick <fabf@skynet.be>, isimatu.yasuaki@jp.fujitsu.com,
        jbaron@akamai.com, linux-doc@vger.kernel.org,
        kexec@lists.infradead.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v8] kernel, add panic_on_warn
References: <1415187736-16242-1-git-send-email-prarit@redhat.com> <alpine.DEB.2.10.1411051357050.31575@chino.kir.corp.google.com> <545B733C.6080903@redhat.com> <alpine.DEB.2.10.1411061352440.1526@chino.kir.corp.google.com> <20141106220731.GA13590@redhat.com> <alpine.DEB.2.10.1411070214220.32405@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.10.1411070214220.32405@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/07/2014 05:15 AM, David Rientjes wrote:
> On Thu, 6 Nov 2014, Vivek Goyal wrote:
> 
>> On Thu, Nov 06, 2014 at 01:57:36PM -0800, David Rientjes wrote:
>>
>> [..]
>>> You see that doing
>>>
>>> 	if (panic_on_warn) {
>>> 		panic_on_warn = 0;
>>> 		panic(...);
>>> 	}
>>>
>>> is racy, I hope.  If two threads WARN() at the same time, then there's 
>>> nothing preventing a double panic() because WARN() itself is not 
>>> serialized against anything.  So both the current comment and your 
>>> suggested revision comment are bogus.
>>
>> panic() is serialized on panic_lock. So I guess it is fine to hit WARN()
>> on multiple cpus. Do you see an issue there?
>>
> 
> No issue at all, what's completely mysterious is the panic_on_warn = 0 and 
> the completely bogus comment that says "prevent further WARN()s from 
> panicking the system" when that's racy.  There's no need to clear 
> panic_on_warn at all.

There very much is.  Consider a thread that hits a WARN() and then panics.  Then
somewhere in the panic code the thread hits another WARN() ... and then panics
again.  Previously this would have caused the system to "finish" panick'ing.
Now it makes the system hang.

P.
> 
