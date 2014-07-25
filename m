Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760513AbaGYOPr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 10:15:47 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:57628 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223AbaGYOPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 10:15:45 -0400
MIME-Version: 1.0
In-Reply-To: <C2D7FE5348E1B147BCA15975FBA230753C4B67CF@IN01WEMBXA.internal.synopsys.com>
References: <C2D7FE5348E1B147BCA15975FBA230753C4B67CF@IN01WEMBXA.internal.synopsys.com>
From: Rob Herring <robherring2@gmail.com>
Date: Fri, 25 Jul 2014 09:15:22 -0500
Message-ID: <CAL_JsqJ2q0RSvXQW03RqwwBi_TKQ7Zt6DsUbsUruzh5oqYi5Cg@mail.gmail.com>
Subject: Re: ARC fails to boot on linux-next of 20140711
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        linux-next <linux-next@vger.kernel.org>,
        Anton Kolesov <Anton.Kolesov@synopsys.com>,
        lkml <linux-kernel@vger.kernel.org>,
        greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 6:02 AM, Vineet Gupta
<Vineet.Gupta1@synopsys.com> wrote:
> Hi Grant,
>
> linux-next has a series for arc_uart (via tty tree) which converts it to generic
> earlycon and specifies console via /chosen/stdout-path vs.  an explicit param in
> /chose/bootargs
>
> 2014-06-24 9da433c0a0b5 ARC: [arcfpga] stdout-path now suffices for earlycon/console
>
> This relied on prev commit of yours (from linux next of 20140711), which seem to
> have disappeared now.
>
> 2014-03-27 a9296cf2d0b6 of: Create of_console_check() for selecting a console
> specified in /chosen
> 2014-03-27 cfa9cacc5dd3 of: Enable console on serial ports specified by
> /chosen/stdout-path
>
> Is there a specific reason for dropping these patches (or perhaps a merge to be
> merged). I cherry-picked both but still doesn't work.
>
> Can you please advise next step forward, before I go off debugging with those
> patches in.

There's an issue that if you have stdout-path and "earlycon" on the
command line, the kernel will switch to tty0 and disable the earlycon.

This is the "fix", but I don't like adding the DT dependency into generic code:

@@ -2382,7 +2386,7 @@ void register_console(struct console *newcon)
                if (newcon->setup == NULL ||
                    newcon->setup(newcon, NULL) == 0) {
                        newcon->flags |= CON_ENABLED;
-                       if (newcon->device) {
+                       if (newcon->device  && !of_stdout) {
                                newcon->flags |= CON_CONSDEV;
                                preferred_console = 0;
                        }

Rob
