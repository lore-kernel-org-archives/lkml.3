Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353Ab3IKUuH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 16:50:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55838 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757267Ab3IKUuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 16:50:05 -0400
Message-ID: <5230D649.3090608@zytor.com>
Date: Wed, 11 Sep 2013 13:44:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, Andy Lutomirski <luto@amacapital.net>,
        Jeff Garzik <jgarzik@pobox.com>, David Safford <safford@us.ibm.com>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        Ashley Lai <ashley@ashleylai.com>, Rajiv Andrade <mail@srajiv.net>,
        Marcel Selhorst <tpmdd@selhorst.net>, Sirrix AG <tpmdd@sirrix.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kent Yoder <key@linux.vnet.ibm.com>,
        David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>,
        "Johnston, DJ" <dj.johnston@intel.com>
Subject: Re: TPMs and random numbers
References: <1378920168.26698.64.camel@localhost> <CALCETrVgiJuw9vj+BhchgzAH06gqEO4TYJyt8wd+2CCy33RQ3Q@mail.gmail.com> <20130911184509.GB13397@thunk.org> <CAFtxgO7XKbNn1-VW6Ha9P9wj7VAHw6Upar9udgy6dMrFNAHU0Q@mail.gmail.com> <CALCETrX0hN5hfW0rAsJ-uAKyV5eVSdhntT0TOVumLm2CDyLLBQ@mail.gmail.com> <41ba2dff-12ed-4127-acbd-ae5b40e38afd@email.android.com> <20130911202831.GC13397@thunk.org>
In-Reply-To: <20130911202831.GC13397@thunk.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2013 01:28 PM, Theodore Ts'o wrote:
> On Wed, Sep 11, 2013 at 12:25:48PM -0700, H. Peter Anvin wrote:
>> This of course has been a long-running debate.  Similarly, we could
>> make much better use of RDRAND if instead of doing data reduction in
>> rngd we could feed it to the pool and just credit fractional bits.
>> The FIPS tests that rngd runs are weak and obsoleted, but perhaps
>> better than nothing (now when we don't shut down rngd due to false
>> positives.)
> 
> /dev/urandom is using RDRAND already, and that's what most of the
> applications which are generating ssh host keys, session keys, etc.,
> are using.
> 
> /dev/random is using RDRAND as well, but we're not giving any entropy
> credit, so it will take longer to get the necessary randomness to
> generate a GPG key.
> 

We're using RDRAND in two ways: in the kernel, we're "washing" the pool
output with it (with the notion that we'll always get the best of both
worlds) -- we don't give any entropy credit for that.

We are also using RDRAND with the architecturally required 512:1 data
reduction in rngd, to produce "creditable entropy".  This is in part
because rngd doesn't really have a way to deal with fractional entropy,
in the light of FIPS tests and all (which don't make sense anyway for
postconditioned output, from RDRAND, TPM or any other similar source.)

One could thus posit that it would make more sense for that type of
source to feed the kernel entropy pools directly from a kernel thread
rather than taking a trip to user space.  In the case of RDRAND
specifically, a kernel thread or similar could feed RDRAND to the pools
and credit 1/512 of the data volume as entropy.  Since the factor of 512
is an architectural lower bound (and *very* conservative) it would be
better to let the pool system do the data reduction than doing it in
userspace.

Now, I'm pretty sure that some cryptographers are very unhappy about the
fact that we use a linear operation to do the pool insertion mixing.  I
personally am not qualified to say to what extent that is an actual problem.

	-hpa

