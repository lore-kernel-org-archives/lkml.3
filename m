Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116AbbAPQHW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 11:07:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58413 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516AbbAPQHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 11:07:21 -0500
Message-ID: <54B93726.4050309@redhat.com>
Date: Fri, 16 Jan 2015 11:07:02 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Suresh Siddha <sbsiddha@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@redhat.com, hpa@zytor.com, matt.fleming@intel.com, bp@suse.de,
        pbonzini@redhat.com, tglx@linutronix.de, luto@amacapital.net
Subject: Re: [PATCH 2/3] x86, fpu: don't abuse ->has_fpu in __kernel_fpu_{begin,end}()
References: <1421012793-30106-1-git-send-email-riel@redhat.com> <20150115191918.GA27332@redhat.com> <20150115192005.GC27332@redhat.com> <54B876FD.3060702@redhat.com> <20150116155445.GA7249@redhat.com>
In-Reply-To: <20150116155445.GA7249@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 01/16/2015 10:54 AM, Oleg Nesterov wrote:
> On 01/15, Rik van Riel wrote:
>> 
>> -----BEGIN PGP SIGNED MESSAGE----- Hash: SHA1
>> 
>> On 01/15/2015 02:20 PM, Oleg Nesterov wrote:
>>> b/arch/x86/kernel/i387.c @@ -81,9 +81,7 @@ void 
>>> __kernel_fpu_begin(void) this_cpu_write(in_kernel_fpu, true);
>>> 
>>> if (__thread_has_fpu(me)) { -		__thread_clear_has_fpu(me);
>> 
>> I will put that line back in the patch series that defers the 
>> loading of FPU state until the switch to user space,
> 
> I think this needs more discussion.
> 
> Firstly, __thread_clear_has_fpu() should go into
> __kernel_fpu_end(), it should replace restore_fpu_checking().
> 
> But does your series actually need this change? Correctness-wise
> this is not needed (afaics). Performance-wise I am not sure,
> kernel_fpu_begin() is unlikely event. Plus I am not sure this is a
> win (in general), but I can be easily wrong.

__kernel_fpu_begin() / __kernel_fpu_end() are used all the time
when running KVM guests. The KVM VCPU thread has both a user space
and a guest VCPU state. Generally the VCPU thread stays in the kernel,
and rarely (if ever) exits to user space.

>> but I guess we can go either way for now...
> 
> Yes, this should not really conflict with your changes in any
> case.
> 
> Given that you acked 1/3 and 3/3, perhaps you can ack this one as
> well?

Sure, we can figure out the cleanest thing to do for KVM later on.
Lets get these cleanups merged first.

Acked-by: Rik van Riel <riel@redhat.com>

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEbBAEBAgAGBQJUuTcmAAoJEM553pKExN6DJJMH+IjE3w+9UJ29AgE5Nw11qG86
5CgsxQ9T2CuzysW3a3HxRssjjPRtYeU1acDlQ0QMl6SKRw73wgy1kcZ22qEN1hSF
jKxSmkOgMWtUejJTRVKwHuKwG53BMiT/ZfSy8sIDtKOJ6HWZrHFCtvacGQ/tIjDF
gtfmUzZ2tfiJaYXYhdUlYDssKbI1lh/BMp3Y7vW6h5doDJL/KIKALlGWlI1Arsjl
Ns3SCvcztw8ojJnHK9tuK6ngAz9fkVJtef6+r59ITdcO1++lE8a73xLwg+FUDj4v
wlHz2gkYDjuLCNrahnplJHIuTV6LXR1FWiAFh6MElt7qejSUmcSxKudwhncdIw==
=GbZ2
-----END PGP SIGNATURE-----
