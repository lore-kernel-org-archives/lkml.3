Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751511AbaELDoG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 23:44:06 -0400
Received: from mga11.intel.com ([192.55.52.93]:56475 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbaELDoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 23:44:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1032,1389772800"; 
   d="scan'208";a="537442142"
Message-ID: <53704383.8060504@linux.intel.com>
Date: Sun, 11 May 2014 20:44:03 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Stephan Mueller <smueller@chronox.de>
CC: "Theodore Ts'o" <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Subject: Re: arch_random_refill
References: <21542339.0lFnPSyGRS@myon.chronox.de> <53703E74.9020700@linux.intel.com> <3260147.sUis3H5ONm@myon.chronox.de>
In-Reply-To: <3260147.sUis3H5ONm@myon.chronox.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2014 08:36 PM, Stephan Mueller wrote:
> 
> Ohh, ok, thanks for fixing that. :-) 
> 
> Though what makes me wonder is the following: why are some RNGs forced to use 
> the hw_random framework whereas some others are not? What is the driver for 
> that?
> 
> The current state of random.c vs. drivers/char/hw_random and the strong in-
> kernel separation between both makes me wonder. Isn't that all kind of 
> inconsistent?
> 

The main differences are speed of access, trivial interface, and
architectural guarantees.  You also don't have to deal with enumeration,
DMA engines, interrupts, indirect access, or bus drivers, which all are
utterly unacceptable on a synchronous path.

That being said, it is getting clear that we most likely would be better
off with the kernel directly feeding from at least a subset of the
hw_random drivers, rather than waiting for user space to come along and
launch a daemon... after $DEITY knows how many other processes have
already been launched.  There are patches being worked on to make that
happen, although there are a fair number of potential issues, including
the fact that some of the hw_random drivers are believed to be dodgy --
for example, the TPM driver: some TPMs are believed to not contain any
entropy element and simply rely on a factory-seeded nonvolatile counter
(since the TPM has to have support for nonvolatile counters anyway, this
hardware is already present.)

	-hpa



