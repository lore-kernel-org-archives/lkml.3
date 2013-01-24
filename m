Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793Ab3AXAhQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 19:37:16 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:42159 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab3AXAhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 19:37:11 -0500
X-IronPort-AV: E=Sophos;i="4.84,525,1355126400"; 
   d="scan'208";a="21802371"
Message-ID: <51008234.8080702@codeaurora.org>
Date: Wed, 23 Jan 2013 16:37:08 -0800
From: Stepan Moskovchenko <stepanm@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        George Spelvin <linux@horizon.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Andrei Emeltchenko <andrei.emeltchenko@intel.com>, mingo@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] lib: vsprintf: Add %pa format specifier for phys_addr_t
 types
References: <1358833677-15611-1-git-send-email-stepanm@codeaurora.org>    <CAMuHMdWedqgvrSCfpmDFdM=ww-6+8v39sz+92CQaYHO4x5jNNQ@mail.gmail.com>    <1358914468.2107.26.camel@joe-AO722>
In-Reply-To: <1358914468.2107.26.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 2013-01-22 at 23:26 +0100, Geert Uytterhoeven wrote:
>> On Tue, Jan 22, 2013 at 6:47 AM, Stepan Moskovchenko
>> <stepanm@codeaurora.org> wrote:
>> > Add the %pa format specifier for printing a phys_addr_t
>> > type, since the physical address size on some platforms
>> > can vary based on build options, regardless of the native
>> > integer type.
>>
>> I'm not so sure it's a good idea to start using %p for integer types.
>
> It would also require that some automatic variables
> that could otherwise be used in registers be put on
> the stack.
>

When calling something like printk on a variable, is that really a big 
concern in the grand scheme of things? On a system with a 32-bit 
phys_addr_t type, how does the overhead of having to put the variable on 
the stack compare to the overhead needed to cast to an unsigned long 
long and emit the eight extra '0' characters when printing a formatted 
physical address? If allocation efficiency is a big concern for a 
particular code path, the caller is always free to continue to cast to 
unsigned long long and use %llu, if they don't mind extra padding where 
phys_addr_t is smaller than a long long. But considering this is 
primarily meant to be used by printk during initialization / debug / 
error handling paths, there will be plenty of other overhead involved in 
producing log output.

As far as type safety is concerned, the %p specifier is already willing 
to accept pointers to all sorts of things which it is powerless to 
check, and it is up to the caller to do the right thing.

Printing out a physical address is a pretty reasonable thing for a 
driver to do in an init or debug path. It is conceivable that the same 
driver may be used on a system with 32-bit ore >32-bit physical address 
types. With something like ARM LPAE, it is even possible for the same 
system to use 32-bit and >32-bit addressing based strictly on build 
options, while still using the same drivers, meaning that the drivers 
would need to deal with phys_addr_t being of variable size. It also 
seems like a potential bit of extra overhead is not worth the ugliness 
of casting each phys_addr_t to an unsigned long long and printing it as 
a 64-bit type regardless of the actual number of address bits available. 
If a driver is really concerned about efficiency of its init paths, it 
is free to continue using %llu, or better yet, cut down on the amount of 
log spam these paths generate.

Steve
