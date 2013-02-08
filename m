Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947143Ab3BHWFE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 17:05:04 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:48728 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946953Ab3BHWFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 17:05:01 -0500
X-RZG-AUTH: :P2ERcEykfu11Y98lp/T7+hdri+uKZK8QS9ij0PRv0OgBX++PB3K3G/7rbhwz
X-RZG-CLASS-ID: mo00
Message-ID: <51157686.9000404@chronox.de>
Date: Fri, 08 Feb 2013 23:04:54 +0100
From: Stephan Mueller <smueller@chronox.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Ted Ts'o" <tytso@mit.edu>, linux-crypto@vger.kernel.org
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH] Entropy generator with 100 kB/s throughput
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi crypto hackers,

[1] patch at http://www.chronox.de/jitterentropy-0.1.tar.gz

The Linux kernel RNG which we all use via /dev/random or /dev/urandom
received a lot of merits over the long years it exists. In particular
it was subject to countless researches and assessments and was determined
to deliver appropriate entropy to the caller.

However, we all know that the RNG also has deficiencies, which makes
the appropriate use not entirely clear to everybody. In the past we heard
about weak keys in embedded systems and the like. It is not the RNG's fault,
but rather the problem of designers of such systems. Nonetheless, things
could be easier with the use of the Linux RNG . In particular I met the
following shortcomings over the years:

* /dev/random is regarded as high-quality RNG as it is constantly reseeded,
  but suffers from its blocking nature

* there is no in-kernel equivalent for /dev/random -- i.e. how can you
really
  seed the DRNG that is present in the kernel crypto API with high quality
  entropy?

* at boot time the data /dev/random or /dev/urandom spits out is
questionable
  which requires a reseed during reboot. Also, that seed file must first be
  written, which may not be trivial in all circumstances. For example, in
  embedded systems or live CDs, this may be a challenge. Or what about
system
  outages -- there is no clean shutdown and no new seed file.

* in virtual environments (i.e. the Linux kernel operates as guest),
  /dev/random does not have access to all the devices to collect entropy.

* when generating the key for full disk encryption configuration, there
may be
  limited entropy in the entropy pools

* random.c contains complex processing which enlarges the device event
  processing for every event

In the patch, I try to provide an entropy collector without these
shortcomings.
The patch offers an entropy generator based on CPU timing jitter. The
entropy
collector has the following properties:

* it does not maintain any state and therefore does not need any seed

* it delivers entropy on demand with a throughput of about 100 kB/s and does
  not block -- it performs a synchronous entropy generation for the caller

* it should work well in virtualized environments

* the heart of the entropy collector is about 10 lines of code and does not
  use cryptography

* an array of statistical test suites pass the output of the entropy
collector
  (again, the output is not mangled with cryptography)

The design and concepts are documented in source code comments.

The source code is available at [1]. The code can be compiled as kernel
module
as well as user space application. In case the code finds its way to the
kernel, the user space code will be removed -- currently it remains to ease
the analysis. To compile as kernel module, just run make. To compile as user
space application, run make -f Makefile.user. Note, the user space part
can also
be used in user space libraries to avoid /dev/random.

Is such entropy collector of interest for the kernel? Do you see weaknesses
in the design or its implementation?

In a recent discussion about the Linux RNG Theodore Ts'o indicated that
in the long run, he would like to see an RNG based on AES
(see http://lkml.org/lkml/2012/12/15/162).

In addition to the entropy collector, the kernel module also includes a link
to the kernel crypto API X9.31 DRNG based on AES. Two instances of the DRNG
are maintained. The first instance is reseeded once in a while (after
1024 bytes
of random data) with the CPU jitter entropy. The second is reseeded with 16
bytes of entropy when 16 bytes are read from the DRNG. The first DRNG
therefore
is a fast delivering DRNG which is information theoretical weaker than the
second DRNG (which is much slower, but the information theoretical entropy
equals about 1 bit per 1 bit of output).

For testing purposes, debugfs interface files are implemented to read from
the entropy collector and the two DRNGs. The test mode is triggered with the
parameter "insmod jitterentropy.ko testmode=1". The interface files are
/sys/kernel/debug/jitterentropy/[seed|drng|strong-drng].

Detailed design description is given as comments in the source code file.

Thanks
Stephan

