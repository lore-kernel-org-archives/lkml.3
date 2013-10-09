Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab3JIQYv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 12:24:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54861 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751737Ab3JIQYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 12:24:48 -0400
Message-ID: <52558320.9090603@zytor.com>
Date: Wed, 09 Oct 2013 09:24:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, Stanimir Varbanov <svarbanov@mm-sol.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 0/2] Add support for Qualcomm's PRNG
References: <1380811955-18085-1-git-send-email-svarbanov@mm-sol.com> <20131003165130.GA11974@thunk.org> <524EEB96.6040707@mm-sol.com> <20131004181005.GA7022@thunk.org> <52556C4E.9000604@mm-sol.com> <52557137.5050200@zytor.com> <20131009160338.GD1198@thunk.org>
In-Reply-To: <20131009160338.GD1198@thunk.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2013 09:03 AM, Theodore Ts'o wrote:
> On Wed, Oct 09, 2013 at 08:07:35AM -0700, H. Peter Anvin wrote:
>> There needs to be an architecturally guaranteed lower bound on the
>> entropic content for this to be at all useful.  However, the hwrandom
>> interface is currently expecting fully entropic output (which is almost
>> certainly bogus... consider the PowerPC random number generator[1]) and
>> so using it for a PRNG output is directly wrong.  
> 
> You can specify as a command-line argument (-H) to rngd the entropy
> per bit of input data.  So if you think an entropy source isn't great,
> but has some uncertainty, you could do pass to rngd "-H 0.5" or maybe
> even "-H 0.1".
> 
> Maybe it would be nice to have /dev/hwrandom export the quality of its
> output, but the reality is that most hardware devices don't document
> or export via some programmatic interface how well or how poorly their
> hwrng really might be.  And even if they did, most people, who don't
> have access to scanning electronic microscopes and nanometer probes,
> and the ability to decrypt, reverse engineer, and decompile firmware,
> couldn't know for sure whether or not to believe the claims of the
> hardware or the hardware manufacturer anyway.
> 

There is no -H option in upstream rngd.  It might be in the Debian fork,
but the Debian fork has serious other problems.  I don't understand how
that would work with the FIPS tests in rngd, unless of course the FIPS
tests are so weak they are pointless anyway (they are

/dev/hwrng should definitely export it rather than having to have the
*user* enter that data... the user has even less opportunity than the
vendor and driver maintainer to get this even remotely right, I fear.

It is really problematic when there isn't even anything to hang things
off, and perhaps a real question is if we even should have drivers for
devices where there isn't any kind of documentation given, or if we
should derate them substantially.

The RDRAND code in rngd already has cryptographic (AES) data reduction
and we might want to extend that code to be able to derate other data
sources.

Or we should just move this into a kernel thread and let the pool do that...

	-hpa

