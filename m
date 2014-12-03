Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666AbaLCUhp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 15:37:45 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:65502 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbaLCUhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 15:37:42 -0500
Date: Wed, 3 Dec 2014 15:37:39 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Robert Jarzmik <robert.jarzmik@free.fr>
cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] optimize ktime_divns for constant divisors
In-Reply-To: <87zjb4zdyc.fsf@free.fr>
Message-ID: <alpine.LFD.2.11.1412031525320.470@knanqh.ubzr>
References: <alpine.LFD.2.11.1412031424150.470@knanqh.ubzr> <87zjb4zdyc.fsf@free.fr>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Dec 2014, Robert Jarzmik wrote:

> Nicolas Pitre <nicolas.pitre@linaro.org> writes:
> 
> > Let ktime_divns() use do_div() inline whenever the divisor is constant
> > and small enough.  This will make things like ktime_to_us() and 
> > ktime_to_ms() much faster.
> 
> Hi Nicolas,
> 
> I suppose the "small enough" is linked to the "!(div >> 32)" in your patch.  Can
> I have the rationale which brought up this value, and if that value is universal
> across architectures (ie. x86/ppc/arm/...) ?

Yes.  The do_div() function is defined to accept a 32-bit divisor only.  
The out-of-line ktime_divns code does scale down both the dividend and 
the divisor until the divisor is within 32 bits of magnitude before 
calling do_div().  However the constness of the divisor is lost and the 
optimised do_div (on ARM at least) doesn't get involved.

> And when you say "much faster", do you have figures to add to your commit
> message ?

No actual figure.  But a wild guess would be around an order of 
magnitude.  See commit fa4adc6149 for an example of generated code.


Nicolas
