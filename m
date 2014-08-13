Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408AbaHMUGd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 16:06:33 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:52332 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbaHMUGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 16:06:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: ksummit-discuss@lists.linuxfoundation.org
Cc: Ben Hutchings <ben@decadent.org.uk>, John Stultz <john.stultz@linaro.org>,
        "Joseph S. Myers" <joseph@codesourcery.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-discuss] 2038 Kernel Summit Discussion Fodder
Date: Wed, 13 Aug 2014 22:06:19 +0200
Message-ID: <3758173.O0N9ZgmMoN@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-23-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1407895613.3017.138.camel@deadeye.wl.decadent.org.uk>
References: <CALAqxLUcfaJnxdmkn6mucepNk3QaCQdcSPLRjjeKsk_OTp=uLA@mail.gmail.com> <1407895613.3017.138.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:QNZ9n0IHiy/nUfbfOsgfc94Ha0ScJEJyKTEd/gsUeGx
 fGaBZfq+h09LvwJfjTZCxDFnVsu5Rg/Oz4sAPWIbvLMXJY5PRd
 mTMXQyDuhrBmGfNbXbjrtkdYKoWSRsqNQhLjmRRVzxiSRwyIQx
 7jZkbcOkwZPC/wftw64pf2XZCMkVb3VhYkmAgQEaeuBOGb1m9+
 HCo9dTfBZrIJ4XtFVRD11lSqODLtJ/KylEX8UH8LrwfWWlmuhc
 76aR/3UbN8bd7LhkkZkIigEgCoPI+IBWANaJUH2vQS5BDPvsdR
 PBehW89PwHexofk8pYshAswBfs0paUnmFDQpLYZuhTUz1k5Bv/
 g2DVy4/5aIbRTOxFkymE=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 August 2014 03:06:53 Ben Hutchings wrote:
> > On the kernel side, it also adds more complexity, where we have to add
> > even more complex compat support for 64bit systems to handle all the
> > various 32bit applications possible.
> [...]
> 
> Didn't we need to do this already to support x32?  Have compat ioctls
> involving time been botched?

AFAICT, every ioctl that involves passing a __kernel_ulong_t or
__kernel_ulong_t is potentially broken on x32, and this includes
everything passing a time_t or timespec.

The problem is that the libc ioctl() function ends up in the kernel's
compat_ioctl handler, which expects the 32-bit ABI, not the 64-bit ABI.
Most other syscalls in x32 however use the 64-bit ABI.

It works only for drivers that use the same function for .ioctl and
.compat_ioctl, and that encode the size of the data structure correctly
in the ioctl command code. I assume this is how we will do it for all
32-bit architectures with 64-bit time_t, but on x32 it also concerns
other types that use __kernel_long_t.

	Arnd
