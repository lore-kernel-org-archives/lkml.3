Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757739Ab3J1XRG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 19:17:06 -0400
Received: from gate.crashing.org ([63.228.1.57]:51933 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757618Ab3J1XRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 19:17:04 -0400
Message-ID: <1383002174.5117.19.camel@pasglop>
Subject: Re: [RFC 9/9] of/irq: create interrupts-extended property
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@kernel.crashing.org>
Date: Tue, 29 Oct 2013 10:16:14 +1100
In-Reply-To: <526EDB80.7080406@wwwdotorg.org>
References: <1381869563-16083-1-git-send-email-grant.likely@linaro.org>
	 <1381869563-16083-10-git-send-email-grant.likely@linaro.org>
	 <20131027134607.E1782C4039D@trevor.secretlab.ca>
	 <526EDB80.7080406@wwwdotorg.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-10-28 at 15:47 -0600, Stephen Warren wrote:

> "interrupts-ex" would be shorter, although I guess slightly harder to
> guess its purpose, unless you're familiar with "ex" in symbol names.
> 
> ...
> >> +A device node may contain either "interrupts" or "interrupts-extended", but not
> >> +both. If both properties are present, then the operating system should log an
> >> +error
> 
> That sounds rather like prescribing SW behaviour, which I thought DT
> bindings shouldn't do?
> 
> >> and use only the data in "interrupts".
> 
> ... so perhaps that's better phrased as:
> 
> A device node may contain either "interrupts" or "interrupts-extended",
> but not both. If both properties are present, the data in "interrupts"
> takes precedence.

So let's add a coat of paint to this shed :-)

Either it's an error, or we have a precedence rule. If it's an error
then there is no point having a precedence rule, the DT is broken and
might be in all sort of other ways, the precedence is pointless, there's
no telling what property is correct.

However, if we have a precedence rule, then it should be the other way
around, interrupts-extended takes precedence.

A concrete example:

A device has two interrupts "INT0" and "INT1". One goes to PICA, the
other one to PICB,
the first one is necessary for basic use, the second one is only
necessary for some advanced/new functionality.

It makes sense in this case to have the device-tree do:

   interrupts = < INT0 >;
   interrupt-parent = <&PICA>;
   interrupts-extended = <&PICA, INT0, &PICB, INT1>;

Because that way:

 - An old kernel which doesn't understand interrupts-extended but *also*
only uses the first interrupt (doesn't exploit the advanced/new
functionalities) will work by picking up interrupts+interrupt-parent,

 - A newer kernel which does understand interrupts-extended can then
make use of it to support the advanced/new functionalities.

Cheers,
Ben.


