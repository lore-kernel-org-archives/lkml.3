Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751194AbbARSP5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 13:15:57 -0500
Received: from mail.eperm.de ([89.247.134.16]:59526 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776AbbARSPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 13:15:54 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Tadeusz Struk <tadeusz.struk@intel.com>
Cc: aidan.o.mahony@intel.com, gabriele.paoloni@intel.com,
        adrian.hoban@intel.com, linux-crypto@vger.kernel.org,
        herbert@gondor.apana.org.au, "'LKML'" <linux-kernel@vger.kernel.org>
Subject: Re: Intel GCM: __driver-gcm-aes-aesni setkey missing
Date: Sun, 18 Jan 2015 19:15:47 +0100
Message-ID: <2105300.1I7Yf8LP5t@tachyon.chronox.de>
User-Agent: KMail/4.14.3 (Linux/3.17.8-300.fc21.x86_64; KDE/4.14.3; x86_64; ; )
In-Reply-To: <54BB0E42.9070209@intel.com>
References: <1976848.LqsUs5V3zD@tachyon.chronox.de> <54BB0E42.9070209@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 17. Januar 2015, 17:37:06 schrieb Tadeusz Struk:

Hi Tadeusz,

> Hi Stephan,
> 
> On 01/17/2015 10:23 AM, Stephan Mueller wrote:
> > during testing of my algif_aead patch with the different GCM
> > implementations I am able to trigger a kernel crash from user space using
> > __driver-gcm-aes- aesni.
> > 
> > As I hope that algif_aead is going to be included, unprivileged userspace
> > would then reliably crash the kernel -- with the current kernel code,
> > userspace has no interface to trigger the issue.
> 
> Yes, that's a problem.
> 
> > As I am not sure what the purpose of __driver-gcm-aes-aesni is (only a
> > backend for RFC4106 GCM or a regular cipher), I did not yet create a
> > patch. IMHO there are two solutions:
> > 
> > - either create a valid setkey callback so that a key is set
> > 
> > - or create a noop setkey that returns -EOPNOTSUPP which effectively
> > disables that cipher for regular consumption.
> 
> __driver-gcm-aes-aesni is only a helper for rfc4106-gcm-aesni and it
> never supposed to be used on it's own. I think implementing a setkey
> function that only returns an error would be a good solution for this.

Ok, I will send a patch shortly.

> Another question is what if someone will ignore the error or skip the
> setsockopt(ALG_SET_KEY) altogether and still call the sendmsg() and
> read() to trigger encrypt()?

Using my libkcapi [1] test bench, I disabled key and IV submission for 
symmetric ciphers (tested cbc(aes) which invokes your AESNI code path on my 
box -- and gcm(aes) and ccm(aes) which again both use the AESNI core and the C 
implementation of GCM and CCM).

All tests with missing keys and IVs:

- showed a successful encryption / decryption with the CBC mode

- returned the error code of either ENOKEY or EINVAL for GCM / CCM 
encryption/decryption

There is no crash/BUG/WARN observed.

> 
> > Note, if it is only a backend for the RFC4106 implementation, may I ask
> > why
> > __driver-gcm-aes-aesni is implemented as a separate cipher that is
> > registered with the kernel crypto API?
> 
> This is because we need to have one instance of the helper tfm with its
> context per each of the rfc4106-gcm-aesni tfm instance and that was one
> convenient way to do this.

Then I concur with you that having a setkey function returning an error is the 
right way.
> 
> Tadeusz
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Ciao
Stephan
