Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040AbbAGFi3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 00:38:29 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:47251 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbbAGFi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 00:38:28 -0500
Message-ID: <54ACC64F.6030304@redhat.com>
Date: Wed, 07 Jan 2015 06:38:23 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, Gleb Natapov <gleb@kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [RFC 2/2] x86, vdso, pvclock: Simplify and speed up the vdso
 pvclock reader
References: <cover.1419295081.git.luto@amacapital.net> <8d09c16eb39cbe264417cc66c4aca730af10b70b.1419295081.git.luto@amacapital.net> <20150105152511.GA9172@amt.cnet> <CALCETrXRs4NmhMvp+7kydrfyGCiNymkTe_sP6HFVvhMCC2Ei0Q@mail.gmail.com> <20150105191756.GA31201@amt.cnet> <CALCETrVWmbcv1w5a3N1VzyWEobP0qW+RQkhWO9yOkxzdKdJgeg@mail.gmail.com> <20150105224858.GA6846@amt.cnet> <54AB9FFD.6070309@redhat.com> <54ABCE85.6070004@redhat.com> <CALCETrWKgB7nj19zW_cQaa4RWjDojbN92_3+-27bHXbB-EEOnA@mail.gmail.com>
In-Reply-To: <CALCETrWKgB7nj19zW_cQaa4RWjDojbN92_3+-27bHXbB-EEOnA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/01/2015 17:56, Andy Lutomirski wrote:
> Still no good.  We can migrate a bunch of times so we see the same CPU
> all three times

There are no three times.  The CPU you see here:

>> 
>> 
>>     // ... compute nanoseconds from pvti and tsc ...
>>     rmb();
>> }   while(v != pvti->version);

is the same you read here:

>>         cpu = get_cpu();

The algorithm is:

1) get a consistent (cpu, version, tsc)

   1.a) get cpu
   1.b) get pvti[cpu]->version, ignoring low bit
   1.c) get (tsc, cpu)
   1.d) if cpu from 1.a and 1.c do not match, loop
   1.e) if pvti[cpu] was being updated, we'll loop later

2) compute nanoseconds from pvti[cpu] and tsc

3) if pvti[cpu] changed under our feet during (2), i.e. version doesn't
match, retry.

As long as the CPU is consistent between get_cpu() and rdtscp(), there
is no problem with migration, because pvti is always accessed for that
one CPU.  If there were any problem, it would be caught by the version
check.  Writing it down with two nested do...whiles makes it clearer IMHO.

> and *still* don't get a consistent read, unless we
> play nasty games with lots of version checks (I have a patch for that,
> but I don't like it very much).  The patch is here:
> 
> https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/commit/?h=x86/vdso_paranoia&id=a69754dc5ff33f5187162b5338854ad23dd7be8d
> 
> but I don't like it.
> 
> Thus far, I've been told unambiguously that a guest can't observe pvti
> while it's being written, and I think you're now telling me that this
> isn't true and that a guest *can* observe pvti while it's being
> written while the low bit of the version field is not set.  If so,
> this is rather strongly incompatible with the spec in the KVM docs.

Where am I saying that?

Paolo
