Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277AbbAEVzE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 16:55:04 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:61308 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905AbbAEVzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 16:55:02 -0500
MIME-Version: 1.0
In-Reply-To: <CA+8MBbKbuyYWKK_wK1pwX_T39dKmukBom+i7H5dndfjhDJahbQ@mail.gmail.com>
References: <20141124205441.GW5050@linux.vnet.ibm.com> <CALCETrXBofV3oxDwK4MiSvFQcX3yxX_sL_KY63EZ8DgS8LnJSg@mail.gmail.com>
 <20141124213501.GX5050@linux.vnet.ibm.com> <20141124223407.GB8512@linux.vnet.ibm.com>
 <CALCETrUA+z5z6bnOw63-EUiFD4WQtBXm1TE2DSRj3uG+d_k-bQ@mail.gmail.com>
 <20141124225754.GY5050@linux.vnet.ibm.com> <20141124233101.GA2819@linux.vnet.ibm.com>
 <CALCETrV37kqC658AzBHZ5z_vH2b_1T821q5EfbMcS9Ecpj8EEw@mail.gmail.com>
 <20141124235058.GZ5050@linux.vnet.ibm.com> <CALCETrUFwyBYFWZi4JC1-HftmUumLr+bB1kh8EW6LViN+G+j+g@mail.gmail.com>
 <20141125185803.GC3938@pd.tnic> <CA+8MBb+iw3KJz5EgX-DLBHGWANUSVFP2bQe2_U4kqCfM-wzH8Q@mail.gmail.com>
 <CALCETrWFBEvL4CSD+cZ0inMcvv09rLJi4Wpf4gLz5fvsGcV-wQ@mail.gmail.com> <CA+8MBbKbuyYWKK_wK1pwX_T39dKmukBom+i7H5dndfjhDJahbQ@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 5 Jan 2015 13:54:40 -0800
Message-ID: <CALCETrV6=aWoAckieQkPJ4BCr9VzU=9080EmLfeL4ZWm+Hr55g@mail.gmail.com>
Subject: Re: [PATCH v4 2/5] x86, traps: Track entry into and exit from IST context
To: Tony Luck <tony.luck@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>, Paul McKenney <paulmck@linux.vnet.ibm.com>,
        X86 ML <x86@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Josh Triplett <josh@joshtriplett.org>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 5, 2015 at 1:46 PM, Tony Luck <tony.luck@gmail.com> wrote:
> On Wed, Dec 10, 2014 at 4:24 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> I think you need ist_begin_non_atomic() before local_irq_enable() and
>> ist_end_non_atomic() after local_irq_disable().  Otherwise it should
>> be good.
>
> In your x86/paranoid branch you added:
>
>      prev_state = ist_enter(regs);
>           .... body of do_machine_check() here ...
>      ist_exit(regs, prev_state);
>
> Does that override the previous advice? Or do I still need something before
> I call local_irq_enable() and after local_irq_disable()?

I think I was just being vague.  It would be:

     prev_state = ist_enter(regs);
          .... beginning of do_machine_check() here ...

     if (whatever condition) {
        ist_begin_non_atomic();
        local_irq_enable();

        ...

        local_irq_disable();
        ist_end_non_atomic();
     ist_exit(regs, prev_state);

--Andy

>
> -Tony



-- 
Andy Lutomirski
AMA Capital Management, LLC
