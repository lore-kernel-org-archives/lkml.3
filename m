Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871Ab3JIPIT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 11:08:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53536 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462Ab3JIPIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 11:08:17 -0400
Message-ID: <52557137.5050200@zytor.com>
Date: Wed, 09 Oct 2013 08:07:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Stanimir Varbanov <svarbanov@mm-sol.com>
CC: "Theodore Ts'o" <tytso@mit.edu>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 0/2] Add support for Qualcomm's PRNG
References: <1380811955-18085-1-git-send-email-svarbanov@mm-sol.com> <20131003165130.GA11974@thunk.org> <524EEB96.6040707@mm-sol.com> <20131004181005.GA7022@thunk.org> <52556C4E.9000604@mm-sol.com>
In-Reply-To: <52556C4E.9000604@mm-sol.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2013 07:46 AM, Stanimir Varbanov wrote:
> 
> No, there is no public documentation for the block. Here is the driver
> documentation which I used as a base [1].
> 
> My guess was that - if it is PRNG (got from hardware description link
> above) than according to wiki [2] it is also known as a deterministic
> random bit generator (DRBG). The recommendation for RNG using DRBG is
> NIST 800-90.
> 
> Of course I could be wrong, so I can add a comment that this is just a
> guess and we shouldn't over-reliance on this.
> 

There needs to be an architecturally guaranteed lower bound on the
entropic content for this to be at all useful.  However, the hwrandom
interface is currently expecting fully entropic output (which is almost
certainly bogus... consider the PowerPC random number generator[1]) and
so using it for a PRNG output is directly wrong.  This is part of why
RDRAND support is implemented directly in rngd so that we can do the
required cryptographic data reduction to produce fully entropic output.

	-hpa



[1] which has a known first-order bias which they "correct" for by
XORing two datums together in a very simple data reduction step.
However, if their random source has bias it is extremely likely it also
has nonzero correlations, which require stronger reductions.  It would
make a lot more sense to feed this data into the random pools but
derated at a lower entropy level.  This would be useful for RDRAND as well.


