Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbaEMSLZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 14:11:25 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:62684 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201AbaEMSLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 14:11:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ley Foon Tan <lftan@altera.com>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        lftan.linux@gmail.com, cltang@codesourcery.com
Subject: Re: [PATCH 00/25] Change time_t and clock_t to 64 bit
Date: Tue, 13 May 2014 20:10:31 +0200
Message-ID: <6202090.0OtAjefIFT@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140513174640.GA20961@infradead.org>
References: <1399971456-3941-1-git-send-email-lftan@altera.com> <alpine.DEB.2.02.1405131727480.6261@ionos.tec.linutronix.de> <20140513174640.GA20961@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:abvoJj1ZxMMvwbTRzQZCyNA0goziEuCQrpJjA2hBxpB
 W2iOUY0CGa/G5lj/UNPPCYsH/Hr8s8g6nJqaVyw2s+z8SFXTJX
 //DcbbzMNDM4/MmjkXooyfhGK2x3gRYKD48+VW/RYMS6ABw9Yd
 Ck7rpgIbndWehcz79pHayxoK5KWOZrTgYiOnxw5VZ6hc3HTaO9
 cZYJa2muOgGHjFfz7Fn3yQTs/eqc9tADLMfDGummrw0CmKnmUR
 CVOImFXpbXMO4oi0MlCPeGLP/viBCE8VoBcsavqcDMt5TrBhsB
 dPLrOJNNM2+zXyT3sApgRA3Kd+A/qjwhiF2NM13Z6cBR5rmUf8
 4UGOcP2m/yK8iaE8FQto=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 May 2014 10:46:40 Christoph Hellwig wrote:
> On Tue, May 13, 2014 at 05:33:01PM +0200, Thomas Gleixner wrote:
> > and it
> > would be dumb as hell to have new archs use time_t 32bit when we are
> > currently twisting our brain around how to solve the y2038
> > problem. Simply because we can not do the BSD flag day approach and
> > change it.
> 
> I don't think it's a good idea to have minor new architectures
> pointlessly different than the major ones.  Especially given that we'll
> absolutely have to fir the y2038 problem for 32-bit arm and probably
> x86 anyway.

I've just spent two days looking at stuff that uses time_t inside
of the kernel, to get a better idea of what we actually need to
do to get provide new user interfaces for the existing architectures.

My impression so far is that we're better off fixing it for the
existing architectures first and then using the new interfaces
exclusively on new ones, rather than changing over the ABI for
all new architectures at this point, which would likely create
yet another variant to maintain in the long run.

Using 64-bit time_t on x32 is fine, because it's fast to operate
in user space with 64-bit registers, and the kernel is 64-bit
anyway. Inside of the kernel, we may get into trouble using
a 64-bit time_t on 32-bit architectures because of the overhead
in 64-bit math, e.g. all the timekeeping code that is based on
timespec or some code paths in file systems and network code where
we actually require division of time_t values.
We clearly have to change that code in some for to deal with y2038,
but 64-bit time_t may not be the best option. A lot of the
in-kernel code can probably use ktime_t, which we can change
to a different representation (e.g. 34 bit seconds) if needed,
and all the code that is only interested in relative time
(e.g. nanosleep) doesn't have to change at all.

	Arnd
