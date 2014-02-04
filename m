Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbaBDQUR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 11:20:17 -0500
Received: from mail.eperm.de ([89.247.134.16]:51440 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753431AbaBDQUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 11:20:14 -0500
From: Stephan Mueller <smueller@chronox.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        Ralf Baechle <ralf@linux-mips.org>, dave.taht@gmail.com,
        John Crispin <blogic@openwrt.org>, andrewmcgr@gmail.com,
        Thorsten Glaser <tg@mirbsd.de>, sandyinchina@gmail.com
Subject: Re: [PATCH 2/5] CPU Jitter RNG: Enable compilation
Date: Tue, 04 Feb 2014 17:19:52 +0100
Message-ID: <3579180.ti4z33qfDe@tauon>
User-Agent: KMail/4.11.5 (Linux/3.12.7-300.fc20.x86_64; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAMuHMdUpgifUHOYbYLDiLfDdTQ74PBUjjEJWGopg3BwD+qWR6g@mail.gmail.com>
References: <2039634.jSmQAS6tdi@myon.chronox.de> <3180926.X9oRPa7ARL@myon.chronox.de> <CAMuHMdUpgifUHOYbYLDiLfDdTQ74PBUjjEJWGopg3BwD+qWR6g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 4. Februar 2014, 14:39:54 schrieb Geert Uytterhoeven:

Hi Geert,

>On Tue, Feb 4, 2014 at 1:40 PM, Stephan Mueller <smueller@chronox.de> 
wrote:
>> +CFLAGS_jitterentropy-base.o    = -O0
>
>Why? if really needed, this deserves a comment.

Sorry to have not explained all details in the email.

Please consider the following rationale found in the jitterentropy-
base.c, given for jent_fold_time:

 * The code is deliberately inefficient and shall stay that way. This 
function
 * is the root cause why the code shall be compiled without 
optimization. This
 * function not only acts as folding operation, but this function's 
execution
 * is used to measure the CPU execution time jitter. Any change to the 
loop in
 * this function implies that careful retesting must be done.

The idea of the RNG is to measure the execution timing of a set of 
instruction. The set of instructions that are measured as part of the 
execution timing jitter measurement is exactly the jent_fold_time 
function. When the compiler applies optimizations, one really does not 
know how this deliberately inefficient loop is made more efficient. When 
it is made more efficient by the compiler, it is unclear how much 
instructions are really executed. And the less instructions, the less 
timing variations the RNG gets, the less entropy the RNG picks up.

Please note that all testing that is executed shows that optimizations 
do not really matter. But there are some very old systems (AMD 
Semperons, very old Pentiums) who show timing variations which border to 
the lowest allowed variations when enabling optimizations. When 
disabling optimizations, all the expected timing variations are present. 
And for an RNG, it is always important to have "leeway" in the amount of 
entropy sampled from the raw noise, i.e. it is better to be too 
conservative and underestimate the entropy by a significant amount.

As the entire RNG is intended to be based on timing variations, I felt 
that the entire C file can be compiled without optimizations. In this 
case, even the post-processing of the data while collecting entropy even 
adds more entropy, albeit this impact was not subject to testing or 
analysis -- at least it will not diminish the measured timing 
variations.

Also, I consider the execution speed of the entropy collection is not 
really an issue because the RNG delivers random numbers at a 
comparatively high rate. Any other noise source feeding into random.c 
delivers data with far less speed.

For more details, please see [1] section 5.1 below the presented graphs.

[1] http://www.chronox.de/jent/doc/CPU-Jitter-NPTRNG.html

Ciao
Stephan
